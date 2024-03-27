---
title: "HugeGraph 1.3.0 Release Notes"
linkTitle: "Release-1.3.0"
weight: 11
---

### Java version statement

In 1.3.0:
1. consider using Java 11 in `hugegraph/toolchain/commons`, also compatible with Java 8 now.
2. `hugegraph-computer` required to use Java 11, **not compatible with Java 8!**
3. Using Java8 may loss some security ensured, we recommend using Java 11 in **production env** with AuthSystem enabled.

**1.3.0** is the last major version compatible with **Java 8**, compatibility with Java 8 will end in 
next release(1.5.0) when [PD/Store](https://github.com/apache/incubator-hugegraph/issues/2265) merged into master branch (Except for the `java-client`).

PS: In the future, we will gradually upgrade the java version, **Java 11** -> **Java 17** -> **Java 21**.

### hugegraph

> WIP: this doc is under construction, please wait for the final version (BETA) 

* fix(core): task restore interrupt problem on restart server by @xiaoleizi2016 in https://github.com/apache/incubator-hugegraph/pull/2401
* chore: add license link by @caicancai in https://github.com/apache/incubator-hugegraph/pull/2398
* doc: enhance NOTICE info to keep it clear by @imbajin in https://github.com/apache/incubator-hugegraph/pull/2409
* feat: support docker use the auth when starting by @aroundabout in https://github.com/apache/incubator-hugegraph/pull/2403
* fix(server): reinitialize the progress to set up graph auth friendly by @Z-HUANT in https://github.com/apache/incubator-hugegraph/pull/2411
* fix(chore): remove zgc in dockerfile for ARM env by @aroundabout in https://github.com/apache/incubator-hugegraph/pull/2421
* chore(server): update swagger info for default server profile by @SunnyBoy-WYH in https://github.com/apache/incubator-hugegraph/pull/2423
* fix(server): make CacheManager constructor private to satisfy the singleton pattern by @Pengzna in https://github.com/apache/incubator-hugegraph/pull/2432
* fix(server): unify the license headers by @msgui in https://github.com/apache/incubator-hugegraph/pull/2438
* fix: format and clean code in dist and example modules by @msgui in https://github.com/apache/incubator-hugegraph/pull/2441
* fix: format and clean code in core module by @msgui in https://github.com/apache/incubator-hugegraph/pull/2440
* fix: format and clean code in modules by @msgui in https://github.com/apache/incubator-hugegraph/pull/2439
* fix(server): clean up the code by @msgui in https://github.com/apache/incubator-hugegraph/pull/2456
* fix(server): unify license header for protobuf file by @VGalaxies in https://github.com/apache/incubator-hugegraph/pull/2448
* chore: improve license header checker confs and pre-check header when validating by @VGalaxies in https://github.com/apache/incubator-hugegraph/pull/2445
* chore: unify to call SchemaLabel.getLabelId() by @javeme in https://github.com/apache/incubator-hugegraph/pull/2458
* fix(server): remove extra blank lines by @msgui in https://github.com/apache/incubator-hugegraph/pull/2459
* feat(api): optimize adjacent-edges query by @Z-HUANT in https://github.com/apache/incubator-hugegraph/pull/2408
* chore: refine the hg-style.xml specification by @returnToInnocence in https://github.com/apache/incubator-hugegraph/pull/2457
* chore: Add a newline formatting configuration and a comment for warning by @returnToInnocence in https://github.com/apache/incubator-hugegraph/pull/2464
* fix(server): add tip for gremlin api NPE with empty query by @SunnyBoy-WYH in https://github.com/apache/incubator-hugegraph/pull/2467
* fix(server):fix the metric name when promthus collect hugegraph metric,see issue by @SunnyBoy-WYH in https://github.com/apache/incubator-hugegraph/pull/2462
* fix(server): `serverStarted` error when execute gremlin example by @VGalaxies in https://github.com/apache/incubator-hugegraph/pull/2473
* fix(auth): enhance the URL check by @zyxxoo in https://github.com/apache/incubator-hugegraph/pull/2422
* feat: added the OpenTelemetry trace support by @lynnbond in https://github.com/apache/incubator-hugegraph/pull/2477
* chore(server): clear context after req done by @SunnyBoy-WYH in https://github.com/apache/incubator-hugegraph/pull/2470
* refact(server): enhance the storage path in RocksDB & clean code by @imbajin in https://github.com/apache/incubator-hugegraph/pull/2491

#### API Changes


#### Feature Changes


#### Bug Fix


#### Option Changes


#### Other Changes


#### Bug Fix


#### Option Changes


#### Other Changes

### hugegraph-toolchain

* doc: update copyright date(year) in NOTICE ([#567](https://github.com/apache/incubator-hugegraph-toolchain/pull/567))
* chore(deps): bump ip from 1.1.5 to 1.1.9 in /hugegraph-hubble/hubble-fe ([#580](https://github.com/apache/incubator-hugegraph-toolchain/pull/580)) 
* fix: concurrency issue causing file overwrite due to identical filenames ([#572](https://github.com/apache/incubator-hugegraph-toolchain/pull/572))
* refactor(hubble): enhance maven front plugin ([#568](https://github.com/apache/incubator-hugegraph-toolchain/pull/568))
* fix(loader): update shade plugin for spark loader ([#566](https://github.com/apache/incubator-hugegraph-toolchain/pull/566))
* chore(deps): bump es5-ext from 0.10.53 to 0.10.63 in /hugegraph-hubble/hubble-fe ([#582](https://github.com/apache/incubator-hugegraph-toolchain/pull/582))
* fix(hubble): yarn install timeout in arm64 ([#583](https://github.com/apache/incubator-hugegraph-toolchain/pull/583))
* feat(client): support user defined OKHTTPClient configs ([#590](https://github.com/apache/incubator-hugegraph-toolchain/pull/590))
* fix(loader): support file name with prefix for hdfs source ([#571](https://github.com/apache/incubator-hugegraph-toolchain/pull/571))
* chore(hubble): Enhance code style in hubble ([#592](https://github.com/apache/incubator-hugegraph-toolchain/pull/592))
* feat(hubble):  warp the exception info in HugeClientUtil ([#589](https://github.com/apache/incubator-hugegraph-toolchain/pull/589))
* chore: upgrade version to 1.3.0 ([#596](https://github.com/apache/incubator-hugegraph-toolchain/pull/596))
* chore(ci): update profile commit id for 1.3 ([#597](https://github.com/apache/incubator-hugegraph-toolchain/pull/597))


#### API Changes

#### Feature Changes


#### Bug Fix

#### Option Changes

#### Other Changes


### hugegraph-commons



#### Feature Changes

#### Bug Fix

#### Other Changes

### Release Details

Please check the release details in each repository:

- [Server Release Notes](https://github.com/apache/incubator-hugegraph/releases)
- [Toolchain Release Notes](https://github.com/apache/incubator-hugegraph-toolchain/releases)
- [Computer Release Notes](https://github.com/apache/incubator-hugegraph-computer/releases)
- [Commons Release Notes](https://github.com/apache/incubator-hugegraph-commons/releases)
