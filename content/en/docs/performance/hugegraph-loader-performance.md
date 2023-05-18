---
title: "HugeGraph-Loader Performance"
linkTitle: "HugeGraph-Loader Performance"
weight: 3
---

## Use Cases

When the number of graph data to be batch inserted (including vertices and edges) is at the billion level or below, or the total data size is less than TB, the [HugeGraph-Loader](/docs/quickstart/hugegraph-loader) tool can be used to continuously and quickly import graph data.

## Performance

> The test uses the edge data of website.

### RocksDB single-machine performance

- When label index is turned off, 228k edges/s.
- When label index is turned on, 153k edges/s.

### Cassandra cluster performance

- When label index is turned on by default, 63k edges/s.
