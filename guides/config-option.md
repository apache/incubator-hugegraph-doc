### 基本配置项

config option               | default value                                    | descrition
--------------------------- | ------------------------------------------------ | ---------------------------------------------------------------------------------------
backend                     | rocksdb                                          | The data store type, available values are [memory, rocksdb, cassandra, scylladb, mysql]
serializer                  | binary                                           | The serializer for backend store, available values are [text, binary, cassandra, mysql]
store                       | hugegraph                                        | The database name like Cassandra Keyspace.
store.graph                 | graph                                            | The graph table name, which store vertex, edge and property.
store.schema                | schema                                           | The schema table name, which store meta data.
vertex.default_label        | vertex                                           | The default vertex label.
vertex.tx_capacity          | 10000                                            | The max size(items) of vertices(uncommitted) in transaction.
edge.tx_capacity            | 10000                                            | The max size(items) of edges(uncommitted) in transaction.
graph.cache_capacity        | 10485760                                         | The max cache size(items) of graph data(vertex/edge).
graph.cache_expire          | 600                                              | The expire time in seconds of graph data(vertex/edge).
gremlin.graph               | com.baidu.hugegraph.HugeFactory                  | Gremlin entrence to create graph.
schema.cache_capacity       | 1048576                                          | The max cache size(items) of schema data.
schema.illegal_name_regex   | .*\s+$&#124;~.*                                  | The regex specified the illegal format for schema name.
snowflake.datecenter_id     | 0                                                | The datacenter id of snowflake id generator.
snowflake.force_string      | false                                            | Whether to force the snowflake long id to be a string.
snowflake.worker_id         | 0                                                | The worker id of snowflake id generator.
rate_limit                  | 0                                                | The max rate(items/s) to add/update/delete vertices/edges.
auth.admin_token            | 162f7848-0b6d-4faf-b557-3a0797869c55             | Token for administrator operations.
auth.require_authentication | false                                            | Whether to enable authentication.
auth.user_tokens            | [hugegraph:9fd95c9c-711b-415b-b85f-d4df46ba5c31] | The map of user tokens with name and password.

### API 配置项

config option                | default value                         | descrition
---------------------------- | ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------
restserver.url               | http://127.0.0.1:8080                 | The url for listening of rest-api server.
graphs                       | [hugegraph:conf/hugegraph.properties] | The map of graphs' name and config file.
gremlinserver.url            | http://127.0.0.1:8182                 | The url of gremlin server.
batch.max_edges_per_batch    | 500                                   | The maximum number of edges submitted per batch.
batch.max_vertices_per_batch | 500                                   | The maximum number of vertices submitted per batch.
batch.max_write_ratio        | 50                                    | The maximum thread ratio for batch writing, only take effect if the batch.max_write_threads is 0.
batch.max_write_threads      | 0                                     | The maximum threads for batch writing, if the value is 0, the actual value will be set to batch.max_write_ratio * total-rest-threads.
exception.allow_trace        | false                                 | Whether to allow exception trace stack.

### Cassandra & ScyllaDB 后端配置项

config option                  | default value  | descrition
------------------------------ | -------------- | ------------------------------------------------------------------
cassandra.host                 | localhost      | The seeds hostname or ip address of cassandra cluster.
cassandra.port                 | 9042           | The seeds port address of cassandra cluster.
cassandra.connect_timeout      | 5              | The cassandra driver connect server timeout(seconds).
cassandra.read_timeout         | 20             | The cassandra driver read from server timeout(seconds).
cassandra.keyspace.strategy    | SimpleStrategy | The keyspace strategy.
cassandra.keyspace.replication | 3              | The keyspace replication factor.
cassandra.username             |                | The username to use to login to cassandra cluster.
cassandra.password             |                | The password corresponding to cassandra.username.
cassandra.compression_type     | none           | The compression algorithm of cassandra transport: none/snappy/lz4.

### RocksDB 后端配置项

config option                                  | default value | descrition
---------------------------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rocksdb.allow_mmap_reads                       | false         | Allow the OS to mmap file for reading sst tables.
rocksdb.allow_mmap_writes                      | false         | Allow the OS to mmap file for writing.
rocksdb.bulkload_mode                          | false         | Switch to the mode to bulk load data into RocksDB.
rocksdb.compaction_style                       | LEVEL         | Set compaction style for RocksDB: LEVEL/UNIVERSAL/FIFO.
rocksdb.compression_type                       | snappy        | The compression algorithm of RocksDB: snappy/z/bzip2/lz4/lz4hc/xpress/zstd.
rocksdb.data_disks                             | []            | The optimized disks for storing data of RocksDB. The format of each element: `STORE/TABLE: /path/to/disk`.Allowed keys are [graph/vertex, graph/edge_out, graph/edge_in, graph/secondary_index, graph/range_index]
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

### MySQL 后端配置项

config option            | default value               | descrition
------------------------ | --------------------------- | -------------------------------------------------------------------------------
jdbc.driver              | com.mysql.jdbc.Driver       | The JDBC driver class to connect database.
jdbc.url                 | jdbc:mysql://127.0.0.1:3306 | The url of database in JDBC format.
jdbc.username            | root                        | The username to login database.
jdbc.password            |                             | The password corresponding to jdbc.username.
jdbc.reconnect_interval  | 3                           | The interval(seconds) between reconnections when the database connection fails.
jdbc.reconnect_max_times | 3                           | The reconnect times when the database connection fails.
