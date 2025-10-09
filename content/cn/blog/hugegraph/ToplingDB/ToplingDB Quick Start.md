---
date: 2025-10-09
title: "ToplingDB Quick Start"
linkTitle: "ToplingDB Quick Start"
---

> [ToplingDB](https://github.com/topling/toplingdb)是对 RocksDB 的可配置、可观测扩展，支持通过 YAML 文件进行动态调优，并通过内置 Web Server 实现实时监控

修改 `hugegraph.properties`

```properties
backend=rocksdb
serializer=binary
rocksdb.data_path=.
rocksdb.wal_path=.
rocksdb.option_path=./conf/graphs/rocksdb_plus.yaml # 配置文件路径
rocksdb.open_http=true # 是否开启Web Server
```


初始化数据库（第一次启动时或在 `conf/graphs/` 下手动添加了新配置时需要进行初始化）

```bash
cd *hugegraph-${version}
bin/init-store.sh
```

启动 server

```bash
bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

提示的 url 与 `rest-server.properties` 中配置的 `restserver.url` 一致

Web Server 的监听端口在 YAML 文件中通过 `http.listening_ports` 字段进行配置
