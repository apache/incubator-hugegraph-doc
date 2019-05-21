## HugeGraph 配置项

### Gremlin Server 配置项

config option                | default value                                               | descrition
---------------------------- | ----------------------------------------------------------- | ----------------------------------------------------------------------------------
host                         | 127.0.0.1                                                   | The host or ip of Gremlin Server.
port                         | 8182                                                        | The listening port of Gremlin Server.
scriptEvaluationTimeout      | 30000                                                       | The timeout for gremlin script execution(millisecond).
channelizer                  | org.apache.tinkerpop.gremlin.server.channel.HttpChannelizer | Indicates the protocol which the Gremlin Server provides service.
graphs                       | hugegraph: conf/hugegraph.properties                        | The map of graphs with name and config file path.
authentication               | authenticator: com.baidu.hugegraph.auth.StandardAuthenticator, config: {tokens: conf/rest-server.properties} | The authenticator and config(contains tokens path) of authentication mechanism.

> 对应配置文件`gremlin-server.yaml`

### Rest Server & API 配置项

config option                | default value                                    | descrition
---------------------------- | ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------
graphs                       | [hugegraph:conf/hugegraph.properties]            | The map of graphs' name and config file.
restserver.url               | http://127.0.0.1:8080                            | The url for listening of rest-api server.
restserver.max_worker_threads| 2 * CPUs                                         | The maximum worker threads of rest server.
gremlinserver.url            | http://127.0.0.1:8182                            | The url used to connect gremlin server from rest-api server.
batch.max_edges_per_batch    | 500                                              | The maximum number of edges submitted per batch.
batch.max_vertices_per_batch | 500                                              | The maximum number of vertices submitted per batch.
batch.max_write_ratio        | 50                                               | The maximum thread ratio for batch writing, only take effect if the batch.max_write_threads is 0.
batch.max_write_threads      | 0                                                | The maximum threads for batch writing, if the value is 0, the actual value will be set to batch.max_write_ratio * total-rest-threads.
exception.allow_trace        | false                                            | Whether to allow exception trace stack.
auth.authenticator           |                                                  | The class path of authenticator implemention. e.g., com.baidu.hugegraph.auth.StandardAuthenticator.
auth.admin_token             | 162f7848-0b6d-4faf-b557-3a0797869c55             | Token for administrator operations.
auth.user_tokens             | [hugegraph:9fd95c9c-711b-415b-b85f-d4df46ba5c31] | The map of user tokens with name and password.

> 对应配置文件`rest-server.properties`

### 基本配置项

config option                    | default value                   | descrition
-------------------------------- | ------------------------------- | -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
backend                          | rocksdb                         | The data store type, available values are [memory, rocksdb, cassandra, scylladb, hbase, mysql].
serializer                       | binary                          | The serializer for backend store, available values are [text, binary, cassandra, hbase, mysql].
store                            | hugegraph                       | The database name like Cassandra Keyspace.
rate_limit                       | 0                               | The max rate(items/s) to add/update/delete vertices/edges.
store.graph                      | graph                           | The graph table name, which store vertex, edge and property.
store.schema                     | schema                          | The schema table name, which store meta data.
store.system                     | system                          | The system table name, which store system data.
vertex.default_label             | vertex                          | The default vertex label.
vertex.check_customzied_id_exist | true                            | Whether to check the vertices exist for those using customized id strategy.
vertex.tx_capacity               | 10000                           | The max size(items) of vertices(uncommitted) in transaction.
vertex.cache_capacity            | 10000000                        | The max cache size(items) of vertex cache.
vertex.cache_expire              | 600                             | The expire time in seconds of vertex cache.
edge.tx_capacity                 | 10000                           | The max size(items) of edges(uncommitted) in transaction.
edge.cache_capacity              | 1000000                         | The max cache size(items) of edge cache.
edge.cache_expire                | 600                             | The expire time in seconds of edge cache.
schema.cache_capacity            | 100000                          | The max cache size(items) of schema data.
schema.illegal_name_regex        | .*\s+$&#124;~.*                 | The regex specified the illegal format for schema name.
schema.sync_deletion             | false                           | Whether to delete schema synchronously.
query.page_size                  | 500                             | The size of each page when query using paging.
task.wait_timeout                | 10                              | Timeout in seconds for waiting for the task to complete,such as when truncating or clearing the backend.
search.text_analyzer             | ikanalyzer                      | Choose a text analyzer for searching the vertex/edge properties, available type are [word, ansj, hanlp, smartcn, jieba, jcseg, mmseg4j, ikanalyzer].
search.text_analyzer_mode        | smart                           | Specify the mode for the text analyzer, the available mode of analyzer are {word: [MaximumMatching, ReverseMaximumMatching, MinimumMatching, ReverseMinimumMatching, BidirectionalMaximumMatching, BidirectionalMinimumMatching, BidirectionalMaximumMinimumMatching, FullSegmentation, MinimalWordCount, MaxNgramScore, PureEnglish], ansj: [BaseAnalysis, IndexAnalysis, ToAnalysis, NlpAnalysis], hanlp: [standard, nlp, index, nShort, shortest, speed], smartcn: [], jieba: [SEARCH, INDEX], jcseg: [Simple, Complex], mmseg4j: [Simple, Complex, MaxWord], ikanalyzer: [smart, max_word]}.
snowflake.datecenter_id          | 0                               | The datacenter id of snowflake id generator.
snowflake.force_string           | false                           | Whether to force the snowflake long id to be a string.
snowflake.worker_id              | 0                               | The worker id of snowflake id generator.
gremlin.graph                    | com.baidu.hugegraph.HugeFactory | Gremlin entrence to create graph.

> 基本配置项及后端配置项对应配置文件：{graph-name}.properties，如`hugegraph.properties`

### Cassandra & ScyllaDB 后端配置项

config option                  | default value  | descrition
------------------------------ | -------------- | ------------------------------------------------------------------
cassandra.host                 | localhost      | The seeds hostname or ip address of cassandra cluster.
cassandra.port                 | 9042           | The seeds port address of cassandra cluster.
cassandra.connect_timeout      | 5              | The cassandra driver connect server timeout(seconds).
cassandra.read_timeout         | 20             | The cassandra driver read from server timeout(seconds).
cassandra.keyspace.strategy    | SimpleStrategy | The replication strategy of keyspace, valid value is SimpleStrategy or NetworkTopologyStrategy.
cassandra.keyspace.replication | [3]            | The keyspace replication factor of SimpleStrategy, like '[3]'.Or replicas in each datacenter of NetworkTopologyStrategy, like '[dc1:2,dc2:1]'.
cassandra.username             |                | The username to use to login to cassandra cluster.
cassandra.password             |                | The password corresponding to cassandra.username.
cassandra.compression_type     | none           | The compression algorithm of cassandra transport: none/snappy/lz4.
cassandra.jmx_port=7199        | 7199           | The port of JMX API service for cassandra.

### RocksDB 后端配置项

config option                                  | default value | descrition
---------------------------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rocksdb.allow_mmap_reads                       | false         | Allow the OS to mmap file for reading sst tables.
rocksdb.allow_mmap_writes                      | false         | Allow the OS to mmap file for writing.
rocksdb.bulkload_mode                          | false         | Switch to the mode to bulk load data into RocksDB.
rocksdb.compaction_style                       | LEVEL         | Set compaction style for RocksDB: LEVEL/UNIVERSAL/FIFO.
rocksdb.compression_type                       | snappy        | The compression algorithm of RocksDB: snappy/z/bzip2/lz4/lz4hc/xpress/zstd.
rocksdb.data_disks                             | []            | The optimized disks for storing data of RocksDB. The format of each element: `STORE/TABLE: /path/to/disk`.Allowed keys are [graph/vertex, graph/edge_out, graph/edge_in, graph/secondary_index, graph/range_index].
rocksdb.data_path                              | rocksdb-data  | The path for storing data of RocksDB.
rocksdb.delayed_write_rate                     | 16777216      | The rate limit in bytes/s of user write requests when need to slow down if the compaction gets behind.
rocksdb.log_level                              | INFO          | The info log level of RocksDB.
rocksdb.max_background_compactions             | 4             | The maximum number of concurrent background compaction jobs.
rocksdb.max_background_flushes                 | 4             | The maximum number of concurrent background flush jobs.
rocksdb.max_bytes_for_level_base               | 536870912     | The upper-bound of the total size of level-1 files in bytes.
rocksdb.max_bytes_for_level_multiplier         | 10.0          | The ratio between the total size of level (L+1) files and the total size of level L files for all L.
rocksdb.max_open_files                         | -1            | The maximum number of open files that can be cached by RocksDB.
rocksdb.max_subcompactions                     | 4             | The value represents the maximum number of threads per compaction job.
rocksdb.max_write_buffer_number                | 6             | The maximum number of write buffers that are built up in memory.
rocksdb.max_write_buffer_number_to_maintain    | 0             | The total maximum number of write buffers to maintain in memory.
rocksdb.min_write_buffer_number_to_merge       | 2             | The minimum number of write buffers that will be merged together.
rocksdb.num_levels                             | 7             | Set the number of levels for this database.
rocksdb.optimize_mode                          | true          | Optimize for heavy workloads and big datasets.
rocksdb.sst_path                               |               | The path for ingesting SST file into RocksDB.
rocksdb.target_file_size_base                  | 67108864      | The target file size for compaction in bytes.
rocksdb.target_file_size_multiplier            | 1             | The size ratio between a level L file and a level (L+1) file.
rocksdb.use_direct_io_for_flush_and_compaction | false         | Enable the OS to use direct reads and writes in flush and compaction.
rocksdb.use_direct_reads                       | false         | Enable the OS to use direct I/O for reading sst tables.
rocksdb.wal_path                               | rocksdb-data  | The path for storing WAL of RocksDB.
rocksdb.write_buffer_size                      | 134217728     | Amount of data in bytes to build up in memory.

### HBase 后端配置项

config option            | default value               | descrition
------------------------ | --------------------------- | -------------------------------------------------------------------------------
hbase.hosts              | localhost                   | The hostnames or ip addresses of HBase zookeeper, separated with commas. 
hbase.port               | 2181                        | The port address of HBase zookeeper.
hbase.threads_max        | 64                          | The max threads num of hbase connections.
hbase.znode_parent       | /hbase                      | The znode parent path of HBase zookeeper.

### MySQL 后端配置项

config option            | default value               | descrition
------------------------ | --------------------------- | -------------------------------------------------------------------------------
jdbc.driver              | com.mysql.jdbc.Driver       | The JDBC driver class to connect database.
jdbc.url                 | jdbc:mysql://127.0.0.1:3306 | The url of database in JDBC format.
jdbc.username            | root                        | The username to login database.
jdbc.password            |                             | The password corresponding to jdbc.username.
jdbc.reconnect_interval  | 3                           | The interval(seconds) between reconnections when the database connection fails.
jdbc.reconnect_max_times | 3                           | The reconnect times when the database connection fails.
