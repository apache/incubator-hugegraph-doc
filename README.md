## Welcome to HugeGraph

### Summary

HugeGraph是一款开源图数据库(Graph Database)系统([GitHub项目地址](https://github.com/hugegraph/hugegraph))，可以存储海量的顶点(Vertex)和边(Edge)，
实现了[Apache TinkerPop 3](https://tinkerpop.apache.org)框架，支持[Gremlin](https://tinkerpop.apache.org/gremlin.html)查询语言。
HugeGraph支持多用户并行操作，用户可输入Gremlin查询语句，并及时得到图查询结果。也可在用户程序中调用HugeGraph API进行图分析或查询。

本系统的主要应用场景是解决百度安全事业部所面对的反欺诈、威胁情报、黑产打击等业务的图数据存储和建模分析需求，在此基础上逐步扩展及支持了更多的通用图应用。

### Features

HugeGraph支持在线及离线环境下的图操作，支持批量导入数据，支持高效的复杂关联关系分析，并且能够与大数据平台无缝集成。

本系统具备如下特点：  

- 基于TinkerPop 3 框架实现，支持Gremlin图查询语言
- 支持从TXT、CSV、JSON等格式的文件中批量导入数据
- 具备独立的Schema元数据信息，方便第三方系统集成
- 具备可视化操作界面，降低用户使用门槛
- 存储系统采用插件方式，支持RocksDB、Cassandra、ScyllaDB、HBase及MySQL等多种后端
- 优化的图接口：最短路径(Shortest Path)、K步连通子图(K-neighbor)、K步到达邻接点(K-out)等
- 支持属性图，顶点和边均可添加属性，支持丰富的属性类型
- 可以对边和顶点的属性建立索引，支持精确查询、范围查询、全文检索
- 支持多顶点ID策略：支持主键ID、支持自动生成ID、支持用户自定义字符串ID、支持用户自定义数字ID
- 与Hadoop、Spark GraphX等大数据系统集成，支持Bulk Load操作

### Modules

- [HugeGraph-Server](quickstart/hugegraph-server.md): HugeGraph-Server是HugeGraph项目的核心部分，包含Core、Backend、API等子模块；
  - Core：图引擎实现，向下连接Backend模块，向上支持API模块；
  - Backend：实现将图数据存储到后端，支持的后端包括：Memory、Cassandra、ScyllaDB、RocksDB、HBase及MySQL，用户根据实际情况选择一种即可；
  - API：内置REST Server，向用户提供RESTful API，同时完全兼容Gremlin查询。
- [HugeGraph-Client](quickstart/hugegraph-client.md)：HugeGraph-Client提供了RESTful API的客户端，用于连接HugeGraph-Server，目前仅实现Java版，其他语言用户可自行实现；
- [HugeGraph-Loader](quickstart/hugegraph-loader.md)：HugeGraph-Loader是基于HugeGraph-Client的数据导入工具，将普通文本数据转化为图形的顶点和边并插入图形数据库中；
- [HugeGraph-Spark](quickstart/hugegraph-spark.md)：HugeGraph-Spark能在图上做并行计算，例如PageRank算法等；
- [HugeGraph-Studio](quickstart/hugegraph-studio.md)：HugeGraph-Studio是HugeGraph的Web可视化工具，可用于执行Gremlin语句及展示图。

### Contact Us

- 负责人：[刘杰]()，[李章梅](https://github.com/javeme)
- 接口人：[王建奎](https://github.com/Jerrick)，[张义](https://github.com/zhoney)，[李凝瑞](https://github.com/Linary)
- 反馈邮箱：[hugegraph@googlegroups.com](mailto:hugegraph@googlegroups.com)
