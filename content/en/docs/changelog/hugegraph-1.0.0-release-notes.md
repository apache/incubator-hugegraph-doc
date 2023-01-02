---
title: "HugeGraph 1.0.0 Release Notes"
linkTitle: "Release-1.0.0"
weight: 1
---

> TODO: update the summary soon, please check the detail in each repository first, thanks

- [Server Release Note](https://github.com/apache/incubator-hugegraph/releases/tag/1.0.0)
- [Toolchain Release Note](https://github.com/apache/incubator-hugegraph-toolchain/releases/tag/1.0.0)
- [Computer Release Note](https://github.com/apache/incubator-hugegraph-computer/releases/tag/1.0.0)
- [Commons Release Note](https://github.com/apache/incubator-hugegraph-commons/releases/tag/1.0.0)

### OLTP API & Client Changes

#### API Changes

- feat(api): support hot set trace through /exception/trace API.
- feat(api): support query by cypher language.
- feat(api): support swagger UI to viewing API.

#### Client Changes

- xx

### Core & Server

#### Feature Changes

- feat: support java 11 & adapt shell/ci code.
- feat(core): support adamic-adar & resource-allocation algorithms.
- feat(hbase): support hash rowkey struct & pre-init tables.
- feat(core): support query data by use cypher language.
- feat(core): support automatic management for cluster role.
- feat(core): support 16 OLAP algorithms, like LPA, Louvain, PageRank, BetweennessCentrality, RingsDetect.

#### Bug Fix

- fix(core): NoSuchMethodError Relations() & can't query edges by multi labels + properties.
- fix(core): limit max depth for cycle detection.
- fix: tree step & edge batch update error & edge cache & task status.
- fix(mysql): run g.V() is error & update ci with docker image in MySQL.
- fix: close exception and server-info EXPIRED_INTERVAL.
- fix: export ConditionP.
- fix: query by within + Text.contains.
- fix: schema label race condition of addIndexLabel/removeIndexLabel.
- fix: limit admin role can drop graph.
- fix: ProfileApi url check & add build package to ignore file
- fix: empty-graph in count().is(0)& can't shutdown with exception & possible extra comma.
- fix: JNA UnsatisfiedLinkError for Apple M1.
- fix: start RpcServer NPE & args count of ACTION_CLEARED error & example error.
- fix: rpc server not start.
- fix: User-controlled data in numeric cast & remove word dependency.
- fix: closing iterators on errors for Cassandra & Mysql.

#### Options Changes

- move `raft.endpoint` option from graph scope to server scope.

#### Other Changes

- refact(core): enhance schema job module.
- refact(raft): improve raft module & test & install snapshot and add peer.
- refact(core): remove early cycle detection & limit max depth.
- cache: fix assert node.next==empty.
- fix apache license conflicts: jnr-posix and jboss-logging.
- chore: add logo in README & remove outdated log4j version.
- refact(core): improve CachedGraphTransaction perf.
- chore: update CI config & support ci robot & add codeQL SEC-check & graph option.
- refact: ingore security check api & fix some bugs & clean code.
- doc: enhance CONTRIBUTING.md & README.md.
- refact: add checkstyle plugin & clean/format the code.
- refact(core): improve decode string empty bytes & avoid array-construct columns in BackendEntry.
- refact(cassandra): translate ipv4 to ipv6 metrics & update cassandra dependency vesion.
- chore: use .asf.yaml for apache workflow & replace APPLICATION_JSON with TEXT_PLAIN.
- feat: add system schema store.
- refact(rocksdb): update rocksdb version to 6.22 & improve rocksdb code.
- refact: update mysql scope to test & clean protobuf style/configs.
- chore: upgrade Dockerfile server to 0.12.0 & add editorconfig & improve ci.
- chore: upgrade grpc version.
- feat: support updateIfPresent/updateIfAbsent operation.
- chore: modify abnormal logs & upgrade netty-all to 4.1.44.
- refact: upgrade dependencies & adopt new analyzer & clean code.
- chore: improve .gitignore & update ci configs & add RAT/faltten plugin.
- chore(license): add dependencies-check ci & 3rd-party dependency licenses.
- refact: Shutdown log when shutdown process & fix tx leak & enhance the file path.
- refact: rename package to apache & dependency in all modules (Breaking Change).
- chore: add license checker & update antrun plugin & fix building problem in windows.
- feat: support one-step script for apache release v1.0.0 release.

### Toolchain Changes

- xx
- xx

### Computer Changes

- xx
- xx

### Commons Changes

- xx
- xx
