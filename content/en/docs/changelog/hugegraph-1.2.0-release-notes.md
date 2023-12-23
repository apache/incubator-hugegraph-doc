---
title: "HugeGraph 1.2.0 Release Notes"
linkTitle: "Release-1.2.0"
weight: 1
---

### hugegraph
* fix: transfer add_peer/remove_peer command to leader by @simon824 in https://github.com/apache/incubator-hugegraph/pull/2112
* doc: update issue template & README file by @imbajin in https://github.com/apache/incubator-hugegraph/pull/2131
* chore: cmn algorithm optimization by @zyxxoo in https://github.com/apache/incubator-hugegraph/pull/2134
* add github token for license check comment by @JackyYangPassion in https://github.com/apache/incubator-hugegraph/pull/2139
* refact: use standard UTF-8 charset & enhance CI configs by @imbajin in https://github.com/apache/incubator-hugegraph/pull/2095
* refact: use a slim way to build docker image on latest code & support zgc by @imbajin in https://github.com/apache/incubator-hugegraph/pull/2118
* chore: disable PR up-to-date in branch by @javeme in https://github.com/apache/incubator-hugegraph/pull/2150
* feat: support task auto manage by server role state machine by @zyxxoo in https://github.com/apache/incubator-hugegraph/pull/2130
* fix query dirty edges of a vertex with cache by @javeme in https://github.com/apache/incubator-hugegraph/pull/2166
* feat: support parallel compress snapshot by @wuchaojing in https://github.com/apache/incubator-hugegraph/pull/2136
* refact(core): remove lock of globalMasterInfo to optimize perf by @zyxxoo in https://github.com/apache/incubator-hugegraph/pull/2151
* feat: use an enhanced CypherAPI to refactor it by @lynnbond in https://github.com/apache/incubator-hugegraph/pull/2143
* chore: remove stage-repo in pom due to release done & update mail rule by @z7658329 in https://github.com/apache/incubator-hugegraph/pull/2128
* move validate release to hugegraph-doc by @z7658329 in https://github.com/apache/incubator-hugegraph/pull/2109
* fix exception of vertex-drop with index by @simon824 in https://github.com/apache/incubator-hugegraph/pull/2181
* chore: async remove left index shouldn't effect query by @zyxxoo in https://github.com/apache/incubator-hugegraph/pull/2199
* fix: remove dup 'From' in filterExpiredResultFromFromBackend by @KeeProMise in https://github.com/apache/incubator-hugegraph/pull/2207
* refact(core): early stop unnecessary loops in edge cache by @GYXkeep in https://github.com/apache/incubator-hugegraph/pull/2211
* refact(core): optimized batch removal of remaining indices consumed by a single consumer by @zyxxoo in https://github.com/apache/incubator-hugegraph/pull/2203
* chore: update .asf.yaml for mail rule by @imbajin in https://github.com/apache/incubator-hugegraph/pull/2221
* doc: update README & add QR code by @msgui in https://github.com/apache/incubator-hugegraph/pull/2218
* fix: jdbc ssl mode parameter redundant by @liuxiaocs7 in https://github.com/apache/incubator-hugegraph/pull/2224
* fix: error when start gremlin-console with sample script by @VGalaxies in https://github.com/apache/incubator-hugegraph/pull/2231
* chore: improve the UI & content in README by @lionztt in https://github.com/apache/incubator-hugegraph/pull/2227
* add com.janeluo.ikkanalyzer dependency to core model by @KeeProMise in https://github.com/apache/incubator-hugegraph/pull/2206
* fix: update ssl_mode value by @liuxiaocs7 in https://github.com/apache/incubator-hugegraph/pull/2235
* chore: add pr template by @liuxiaocs7 in https://github.com/apache/incubator-hugegraph/pull/2234
* fix(core): support order by id  by @liuxiaocs7 in https://github.com/apache/incubator-hugegraph/pull/2233
* doc: modify ASF and remove meaningless CLA by @KeeProMise in https://github.com/apache/incubator-hugegraph/pull/2237
* fix: optimizing ClassNotFoundException error message for MYSQL by @Z-HUANT in https://github.com/apache/incubator-hugegraph/pull/2246
* feat(perf): support JMH benchmark in HG-test module by @conghuhu in https://github.com/apache/incubator-hugegraph/pull/2238
* fix：asf invalid notification scheme 'discussions_status' by @Z-HUANT in https://github.com/apache/incubator-hugegraph/pull/2247
* fix: asf invalid notification scheme 'discussions_comment' by @Z-HUANT in https://github.com/apache/incubator-hugegraph/pull/2250
* fix: incorrect use of 'NO_LIMIT' variable by @DanGuge in https://github.com/apache/incubator-hugegraph/pull/2253
* feat(api&core):  in oltp apis, add statistics info and support full info about vertices and edges by @DanGuge in https://github.com/apache/incubator-hugegraph/pull/2262
* Update StandardStateMachineCallback.java by @lzyxx77 in https://github.com/apache/incubator-hugegraph/pull/2290
* chore(dist): replace wget to curl to download swagger-ui  by @VGalaxies in https://github.com/apache/incubator-hugegraph/pull/2277
* feat(dist): support pre-load test graph data in docker container by @aroundabout in https://github.com/apache/incubator-hugegraph/pull/2241
* fix(core): close flat mapper iterator after usage by @qwtsc in https://github.com/apache/incubator-hugegraph/pull/2281
* fix(dist): avoid var PRELOAD cover environmnet vars by @aroundabout in https://github.com/apache/incubator-hugegraph/pull/2302
* feat(api-core): support label & property filtering for both edge and vertex & support kout dfs mode by @DanGuge in https://github.com/apache/incubator-hugegraph/pull/2295
* fix: base-ref/head-ref missed in dependency-review on master by @msgui in https://github.com/apache/incubator-hugegraph/pull/2308
* doc: update README about start server with example graph by @aroundabout in https://github.com/apache/incubator-hugegraph/pull/2315
* Feat: IP white list by @SunnyBoy-WYH in https://github.com/apache/incubator-hugegraph/pull/2299
* feat(api): support metric API Prometheus format & add statistic metric api  by @SunnyBoy-WYH in https://github.com/apache/incubator-hugegraph/pull/2286
* README.md tiny improve by @javeme in https://github.com/apache/incubator-hugegraph/pull/2320
* feat(api): support embedded arthas agent in hugegraph-server by @SunnyBoy-WYH in https://github.com/apache/incubator-hugegraph/pull/2278
* doc: README.md tiny improve  by @aroundabout in https://github.com/apache/incubator-hugegraph/pull/2331
* feat: support Cassandra with docker-compose in server by @aroundabout in https://github.com/apache/incubator-hugegraph/pull/2307
* fix: in wait-storage.sh, always wait for storage with default rocksdb  by @aroundabout in https://github.com/apache/incubator-hugegraph/pull/2333
* feat(core): support batch+parallel edges traverse by @DanGuge in https://github.com/apache/incubator-hugegraph/pull/2312
* fix(core): handle schema Cache expandCapacity concurrent problem by @conghuhu in https://github.com/apache/incubator-hugegraph/pull/2332
* feat(cassandra): adapt cassandra from 3.11.12 to 4.0.10 by @lzyxx77 in https://github.com/apache/incubator-hugegraph/pull/2300
* chore(api): add swagger desc for Arthas & Metric & Cypher & White API by @SunnyBoy-WYH in https://github.com/apache/incubator-hugegraph/pull/2337
* feat(api): support recording slow query log by @SunnyBoy-WYH in https://github.com/apache/incubator-hugegraph/pull/2327
* refact: adjust project structure for merge PD & Store[Breaking Change] by @VGalaxies in https://github.com/apache/incubator-hugegraph/pull/2338
* fix(api): clean some code for release by @imbajin in https://github.com/apache/incubator-hugegraph/pull/2348
* fix(api): refactor/downgrade record logic for slow log by @imbajin in https://github.com/apache/incubator-hugegraph/pull/2347
* feat: adapt Dockerfile for new project structure by @aroundabout in https://github.com/apache/incubator-hugegraph/pull/2344
* fix: remove redirect-to-master from synchronous Gremlin API by @qwtsc in https://github.com/apache/incubator-hugegraph/pull/2356
* chore: disable raft test in normal PR due to timeout problem by @imbajin in https://github.com/apache/incubator-hugegraph/pull/2349
* feat(server):swagger support auth for standardAuth mode  by @SunnyBoy-WYH in https://github.com/apache/incubator-hugegraph/pull/2360
* chore(ci): add stage profile settings by @lzyxx77 in https://github.com/apache/incubator-hugegraph/pull/2361
* fix HBase PrefixFilter bug by @haohao0103 in https://github.com/apache/incubator-hugegraph/pull/2364
* feat: optimising adjacency edge queries by @msgui in https://github.com/apache/incubator-hugegraph/pull/2242
* chore: move server info into GlobalMasterInfo by @javeme in https://github.com/apache/incubator-hugegraph/pull/2370
* chore: fix curl failed to request https urls by @simon824 in https://github.com/apache/incubator-hugegraph/pull/2378
* refact(api): update common 1.2 & fix jersey client code problem by @zhenyuT in https://github.com/apache/incubator-hugegraph/pull/2365
* fix(api): correct the vertex id in the edge-existence api by @msgui in https://github.com/apache/incubator-hugegraph/pull/2380
* chore: reset hugegraph version to 1.2.0 by @VGalaxies in https://github.com/apache/incubator-hugegraph/pull/2382
* refact(rocksdb): clean & reformat some code by @imbajin in https://github.com/apache/incubator-hugegraph/pull/2200
* feat(core): add IntMapByDynamicHash V1 implement by @conghuhu in https://github.com/apache/incubator-hugegraph/pull/2377
* fix: github action build docker image failed during the release 1.2 process by @aroundabout in https://github.com/apache/incubator-hugegraph/pull/2386
* fix: TinkerPop unit test lack some lables by @zyxxoo in https://github.com/apache/incubator-hugegraph/pull/2387


### hugegraph-computer
* remove apache stage repo & update notification rule by @z7658329 in https://github.com/apache/incubator-hugegraph-computer/pull/232
* chore: fix empty license file by @simon824 in https://github.com/apache/incubator-hugegraph-computer/pull/233
* chore: enhance mailbox settings & enable require ci by @imbajin in https://github.com/apache/incubator-hugegraph-computer/pull/235
* fix: typo errors in start-computer.sh by @Radeity in https://github.com/apache/incubator-hugegraph-computer/pull/238
* [Feature-241] Add PULL_REQUEST_TEMPLATE by @Radeity in https://github.com/apache/incubator-hugegraph-computer/pull/242
* chore：change etcd url only for ci by @coderzc in https://github.com/apache/incubator-hugegraph-computer/pull/245
* feat: implement fast-failover for MessageRecvManager and DataClientManager by @Radeity in https://github.com/apache/incubator-hugegraph-computer/pull/243
* feat: implement parallel send data in load graph step by @Radeity in https://github.com/apache/incubator-hugegraph-computer/pull/248
* fix: superstep not take effect by @JackyYangPassion in https://github.com/apache/incubator-hugegraph-computer/pull/237
* doc: update readme & add QR code by @msgui in https://github.com/apache/incubator-hugegraph-computer/pull/249
* feat(core): isolate namespace for different input data source by @Radeity in https://github.com/apache/incubator-hugegraph-computer/pull/252
* doc(k8s): add building note for missing classes by @conghuhu in https://github.com/apache/incubator-hugegraph-computer/pull/254
* chore: reduce mail to dev list by @imbajin in https://github.com/apache/incubator-hugegraph-computer/pull/255
* chore: update PULL_REQUEST_TEMPLATE.md by @Radeity in https://github.com/apache/incubator-hugegraph-computer/pull/257
* feat(k8s): init operator project & add webhook by @Radeity in https://github.com/apache/incubator-hugegraph-computer/pull/259
* fix(k8s): remove crd declaration in operator yaml by @Radeity in https://github.com/apache/incubator-hugegraph-computer/pull/263
* add: dependency-review by @msgui in https://github.com/apache/incubator-hugegraph-computer/pull/266
* chore: correct incorrect comment by @diaohancai in https://github.com/apache/incubator-hugegraph-computer/pull/268
* refact(core): support auth config for computer task by @diaohancai in https://github.com/apache/incubator-hugegraph-computer/pull/265
* fix(k8s): modify inconsistent apiGroups by @Radeity in https://github.com/apache/incubator-hugegraph-computer/pull/270
* feat(core): support load vertex/edge snapshot by @Radeity in https://github.com/apache/incubator-hugegraph-computer/pull/269
* feat(k8s): Add MinIO as internal(default) storage by @Radeity in https://github.com/apache/incubator-hugegraph-computer/pull/272
* feat(algorithm): support random walk in computer by @diaohancai in https://github.com/apache/incubator-hugegraph-computer/pull/274
* fix(algorithm): record loop is not copied by @corgiboygsj in https://github.com/apache/incubator-hugegraph-computer/pull/276
* refactor(api): ListValue.getFirst() replaces ListValue.get(0) by @diaohancai in https://github.com/apache/incubator-hugegraph-computer/pull/282
* feat: use 'foreground' delete policy to cancel k8s job by @qwtsc in https://github.com/apache/incubator-hugegraph-computer/pull/290
* feat(algorithm): support biased second order random walk by @diaohancai in https://github.com/apache/incubator-hugegraph-computer/pull/280
* Improve: Passing workerId to WorkerStat & Skip wait worker close if master executes failed by @coderzc in https://github.com/apache/incubator-hugegraph-computer/pull/292
* refact(core): adaptor for common 1.2 & fix a string of possible CI problem by @imbajin in https://github.com/apache/incubator-hugegraph-computer/pull/286
* chore: add check dependencies by @simon824 in https://github.com/apache/incubator-hugegraph-computer/pull/293
* fix: remove okhttp1 due to conflicts risk by @imbajin in https://github.com/apache/incubator-hugegraph-computer/pull/294

### hugegraph-toolchain

#### API Changes

- feat(client): support edgeExistence api ([#544](https://github.com/apache/incubator-hugegraph-toolchain/pull/544))
- refact(client): update tests for new OLTP traverser APIs ([#550](https://github.com/apache/incubator-hugegraph-toolchain/pull/550))


#### Feature Changes

- feat(spark): support spark-sink connector for loader ([#497](https://github.com/apache/incubator-hugegraph-toolchain/pull/497))
- feat(loader): support kafka as datasource ([#506](https://github.com/apache/incubator-hugegraph-toolchain/pull/506))
- feat(client): support go client for hugegraph ([#514](https://github.com/apache/incubator-hugegraph-toolchain/pull/514))
- feat(loader): support docker for loader ([#530](https://github.com/apache/incubator-hugegraph-toolchain/pull/530))
- feat: update common version and remove jersey code ([#538](https://github.com/apache/incubator-hugegraph-toolchain/pull/538))


#### Bug Fix

- fix: convert numbers to strings ([#465](https://github.com/apache/incubator-hugegraph-toolchain/pull/465))
- fix: hugegraph-spark-loader shell string length limit ([#469](https://github.com/apache/incubator-hugegraph-toolchain/pull/469))
- fix: spark loader meet Exception: Class is not registered ([#470](https://github.com/apache/incubator-hugegraph-toolchain/pull/470))
- fix: spark loader Task not serializable ([#471](https://github.com/apache/incubator-hugegraph-toolchain/pull/471))
- fix: spark with loader has dependency conflicts ([#480](https://github.com/apache/incubator-hugegraph-toolchain/pull/480))
- fix: spark-loader example schema and struct mismatch ([#504](https://github.com/apache/incubator-hugegraph-toolchain/pull/504))
- fix(loader): error log ([#499](https://github.com/apache/incubator-hugegraph-toolchain/pull/499))
- fix: checkstyle && add suppressions.xml ([#500](https://github.com/apache/incubator-hugegraph-toolchain/pull/500))
- fix(loader): resolve error in loader script ([#510](https://github.com/apache/incubator-hugegraph-toolchain/pull/510))
- fix: base-ref/head-ref missed in dependency-check-ci on branch push ([#516](https://github.com/apache/incubator-hugegraph-toolchain/pull/516), [#551](https://github.com/apache/incubator-hugegraph-toolchain/pull/551))
- fix yarn network connection on linux/arm64 arch ([#519](https://github.com/apache/incubator-hugegraph-toolchain/pull/519))
- fix(hubble): drop-down box could not display all options ([#535](https://github.com/apache/incubator-hugegraph-toolchain/pull/535))
- fix(hubble): build with node and yarn ([#543](https://github.com/apache/incubator-hugegraph-toolchain/pull/543))
- fix(loader): loader options ([#548](https://github.com/apache/incubator-hugegraph-toolchain/pull/548))
- fix(hubble): parent override children dep version ([#549](https://github.com/apache/incubator-hugegraph-toolchain/pull/549))
- fix: exclude okhttp1 which has different groupID with okhttp3 ([#555](https://github.com/apache/incubator-hugegraph-toolchain/pull/555))
- fix: github action build docker image failed ([#556](https://github.com/apache/incubator-hugegraph-toolchain/pull/556), [#557](https://github.com/apache/incubator-hugegraph-toolchain/pull/557))
- fix: build error with npm not exist & tiny improve ([#558](https://github.com/apache/incubator-hugegraph-toolchain/pull/558))


#### Option Changes

- set default data when create graph ([#447](https://github.com/apache/incubator-hugegraph-toolchain/pull/447))


#### Other Changes

- chore: remove apache stage repo & update mail rule ([#433](https://github.com/apache/incubator-hugegraph-toolchain/pull/433), [#474](https://github.com/apache/incubator-hugegraph-toolchain/pull/474), [#479](https://github.com/apache/incubator-hugegraph-toolchain/pull/479))
- refact: clean extra store file in all modules ([#434](https://github.com/apache/incubator-hugegraph-toolchain/pull/434))
- chore: use fixed node.js version 16 to avoid ci problem ([#437](https://github.com/apache/incubator-hugegraph-toolchain/pull/437), [#441](https://github.com/apache/incubator-hugegraph-toolchain/pull/441))
- chore(hubble): use latest code in Dockerfile ([#440](https://github.com/apache/incubator-hugegraph-toolchain/pull/440))
- chore: remove maven plugin for docker build ([#443](https://github.com/apache/incubator-hugegraph-toolchain/pull/443))
- chore: improve spark parallel ([#450](https://github.com/apache/incubator-hugegraph-toolchain/pull/450))
- doc: fix build status badge link ([#455](https://github.com/apache/incubator-hugegraph-toolchain/pull/455))
- chore: keep hadoop-hdfs-client and hadoop-common version consistent ([#457](https://github.com/apache/incubator-hugegraph-toolchain/pull/457))
- doc: add basic contact info & QR code in README ([#462](https://github.com/apache/incubator-hugegraph-toolchain/pull/462), [#475](https://github.com/apache/incubator-hugegraph-toolchain/pull/475))
- chore: disable PR up-to-date in branch ([#473](https://github.com/apache/incubator-hugegraph-toolchain/pull/473))
- chore: auto add pr auto label by path ([#466](https://github.com/apache/incubator-hugegraph-toolchain/pull/466), [#528](https://github.com/apache/incubator-hugegraph-toolchain/pull/528))
- chore: unify the dependencies versions of the entire project ([#478](https://github.com/apache/incubator-hugegraph-toolchain/pull/478))
- chore(deps): bump async, semver, word-wrap, browserify-sign in hubble-fe ([#484](https://github.com/apache/incubator-hugegraph-toolchain/pull/484), [#491](https://github.com/apache/incubator-hugegraph-toolchain/pull/491), [#494](https://github.com/apache/incubator-hugegraph-toolchain/pull/494), [#529](https://github.com/apache/incubator-hugegraph-toolchain/pull/529))
- chore: add pr template ([#498](https://github.com/apache/incubator-hugegraph-toolchain/pull/498))
- doc(hubble): add docker-compose to start with server ([#522](https://github.com/apache/incubator-hugegraph-toolchain/pull/522))
- chore(ci): add stage profile settings ([#536](https://github.com/apache/incubator-hugegraph-toolchain/pull/536))
- chore(client): increase the api num as the latest server commit + 10 ([#546](https://github.com/apache/incubator-hugegraph-toolchain/pull/546))
- chore(spark): install hugegraph from source ([#552](https://github.com/apache/incubator-hugegraph-toolchain/pull/552))
- doc: adjust docker related desc in readme ([#559](https://github.com/apache/incubator-hugegraph-toolchain/pull/559))
- chore(license): update license for 1.2 ([#560](https://github.com/apache/incubator-hugegraph-toolchain/pull/560), [#561](https://github.com/apache/incubator-hugegraph-toolchain/pull/561))



### hugegraph-commons
* fix(common): handle spring-boot2/jersey dependency conflicts by @z7658329 in https://github.com/apache/incubator-hugegraph-commons/pull/131
* refact(common): add more construction methods for convenient by @chengxin1374 in https://github.com/apache/incubator-hugegraph-commons/pull/132
* add: dependency-review by @msgui in https://github.com/apache/incubator-hugegraph-commons/pull/134
* feat(common): replace jersey dependencies with OkHttp (Breaking Change) by @zhenyuT in https://github.com/apache/incubator-hugegraph-commons/pull/133
* fix: Assert.assertThrows() should check result of exceptionConsumer by @javeme in https://github.com/apache/incubator-hugegraph-commons/pull/135
* refact(common): rename jsonutil to avoid conflicts with server by @imbajin in https://github.com/apache/incubator-hugegraph-commons/pull/136
* fix(common): json param convert by @zhenyuT in https://github.com/apache/incubator-hugegraph-commons/pull/137
* doc: update README for release by @imbajin in https://github.com/apache/incubator-hugegraph-commons/pull/138
* update licence by @zhenyuT in https://github.com/apache/incubator-hugegraph-commons/pull/139

### Release Details

Please check the release details in each repository:

- [Server Release Notes](https://github.com/apache/incubator-hugegraph/releases)
- [Toolchain Release Notes](https://github.com/apache/incubator-hugegraph-toolchain/releases)
- [Computer Release Notes](https://github.com/apache/incubator-hugegraph-computer/releases)
- [Commons Release Notes](https://github.com/apache/incubator-hugegraph-commons/releases)
