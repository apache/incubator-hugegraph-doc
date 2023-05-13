---
title: "HugeGraph Architecture Overview"
linkTitle: "Architecture Overview"
weight: 1
---

### 1 Overview

As a general-purpose graph database product, HugeGraph needs to have the basic functions of graph data, as shown in the figure below. HugeGraph includes three levels of functions, namely storage layer, computing layer and user interface layer. HugeGraph supports two types of graph computing, OLTP and OLAP. OLTP implements the [Apache TinkerPop3](https://tinkerpop.apache.org) framework and supports the [Gremlin](https://tinkerpop.apache.org/gremlin.html) query language. OLAP computing is implemented based on SparkGraphX.

<center>
  <img src="/docs/images/design/architectural-overview.png" alt="image">
</center>


### 2 components

The main functions of HugeGraph are divided into components such as HugeCore, ApiServer, HugeGraph-Client, HugeGraph-Loader and HugeGraph-Studio. The communication relationship between each component is shown in the figure below.

<center>
  <img src="/docs/images/design/architectural-component.png" alt="image">
</center>


- HugeCore: The core module of HugeGraph, the interface of TinkerPop is mainly implemented in this module. The function of HugeCore includes two parts: OLTP and OLAP.
- ApiServer: Provides RESTFul Api interface, and provides external interface services such as Graph Api, Schema Api, and Gremlin Api.
- HugeGraph-Client: Java-based client driver. HugeGraph-Client is a Java version client driver, which can provide Python, Go, C++ and other multi-language support as needed.
- HugeGraph-Loader: data import module. HugeGraph-Loader can scan and analyze existing data, automatically generate Graph Schema creation language, and quickly import data in batches.
- HugeGraph-Studio: Web-based visual IDE environment. Record Gremlin queries in Notebook mode, and visualize the relationship between Graphs. HugeGraph-Studio is also a tool recommended by this system.
- HugeGraph-Computer: HugeGraph-Computer is a distributed graph processing system (OLAP).
