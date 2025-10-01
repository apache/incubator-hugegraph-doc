---
title: "Requirements of RocksDB Plus"
linkTitle: "RocksDB Plus 需求文档"
weight: 1
---

## 简介

RocksDB 是 HugeGraph 未来主要的单机/分布式后端存储引擎。但是当前`rocksdb-jni`设计使 HugeGraph 在修改、新增或调整 RocksDB 参数时既无法动态处理，也缺乏灵活性, 存在大量硬编码（hard-code）

为用户增加`RocksDB Plus`的可选项，支持通过配置文件配置RocksDB参数以及可视化RocksDB存储状态，可在性能、功能和易用性等方面实现全面提升



## 需求列表

### 1. 在保证兼容RocksDB的前提下支持RocksDB Plus

**用户故事**: 作为长期用户，我希望系统能够在不影响现有RocksDB功能和数据兼容性的前提下，支持RocksDB Plus的增强特性

**验收标准**: 用户可以通过配置文件或启动参数选择使用RocksDB或RocksDB Plus



### 2. 支持传入配置文件配置RocksDB参数

**用户故事**: 作为用户，我希望能够根据我的业务特性和机器硬件情况调整存储引擎参数，以便针对应用和运行环境提高数据库性能。

**验收标准**: 系统能够支持传入配置文件对RocksDB进行参数配置。



### 3. 支持运行时观测RocksDB存储引擎

**用户故事**: 作为系统运维人员，我希望有清晰直观的RocksDB参数配置情况以及RocksDB运行时状态观测。

**验收标准**: 系统支持通过 Web Server 提升存储引擎的可观测性。



## 成功标准

* 系统能够同时兼容 RocksDB 和 RocksDB Plus 的 API
* 系统支持通过配置文件方式配置 RocksDB Plus 参数
* 系统支持通过 Web Server 增强存储引擎的可观测性