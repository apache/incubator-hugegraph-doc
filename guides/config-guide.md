## HugeGraph 配置

### 1 概述

配置文件的目录为 hugegraph-release/conf，所有关于服务和图本身的配置都在此目录下。

主要的配置文件包括：gremlin-server.yaml、rest-server.properties 和 hugegraph.properties

HugeGraphServer 内部集成了 GremlinServer 和 RestServer，而 gremlin-server.yaml 和 rest-server.properties 就是用来配置这两个Server的。

- [GremlinServer](http://tinkerpop.apache.org/docs/3.2.3/reference/#gremlin-server)：GremlinServer接受用户的gremlin语句，解析后转而调用Core的代码。
- RestServer：提供Restful API，根据不同的HTTP请求，调用对应的Core API，如果用户请求体是gremlin语句，则会转发给GremlinServer，实现对图数据的操作。

下面对这三个配置文件逐一介绍。

### 2 gremlin-server.yaml

gremlin-server.yaml 文件默认的内容如下：

```yaml
host: 127.0.0.1
port: 8182
scriptEvaluationTimeout: 30000
# If you want to start gremlin-server for gremlin-console(web-socket),
# please change `HttpChannelizer` to `WebSocketChannelizer` or comment this line.
channelizer: org.apache.tinkerpop.gremlin.server.channel.HttpChannelizer
graphs: {
  hugegraph: conf/hugegraph.properties
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

上面的配置项很多，但目前只需要关注如下几个配置项：host、port、channelizer 和 graphs。

- host：部署 GremlinServer 机器的机器名或 IP，目前 HugeGraphServer 不支持分布式部署，且GremlinServer不直接暴露给用户，此项可以不修改；
- port：部署 GremlinServer 机器的端口，同 host，可以不修改；
- channelizer：GremlinServer 与客户端有两种通信方式，分别是 WebSocket 和 HTTP（默认）。如果选择 WebSocket，用户可以通过 [Gremlin-Console](http://hugegraph.baidu.com/clients/gremlin-console.html) 快速体验 HugeGraph 的特性，但是不支持大规模数据导入，推荐使用 HTTP 的通信方式，我们的一些外围组件都是基于 HTTP 实现的；
- graphs：GremlinServer 启动时需要打开的图，该项是一个 map 结构，key 是图的名字，value 是该图的配置文件路径；

### 3 rest-server.properties

rest-server.properties 文件的默认内容如下：

```properties
restserver.url=http://127.0.0.1:8080
gremlinserver.url=http://127.0.0.1:8182
graphs=[hugegraph:conf/hugegraph.properties]

max_vertices_per_batch=500
max_edges_per_batch=500
```

- restserver.url：RestServer 提供服务的 url，根据实际环境修改；
- gremlinserver.url：GremlinServer 为 RestServer 提供服务的 url，该配置项与 gremlin-server.yaml 中的 host 和 port 相匹配，默认可以不修改；
- graphs：RestServer 启动时也需要打开图，该项为 map 结构，key 是图的名字，value 是该图的配置文件路径；

> 注意：gremlin-server.yaml 和 rest-server.properties 都包含 graphs 配置项，而 `init-store` 命令是根据 gremlin-server.yaml 的 graphs 下的图进行初始化的。

### 4 hugegraph.properties

hugegraph.properties 是一类文件，因为如果系统存在多个图，则会有多个相似的文件。该文件用来配置与图存储和查询相关的参数，文件的默认内容如下：

```properties
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

# hugespark
admin.token=162f7848-0b6d-4faf-b557-3a0797869c55
```

重点关注未注释的几项：

- gremlin.graph：GremlinServer 的启动入口，用户不要修改此项；
- backend：使用的后端存储，可选值有 memory、cassandra、scylladb 和 rocksdb；
- serializer：主要为内部使用，用于将 schema、vertex 和 edge 序列化到后端，对应的可选值为 text、cassandra、scylladb 和 binary；
- store：图存储到后端使用的数据库名，在 cassandra 和 scylladb 中就是 keyspace 名，此项的值与 GremlinServer 和 RestServer 中的图名并无关系，但是出于直观考虑，建议仍然使用相同的名字；
- cassandra.host：backend 为 cassandra 或 scylladb 时此项才有意义，cassandra/scylladb 集群的 seeds；
- cassandra.port：backend 为 cassandra 或 scylladb 时此项才有意义，cassandra/scylladb 集群的 native port；
- rocksdb.data_path：backend 为 rocksdb 时此项才有意义，rocksdb 的数据目录
- rocksdb.wal_path：backend 为 rocksdb 时此项才有意义，rocksdb 的日志目录
- admin.token: 通过一个token来获取服务器的配置信息，例如：<http://localhost:8080/graphs/hugegraph/conf?token=162f7848-0b6d-4faf-b557-3a0797869c55>

### 5 多图配置

我们的系统是可以存在多个图的，并且各个图的后端可以不一样，比如图 hugegraph 和 hugegraph1，其中 hugegraph 以 cassandra 作为后端，hugegraph1 以 rocksdb作为后端。

配置方法也很简单：

**修改 gremlin-server.yaml**

在 gremlin-server.yaml 的 graphs 域中添加一个键值对，键为图的名字，值为图的配置文件路径，比如：

```yaml
graphs: {
  hugegraph: conf/hugegraph.properties,
  hugegraph1: conf/hugegraph1.properties
}
```

**修改 rest-server.properties**

在 rest-server.properties 的 graphs 域中添加一个键值对，键为图的名字，值为图的配置文件路径，比如：

```properties
graphs=[hugegraph:conf/hugegraph.properties, hugegraph1:conf/hugegraph1.properties]
```

**添加 hugegraph1.properties**

拷贝 hugegraph.properties，命名为 hugegraph1.properties，修改图对应的数据库名以及关于后端部分的参数，比如：

```properties
store=hugegraph1

...

backend=rocksdb
serializer=binary
```

**停止 Server，初始化执行 init-store.sh（为新的图创建数据库），重新启动 Server**

```bash
$ bin/stop-hugegraph.sh
$ bin/init-store.sh
$ bin/start-hugegraph.sh
```
