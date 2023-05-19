---
title: "HugeGraph configuration"
linkTitle: "Config Guide"
weight: 1
---

### 1 Overview

The directory for the configuration files is `hugegraph-release/conf`, and all the configurations related to the service and the graph itself are located in this directory.

The main configuration files include `gremlin-server.yaml`, `rest-server.properties`, and `hugegraph.properties`.

The `HugeGraphServer` integrates the `GremlinServer` and `RestServer` internally, and `gremlin-server.yaml` and `rest-server.properties` are used to configure these two servers.

- [GremlinServer](http://tinkerpop.apache.org/docs/3.2.3/reference/#gremlin-server): GremlinServer accepts Gremlin statements from users, parses them, and then invokes the Core code.
- RestServer: It provides a RESTful API that, based on different HTTP requests, calls the corresponding Core API. If the user's request body is a Gremlin statement, it will be forwarded to GremlinServer to perform operations on the graph data.

Now let's introduce these three configuration files one by one.

### 2. gremlin-server.yaml

The default content of the `gremlin-server.yaml` file is as follows:

```yaml
# host and port of gremlin server, need to be consistent with host and port in rest-server.properties
#host: 127.0.0.1
#port: 8182

# timeout in ms of gremlin query
scriptEvaluationTimeout: 30000

channelizer: org.apache.tinkerpop.gremlin.server.channel.WsAndHttpChannelizer
graphs: {
  hugegraph: conf/hugegraph.properties
}
scriptEngines: {
  gremlin-groovy: {
    plugins: {
      com.baidu.hugegraph.plugin.HugeGraphGremlinPlugin: {},
      org.apache.tinkerpop.gremlin.server.jsr223.GremlinServerGremlinPlugin: {},
      org.apache.tinkerpop.gremlin.jsr223.ImportGremlinPlugin: {
        classImports: [
          java.lang.Math,
          com.baidu.hugegraph.backend.id.IdGenerator,
          com.baidu.hugegraph.type.define.Directions,
          com.baidu.hugegraph.type.define.NodeRole,
          com.baidu.hugegraph.traversal.algorithm.CustomizePathsTraverser,
          com.baidu.hugegraph.traversal.algorithm.CustomizedCrosspointsTraverser,
          com.baidu.hugegraph.traversal.algorithm.FusiformSimilarityTraverser,
          com.baidu.hugegraph.traversal.algorithm.HugeTraverser,
          com.baidu.hugegraph.traversal.algorithm.NeighborRankTraverser,
          com.baidu.hugegraph.traversal.algorithm.PathsTraverser,
          com.baidu.hugegraph.traversal.algorithm.PersonalRankTraverser,
          com.baidu.hugegraph.traversal.algorithm.ShortestPathTraverser,
          com.baidu.hugegraph.traversal.algorithm.SubGraphTraverser,
          com.baidu.hugegraph.traversal.optimize.Text,
          com.baidu.hugegraph.traversal.optimize.TraversalUtil,
          com.baidu.hugegraph.util.DateUtil
        ],
        methodImports: [java.lang.Math#*]
      },
      org.apache.tinkerpop.gremlin.jsr223.ScriptFileGremlinPlugin: {
        files: [scripts/empty-sample.groovy]
      }
    }
  }
}
serializers:
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphBinaryMessageSerializerV1,
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
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV2d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV3d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
metrics: {
  consoleReporter: {enabled: false, interval: 180000},
  csvReporter: {enabled: false, interval: 180000, fileName: ./metrics/gremlin-server-metrics.csv},
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

There are many configuration options mentioned above, but for now, let's focus on the following options: `channelizer` and `graphs`.

- `graphs`: This option specifies the graphs that need to be opened when the GremlinServer starts. It is a map structure where the key is the name of the graph and the value is the configuration file path for that graph.
- `channelizer`: The GremlinServer supports two communication modes with clients: WebSocket and HTTP (default). If WebSocket is chosen, users can quickly experience the features of HugeGraph using [Gremlin-Console](/clients/gremlin-console.html), but it does not support importing large-scale data. It is recommended to use HTTP for communication, as all peripheral components of HugeGraph are implemented based on HTTP.

By default, the GremlinServer serves at `localhost:8182`. If you need to modify it, configure the `host` and `port` settings.

- `host`: The hostname or IP address of the machine where the GremlinServer is deployed. Currently, HugeGraphServer does not support distributed deployment, and GremlinServer is not directly exposed to users.
- `port`: The port number of the machine where the GremlinServer is deployed.

Additionally, you need to add the corresponding configuration `gremlinserver.url=http://host:port` in `rest-server.properties`.

### 3. rest-server.properties

The default content of the `rest-server.properties` file is as follows:

```properties
# bind url
restserver.url=http://127.0.0.1:8080
# gremlin server url, need to be consistent with host and port in gremlin-server.yaml
#gremlinserver.url=http://127.0.0.1:8182

# graphs list with pair NAME:CONF_PATH
graphs=[hugegraph:conf/hugegraph.properties]

# authentication
#auth.authenticator=
#auth.admin_token=
#auth.user_tokens=[]

server.id=server-1
server.role=master
```

- `restserver.url`: The URL at which the RestServer provides its services. Modify it according to the actual environment.
- `graphs`: The RestServer also needs to open graphs when it starts. This option is a map structure where the key is the name of the graph and the value is the configuration file path for that graph.

> Note: Both `gremlin-server.yaml` and `rest-server.properties` contain the `graphs` configuration option, and the `init-store` command initializes based on the graphs specified in the `graphs` section of `gremlin-server.yaml`.

> The `gremlinserver.url` configuration option is the URL at which the GremlinServer provides services to the RestServer. By default, it is set to `http://localhost:8182`. If you need to modify it, it should match the `host` and `port` settings in `gremlin-server.yaml`.

### 4. hugegraph.properties

`hugegraph.properties` is a type of file. If the system has multiple graphs, there will be multiple similar files. This file is used to configure parameters related to graph storage and querying. The default content of the file is as follows:

```properties
# gremlin entrence to create graph
gremlin.graph=com.baidu.hugegraph.HugeFactory

# cache config
#schema.cache_capacity=100000
# vertex-cache default is 1000w, 10min expired
#vertex.cache_capacity=10000000
#vertex.cache_expire=600
# edge-cache default is 100w, 10min expired
#edge.cache_capacity=1000000
#edge.cache_expire=600

# schema illegal name template
#schema.illegal_name_regex=\s+|~.*

#vertex.default_label=vertex

backend=rocksdb
serializer=binary

store=hugegraph

raft.mode=false
raft.safe_read=false
raft.use_snapshot=false
raft.endpoint=127.0.0.1:8281
raft.group_peers=127.0.0.1:8281,127.0.0.1:8282,127.0.0.1:8283
raft.path=./raft-log
raft.use_replicator_pipeline=true
raft.election_timeout=10000
raft.snapshot_interval=3600
raft.backend_threads=48
raft.read_index_threads=8
raft.queue_size=16384
raft.queue_publish_timeout=60
raft.apply_batch=1
raft.rpc_threads=80
raft.rpc_connect_timeout=5000
raft.rpc_timeout=60000

# if use 'ikanalyzer', need download jar from 'https://github.com/apache/hugegraph-doc/raw/ik_binary/dist/server/ikanalyzer-2012_u6.jar' to lib directory
search.text_analyzer=jieba
search.text_analyzer_mode=INDEX

# rocksdb backend config
#rocksdb.data_path=/path/to/disk
#rocksdb.wal_path=/path/to/disk

# cassandra backend config
cassandra.host=localhost
cassandra.port=9042
cassandra.username=
cassandra.password=
#cassandra.connect_timeout=5
#cassandra.read_timeout=20
#cassandra.keyspace.strategy=SimpleStrategy
#cassandra.keyspace.replication=3

# hbase backend config
#hbase.hosts=localhost
#hbase.port=2181
#hbase.znode_parent=/hbase
#hbase.threads_max=64

# mysql backend config
#jdbc.driver=com.mysql.jdbc.Driver
#jdbc.url=jdbc:mysql://127.0.0.1:3306
#jdbc.username=root
#jdbc.password=
#jdbc.reconnect_max_times=3
#jdbc.reconnect_interval=3
#jdbc.sslmode=false

# postgresql & cockroachdb backend config
#jdbc.driver=org.postgresql.Driver
#jdbc.url=jdbc:postgresql://localhost:5432/
#jdbc.username=postgres
#jdbc.password=

# palo backend config
#palo.host=127.0.0.1
#palo.poll_interval=10
#palo.temp_dir=./palo-data
#palo.file_limit_size=32
```

Pay attention to the following uncommented items:

- `gremlin.graph`: The entry point for GremlinServer startup. Users should not modify this item.
- `backend`: The backend storage used, with options including `memory`, `cassandra`, `scylladb`, `mysql`, `hbase`, `postgresql`, and `rocksdb`.
- `serializer`: Mainly for internal use, used to serialize schema, vertices, and edges to the backend. The corresponding options are `text`, `cassandra`, `scylladb`, and `binary` (Note: The `rocksdb` backend should have a value of `binary`, while for other backends, the values of `backend` and `serializer` should remain consistent. For example, for the `hbase` backend, the value should be `hbase`).
- `store`: The name of the database used for storing the graph in the backend. In Cassandra and ScyllaDB, it corresponds to the keyspace name. The value of this item is unrelated to the graph name in GremlinServer and RestServer, but for clarity, it is recommended to use the same name.
- `cassandra.host`: This item is only meaningful when the backend is set to `cassandra` or `scylladb`. It specifies the seeds of the Cassandra/ScyllaDB cluster.
- `cassandra.port`: This item is only meaningful when the backend is set to `cassandra` or `scylladb`. It specifies the native port of the Cassandra/ScyllaDB cluster.
- `rocksdb.data_path`: This item is only meaningful when the backend is set to `rocksdb`. It specifies the data directory for RocksDB.
- `rocksdb.wal_path`: This item is only meaningful when the backend is set to `rocksdb`. It specifies the log directory for RocksDB.
- `admin.token`: A token used to retrieve server configuration information. For example: <http://localhost:8080/graphs/hugegraph/conf?token=162f7848-0b6d-4faf-b557-3a0797869c55>

### 5. Multi-Graph Configuration

Our system can have multiple graphs, and each graph can have a different backend. For example, there are two graphs named `hugegraph` and `hugegraph1`, where `hugegraph` uses Cassandra as the backend and `hugegraph1` uses RocksDB as the backend.

The configuration method is simple:

**Modify `gremlin-server.yaml`**

Add a key-value pair in the `graphs` section of `gremlin-server.yaml`, where the key is the name of the graph and the value is the path to the graph's configuration file. For example:

```yaml
graphs: {
  hugegraph: conf/hugegraph.properties,
  hugegraph1: conf/hugegraph1.properties
}
```

**Modify `rest-server.properties`**

Add a key-value pair in the `graphs` section of `rest-server.properties`, where the key is the name of the graph and the value is the path to the graph's configuration file. For example:

```properties
graphs=[hugegraph:conf/hugegraph.properties, hugegraph1:conf/hugegraph1.properties]
```

**Add `hugegraph1.properties`**

Copy `hugegraph.properties` and name it `hugegraph1.properties`. Modify the database name corresponding to the graph and the parameters related to the backend. For example:

```properties
store=hugegraph1

...

backend=rocksdb
serializer=binary
```

**Stop the server, execute `init-store.sh` (to create a new database for the new graph), and restart the server.**

```bash
$ bin/stop-hugegraph.sh
$ bin/init-store.sh
$ bin/start-hugegraph.sh
```
