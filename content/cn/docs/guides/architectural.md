---
title: "HugeGraph Architecture Overview"
linkTitle: "Architecture Overview"
weight: 1
---

### 1 概述

作为一款通用的图数据库产品，HugeGraph 需具备图数据的基本功能，如下图所示。

<div style="text-align: center;">
  <img src="/docs/images/design/architectural-revised.png" alt="image">
</div>

HugeGraph 包括三个层次的功能，分别是应用程序层、图引擎层和存储层。

- 应用程序层：
  - Hubble: 一站式可视化分析平台，平台涵盖了从数据建模，到数据快速导入，再到数据的在线、离线分析、以及图的统一管理的全过程，实现了图应用的全流程向导式操作。
  - Loader: 数据导入组件，能够将多种数据源的数据转化为图的顶点和边并批量导入到图数据库中。
  - Tools: 命令行工具，用于部署、管理和备份/恢复 HugeGraph 中的数据。
  - Computer: 分布式图处理系统 (OLAP)，它是 [Pregel](https://kowshik.github.io/JPregel/pregel_paper.pdf) 的一个实现，可以运行在 Kubernetes 上。
  - Client: 使用 Java 编写的 HugeGraph 客户端，用户可以使用 Client 编写 Java 代码操作 HugeGraph，后续可根据需要提供 Python、Go、C++ 等多语言支持。
- 图引擎层：
  - REST Server: 提供 RESTful API 用于查询 Graph/Schema 等信息，支持 [Gremlin](https://tinkerpop.apache.org/gremlin.html) 查询语言，提供服务监控和运维的 APIs。
  - Graph Engine: 支持 OLTP 和 OLAP 两种图计算类型，其中 OLTP 实现了 [Apache TinkerPop3](https://tinkerpop.apache.org) 框架。
- 存储层：
  - Storage Backend: 支持多种内置存储后端 (RocksDB/MySQL/HBase/...)，也允许用户无需更改现有源码的情况下扩展自定义后端。
