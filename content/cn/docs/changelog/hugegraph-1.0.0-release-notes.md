---
title: "HugeGraph 1.0.0 Release Notes"
linkTitle: "Release-1.0.0"
weight: 1
---

> Note: the summary is updating, please check the detail in each repository first, thanks

- [Server Release Note](https://github.com/apache/incubator-hugegraph/releases/tag/1.0.0)
- [Toolchain Release Note](https://github.com/apache/incubator-hugegraph-toolchain/releases/tag/1.0.0)
- [Computer Release Note](https://github.com/apache/incubator-hugegraph-computer/releases/tag/1.0.0)
- [Commons Release Note](https://github.com/apache/incubator-hugegraph-commons/releases/tag/1.0.0)

### OLTP API & Client 更新

#### API/Client 接口更新

- 支持热更新`trace`开关的 `/exception/trace` API。
- 支持 Cypher 图查询语言 API。
- 支持通过 Swagger UI 接口来查看提供的 API 列表。
- 将各算法中 'limit' 参数的类型由 long 调整为 int。
- 支持在 Client 端跳过 Server 对 HBase 写入数据 (Beta)。

### Core & Server

#### 功能更新

- 支持 Java 11 版本。
- 支持 2 个新的 OLTP 算法： adamic-adar 和 resource-allocation。
- 支持 HBase 后端使用哈希 RowKey，并且允许预初始化 HBase 表。
- 支持 Cypher 图查询语言。
- 支持集群 Master 角色的自动管理与故障转移。
- 支持 16 个 OLAP 算法, 包括：LPA, Louvain, PageRank, BetweennessCentrality, RingsDetect等。
- 根据 Apache 基金会对项目的发版要求进行适配，包括 License 合规性、发版流程、代码风格等。

#### Bug 修复

- 修复无法根据多个 Label 和属性来查询边数据。
- 增加对环路检测算法的最大深度限制。
- 修复 tree() 语句返回结果异常问题。
- 修复批量更新边传入 Id 时的检查异常问题。
- 解决非预期的 Task 状态问题。
- 解决在更新顶点时未清除边缓存的问题。
- 修复 MySQL 后端执行 g.V() 时的错误。
- 修复因为 server-info 无法超时导致的问题。
- 导出了 ConditionP 类型用于 Gremlin 中用户使用。
- 修复 within + Text.contains 查询问题。
- 修复 addIndexLabel/removeIndexLabel 接口的竞争条件问题。
- 限制仅 Admin 允许输出图实例。
- 修复 Profile API 的检查问题。
- 修复在 count().is(0) 查询中 Empty Graph 的问题。
- 修复在异常时无法关闭服务的问题。
- 修复在 Apple M1 系统上的 JNA 报错 UnsatisfiedLinkError 的问题。
- 修复启动 RpcServer 时报 NPE 的问题。
- 修复 ACTION_CLEARED 参数数量的问题。
- 修复 RpcServer 服务启动问题。
- 修复用户传入参数可能得数字转换隐患问题。
- 移除了 Word 分词器依赖。
- 修复 Cassandra 与 MySQL 后端在异常时未优雅关闭迭代器的问题。

#### 配置项更新

- 将配置项 `raft.endpoint` 从 Graph 作用域移动到 Server 作用域中。

#### 其它修改

- refact(core): enhance schema job module.
- refact(raft): improve raft module & test & install snapshot and add peer.
- refact(core): remove early cycle detection & limit max depth.
- cache: fix assert node.next==empty.
- fix apache license conflicts: jnr-posix and jboss-logging.
- chore: add logo in README & remove outdated log4j version.
- refact(core): improve CachedGraphTransaction perf.
- chore: update CI config & support ci robot & add codeQL SEC-check & graph option.
- refact: ignore security check api & fix some bugs & clean code.
- doc: enhance CONTRIBUTING.md & README.md.
- refact: add checkstyle plugin & clean/format the code.
- refact(core): improve decode string empty bytes & avoid array-construct columns in BackendEntry.
- refact(cassandra): translate ipv4 to ipv6 metrics & update cassandra dependency version.
- chore: use .asf.yaml for apache workflow & replace APPLICATION_JSON with TEXT_PLAIN.
- feat: add system schema store.
- refact(rocksdb): update rocksdb version to 6.22 & improve rocksdb code.
- refact: update mysql scope to test & clean protobuf style/configs.
- chore: upgrade Dockerfile server to 0.12.0 & add editorconfig & improve ci.
- chore: upgrade grpc version.
- feat: support updateIfPresent/updateIfAbsent operation.
- chore: modify abnormal logs & upgrade netty-all to 4.1.44.
- refact: upgrade dependencies & adopt new analyzer & clean code.
- chore: improve .gitignore & update ci configs & add RAT/flatten plugin.
- chore(license): add dependencies-check ci & 3rd-party dependency licenses.
- refact: Shutdown log when shutdown process & fix tx leak & enhance the file path.
- refact: rename package to apache & dependency in all modules (Breaking Change).
- chore: add license checker & update antrun plugin & fix building problem in windows.
- feat: support one-step script for apache release v1.0.0 release.

.... (Toolchain, Computer, Commons, etc.)
