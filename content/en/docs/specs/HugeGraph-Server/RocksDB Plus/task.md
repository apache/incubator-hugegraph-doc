---
title: "Tasks of RocksDB Plus"
linkTitle: "Tasks of RocksDB Plus"
weight: 3
---

This document translates the design of HugeGraph RocksDB Plus into a series of executable development tasks. Each task follows a test-driven approach to ensure incremental progress and early validation.

## Common Development Commands

### Runtime

RocksDB Plus (ToplingDB) requires dynamic libraries to be preloaded via `LD_PRELOAD`. The `preload-topling.sh` script parses the JAR package, extracts the necessary libraries, and performs the preload setup.

When using an IDE such as IntelliJ IDEA, you need to configure the following environment variables in Run/Debug Configurations:

```shell
LD_LIBRARY_PATH=/path/to/your/library:$LD_LIBRARY_PATH
LD_PRELOAD=libjemalloc.so:librocksdbjni-linux64.so
```

When running from the terminal, simply use `init-store.sh` and `start-hugegraph.sh`, as `preload-topling.sh` is already embedded in these scripts.

## 1. Project Infrastructure Setup

- [x] **1.1 Build RocksDB Plus JAR Package**
  - Publish the package to GitHub Packages via GitHub Actions and update Maven's `settings.xml`
  - Provide documentation for manually building the RocksDB Plus JAR package

## 2. Compatibility with RocksDB Plus and Standard RocksDB

- [x] **2.1 Modify openRocksDB logic in RocksDBStdSession**
  - Use reflection to detect whether the current JAR contains RocksDB Plus APIs; if so, start the storage engine using RocksDB Plus
  - If not available, fall back to the standard RocksDB API for engine startup

## 3. Add Configuration Options for RocksDB Plus in HugeGraph

- [x] **3.1 Add `rocksdb.option_path` configuration**
  - Type: string, used to specify the path to the YAML configuration file
  - Allow users to pass the YAML file via `hugegraph.properties` using `rocksdb.option_path`
  - This option is invalid for standard RocksDB JARs, as RocksDB APIs do not support file-based configuration

- [x] **3.2 Add `rocksdb.open_http` configuration**
  - Type: boolean, used to specify whether to enable the RocksDB Plus Web Server
  - Allow users to configure Web Server activation via `rocksdb.open_http` in `hugegraph.properties`
  - The Web Server port is defined in the YAML file specified by `option_path`, under `http.listening_ports`
  - For simplicity, the Web Server is only enabled for the `GRAPH_STORE` instance that stores graph data

## 4. End-to-End Performance Testing

- [x] **4.1 Write Performance Testing**
  - Use `hugegraph-loader` to load the twitter-2010 dataset
  - Shuffle the twitter-2010 dataset to simulate real-world random insertion patterns and evaluate the write performance of RocksDB Plus.
  - RocksDB Plus improves random write performance by up to 40% and reduces storage overhead by approximately 50%

- [x] **4.2 Read Performance Testing**
  - Execute edge traversal, vertex traversal, and KOUT queries to evaluate read performance improvements
  - Under cold start conditions, edge traversal latency is reduced by up to 50%, and KOUT query average latency is reduced by approximately 15%
