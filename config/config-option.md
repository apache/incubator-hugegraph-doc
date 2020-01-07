## HugeGraph 配置项

### Gremlin Server 配置项

对应配置文件`gremlin-server.yaml`

config option           | default value                                                                                                | descrition
----------------------- | ------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------
host                    | 127.0.0.1                                                                                                    | The host or ip of Gremlin Server.
port                    | 8182                                                                                                         | The listening port of Gremlin Server.
graphs                  | hugegraph: conf/hugegraph.properties                                                                         | The map of graphs with name and config file path.
scriptEvaluationTimeout | 30000                                                                                                        | The timeout for gremlin script execution(millisecond).
channelizer             | org.apache.tinkerpop.gremlin.server.channel.HttpChannelizer                                                  | Indicates the protocol which the Gremlin Server provides service.
authentication          | authenticator: com.baidu.hugegraph.auth.StandardAuthenticator, config: {tokens: conf/rest-server.properties} | The authenticator and config(contains tokens path) of authentication mechanism.

### Rest Server & API 配置项

对应配置文件`rest-server.properties`

config option                      | default value                                    | descrition
---------------------------------- | ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------
graphs                             | [hugegraph:conf/hugegraph.properties]            | The map of graphs' name and config file.
server.id                          | server-1                                         | The id of rest server, used for license verification.
restserver.url                     | http://127.0.0.1:8080                            | The url for listening of rest server.
restserver.max_worker_threads      | 2 * CPUs                                         | The maxmium worker threads of rest server.
restserver.min_free_memory         | 64                                               | The minmium free memory(MB) of rest server, requests will be rejected when the available memory of system is lower than this value.
restserver.request_timeout         | 30                                               | The time in seconds within which a request must complete, -1 means no timeout.
restserver.connection_idle_timeout | 30                                               | The time in seconds to keep an inactive connection alive, -1 means no timeout.
restserver.connection_max_requests | 256                                              | The max number of HTTP requests allowed to be processed on one keep-alive connection, -1 means unlimited.
gremlinserver.url                  | http://127.0.0.1:8182                            | The url of gremlin server.
gremlinserver.max_route            | 8                                                | The max route number for gremlin server.
gremlinserver.timeout              | 30                                               | The timeout in seconds of waiting for gremlin server.
batch.max_edges_per_batch          | 500                                              | The maximum number of edges submitted per batch.
batch.max_vertices_per_batch       | 500                                              | The maximum number of vertices submitted per batch.
batch.max_write_ratio              | 50                                               | The maximum thread ratio for batch writing, only take effect if the batch.max_write_threads is 0.
batch.max_write_threads            | 0                                                | The maximum threads for batch writing, if the value is 0, the actual value will be set to batch.max_write_ratio * total-rest-threads.
auth.authenticator                 |                                                  | The class path of authenticator implemention. e.g., com.baidu.hugegraph.auth.StandardAuthenticator
auth.admin_token                   | 162f7848-0b6d-4faf-b557-3a0797869c55             | Token for administrator operations.
auth.user_tokens                   | [hugegraph:9fd95c9c-711b-415b-b85f-d4df46ba5c31] | The map of user tokens with name and password.
exception.allow_trace              | false                                            | Whether to allow exception trace stack.

### 基本配置项

基本配置项及后端配置项对应配置文件：{graph-name}.properties，如`hugegraph.properties`

config option                    | default value                   | descrition
-------------------------------- | ------------------------------- | -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
gremlin.graph	                 | com.baidu.hugegraph.HugeFactory | The entrence of gremlin server to create graph.
backend                          | rocksdb                         | The data store type, available values are [memory, rocksdb, cassandra, scylladb, hbase, mysql].
serializer                       | binary                          | The serializer for backend store, available values are [text, binary, cassandra, hbase, mysql].
store                            | hugegraph                       | The database name like Cassandra Keyspace.
store.connection_detect_interval | 600                             | The interval in seconds for detecting connections, if the idle time of a connection exceeds this value, detect it and reconnect if needed before using, value 0 means detecting every time.
store.graph                      | g                               | The graph table name, which store vertex, edge and property.
store.schema                     | m                               | The schema table name, which store meta data.
store.system                     | s                               | The system table name, which store system data.
schema.illegal_name_regex	     | .*\s+$&#124;~.*	               | The regex specified the illegal format for schema name.
schema.cache_capacity            | 100000                          | The max cache size(items) of schema cache.
schema.sync_deletion             | false                           | Whether to delete schema synchronously.
vertex.cache_capacity            | 10000000                        | The max cache size(items) of vertex cache.
vertex.cache_expire              | 600                             | The expire time in seconds of vertex cache.
vertex.check_customized_id_exist | true                            | Whether to check the vertices exist for those using customized id strategy
vertex.default_label             | vertex                          | The default vertex label.
vertex.tx_capacity               | 10000                           | The max size(items) of vertices(uncommitted) in transaction.
edge.cache_capacity              | 1000000                         | The max cache size(items) of edge cache.
edge.cache_expire                | 600                             | The expire time in seconds of edge cache.
edge.tx_capacity                 | 10000                           | The max size(items) of edges(uncommitted) in transaction.
rate_limit                       | 0                               | The max rate(items/s) to add/update/delete vertices/edges.
query.page_size                  | 500                             | The size of each page when query using paging.
search.text_analyzer             | ikanalyzer                      | Choose a text analyzer for searching the vertex/edge properties, available type are [word, ansj, hanlp, smartcn, jieba, jcseg, mmseg4j, ikanalyzer]
search.text_analyzer_mode        | smart                           | Specify the mode for the text analyzer, the available mode of analyzer are {word: [MaximumMatching, ReverseMaximumMatching, MinimumMatching, ReverseMinimumMatching, BidirectionalMaximumMatching, BidirectionalMinimumMatching, BidirectionalMaximumMinimumMatching, FullSegmentation, MinimalWordCount, MaxNgramScore, PureEnglish], ansj: [BaseAnalysis, IndexAnalysis, ToAnalysis, NlpAnalysis], hanlp: [standard, nlp, index, nShort, shortest, speed], smartcn: [], jieba: [SEARCH, INDEX], jcseg: [Simple, Complex], mmseg4j: [Simple, Complex, MaxWord], ikanalyzer: [smart, max_word]}
snowflake.datecenter_id          | 0                               | The datacenter id of snowflake id generator.
snowflake.force_string           | false                           | Whether to force the snowflake long id to be a string.
snowflake.worker_id              | 0                               | The worker id of snowflake id generator.
task.wait_timeout                | 10                              | Timeout in seconds for waiting for the task to complete,such as when truncating or clearing the backend.

### Cassandra 后端配置项

config option                  | default value  | descrition
------------------------------ | -------------- | ------------------------------------------------------------------
backend                        |                | Must be set to `cassandra`
serializer                     |                | Must be set to `cassandra`
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

### ScyllaDB 后端配置项

config option                  | default value | descrition
------------------------------ | ------------- | ------------------------------------------------------------------------------------------------
backend                        |               | Must be set to `scylladb`
serializer                     |               | Must be set to `scylladb`

其它与 Cassandra 后端一致。

### RocksDB 后端配置项

config option                                   | default value                                                                                                                        | descrition
----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
backend                                         |                                                                                                                                      | Must be set to `rocksdb`
serializer                                      |                                                                                                                                      | Must be set to `binary`
rocksdb.data_disks                              | []                                                                                                                                   | The optimized disks for storing data of RocksDB. The format of each element: `STORE/TABLE: /path/to/disk`.Allowed keys are [graph/vertex, graph/edge_out, graph/edge_in, graph/secondary_index, graph/range_index]
rocksdb.data_path                               | rocksdb-data                                                                                                                         | The path for storing data of RocksDB.
rocksdb.wal_path                                | rocksdb-data                                                                                                                         | The path for storing WAL of RocksDB.
rocksdb.allow_mmap_reads                        | false                                                                                                                                | Allow the OS to mmap file for reading sst tables.
rocksdb.allow_mmap_writes                       | false                                                                                                                                | Allow the OS to mmap file for writing.
rocksdb.block_cache_capacity                    | 8388608                                                                                                                              | The amount of block cache in bytes that will be used by RocksDB, 0 means no block cache.
rocksdb.bloom_filter_bits_per_key               | -1                                                                                                                                   | The bits per key in bloom filter, a good value is 10, which yields a filter with ~ 1% false positive rate, -1 means no bloom filter.
rocksdb.bloom_filter_block_based_mode           | false                                                                                                                                | Use block based filter rather than full filter.
rocksdb.bloom_filter_whole_key_filtering        | true                                                                                                                                 | True if place whole keys in the bloom filter, else place the prefix of keys.
rocksdb.bottommost_compression                  | NO_COMPRESSION                                                                                                                       | The compression algorithm for the bottommost level of RocksDB, allowed values are none/snappy/z/bzip2/lz4/lz4hc/xpress/zstd.
rocksdb.bulkload_mode                           | false                                                                                                                                | Switch to the mode to bulk load data into RocksDB.
rocksdb.cache_index_and_filter_blocks           | false                                                                                                                                | Indicating if we'd put index/filter blocks to the block cache.
rocksdb.compaction_style                        | LEVEL                                                                                                                                | Set compaction style for RocksDB: LEVEL/UNIVERSAL/FIFO.
rocksdb.compression                             | SNAPPY_COMPRESSION                                                                                                                   | The compression algorithm for compressing blocks of RocksDB, allowed values are none/snappy/z/bzip2/lz4/lz4hc/xpress/zstd.
rocksdb.compression_per_level                   | [NO_COMPRESSION, NO_COMPRESSION, SNAPPY_COMPRESSION, SNAPPY_COMPRESSION, SNAPPY_COMPRESSION, SNAPPY_COMPRESSION, SNAPPY_COMPRESSION] | The compression algorithms for different levels of RocksDB, allowed values are none/snappy/z/bzip2/lz4/lz4hc/xpress/zstd.
rocksdb.delayed_write_rate                      | 16777216                                                                                                                             | The rate limit in bytes/s of user write requests when need to slow down if the compaction gets behind.
rocksdb.log_level                               | INFO                                                                                                                                 | The info log level of RocksDB.
rocksdb.max_background_jobs                     | 8                                                                                                                                    | Maximum number of concurrent background jobs, including flushes and compactions.
rocksdb.max_bytes_for_level_base                | 536870912                                                                                                                            | The upper-bound of the total size of level-1 files in bytes.
rocksdb.max_bytes_for_level_multiplier          | 10.0                                                                                                                                 | The ratio between the total size of level (L+1) files and the total size of level L files for all L.
rocksdb.max_open_files                          | -1                                                                                                                                   | The maximum number of open files that can be cached by RocksDB, -1 means no limit.
rocksdb.max_subcompactions                      | 4                                                                                                                                    | The value represents the maximum number of threads per compaction job.
rocksdb.max_write_buffer_number                 | 6                                                                                                                                    | The maximum number of write buffers that are built up in memory.
rocksdb.max_write_buffer_number_to_maintain     | 0                                                                                                                                    | The total maximum number of write buffers to maintain in memory.
rocksdb.min_write_buffer_number_to_merge        | 2                                                                                                                                    | The minimum number of write buffers that will be merged together.
rocksdb.num_levels                              | 7                                                                                                                                    | Set the number of levels for this database.
rocksdb.optimize_filters_for_hits               | false                                                                                                                                | This flag allows us to not store filters for the last level.
rocksdb.optimize_mode                           | true                                                                                                                                 | Optimize for heavy workloads and big datasets.
rocksdb.pin_l0_filter_and_index_blocks_in_cache | false                                                                                                                                | Indicating if we'd put index/filter blocks to the block cache.
rocksdb.sst_path                                |                                                                                                                                      | The path for ingesting SST file into RocksDB.
rocksdb.target_file_size_base                   | 67108864                                                                                                                             | The target file size for compaction in bytes.
rocksdb.target_file_size_multiplier             | 1                                                                                                                                    | The size ratio between a level L file and a level (L+1) file.
rocksdb.use_direct_io_for_flush_and_compaction  | false                                                                                                                                | Enable the OS to use direct read/writes in flush and compaction.
rocksdb.use_direct_reads                        | false                                                                                                                                | Enable the OS to use direct I/O for reading sst tables.
rocksdb.write_buffer_size                       | 134217728                                                                                                                            | Amount of data in bytes to build up in memory.
rocksdb.max_manifest_file_size                  | 104857600                                                                                                                            | The max size of manifest file in bytes.
rocksdb.skip_stats_update_on_db_open            | false                                                                                                                                | Whether to skip statistics update when opening the database, setting this flag true allows us to not update statistics.
rocksdb.max_file_opening_threads                | 16                                                                                                                                   | The max number of threads used to open files.
rocksdb.max_total_wal_size                      | 0                                                                                                                                    | Total size of WAL files in bytes. Once WALs exceed this size, we will start forcing the flush of column families related, 0 means no limit.
rocksdb.db_write_buffer_size                    | 0                                                                                                                                    | Total size of write buffers in bytes across all column families, 0 means no limit.
rocksdb.delete_obsolete_files_period            | 21600                                                                                                                                | The periodicity in seconds when obsolete files get deleted, 0 means always do full purge.

### HBase 后端配置项

config option            | default value               | descrition
------------------------ | --------------------------- | -------------------------------------------------------------------------------
backend                  |                             | Must be set to `hbase`
serializer               |                             | Must be set to `hbase`
hbase.hosts              | localhost                   | The hostnames or ip addresses of HBase zookeeper, separated with commas. 
hbase.port               | 2181                        | The port address of HBase zookeeper.
hbase.threads_max        | 64                          | The max threads num of hbase connections.
hbase.znode_parent       | /hbase                      | The znode parent path of HBase zookeeper.
hbase.zk_retry           | 3                           | The recovery retry times of HBase zookeeper.

### MySQL & PostgreSQL 后端配置项

config option            | default value               | descrition
------------------------ | --------------------------- | -------------------------------------------------------------------------------
backend                  |                             | Must be set to `mysql`
serializer               |                             | Must be set to `mysql`
jdbc.driver              | com.mysql.jdbc.Driver       | The JDBC driver class to connect database.
jdbc.url                 | jdbc:mysql://127.0.0.1:3306 | The url of database in JDBC format.
jdbc.username            | root                        | The username to login database.
jdbc.password            |                             | The password corresponding to jdbc.username.
jdbc.ssl_mode            | false                       | The SSL mode of connections with database.
jdbc.reconnect_interval  | 3                           | The interval(seconds) between reconnections when the database connection fails.
jdbc.reconnect_max_times | 3                           | The reconnect times when the database connection fails.
jdbc.storage_engine      | InnoDB                      | The storage engine of backend store database, like InnoDB/MyISAM/RocksDB for MySQL.

### PostgreSQL 后端配置项

config option            | default value               | descrition
------------------------ | --------------------------- | -------------------------------------------------------------------------------
backend                  |                             | Must be set to `postgresql`
serializer               |                             | Must be set to `postgresql`

其它与 MySQL 后端一致。

> PostgreSQL 后端的 driver 和 url 应该设置为:
> - `jdbc.driver=org.postgresql.Driver`
> - `jdbc.url=jdbc:postgresql://localhost:5432/`