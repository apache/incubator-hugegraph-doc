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

_注：${version}为版本号，最新版本号可参考Download页面_

### 2.2 源码编译

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

- 执行成功后，在hugegraph目录下生成 hugegraph-release-*.tar.gz 文件，即为编译生成的tar包。

## 3\. 配置

解压 hugegraph-release-X.Y.Z-SNAPSHOT.tar.gz，进入 hugegraph-release-X.Y.Z-SNAPSHOT 目录，适当修改conf下的几个配置文件后，就能启动服务了。

主要的配置文件包括：gremlin-server.yaml、rest-server.properties 和 hugegraph.properties

HugeGraphServer内部集成了GremlinServer和RestServer：

- [GremlinServer](http://tinkerpop.apache.org/docs/3.2.3/reference/#gremlin-server)，GremlinServer接受用户的gremlin语句，解析后转而调用Core的代码。gremlin-server.yaml用来配置GremlinServer；

- RestServer，提供RestAPI，根据不同的HTTP请求，调用对应的Core API，如果用户请求体是gremlin语句，则会转发给GremlinServer，实现对图形数据的操作。rest-server.properties 用来配置RestServer；

### 3.1 gremlin-server.yaml

gremlin-server.yaml 文件默认的内容如下：

```
host: 127.0.0.1
port: 8182
scriptEvaluationTimeout: 30000
# If you want to start gremlin-server for gremlin-console(web-socket),
# please change `HttpChannelizer` to `WebSocketChannelizer` or comment this line.
channelizer: org.apache.tinkerpop.gremlin.server.channel.HttpChannelizer
graphs: {
  hugegraph: conf/hugegraph.properties,
  hugegraph1: conf/hugegraph1.properties
}
plugins:
  - com.baidu.hugegraph
scriptEngines: {
  gremlin-groovy: {
    imports: [java.lang.Math],
    staticImports: [java.lang.Math.PI],
    scripts: [scripts/empty-sample.groovy]
  }
}
serializers:
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GryoLiteMessageSerializerV1d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
    }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GryoMessageSerializerV1d0,
      config: {
        serializeResultToString: true,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
    }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerGremlinV1d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
    }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerGremlinV2d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
    }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV1d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
    }
metrics: {
  consoleReporter: {enabled: false, interval: 180000},
  csvReporter: {enabled: true, interval: 180000, fileName: /tmp/gremlin-server-metrics.csv},
  jmxReporter: {enabled: false},
  slf4jReporter: {enabled: false, interval: 180000},
  gangliaReporter: {enabled: false, interval: 180000, addressingMode: MULTICAST},
  graphiteReporter: {enabled: false, interval: 180000}
}
maxInitialLineLength: 4096
maxHeaderSize: 8192
maxChunkSize: 8192
maxContentLength: 65536
maxAccumulationBufferComponents: 1024
resultIterationBatchSize: 64
writeBufferLowWaterMark: 32768
writeBufferHighWaterMark: 65536
ssl: {
  enabled: false
}
```

作为快速开始部分，用户仅需关注：host、port 和 graphs。

- host：部署GremlinServer机器的机器名或IP，目前HugeGraphServer不支持分布式，且GremlinServer不直接暴露给用户，此项可以不修改；

- port：部署GremlinServer机器的端口，同host，可以不修改；

- graphs：GremlinServer启动时需要打开的图，该项为map结构，key是图的名字，value是该图的配置文件；

### 3.2 rest-server.properties

rest-server.properties 文件的默认内容如下：

```
restserver.url=http://127.0.0.1:8080
gremlinserver.url=http://127.0.0.1:8182
graphs=[hugegraph:conf/hugegraph.properties, hugegraph1:conf/hugegraph1.properties]

max_vertices_per_batch=500
max_edges_per_batch=500
```

RestServer是直接处理用户请求的Server，可能会直接调用Core API，也可能将请求转发至GremlinServer再调用Core API。

- restserver.url：RestServer提供服务的url，根据实际环境修改；

- gremlinserver.url：GremlinServer为RestServer提供服务的url，该配置项与gremlin-server.yaml中的host和port相匹配，默认可以不修改；

- graphs：RestServer启动时也需要打开图，该项为map结构，key是图的名字，value是该图的配置文件；

### 3.3 hugegraph.properties

hugegraph.properties 是一类文件，因为如果系统存在多个图，则会有多个相似的文件。该文件用来配置与图存储和查询相关的参数，文件的默认内容如下：

```
# gremlin entrence to create graph
gremlin.graph=com.baidu.hugegraph.HugeFactory

# cache config
#schema.cache_capacity=1048576
#graph.cache_capacity=10485760
#graph.cache_expire=600

# schema illegal name template
#schema.illegal_name_regex=\s+|~.*

#vertex.default_label=vertex

backend=cassandra
serializer=cassandra

store=hugegraph
#store.schema=huge_schema
#store.graph=huge_graph
#store.index=huge_index

# rocksdb backend config
rocksdb.data_path=.
rocksdb.wal_path=.

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

重点关注未注释的几项：

- gremlin.graph：GremlinServer启动时需要通过此项配置的工厂类打开图，用户不要修改此项；

- backend：使用的后端存储，可选值有memory、cassandra、scylladb和rocksdb(0.4.4版开始支持)

- serializer：主要为内部使用，用于将schema、vertex和edge序列化到后端，对应的可选值为text、cassandra、scylladb和binary（0.4.4版开始支持）

- store：图存储到后端使用的数据库名，在cassandra和scylladb中就是keyspace名，此项的值与GremlinServer和RestServer中的图名并无关系，但是出于直观考虑，建议仍然使用相同的名字；

- cassandra.host：backend为cassandra或scylladb时此项才有意义，cassandra集群的seeds

- cassandra.port：backend为cassandra或scylladb时此项才有意义，cassandra集群的native port

## 4. 启动

由于各种后端所需的配置（hugegraph.properties）及启动步骤略有不同，下面逐一介绍。

### 4.1 Memory

- 修改 hugegraph.properties

```
# gremlin entrence to create graph
gremlin.graph=com.baidu.hugegraph.HugeFactory

# cache config
#schema.cache_capacity=1048576
#graph.cache_capacity=10485760
#graph.cache_expire=600

# schema illegal name template
#schema.illegal_name_regex=\s+|~.*

#vertex.default_label=vertex

backend=memory
serializer=text

store=hugegraph
#store.schema=huge_schema
#store.graph=huge_graph
#store.index=huge_index
```

- 直接启动 server 即可

```
$ bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

提示的url与rest-server.properties中配置的restserver.url一致

### 4.2 Cassandra

使用cassandra之前，用户需自行安装[cassandra](http://cassandra.apache.org/doc/latest/)（版本 3.0 以上）

- 修改 hugegraph.properties

```
# gremlin entrence to create graph
gremlin.graph=com.baidu.hugegraph.HugeFactory

# cache config
#schema.cache_capacity=1048576
#graph.cache_capacity=10485760
#graph.cache_expire=600

# schema illegal name template
#schema.illegal_name_regex=\s+|~.*

#vertex.default_label=vertex

backend=cassandra
serializer=cassandra

store=hugegraph
#store.schema=huge_schema
#store.graph=huge_graph
#store.index=huge_index

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
# gremlin entrence to create graph
gremlin.graph=com.baidu.hugegraph.HugeFactory

# cache config
#schema.cache_capacity=1048576
#graph.cache_capacity=10485760
#graph.cache_expire=600

# schema illegal name template
#schema.illegal_name_regex=\s+|~.*

#vertex.default_label=vertex

backend=scylladb
serializer=scylladb

store=hugegraph
#store.schema=huge_schema
#store.graph=huge_graph
#store.index=huge_index

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

由于scylladb数据库本身就是基于cassandra的"优化版"，如果用户未安装scylladb，也可以直接使用cassandra作为后端存储，只需要把backend和serializer修改为scylladb就能使用其driver了，但是并不建议这样做，发挥不出scylladb本身的优势了。

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

RocksDB在release-0.4.4版本开始支持：

- 修改 hugegraph.properties

```
# gremlin entrence to create graph
gremlin.graph=com.baidu.hugegraph.HugeFactory

# cache config
#schema.cache_capacity=1048576
#graph.cache_capacity=10485760
#graph.cache_expire=600

# schema illegal name template
#schema.illegal_name_regex=\s+|~.*

#vertex.default_label=vertex

backend=rocksdb
serializer=binary
rocksdb.data_path=.
rocksdb.wal_path=.

store=hugegraph
#store.schema=huge_schema
#store.graph=huge_graph
#store.index=huge_index
```

> RocksDB需要配置数据目录和日志目录，目录必须提前建立!

- 初始化数据库（仅第一次启动时需要）

```
$ cd hugegraph-release
$ bin/init-store.sh
```

- RocksDB是一个嵌入式的数据库，直接将数据写磁盘上，不需要安装部署, 但要求编译器版本 >= GCC 4.3.0（GLIBCXX_3.4.10），如不满足，需要提前升级

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

以下两个示例分别展示了获取图 _hugegraph_ 的顶点和边的相关属性：

#### 5.2.1 获取`hugegraph`的顶点及相关属性

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

#### 5.2.2 获取 _hugegraph_ 的边及相关属性

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

## 6\. 停止Server

```
$cd hugegraph-release
$bin/stop-hugegraph.sh
```
