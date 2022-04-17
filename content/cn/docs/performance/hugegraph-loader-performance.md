---
title: "HugeGraph-Loader Performance"
linkTitle: "HugeGraph-Loader Performance"
weight: 3
---

## 使用场景

当要批量插入的图数据（包括顶点和边）条数为billion级别及以下，或者总数据量小于TB时，可以采用[HugeGraph-Loader](/docs/quickstart/hugegraph-loader)工具持续、高速导入图数据

## 性能

> 测试均采用网址数据的边数据

### RocksDB单机性能

- 关闭label index，22.8w edges/s
- 开启label index，15.3w edges/s

### Cassandra集群性能

- 默认开启label index，6.3w edges/s