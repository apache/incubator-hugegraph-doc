## Welcome to HugeGraph

### Summary

HugeGraph是一款易用、高效、通用的开源图数据库系统（Graph Database，[GitHub项目地址](https://github.com/hugegraph/hugegraph)），
实现了[Apache TinkerPop3](https://tinkerpop.apache.org)框架及完全兼容[Gremlin](https://tinkerpop.apache.org/gremlin.html)查询语言，
具备完善的工具链组件，助力用户轻松构建基于图数据库之上的应用和产品。HugeGraph支持百亿以上的顶点和边快速导入，并提供毫秒级的关联关系查询能力（OLTP），
并可与Hadoop、Spark等大数据平台集成以进行离线分析（OLAP）。

HugeGraph典型应用场景包括深度关系探索、关联分析、路径搜索、特征抽取、数据聚类、社区检测、
知识图谱等，适用业务领域有如网络安全、电信诈骗、金融风控、广告推荐、社交网络和智能机器人等。

本系统的主要应用场景是解决百度安全事业部所面对的反欺诈、威胁情报、黑产打击等业务的图数据存储和建模分析需求，在此基础上逐步扩展及支持了更多的通用图应用。

### Features

HugeGraph支持在线及离线环境下的图操作，支持批量导入数据，支持高效的复杂关联关系分析，并且能够与大数据平台无缝集成。
HugeGraph支持多用户并行操作，用户可输入Gremlin查询语句，并及时得到图查询结果，也可在用户程序中调用HugeGraph API进行图分析或查询。

本系统具备如下特点：  

- 易用：HugeGraph支持Gremlin图查询语言与Restful API，同时提供图检索常用接口，具备功能齐全的周边工具，轻松实现基于图的各种查询分析运算。
- 高效：HugeGraph在图存储和图计算方面做了深度优化，提供多种批量导入工具，轻松完成百亿数据快速导入，通过优化过的查询达到图检索的毫秒级响应。支持数千用户并发的在线实时操作。
- 通用：HugeGraph支持Apache Gremlin标准图查询语言和Property Graph标准图建模方法，支持基于图的OLTP和OLAP方案。集成Apache Hadoop及Apache Spark大数据平台。
- 可扩展：支持分布式存储、数据多副本及横向扩容，内置多种后端存储引擎，也可插件式轻松扩展后端存储引擎。
- 开放：HugeGraph代码开源（Apache 2 License），客户可自主修改定制，选择性回馈开源社区。

本系统的功能包括但不限于：

- 支持从TXT、CSV、JSON等格式的文件中批量导入数据
- 具备可视化操作界面，降低用户使用门槛
- 优化的图接口：最短路径(Shortest Path)、K步连通子图(K-neighbor)、K步到达邻接点(K-out)等
- 基于Apache TinkerPop3框架实现，支持Gremlin图查询语言
- 支持属性图，顶点和边均可添加属性，支持丰富的属性类型
- 具备独立的Schema元数据信息，方便第三方系统集成
- 支持多顶点ID策略：支持主键ID、支持自动生成ID、支持用户自定义字符串ID、支持用户自定义数字ID	
- 可以对边和顶点的属性建立索引，支持精确查询、范围查询、全文检索	
- 存储系统采用插件方式，支持RocksDB、Cassandra、ScyllaDB、HBase、Palo、MySQL以及InMemory等
- 与Hadoop、Spark GraphX等大数据系统集成，支持Bulk Load操作

### Modules

- [HugeGraph-Server](quickstart/hugegraph-server.md): HugeGraph-Server是HugeGraph项目的核心部分，包含Core、Backend、API等子模块；
  - Core：图引擎实现，向下连接Backend模块，向上支持API模块；
  - Backend：实现将图数据存储到后端，支持的后端包括：Memory、Cassandra、ScyllaDB、RocksDB、HBase及MySQL，用户根据实际情况选择一种即可；
  - API：内置REST Server，向用户提供RESTful API，同时完全兼容Gremlin查询。
- [HugeGraph-Client](quickstart/hugegraph-client.md)：HugeGraph-Client提供了RESTful API的客户端，用于连接HugeGraph-Server，目前仅实现Java版，其他语言用户可自行实现；
- [HugeGraph-Loader](quickstart/hugegraph-loader.md)：HugeGraph-Loader是基于HugeGraph-Client的数据导入工具，将普通文本数据转化为图形的顶点和边并插入图形数据库中；
- [HugeGraph-Spark](quickstart/hugegraph-spark.md)：HugeGraph-Spark能在图上做并行计算，例如PageRank算法等；
- [HugeGraph-Studio](quickstart/hugegraph-studio.md)：HugeGraph-Studio是HugeGraph的Web可视化工具，可用于执行Gremlin语句及展示图；
- [HugeGraph-Tools](quickstart/hugegraph-tools.md)：HugeGraph-Tools是HugeGraph的部署和管理工具，包括管理图、备份/恢复、Gremlin执行等功能。

### Contact Us

- 项目发起人：刘杰
- 项目负责人：韩祖利
- 技术负责人：[李章梅](https://github.com/javeme)
- 接口人：[张义](https://github.com/zhoney)，[李凝瑞](https://github.com/Linary)
- 反馈邮箱：[hugegraph@googlegroups.com](mailto:hugegraph@googlegroups.com)
- 微信公众号：HugeGraph
