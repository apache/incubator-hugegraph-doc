---
title: "Tasks of RocksDB Plus"
linkTitle: "RocksDB Plus 任务列表"
weight: 3
---

本文档将 HugeGraph RocksDB Plus的设计转化为一系列可执行的编码任务。每个任务都以测试驱动的方式进行，确保任务以增量方式推进，并实现早期测试验证



## 开发常用命令

### 运行相关

RocksDB Plus（ToplingDB）需要通过 LD_PRELOAD 预加载相关动态库，`preload-topling.sh`会解析JAR包，提取相关动态库，并进行预加载

当使用IDEA等集成开发环境时，需要在 Run/Debug Configurations 中设置环境变量：

```shell
LD_LIBRARY_PATH=/path/to/your/library:$LD_LIBRARY_PATH
LD_PRELOAD=libjemalloc.so:librocksdbjni-linux64.so
```

在终端中运行时，直接使用 `init-store.sh` 和 `start-hugegraph.sh` 即可，`preload-topling.sh`已嵌入其中



## 1.项目基础设施搭建

- [x] **1.1 构建RocksDB Plus JAR包**
  - 通过Github Actions将包发布至Github Packages，并修改Maven的settings.xml
  - 提供手动构建RocksDB Plus JAR包的流程文档



## 2. 兼容RocksDB Plus和RocksDB实现

- [x] **2.1 修改RocksDBStdSession中openRocksDB逻辑**
  - 通过反射判断当前使用的JAR包中是否包含RocksDB Plus API，如果包含，使用RocksDB Plus API启动存储引擎
  - 如果不包含，回退至传统RocksDB API启动存储引擎



## 3. 新增HugeGraph对RocksDB Plus的配置项

- [x] **3.1 增加`rocksdb.option_path`配置项**
  - 类型为 string，用于传入 YAML 配置文件路径
  
  - 支持用户通过`hugegraph.properties`使用`rocksdb.option_path`传入RocksDB Plus的YAML配置文件
  - 因为RocksDB API中不支持以文件配置参数，因此在传统RocksDB JAR包此项配置无效
  
- [x] **3.2 增加`rocksdb.open_http`配置项**
  - 类型为 boolean，用于指定是否开启 RocksDB Plus 的 Web Serve
  - 支持用户通过`hugegraph.properties`使用`rocksdb.open_http`配置是否开启Web Server
  - Web Server 的端口号由 `option_path` 指定的 YAML 文件中的 `http.listening_ports` 决定
  - 为了简洁性，Web Server只会对存储图的`GRAPH_STORE`实例开启



## **4. 端到端性能测试**

- [x] **4.1 写性能测试**
  - 使用 `hugegraph-loader` 对 twitter-2010 数据集进行加载测试
  - 将 twitter-2010 数据集进行 shuffle 处理，模拟真实场景下的随机插入行为，评估 RocksDB Plus 的写入性能。
  - RocksDB Plus能够将随机写性能提升最高40%，并降低约50%存储开销
- [x] **4.2 读性能测试**
  - 通过执行边遍历、点遍历和 KOUT 查询，测试RocksDB Plus读性能提升
  - 在冷启动下，遍历边查询时间缩短最高至50%。KOUT查询平均时间缩短约15%

