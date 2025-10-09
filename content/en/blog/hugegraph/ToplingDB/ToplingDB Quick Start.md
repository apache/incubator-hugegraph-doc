---
date: 2025-10-09
title: "ToplingDB Quickstart"
linkTitle: "ToplingDB Quickstart"
---

> [ToplingDB](https://github.com/topling/toplingdb) is a configurable and observable extension of RocksDB. It supports dynamic tuning via YAML files and enables real-time monitoring through a built-in Web Server.

Update hugegraph.properties

```properties
backend=rocksdb
serializer=binary
rocksdb.data_path=.
rocksdb.wal_path=.
rocksdb.option_path=./conf/graphs/rocksdb_plus.yaml # Path to YAML configuration file
rocksdb.open_http=true # Enable Web Server
```

Initialize the database (required on the first startup, or a new configuration was manually added under 'conf/graphs/')

```bash
cd *hugegraph-${version}
bin/init-store.sh
```

Start server

```bash
bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```
