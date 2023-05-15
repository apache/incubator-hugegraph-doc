---
title: "HugeGraph-API Performance"
linkTitle: "HugeGraph-API Performance"
weight: 2
---

The HugeGraph API performance test mainly tests HugeGraph-Server's ability to concurrently process RESTful API requests, including:

- Single insertion of vertices/edges
- Batch insertion of vertices/edges
- Vertex/Edge Queries

For the performance test of the RESTful API of each release version of HugeGraph, please refer to:

- [v0.5.6 stand-alone](/docs/performance/api-preformance/hugegraph-api-0.5.6-rocksdb/)
- [v0.5.6 cluster](/docs/performance/api-preformance/hugegraph-api-0.5.6-cassandra/)
- [v0.4.4](/docs/performance/api-preformance/hugegraph-api-0.4.4/)
- [v0.2](/docs/performance/api-preformance/hugegraph-api-0.2/)

> Starting from version 0.5.6, in addition to providing performance tests for the API with the best performance among the backend types supported by HugeGraph, performance tests for both single machine and cluster environments are now available.
