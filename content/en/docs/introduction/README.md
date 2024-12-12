---
title: "Introduction with HugeGraph"
linkTitle: "Introduction"
weight: 1
---

### Summary

Apache HugeGraph is an easy-to-use, efficient, general-purpose open source graph database system
(Graph Database, [GitHub project address](https://github.com/hugegraph/hugegraph)), implemented the [Apache TinkerPop3](https://tinkerpop.apache.org) framework and is fully compatible with the [Gremlin](https://tinkerpop.apache.org/gremlin.html) query language,
With complete toolchain components, it helps users easily build applications and products based on graph databases. HugeGraph supports fast import of more than 10 billion vertices and edges, and provides millisecond-level relational query capability (OLTP). 
It supports large-scale distributed graph computing (OLAP).

Typical application scenarios of HugeGraph include deep relationship exploration, association analysis, path search, feature extraction, data clustering, community detection, knowledge graph, etc., and are applicable to business fields such as network security, telecommunication fraud, financial risk control, advertising recommendation, social network, and intelligence Robots, etc.

### Features

HugeGraph supports graph operations in online and offline environments, supports batch import of data, supports efficient complex relationship analysis, and can be seamlessly integrated with big data platforms.
HugeGraph supports multi-user parallel operations. Users can enter Gremlin query statements and get graph query results in time. They can also call HugeGraph API in user programs for graph analysis or query.

This system has the following features: 

- Ease of use: HugeGraph supports Gremlin graph query language and RESTful API, provides common interfaces for graph retrieval, and has peripheral tools with complete functions to easily implement various graph-based query and analysis operations.
- Efficiency: HugeGraph has been deeply optimized in graph storage and graph computing, and provides a variety of batch import tools, which can easily complete the rapid import of tens of billions of data, and achieve millisecond-level response for graph retrieval through optimized queries. Supports simultaneous online real-time operations of thousands of users.
- Universal: HugeGraph supports the Apache Gremlin standard graph query language and the Property Graph standard graph modeling method, and supports graph-based OLTP and OLAP schemes. Integrate Apache Hadoop and Apache Spark big data platforms.
- Scalable: supports distributed storage, multiple copies of data, and horizontal expansion, built-in multiple back-end storage engines, and can easily expand the back-end storage engine through plug-ins.
- Open: HugeGraph code is open source (Apache 2 License), customers can modify and customize independently, and selectively give back to the open-source community.

The functions of this system include but are not limited to: 

- Supports batch import of data from multiple data sources (including local files, HDFS files, MySQL databases, and other data sources), and supports import of multiple file formats (including TXT, CSV, JSON, and other formats)
- With a visual operation interface, it can be used for operation, analysis, and display diagrams, reducing the threshold for users to use
- Optimized graph interface: shortest path (Shortest Path), K-step connected subgraph (K-neighbor), K-step to reach the adjacent point (K-out), personalized recommendation algorithm PersonalRank, etc.
- Implemented based on the Apache TinkerPop3 framework, supports Gremlin graph query language
- Support attribute graph, attributes can be added to vertices and edges, and support rich attribute types
- Has independent schema metadata information, has powerful graph modeling capabilities, and facilitates third-party system integration
- Support multi-vertex ID strategy: support primary key ID, support automatic ID generation, support user-defined string ID, support user-defined digital ID
- The attributes of edges and vertices can be indexed to support precise query, range query, and full-text search
- The storage system adopts a plug-in method, supporting RocksDB (standalone/cluster), Cassandra, ScyllaDB, HBase, MySQL, PostgreSQL, Palo and Memory, etc.
- Integrated with big data systems such as HDFS, Spark/Flink, GraphX, etc., supports BulkLoad operation to import massive data.
- Supports HA(high availability), multiple data replicas, backup and recovery, monitoring, distributed Trace, etc.

### Modules

- [HugeGraph-Server](/docs/quickstart/hugegraph-server): HugeGraph-Server is the core part of the HugeGraph project, containing Core, Backend, API and other submodules;
  - Core: Implements the graph engine, connects to the Backend module downwards, and supports the API module upwards;
  - Backend: Implements the storage of graph data to the backend, supports backends including Memory, Cassandra, ScyllaDB, RocksDB, HBase, MySQL and PostgreSQL, users can choose one according to the actual situation;
  - API: Built-in REST Server provides RESTful API to users and is fully compatible with Gremlin queries. (Supports distributed storage and computation pushdown)
- [HugeGraph-Toolchain](https://github.com/apache/hugegraph-toolchain): (Toolchain)
  - [HugeGraph-Client](/docs/quickstart/hugegraph-client): HugeGraph-Client provides a RESTful API client for connecting to HugeGraph-Server, currently only the Java version is implemented, users of other languages can implement it themselves;
  - [HugeGraph-Loader](/docs/quickstart/hugegraph-loader): HugeGraph-Loader is a data import tool based on HugeGraph-Client, which transforms ordinary text data into vertices and edges of the graph and inserts them into the graph database;
  - [HugeGraph-Hubble](/docs/quickstart/hugegraph-hubble): HugeGraph-Hubble is HugeGraph's Web 
visualization management platform, a one-stop visualization analysis platform, the platform covers the whole process from data modeling, to fast data import, to online and offline analysis of data, and unified management of the graph;
  - [HugeGraph-Tools](/docs/quickstart/hugegraph-tools): HugeGraph-Tools is HugeGraph's deployment and management tool, including graph management, backup/recovery, Gremlin execution and other functions.
- [HugeGraph-Computer](/docs/quickstart/hugegraph-computer): HugeGraph-Computer is a distributed graph processing system (OLAP). 
  It is an implementation of [Pregel](https://kowshik.github.io/JPregel/pregel_paper.pdf). It can run on clusters such as Kubernetes/Yarn, and supports large-scale graph computing.
- [HugeGraph-AI](/docs/quickstart/hugegraph-ai): HugeGraph-AI is HugeGraph's independent AI 
  component, providing training and inference functions of graph neural networks, LLM/Graph RAG combination/Python-Client and other related components, continuously updating.

### Contact Us

- [GitHub Issues](https://github.com/apache/incubator-hugegraph/issues): Feedback on usage issues and functional requirements (quick response)
- Feedback Email: [dev@hugegraph.apache.org](mailto:dev@hugegraph.apache.org) ([subscriber](https://hugegraph.apache.org/docs/contribution-guidelines/subscribe/) only)
- Security Email: [security@hugegraph.apache.org](mailto:security@hugegraph.apache.org) (Report SEC problems)
- WeChat public account: Apache HugeGraph, welcome to scan this QR code to follow us.

 <img src="https://github.com/apache/hugegraph-doc/blob/master/assets/images/wechat.png?raw=true" alt="QR png" width="300"/>
