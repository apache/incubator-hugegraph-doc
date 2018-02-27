## 1\. 概述

HugeGraph Server为HugeGraph项目的核心部分，包含Core、Backend、API等子模块。

Core模块是Tinkerpop接口的实现，Backend模块用于管理数据存储，目前支持的后端包括：Memory、Cassandra、ScyllaDB以及RocksDB，API模块提供HTTP Server，将Client的HTTP请求转化为对Core的调用。

## 2\. 下载

**环境依赖：JDK1.8，用户自行安装配置**

有两种方式可以获取HugeGraph Server：

- 下载tar包（推荐）

- 源码编译

### 2.1 下载tar包

```
$ wget http://api.xdata.baidu.com/hdfs/yqns02/hugegraph/hugegraph-release-${version}-SNAPSHOT.tar.gz
$ tar -zxvf hugegraph-release-${version}-SNAPSHOT.tar.gz
```

_注：${version}为版本号，最新版本号可参考Download页面，或直接从Download页面点击链接下载_

### 2.2 源码编译

- 下载HugeGraph源代码（目前仅支持从icode上clone）

```
$ git clone ssh://username@icode.baidu.com:8235/baidu/xbu-data/hugegraph baidu/xbu-data/hugegraph && scp -p -P 8235 username@icode.baidu.com:hooks/commit-msg baidu/xbu-data/hugegraph/.git/hooks/
```

- 编译打包生成tar包（编译前检查分支，并切换至master2）:

```
$ git checkout master2
$ cd hugegraph
$ mvn package -DskipTests
```

执行日志如下：

```
......
[INFO] Reactor Summary:
[INFO]
[INFO] hugegraph: Distributed Graph Database .............. SUCCESS [  0.002 s]
[INFO] hugegraph-core: Core Library for hugegraph ......... SUCCESS [  5.013 s]
[INFO] hugegraph-cassandra ................................ SUCCESS [  0.886 s]
[INFO] hugegraph-api ...................................... SUCCESS [  0.992 s]
[INFO] hugegraph-scylladb ................................. SUCCESS [  0.320 s]
[INFO] hugegraph-rocksdb .................................. SUCCESS [  0.326 s]
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

- 执行成功后，在hugegraph目录下生成 hugegraph-release-*.tar.gz 文件，就是编译生成的tar包。

## 3. 配置

快速开始部分以 Cassandra 作为后端，不需要用户做额外的配置，使用默认配置即可。详细的配置介绍请参考[配置](http://hugegraph.baidu.com/quickstart/config.html)

## 4. 启动

- 初始化数据库

```
$ cd hugegraph-release
$ bin/init-store.sh
```

HugeGraphServer的启动不会创建数据库，所以用户必须在启动Server前初始化过数据库。该操作仅第一次启动时需要，只要用户没有手动删除过数据库，或者没有使用新版本的Server，以后启动Server都不用再执行该操作。

- 启动server
  
```
$ bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

由于各种后端所需的配置（hugegraph.properties）及启动步骤略有不同，下面逐一对各后端的配置及启动做介绍。

### 4.1 Memory

- 修改 hugegraph.properties

```
backend=memory
serializer=text
```

- 直接启动 server 即可

```
$ bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

提示的 url 与 rest-server.properties 中配置的 restserver.url 一致

### 4.2 Cassandra

使用 cassandra 之前，用户需自行安装[cassandra](http://cassandra.apache.org/doc/latest/)（版本 3.0 以上）

- 修改 hugegraph.properties

```
backend=cassandra
serializer=cassandra

# cassandra backend config
cassandra.host=localhost
cassandra.port=9042
cassandra.username=
cassandra.password=
#cassandra.connect_timeout=5
#cassandra.read_timeout=20

#cassandra.keyspace.strategy=SimpleStrategy
#cassandra.keyspace.replication=3
```

- 初始化数据库（仅第一次启动时需要）

```
$ cd hugegraph-release
$ bin/init-store.sh
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

- 启动server

```
$ bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

### 4.3 ScyllaDB

- 修改 hugegraph.properties

```
backend=scylladb
serializer=scylladb

# cassandra backend config
cassandra.host=localhost
cassandra.port=9042
cassandra.username=
cassandra.password=
#cassandra.connect_timeout=5
#cassandra.read_timeout=20

#cassandra.keyspace.strategy=SimpleStrategy
#cassandra.keyspace.replication=3
```

由于 scylladb 数据库本身就是基于 cassandra 的"优化版"，如果用户未安装 scylladb ，也可以直接使用 cassandra 作为后端存储，只需要把 backend 和 serializer 修改为 scylladb，host 和 post 指向 cassandra 集群的 seeds 和 port 即可，但是并不建议这样做，这样发挥不出 scylladb 本身的优势了。

- 初始化数据库（仅第一次启动时需要）

```
$ cd hugegraph-release
$ bin/init-store.sh
```

- 启动server

```
$ bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

### 4.4 RocksDB

- 修改 hugegraph.properties

```
backend=rocksdb
serializer=binary
rocksdb.data_path=.
rocksdb.wal_path=.
```

> RocksDB是一个嵌入式的数据库，直接将数据写磁盘上，不需要安装部署, 但要求编译器版本 >= GCC 4.3.0（GLIBCXX_3.4.10），如不满足，需要提前升级

> RocksDB需要配置数据目录和日志目录，目录必须提前建立!

- 初始化数据库（仅第一次启动时需要）

```
$ cd hugegraph-release
$ bin/init-store.sh
```

- 启动server

```
$ bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

## 5\. 访问Server

### 5.1 服务启动状态校验

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

### 5.2 请求Server

HugeGraphServer的RestAPI包括三种类型的资源，分别是graph、schema、gremlin，

- `graph`包含`vertices`、`edges`

- `schema` 包含`vertexlabels`、 `propertykeys`、 `edgelabels`、`indexlabels`

- `gremlin`包含各种`gremlin`语句，如`g.v()`

#### 5.2.1 获取`hugegraph`的顶点及相关属性

```
$ curl http://localhost:8080/graphs/hugegraph/graph/vertices
```

> 注意：由于图的点和边很多，对于 list 型的请求，比如获取所有顶点，获取所有边等，Server 会将数据压缩再返回，所以直接使用原生的 curl 命令会得到一堆乱码。推荐使用 Chrome 浏览器 + Restlet 插件发送 HTTP 请求。

响应体如下：

```
{
    "vertices": [
        {
            "id": "2lop",
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
            "id": "1josh",
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
        },
        ...
    ]
}
```

详细的API请参考[Restful-API](http://hugegraph.baidu.com/guides/hugegraph-api.html)文档

## 6\. 停止Server

```
$cd hugegraph-release
$bin/stop-hugegraph.sh
```
