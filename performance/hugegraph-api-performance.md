## HugeGraph API Performance

HugeGraph API性能测试主要测试HugeGraph Server对RESTful API请求的并发处理能力，包括：

- 顶点/边的单条插入
- 顶点/边的批量插入
- 顶点/边的查询

HugeGraph的每个发布版本的RESTful API的性能测试情况可以参考：

- [v0.5.6 stand-alone](hugegraph-api-0.5.6-RocksDB.md)
- [v0.5.6 cluster](hugegraph-api-0.5.6-Cassandra.md)
- [v0.4.4](hugegraph-api-0.4.4.md)
- [v0.2](hugegraph-api-0.2.md)

> 之前的版本只提供HugeGraph所支持的后端种类中性能最好的API性能测试，从0.5.6版本开始，分别提供了单机和集群的性能情况