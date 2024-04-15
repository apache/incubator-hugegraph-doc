---
id: 'architecture-overview'
title: 'HugeGraph Architecture Overview'
sidebar_label: 'Architecture Overview'
sidebar_position: 1
---

### 1 Overview

As a general-purpose graph database product, HugeGraph needs to possess basic graph database functionality. HugeGraph supports two types of graph computation: OLTP and OLAP. For OLTP, it implements the [Apache TinkerPop3](https://tinkerpop.apache.org) framework and supports the [Gremlin](https://tinkerpop.apache.org/gremlin.html) and [Cypher](https://en.wikipedia.org/wiki/Cypher) query languages. It comes with a complete application toolchain and provides a plugin-based backend storage driver framework.

Below is the overall architecture diagram of HugeGraph:

![Architecture Overview](/img/guide/architectural-revised.png)

HugeGraph consists of three layers of functionality: the application layer, the graph engine layer, and the storage layer.

- Application Layer:
  - [Hubble](/docs/quickstart/hugegraph-hubble/): An all-in-one visual analytics platform that covers the entire process of data modeling, rapid data import, online and offline analysis of data, and unified management of graphs. It provides a guided workflow for operating graph applications.
  - [Loader](/docs/quickstart/hugegraph-loader/): A data import component that can transform data from various sources into vertices and edges and bulk import them into the graph database.
  - [Tools](/docs/quickstart/hugegraph-tools/): Command-line tools for deploying, managing, and backing up/restoring data in HugeGraph.
  - [Computer](/docs/quickstart/hugegraph-computer/): A distributed graph processing system (OLAP) that implements [Pregel](https://kowshik.github.io/JPregel/pregel_paper.pdf). It can run on Kubernetes.
  - [Client](/docs/quickstart/hugegraph-client/): HugeGraph client written in Java. Users can use the client to operate HugeGraph using Java code. Support for other languages such as Python, Go, and C++ may be provided in the future.
- [Graph Engine Layer](/docs/quickstart/hugegraph-server/):
  - REST Server: Provides a RESTful API for querying graph/schema information, supports the [Gremlin](https://tinkerpop.apache.org/gremlin.html) and [Cypher](https://en.wikipedia.org/wiki/Cypher) query languages, and offers APIs for service monitoring and operations.
  - Graph Engine: Supports both OLTP and OLAP graph computation types, with OLTP implementing the [Apache TinkerPop3](https://tinkerpop.apache.org) framework.
  - Backend Interface: Implements the storage of graph data to the backend.
- Storage Layer:
  - Storage Backend: Supports multiple built-in storage backends (RocksDB/MySQL/HBase/...) and allows users to extend custom backends without modifying the existing source code.
