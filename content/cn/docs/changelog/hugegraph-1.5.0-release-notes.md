---
title: "HugeGraph 1.5.0 Release Notes"
linkTitle: "Release-1.5.0"
weight: 5
---

> WIP: This doc is under construction, please wait for the final version (BETA) 

### 运行环境/版本说明

1. 相较于 **1.3.0**，**1.5.0** 的 `hugegraph` 仅支持 Java 11

PS: 未来 HugeGraph 组件的版本会朝着 `Java 11 -> Java 17 -> Java 21` 演进

### hugegraph

> 1. 本版本新增了大量功能并进行了多项优化，尤其是针对分布式版本新后端 HStore 的支持
> 2. hugegraph-commons 模块合入 hugegraph 主仓库
> 3. 新增 hugegraph 集成测试框架

#### API Changes

* feat(api): Support ignoring the graphspaces part in the URL ([#2612](https://github.com/apache/incubator-hugegraph/pull/2612))

#### Feature Changes

* feat(store): Integrate `store-rocksdb` submodule ([#2513](https://github.com/apache/incubator-hugegraph/pull/2513))
* feat(store): Integrate `store-grpc`, `store-common`, and `store-client` ([#2476](https://github.com/apache/incubator-hugegraph/pull/2476))
* feat(store): Integrate `store-core` and `store-node` submodules ([#2548](https://github.com/apache/incubator-hugegraph/pull/2548), [#2537](https://github.com/apache/incubator-hugegraph/pull/2537))
* feat(pd): Integrate `pd-core` and `pd-service` modules ([#2478](https://github.com/apache/incubator-hugegraph/pull/2478), [#2528](https://github.com/apache/incubator-hugegraph/pull/2528))
* feat(pd): Integrate `pd-grpc`, `pd-common`, and `pd-client` modules ([#2498](https://github.com/apache/incubator-hugegraph/pull/2498))
* feat(pd): Integrate `pd-dist` module and add core, client, and REST tests ([#2532](https://github.com/apache/incubator-hugegraph/pull/2532))
* feat(server): Integrate `server-hstore` module ([#2534](https://github.com/apache/incubator-hugegraph/pull/2534))
* feat(server): Support new Hstore backend ([#2560](https://github.com/apache/incubator-hugegraph/pull/2560))
* feat(server): Support switching RocksDB backend to in-memory mode in Gremlin example scripts ([#2518](https://github.com/apache/incubator-hugegraph/pull/2518))
* feat(dist): Support Docker deployment for PD and Store ([#2573](https://github.com/apache/incubator-hugegraph/pull/2573))
* feat(server): Support heap memory JVM monitoring ([#2650](https://github.com/apache/incubator-hugegraph/pull/2650))

#### Bug Fixes

* fix(pd): Fix issue where partition ID was always empty in Shards List ([#2596](https://github.com/apache/incubator-hugegraph/pull/2596))
* fix(pd/store): Fix issue where log file was not rolling correctly during process execution ([#2589](https://github.com/apache/incubator-hugegraph/pull/2589))
* fix(pd): Fix logical error in PartitionCache locking for graphs ([#2640](https://github.com/apache/incubator-hugegraph/pull/2640))
* fix(pd): Ensure thread safety of range properties ([#2641](https://github.com/apache/incubator-hugegraph/pull/2641))
* fix(server): Fix issue where Gremlin example script's backend configuration was overwritten ([#2519](https://github.com/apache/incubator-hugegraph/pull/2519))
* fix(hstore): Fix JRaft Timer Metrics error ([#2602](https://github.com/apache/incubator-hugegraph/pull/2602))
* fix(hstore): Fix issue where `maxEntriesSize` JRaft config parameter was not effective ([#2630](https://github.com/apache/incubator-hugegraph/pull/2630))
* fix(hstore): Print Hstore GC logs with timestamps ([#2636](https://github.com/apache/incubator-hugegraph/pull/2636))
* fix(server): Fix incorrect source path in Docker container ([#2637](https://github.com/apache/incubator-hugegraph/pull/2637))
* fix(server): Resolve NPE issue in Gremlin queries ([#2467](https://github.com/apache/incubator-hugegraph/pull/2467))

#### Breaking Changes

* BREAKING CHANGE(server): Support for "parent & child" EdgeLabel type ([#2662](https://github.com/apache/incubator-hugegraph/pull/2662))
* BREAKING CHANGE(server): Change the default value generation method, now it is randomly generated ([#2568](https://github.com/apache/incubator-hugegraph/pull/2568))

#### Refactor Changes

* refact(pd/store): Clean up unused files and optimize code ([#2681](https://github.com/apache/incubator-hugegraph/pull/2681))
* refact(server): Optimize server-node information ([#2671](https://github.com/apache/incubator-hugegraph/pull/2671))
* refact(server): Increase write byte limit and remove the `big` parameter when encoding/decoding string IDs ([#2622](https://github.com/apache/incubator-hugegraph/pull/2622))

#### Other Changes

* chore: Update license to version 1.5 ([#2687](https://github.com/apache/incubator-hugegraph/pull/2687))
* chore: Add `editorconfig-maven-plugin` to validate code styles defined in `.editorconfig` ([#2591](https://github.com/apache/incubator-hugegraph/pull/2591))
* chore: Refactor build scripts to support `install-dist` module ([#2552](https://github.com/apache/incubator-hugegraph/pull/2552))
* chore: Remove Java 8 dependency in CI ([#2503](https://github.com/apache/incubator-hugegraph/pull/2503))
* chore: Enable Docker build support and simplify CI naming ([#2599](https://github.com/apache/incubator-hugegraph/pull/2599))
* chore: Migrate `hg-style.xml` to `.editorconfig` configuration ([#2561](https://github.com/apache/incubator-hugegraph/pull/2561))
* chore: Temporarily ignore hstore module core test failures in `ci` ([#2599](https://github.com/apache/incubator-hugegraph/pull/2599))

#### Documentation Changes

* doc(server): Improve comments in `rest-server.properties` configuration file ([#2610](https://github.com/apache/incubator-hugegraph/pull/2610))
* doc(pd): Add comment for `initial-store-count` configuration option ([#2587](https://github.com/apache/incubator-hugegraph/pull/2587))

### hugegraph-toolchain

### hugegraph-ai

### hugegraph-computer

### 发布细节

Please check the release details/contributor in each repository:

- [Server Release Notes](https://github.com/apache/incubator-hugegraph/releases)
- [Toolchain Release Notes](https://github.com/apache/incubator-hugegraph-toolchain/releases)
- [Computer Release Notes](https://github.com/apache/incubator-hugegraph-computer/releases)
- [AI Release Notes](https://github.com/apache/incubator-hugegraph-ai/releases)
