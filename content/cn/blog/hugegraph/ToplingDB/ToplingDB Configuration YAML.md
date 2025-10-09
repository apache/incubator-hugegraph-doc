---
date: 2025-09-30
title: "ToplingDB YAML configuration file"
linkTitle: "ToplingDB的YAML配置文件"
---

RocksDB 提供了丰富的参数配置，但大多数情况下，这些配置需要通过硬编码完成。

[ToplingDB](https://github.com/topling/toplingdb) 在此基础上引入了 **SidePlugin + YAML** 的方式，使得配置更加模块化和可组合。

本文重点介绍 **ToplingDB 扩展参数** 的部分，帮助读者理解这些配置的意义。

## 0. HugeGraph 中提供的rocksdb_plus.yaml
下文只包括HugeGraph中所使用的配置参数，ToplingDB支持的完整配置请参考：[SidePlugin Wiki](https://github.com/topling/sideplugin-wiki-en/wiki)
```yaml
http: # Web Server 相关配置
  # normally parent path of db path
  document_root: /dev/shm/rocksdb_resource # 静态资源目录, HugeGraph中通过`preload_topling.sh`进行静态资源提取
  listening_ports: '2011' # Web Server监听端口，用于管理/监控
setenv: # 环境变量设置
  StrSimpleEnvNameNotOverwrite: StringValue
  IntSimpleEnvNameNotOverwrite: 16384
  OverwriteThisEnv:
    #comment: overwrite is default to false
    overwrite: true
    value: force overwrite this env by overwrite true
Cache: # Cache 相关配置
  lru_cache: # 定义一个 LRU 缓存实例
    class: LRUCache
    params: 
      capacity: 8G # 缓存容量 8GB
      num_shard_bits: -1 # 分片数量，-1 表示自动
      strict_capacity_limit: false
      high_pri_pool_ratio: 0.5
      use_adaptive_mutex: false
      metadata_charge_policy: kFullChargeCacheMetadata # 元数据也计入缓存容量
Statistics: # 数据采样配置
  stat:
    class: default
    params:
      discard_tickers: # 丢弃的统计计数器，减少开销
        - rocksdb.block.cache
        - rocksdb.block.cachecompressed
        - rocksdb.block
        - rocksdb.memtable.payload.bytes.at.flush
        - rocksdb.memtable.garbage.bytes.at.flush
        - rocksdb.txn
        - rocksdb.blobdb
        - rocksdb.row.cache
        - rocksdb.number.block
        - rocksdb.bloom.filter
        - rocksdb.persistent
        - rocksdb.sim.block.cache
      discard_histograms: # 丢弃的直方图统计项
        # comment: ....
        - rocksdb.blobdb
        - rocksdb.bytes.compressed
        - rocksdb.bytes.decompressed
        - rocksdb.num.index.and.filter.blocks.read.per.level
        - rocksdb.num.data.blocks.read.per.level
        - rocksdb.compression.times.nanos
        - rocksdb.decompression.times.nanos
        - rocksdb.read.block.get.micros
        - rocksdb.write.raw.block.micros
      # comment end of array
      #stats_level: kAll
      stats_level: kDisableAll  # 禁用所有统计
MemTableRepFactory: # 内存中 memtable 的实现
  cspp: # ToplingDB 独有的高并发内存结构
    class: cspp
    params:
      mem_cap: 16G # 预分配足够的单块内存地址空间，这些内存可以只是保留地址空间，但并未实际分配。
      use_vm: false
      token_use_idle: true
      chunk_size: 16K # 内部分配粒度
      convert_to_sst: kFileMmap # 直接将 MemTable 转化为 SST，省去 Flush，可选值：{kDontConvert, kDumpMem, kFileMmap}
      sync_sst_file: false # convert_to_sst 为 kFileMmap 时，SST 转化完成后是否执行 fsync
  skiplist: # RocksDB 默认的跳表结构
    class: SkipList
    params:
      lookahead: 0
TableFactory:
  cspp_memtab_sst:
    class: CSPPMemTabTable # 与 cspp 配套的 TableFactory
    params: # empty params
  bb:
    class: BlockBasedTable # RocksDB 默认的块表
    params:
      checksum: kCRC32c
      block_size: 4K
      block_restart_interval: 16
      index_block_restart_interval: 1
      metadata_block_size: 4K
      enable_index_compression: true
      block_cache: "${lru_cache}" # 使用上面定义的 LRU 缓存
      readers:
        BlockBasedTable: bb
        CSPPMemTabTable: cspp_memtab_sst
      block_cache_compressed:
      persistent_cache:
      filter_policy:
  dispatch:
    class: DispatcherTable
    params:
      default: bb # 默认使用 BlockBasedTable
      readers:
        BlockBasedTable: bb
        CSPPMemTabTable: cspp_memtab_sst
      level_writers: [ bb, bb, bb, bb, bb, bb ] # 支持自定义各层写入策略
CFOptions:
  default:
    max_write_buffer_number: 6
    memtable_factory: "${cspp}" # 引用上方定义的cspp，使用 cspp 作为 MemTable
    write_buffer_size: 128M
    # set target_file_size_base as small as 512K is to make many SST files,
    # thus key prefix cache can present efficiency
    target_file_size_base: 64M
    target_file_size_multiplier: 1
    table_factory: dispatch # 引用上方定义的 dispatch, 使用 DispatcherTable Class
    max_bytes_for_level_base: 512M
    max_bytes_for_level_multiplier: 10
    level_compaction_dynamic_level_bytes: false
    level0_slowdown_writes_trigger: 20
    level0_stop_writes_trigger: 36
    level0_file_num_compaction_trigger: 2
    merge_operator: uint64add # support merge
    level_compaction_dynamic_file_size: true
    optimize_filters_for_hits: true
    allow_merge_memtables: true
    min_write_buffer_number_to_merge: 2
    compression_per_level:
      - kNoCompression
      - kNoCompression
      - kSnappyCompression
      - kSnappyCompression
      - kSnappyCompression
      - kSnappyCompression
      - kSnappyCompression
DBOptions:
  dbo:
    create_if_missing: true
    create_missing_column_families: false # this is important, must be false to hugegraph
    max_background_compactions: -1
    max_subcompactions: 4
    max_level1_subcompactions: 0
    inplace_update_support: false
    WAL_size_limit_MB: 0
    statistics: "${stat}"  # 使用上面定义的统计配置
    max_manifest_file_size: 100M
    max_background_jobs: 8
    compaction_readahead_size: 0
    memtable_as_log_index: true #     memtable_as_log_index: true # 此配置结合 convert_to_sst: kFileMmap 可实现[omit L0 Flush](https://github.com/topling/toplingdb/wiki/Omit-L0-Flush)

```

**关键要点**: 
- `listening_ports: '2011'` 指定Web Server监听端口为2011
- `memtable_as_log_index: true` 与 `convert_to_sst: kFileMmap` 结合实现[omit L0 Flush](https://github.com/topling/toplingdb/wiki/Omit-L0-Flush)
- `memtable_factory: "${cspp}"` 指定了内存结构采用`CSPP Memtable`
- `table_factory: dispatch` 指定了TableFactory使用YAML中自定义的`DispatcherTable`结构

## 1. 插件化配置与引用机制

- **YAML 插件化**：配置文件以对象形式组织，每个对象可以单独定义并在其他地方引用。
- **引用语法**：通过 `${lru_cache}`、`${cspp}` 等方式在不同段落复用对象。
- **DispatcherTable**：允许在不同层级或场景下选择不同的 TableFactory。RocksDB 原生只能指定单一 TableFactory。

这种机制使得配置更灵活，便于在复杂场景下组合不同组件。

## 2. 新的 MemTable 实现：CSPP

ToplingDB 提供了一个 RocksDB 原生没有的 MemTable 类型：

- `mem_cap`: 限制 MemTable 的最大内存使用量。
- `token_use_idle`: 利用空闲 token 提升并发写入效率。
- `convert_to_sst: kFileMmap`: 在 flush 时直接使用 mmap 文件方式生成 SST。
- `sync_sst_file: false`: 生成 SST 文件时不强制同步到磁盘。

这些参数为写入路径提供了更多可调节空间，适合需要高并发写入的场景。

更多设计细节请参考 ToplingDB 作者的撰写的相关博客：[cspp-memtable](https://github.com/topling/cspp-memtable/blob/memtable_as_log_index/README_EN.md), [ToplingDB CSPP MemTable Design Essentials](https://zhuanlan.zhihu.com/p/649435555), [CSPP Trie Design Analysis](https://zhuanlan.zhihu.com/p/499138254)

## 3. TableFactory 扩展

- **CSPPMemTabTable**：与 `cspp` MemTable 配套的 TableFactory。
- **DispatcherTable**：支持为不同层级指定不同的 TableFactory，例如：
  - 默认使用 BlockBasedTable。
  - 特定层级可以使用 CSPPMemTabTable。

这类灵活性在 RocksDB 原生配置中并不存在。

## 4. 统计与观测控制

- **discard_tickers / discard_histograms**：可以精确指定哪些统计项需要丢弃。
- **stats_level: kDisableAll**：结合上述配置，可以灵活控制统计开销。

相比 RocksDB 的粗粒度控制，ToplingDB 提供了更细的调节方式。

## 5. DBOptions 新增参数

- **memtable_as_log_index: true**：允许使用 MemTable 作为日志索引，加快恢复速度。

## 6. 总结

ToplingDB 在 RocksDB 的基础上增加了以下能力：

- 插件化配置与对象复用
- 新的 MemTable 类型（cspp）及配套 TableFactory
- DispatcherTable 支持多工厂调度
- 内置 Web Server
- 更灵活的统计与观测控制
- 特殊 DBOptions（如 memtable_as_log_index）

这些扩展为用户提供了更多的可调节空间，尤其适合需要高写入性能和灵活运维的场景。