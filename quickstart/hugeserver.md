## HugeGraphServer Quick Start


### 1. HugeGraphServer 概述


HugeGraph Server为HugeGraph项目的核心部分，包含Core、Backend、Api等子模块，Server基于HTTP协议为各种Client提供操作图的接口。


### 2. 下载


有两种方式可以获取HugeServer：

* 下载源码包编译安装

* 下载二进制tar包


#### 2.1  下载源码编译生成tar包


* 下载HugeGraph源码包：(暂时从icode上clone)

```
$ git clone ssh://username@icode.baidu.com:8235/baidu/xbu-data/hugegraph baidu/xbu-data/hugegraph && scp -p -P 8235 username@icode.baidu.com:hooks/commit-msg baidu/xbu-data/hugegraph/.git/hooks/
```

* 编译生成tar包:
   
```
$ cd hugegraph 
$ mvn package -DskipTests 
```

**注：编译前先检查代码分支,并切换至master2：**
 
```
$ git branch -a 
$ git checkout master2
```
    
执行结果如下：
        
```
[INFO] Scanning for projects...
[INFO] Reactor Build Order:
[INFO] 
[INFO] hugegraph: Distributed Graph Database
[INFO] hugegraph-common
[INFO] hugegraph-core: Core Library for hugegraph
[INFO] hugegraph-api
[INFO] hugegraph-cassandra
[INFO] hugegraph-dist: Tar and Distribute Archives
[INFO] hugegraph-example
[INFO] hugegraph-test
......
[INFO] hugegraph: Distributed Graph Database .............. SUCCESS [  0.004 s]
[INFO] hugegraph-common ................................... SUCCESS [  3.046 s]
[INFO] hugegraph-core: Core Library for hugegraph ......... SUCCESS [  2.088 s]
[INFO] hugegraph-api ...................................... SUCCESS [  1.413 s]
[INFO] hugegraph-cassandra ................................ SUCCESS [  0.824 s]
[INFO] hugegraph-dist: Tar and Distribute Archives ........ SUCCESS [  6.384 s]
[INFO] hugegraph-example .................................. SUCCESS [  0.289 s]
[INFO] hugegraph-test ..................................... SUCCESS [  0.411 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 14.718 s
[INFO] Finished at: 2017-05-31T13:54:55+08:00
[INFO] Final Memory: 48M/397M
[INFO] ------------------------------------------------------------------------
```

* 执行成功后,在hugegraph目录下生成hugegraph-release-*.tar.gz 文件，即为编译生成的tar包。

#### 2.2 下载二进制tar包


* 可通过以下方式下载HugeGraph-release包

```
$ wget http://api.xdata.baidu.com/hdfs/yqns02/hugegraph/hugegraph-release-${version}-SNAPSHOT.tar.gz
$ tar zxvf hugegraph-release-${version}-SNAPSHOT.tar.gz
```


###  3. 启动Server

目前HugeGraphServer仅支持Cassandra作为后端存储，用户需自行下载安装Cassandra（版本 3.0 以上）,参考[Cassandra官网](http://cassandra.apache.org/doc/latest/)

HugeGraphServer内部集成了GremlinServer和RestServer：

1. GremlinServer(http://tinkerpop.apache.org/docs/3.2.3/reference/#gremlin-server)，GremlinServer提供了一种远程执行Gremlin脚本的方式，它作为独立服务支持任何Gremlin Structure的图形，从而使多个客户端能够与同一个图形数据库进行通信。
    
2. RestServer提供HTTP服务，将HTTP请求转化为HugeGraph中对Core API的调用，实现对图形数据的操作。

目前HugeGraphServer仅支持单机模式部署，后续会支持分布式。

 
启动HugeGraphServer的步骤如下：

* 启动Cassandra；

* 初始化数据库（只初次使用时，执行一次即可）

* 启动HugeGraphServer服务；


**只有启动cassandra成功后才能执行后续步骤**

#### 3.1 初始化数据库

首次执行时需要进行创建数据库操作，如下：

```
$ cd hugegraph-release
$ bin/init-store.sh 
```

执行结果如下：

```
...
16:18:26.931 [main] INFO  c.b.h.b.s.cassandra.CassandraStore - Create keyspace: CREATE KEYSPACE IF NOT EXISTS hugegraph WITH replication={'class':'SimpleStrategy', 'replication_factor':3}
16:18:27.007 [main] INFO  c.b.h.b.s.cassandra.CassandraStore - Create table: CREATE TABLE IF NOT EXISTS edges(SOURCE_VERTEX text, DIRECTION text, LABEL text, SORT_VALUES text, TARGET_VERTEX text, PROPERTIES map<text, text>, PRIMARY KEY ((SOURCE_VERTEX), DIRECTION, LABEL, SORT_VALUES, TARGET_VERTEX));
16:18:27.093 [main] INFO  c.b.h.b.s.cassandra.CassandraStore - create index: CREATE INDEX IF NOT EXISTS edges_label_index ON edges(LABEL);
16:18:27.185 [main] INFO  c.b.h.b.s.cassandra.CassandraStore - Create table: CREATE TABLE IF NOT EXISTS vertices(LABEL text, PRIMARY_VALUES text, PROPERTIES map<text, text>, PRIMARY KEY ((LABEL, PRIMARY_VALUES)));
16:18:27.252 [main] INFO  c.b.h.b.s.cassandra.CassandraStore - create index: CREATE INDEX IF NOT EXISTS vertices_label_index ON vertices(LABEL);
16:18:27.325 [main] INFO  c.b.h.b.s.cassandra.CassandraStore - Store initialized: huge_graph
...
```

#### 3.2 启动HugeGraphServer

```
$ cd hugegraph-release
$ bin/start-hugegraph.sh
```

#### 3.3 启动结果查询

可以通过以下两种方式来检测服务启动结果：

* jps命令查看服务进程

```
localhost:hugegraph-release xxx$ jps
6475 HugeGraphServer
6414 HugeGremlinServer
```

* 通过curl命令检查是否服务正常

```
$ echo `curl -o /dev/null -s -w %{http_code} "http://localhost:8080/graphs/hugegraph/graph/edges"`
```
	
返回结果200，代表server启动正常，且可访问。

```
注：curl参数
-o 是把下载的所有内容重定向到/dev/null;
-s 是屏蔽了curl本身的输出；
-w 是根据需要自定义curl的输出格式。
```


### 4. 访问Server


HugeGraphServer包括三种类型的资源，分别是graph、schema、gremlin，

> * `graph`包含`edges`、`vertices`; 
> * `schema` 包含`vertexlabels`、  `propertykeys`、 `edgelabels`、`indexlabels`四种属性
> * `gremlin`包含各种`gremlin`语句，例如`g.v()`

以下示例1、示例2分别展示了获取图形数据库 *hugegraph* 的顶点和边的相关属性：

（1）示例1 ：获取 *hugegraph* 的边及相关属性

```
$ curl  http://localhost:8080/graphs/hugegraph/graph/edges
```

返回json结果如下：

```
{
    "edges": [
        {
            "id": "person\u0002peter\u0001created\u0001\u0001software\u0002lop", 
            "label": "created", 
            "type": "edge", 
            "inVLabel": "software", 
            "outVLabel": "person", 
            "inV": "softwarelop", 
            "outV": "personpeter", 
            "properties": {
                "date": "20170324"
            }
        }, 
        {
            "id": "person\u0002marko\u0001knows\u0001\u0001person\u0002josh", 
            "label": "knows", 
            "type": "edge", 
            "inVLabel": "person", 
            "outVLabel": "person", 
            "inV": "personjosh", 
            "outV": "personmarko", 
            "properties": {
                "date": "20130220"
            }
        }
    ]
}
```

（2）示例2：获取`hugegraph`的顶点信息

```
$ curl http://localhost:8080/graphs/hugegraph/graph/vertices 
```
 
返回json结果如下：

```
{
    "vertices": [
        {
            "id": "softwarelop", 
            "label": "software", 
            "type": "vertex", 
            "properties": {
                "price": [
                    {
                        "id": "price", 
                        "value": 328
                    }
                ], 
                "name": [
                    {
                        "id": "name", 
                        "value": "lop"
                    }
                ], 
                "lang": [
                    {
                        "id": "lang", 
                        "value": "java"
                    }
                ]
            }
        }, 
        {
            "id": "personjosh", 
            "label": "person", 
            "type": "vertex", 
            "properties": {
                "name": [
                    {
                        "id": "name", 
                        "value": "josh"
                    }
                ], 
                "age": [
                    {
                        "id": "age", 
                        "value": 32
                    }
                ]
            }
        }
    ]
}
```
 
详细的API参考[Restful-API](http://hugegraph.baidu.com/guides/hugegraph-api.html)文档
 
### 5. 停止server

```
$cd hugegraph-release
$bin/stop-hugegraph.sh
```

通过jps命令，检查服务停止结果
