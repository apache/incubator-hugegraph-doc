## Welcome to HugeGraph

### Summary

HugeGraph是一款图数据库（Graph Database）系统，可以存储海量的顶点（Vertex）和边（Edge），
实现了[Apache TinkerPop 3](https://tinkerpop.apache.org)框架，
支持[Gremlin](https://tinkerpop.apache.org/gremlin.html)查询语言。
HugeGraph可以支持多用户并行操作，用户可以输入Gremlin查询语句，并及时得到Graph查询结果。

本系统的主要应用场景是解决百度安全事业部所面对的金融反欺诈、威胁情报、黑产打击等业务的图数据存储和建模分析需求，在此基础上逐步扩展并支持更多的应用。

### Features

HugeGraph是一款离线环境下，面向分析型，支持批量操作的图数据库系统，它能够与大数据平台无缝集成。
本系统具备如下特点：  

- 基于TinkerPop 3 API实现，支持Gremlin图查询语言 
- 具备单独的meta元数据信息，方便第三方系统集成  
- 支持用户自定义边和顶点ID  
- 可以在边和顶点建立索引，支持精确查询、范围查询和模糊查询  
- 具备可视化操作界面，降低用户使用门槛  
- 存储系统采用插件方式，支持RocksDB、Cassandra、ScyllaDB以及MySQL等多种后端  
- 与Hadoop、Spark等大数据系统集成，支持Bulk Load操作  

### Modules

- [HugeGraph-Server](./quickstart/hugeserver.md): HugeGraph-Server是HugeGraph项目的核心部分，包含Core、Backend、API等子模块；
  - Core：是TinkerPop接口的实现，元数据管理，事务处理，序列化/反序列化，向下连接Backend模块，向上连接API模块；
  - Backend：实现将图数据存储到后端，支持的后端包括：Memory、Cassandra、ScyllaDB、RocksDB以及MySQL（0.5版本开始支持），用户根据实际情况选择一种即可；
  - API：内置Rest-Server，向用户提供Restful API，同时可兼容Gremlin查询，将客户端的HTTP请求转化为对Core代码的调用。
- [HugeGraph-Client](./quickstart/hugeclient.md)：HugeGraph-Client提供了RestAPI的客户端，用于连接HugeGraph-Server，目前仅实现Java版，其他语言用户可自行实现；
- [HugeGraph-Loader](./quickstart/hugeloader.md)：HugeGraph-Loader是基于HugeGraph-Client的数据导入工具，将普通文本数据转化为图形的顶点和边并插入图形数据库中；
- [HugeGraph-Spark](./quickstart/hugespark.md)：HugeGraph-Spark能在图上做并行计算，例如PageRank算法等；
- [HugeGraph-Studio](./quickstart/hugestudio.md)：HugeStudio是HugeGraph的Web可视化工具，可用于执行Gremlin语句及展示图。

### Contact Us

- 负责人：[刘杰](mailto:liujie23@baidu.com), [季石磊](mailto:jishilei@baidu.com)
- 接口人：[王建奎](mailto:wangjiankui@baidu.com)，[李章梅](mailto:lizhangmei@baidu.com)，[张义](mailto:zhangyi51@baidu.com)，[李凝瑞](liningrui@baidu.com)
- 反馈邮箱：[hugegraph@baidu.com](mailto:hugegraph@baidu.com)