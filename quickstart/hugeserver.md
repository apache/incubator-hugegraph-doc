## HugeGraphServer Quick Start


### 1. HugeGraphServer 概述


HugeGraph Server为HugeGraph项目的核心部分，包含Core、Backend、API等子模块，Server基于HTTP协议为各种Client提供操作图的接口。


### 2. 下载


有两种方式可以获取HugeGraph Server：

- 下载tar包（推荐）

- 源码编译

#### 2.1 下载tar包

```
$ wget http://api.xdata.baidu.com/hdfs/yqns02/hugegraph/hugegraph-release-${version}-SNAPSHOT.tar.gz
$ tar -zxvf hugegraph-release-${version}-SNAPSHOT.tar.gz
```

*注：${version}为版本号，最新版本号可参考Download页面*

#### 2.2 源码编译

- 下载HugeGraph源码包：(目前仅支持从icode上clone)

```
$ git clone ssh://username@icode.baidu.com:8235/baidu/xbu-data/hugegraph baidu/xbu-data/hugegraph && scp -p -P 8235 username@icode.baidu.com:hooks/commit-msg baidu/xbu-data/hugegraph/.git/hooks/
```

- 编译打包生成tar包（编译前检查分支，并切换至master2）:
   
```
$ git checkout master2
$ cd hugegraph 
$ mvn package -DskipTests 
```

执行结果如下：
        
```
[INFO] Scanning for projects...
[INFO] Reactor Build Order:
[INFO] 
[INFO] hugegraph: Distributed Graph Database
[INFO] hugegraph-core: Core Library for hugegraph
[INFO] hugegraph-cassandra
[INFO] hugegraph-api
[INFO] hugegraph-scylladb
[INFO] hugegraph-dist: Tar and Distribute Archives
[INFO] hugegraph-example
[INFO] hugegraph-test
......
[INFO] Reactor Summary:
[INFO] 
[INFO] hugegraph: Distributed Graph Database .............. SUCCESS [  0.002 s]
[INFO] hugegraph-core: Core Library for hugegraph ......... SUCCESS [  5.013 s]
[INFO] hugegraph-cassandra ................................ SUCCESS [  0.886 s]
[INFO] hugegraph-api ...................................... SUCCESS [  0.992 s]
[INFO] hugegraph-scylladb ................................. SUCCESS [  0.320 s]
[INFO] hugegraph-dist: Tar and Distribute Archives ........ SUCCESS [  7.402 s]
[INFO] hugegraph-example .................................. SUCCESS [  0.391 s]
[INFO] hugegraph-test ..................................... SUCCESS [  1.047 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 16.229 s
[INFO] Finished at: 2017-12-01T10:30:41+08:00
[INFO] Final Memory: 57M/774M
[INFO] ------------------------------------------------------------------------
```

- 执行成功后，在hugegraph目录下生成hugegraph-release-*.tar.gz 文件，即为编译生成的tar包。

###  3. Server介绍与启动

#### 3.1 后端数据库

目前HugeGraphServer支持的后端数据库包括：

- [Cassandra](http://cassandra.apache.org/doc/latest/)（版本 3.0 以上）

- [ScyllaDB](http://www.scylladb.com/)

用户需自行下载安装，并启动数据库服务

#### 3.2 Server组件

HugeGraphServer内部集成了GremlinServer和RestServer：

- [GremlinServer](http://tinkerpop.apache.org/docs/3.2.3/reference/#gremlin-server)，GremlinServer提供了一种远程执行Gremlin脚本的方式，它作为独立服务支持任何Gremlin Structure的图形，从而使多个客户端能够与同一个图形数据库进行通信。
    
- RestServer提供RestAPI，将HTTP请求转化为HugeGraph中对Core API的调用，实现对图形数据的操作。

#### 3.3 部署模式

目前HugeGraphServer仅支持单机模式部署，后续会支持分布式。如果用户对一致性没有要求，可自行部署多个Server，然后上层添加负载均衡组件。

#### 3.4 启动
 
步骤：

* 启动Cassandra或ScyllaDB（用户自行安装启动）

* 初始化数据库（只需在初次使用时执行一次）

* 启动HugeGraphServer服务；

**只有启动cassandra成功后才能执行后续步骤**

##### 3.4.1 初始化数据库

首次执行时需要进行创建数据库操作，如下：

```
$ cd hugegraph-release
$ bin/init-store.sh 
```

执行日志如下：

```
Initing HugeGraph Store...
2017-12-01 11:26:51 1424  [main] [INFO ] com.baidu.hugegraph.HugeGraph [] - Opening backend store: 'cassandra'
2017-12-01 11:26:52 2389  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph, try init keyspace later
2017-12-01 11:26:52 2472  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph, try init keyspace later
2017-12-01 11:26:52 2557  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph, try init keyspace later
2017-12-01 11:26:53 2797  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_graph
2017-12-01 11:26:53 2945  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_schema
2017-12-01 11:26:53 3044  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_index
2017-12-01 11:26:53 3046  [pool-3-thread-1] [INFO ] com.baidu.hugegraph.backend.Transaction [] - Clear cache on event 'store.init'
2017-12-01 11:26:59 9720  [main] [INFO ] com.baidu.hugegraph.HugeGraph [] - Opening backend store: 'cassandra'
2017-12-01 11:27:00 9805  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph1, try init keyspace later
2017-12-01 11:27:00 9886  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph1, try init keyspace later
2017-12-01 11:27:00 9955  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph1, try init keyspace later
2017-12-01 11:27:00 10175 [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_graph
2017-12-01 11:27:00 10321 [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_schema
2017-12-01 11:27:00 10413 [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_index
2017-12-01 11:27:00 10413 [pool-3-thread-1] [INFO ] com.baidu.hugegraph.backend.Transaction [] - Clear cache on event 'store.init'
```

##### 3.4.2 启动HugeGraphServer

```
$ cd hugegraph-release
$ bin/start-hugegraph.sh
```

启动日志：

```
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

##### 3.4.3 启动状态校验

- jps查看服务进程

```
$ jps
6475 HugeGraphServer
```

- curl请求RestAPI

```
$ echo `curl -o /dev/null -s -w %{http_code} "http://localhost:8080/graphs/hugegraph/graph/vertices"`
```
	
返回结果200，代表server启动正常

### 4. 访问Server

HugeGraphServer的RestAPI包括三种类型的资源，分别是graph、schema、gremlin，

- `graph`包含`vertices`、`edges` 

- `schema` 包含`vertexlabels`、  `propertykeys`、 `edgelabels`、`indexlabels`

- `gremlin`包含各种`gremlin`语句，如`g.v()`

以下两个示例分别展示了获取图 *hugegraph* 的顶点和边的相关属性：

#### 4.1 获取`hugegraph`的顶点及相关属性

```
$ curl http://localhost:8080/graphs/hugegraph/graph/vertices 
```
 
响应体如下：

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

#### 4.2 获取 *hugegraph* 的边及相关属性

```
$ curl  http://localhost:8080/graphs/hugegraph/graph/edges
```

响应体如下：

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

详细的API请参考[Restful-API](http://hugegraph.baidu.com/guides/hugegraph-api.html)文档
 
### 5. 停止Server

```
$cd hugegraph-release
$bin/stop-hugegraph.sh
```
