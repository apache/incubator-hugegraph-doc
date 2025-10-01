---
title: "Requirements of RocksDB Plus"
linkTitle: "Requirements of RocksDB Plus"
weight: 1
---

## Introduction

RocksDB is the primary standalone/distributed backend storage engine planned for HugeGraph.
However, the current `rocksdb-jni` design makes it difficult for HugeGraph to dynamically modify or adjust RocksDB parameters, resulting in limited flexibility and extensive hard-coding logic.

To improve performance, functionality, and usability, HugeGraph introduces `RocksDB Plus` as an optional enhancement.
It allows users to configure RocksDB parameters via external configuration files and visualize storage engine status through a built-in Web Server.

## Requirement List

### 1. Support RocksDB Plus while maintaining compatibility with RocksDB

**User Story**: As a long-term user, I want the system to support the enhanced features of RocksDB Plus without affecting existing RocksDB functionality or data compatibility.

**Acceptance Criteria**: Users can choose between RocksDB and RocksDB Plus via configuration files or startup parameters.

### 2. Support configuring RocksDB parameters via external configuration files

**User Story**: As a user, I want to adjust storage engine parameters based on my business needs and hardware environment to optimize database performance.

**Acceptance Criteria**: The system supports passing configuration files to customize RocksDB parameters.

### 3. Support runtime observability of the RocksDB storage engine

**User Story**: As a system operator, I want clear and intuitive visibility into RocksDB configuration and runtime status.

**Acceptance Criteria**: The system supports enhancing storage engine observability via a Web Server.

## Success Criteria

* The system maintains API compatibility with both RocksDB and RocksDB Plus.
* The system supports configuring RocksDB Plus parameters via external configuration files.
* The system enhances storage engine observability through a built-in Web Server.