---
date: 2025-09-30
title: "RocksDB Plus YAML configuration file"
linkTitle: "RocksDB Plus YAML configuration file"
---

RocksDB provides a rich set of configuration parameters, but most of them typically require hardcoded setup.

RocksDB Plus ([ToplingDB](https://github.com/topling/toplingdb)) introduces a **SidePlugin + YAML** mechanism, making configuration more modular and composable.

This document focuses on the **extended parameters of RocksDB Plus**, helping readers understand their purpose and usage.

## 0. rocksdb_plus.yaml used in HugeGraph

The following includes only the configuration parameters used in HugeGraph. For the full configuration supported by ToplingDB, refer to the [SidePlugin Wiki](https://github.com/topling/sideplugin-wiki-en/wiki):

```yaml
http: # Web Server related configuration
  # normally parent path of db path
  document_root: /dev/shm/rocksdb_resource # Static resource directory, extracted by `preload_topling.sh` in HugeGraph
  listening_ports: '2011' # Web Server listening port for management/monitoring

setenv: # Environment variable settings
  StrSimpleEnvNameNotOverwrite: StringValue
  IntSimpleEnvNameNotOverwrite: 16384
  OverwriteThisEnv:
    #comment: overwrite is default to false
    overwrite: true
    value: force overwrite this env by overwrite true

Cache: # Cache configuration
  lru_cache: # Define an LRU cache instance
    class: LRUCache
    params: 
      capacity: 8G # Cache capacity: 8GB
      num_shard_bits: -1 # Number of shards, -1 means auto
      strict_capacity_limit: false
      high_pri_pool_ratio: 0.5
      use_adaptive_mutex: false
      metadata_charge_policy: kFullChargeCacheMetadata # Metadata also counts toward cache capacity

Statistics: # Sampling configuration
  stat:
    class: default
    params:
      discard_tickers: # Discarded tickers to reduce overhead
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
      discard_histograms: # Discarded histogram metrics
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
      stats_level: kDisableAll  # Disable all statistics

MemTableRepFactory: # MemTable implementation in memory
  cspp: # ToplingDB-specific high-concurrency memory structure
    class: cspp
    params:
      mem_cap: 16G # Preallocate sufficient virtual memory space; may reserve address space without actual allocation
      use_vm: false
      token_use_idle: true
      chunk_size: 16K # Internal allocation granularity
      convert_to_sst: kFileMmap # Convert MemTable directly to SST, skipping flush; options: {kDontConvert, kDumpMem, kFileMmap}
      sync_sst_file: false # Whether to fsync after SST conversion when using kFileMmap

  skiplist: # Default skiplist structure in RocksDB
    class: SkipList
    params:
      lookahead: 0

TableFactory:
  cspp_memtab_sst:
    class: CSPPMemTabTable # TableFactory paired with cspp
    params: # empty params

  bb:
    class: BlockBasedTable # Default block-based table in RocksDB
    params:
      checksum: kCRC32c
      block_size: 4K
      block_restart_interval: 16
      index_block_restart_interval: 1
      metadata_block_size: 4K
      enable_index_compression: true
      block_cache: "${lru_cache}" # Use the LRU cache defined above
      readers:
        BlockBasedTable: bb
        CSPPMemTabTable: cspp_memtab_sst
      block_cache_compressed:
      persistent_cache:
      filter_policy:

  dispatch:
    class: DispatcherTable
    params:
      default: bb # Default to BlockBasedTable
      readers:
        BlockBasedTable: bb
        CSPPMemTabTable: cspp_memtab_sst
      level_writers: [ bb, bb, bb, bb, bb, bb ] # Custom write strategy per level

CFOptions:
  default:
    max_write_buffer_number: 6
    memtable_factory: "${cspp}" # Reference cspp defined above
    write_buffer_size: 128M
    # set target_file_size_base as small as 512K is to make many SST files,
    # thus key prefix cache can present efficiency
    target_file_size_base: 64M
    target_file_size_multiplier: 1
    table_factory: dispatch # Reference dispatch defined above
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
    statistics: "${stat}"  # Use the statistics config defined above
    max_manifest_file_size: 100M
    max_background_jobs: 8
    compaction_readahead_size: 0
    memtable_as_log_index: true # Combined with convert_to_sst: kFileMmap to enable [omit L0 Flush](https://github.com/topling/toplingdb/wiki/Omit-L0-Flush)
```

**Key Highlights**:
- `listening_ports: '2011'` sets the Web Server listening port to 2011  
- `memtable_as_log_index: true` combined with `convert_to_sst: kFileMmap` enables [omit L0 Flush](https://github.com/topling/toplingdb/wiki/Omit-L0-Flush)  
- `memtable_factory: "${cspp}"` specifies the use of CSPP MemTable  
- `table_factory: dispatch` uses the custom DispatcherTable defined in YAML  

## 1. Plugin-Based Configuration and Reference Mechanism

- **YAML Pluginization**: Configuration is organized as reusable objects.
- **Reference Syntax**: Use `${lru_cache}`, `${cspp}`, etc., to reuse objects across sections.
- **DispatcherTable**: Allows selecting different TableFactories per level or scenario. Native RocksDB only supports a single TableFactory.

This mechanism makes configuration more flexible and composable for complex use cases.

## 2. New MemTable Implementation: CSPP

ToplingDB introduces a MemTable type not available in native RocksDB:

- `mem_cap`: Limits maximum memory usage of MemTable.
- `token_use_idle`: Improves concurrent writes using idle tokens.
- `convert_to_sst: kFileMmap`: Converts MemTable directly to SST using mmap, skipping flush.
- `sync_sst_file: false`: Avoids fsync after SST generation.

These parameters offer more control over the write path, ideal for high-concurrency scenarios.

For more design details, refer to:
- [cspp-memtable README](https://github.com/topling/cspp-memtable/blob/memtable_as_log_index/README_EN.md)
- [ToplingDB CSPP MemTable Design Essentials](https://zhuanlan.zhihu.com/p/649435555)
- [CSPP Trie Design Analysis](https://zhuanlan.zhihu.com/p/499138254)

## 3. TableFactory Extensions

- **CSPPMemTabTable**: TableFactory designed to work with the `cspp` MemTable.
- **DispatcherTable**: Supports assigning different TableFactories per level:
  - Default: BlockBasedTable
  - Specific levels: CSPPMemTabTable

This flexibility is not available in native RocksDB.

## 4. Statistics and Observability Control

- **discard_tickers / discard_histograms**: Allows precise control over which metrics and counters to discard, reducing runtime overhead.
- **stats_level: kDisableAll**: Disables all statistics collection, useful for performance-sensitive deployments.

Compared to RocksDB’s coarse-grained controls, ToplingDB offers fine-grained observability tuning.

## 5. New DBOptions Parameters

- **memtable_as_log_index: true**: Enables using MemTable as a log index, which accelerates recovery and supports [omit L0 Flush](https://github.com/topling/toplingdb/wiki/Omit-L0-Flush).

This option works in conjunction with `convert_to_sst: kFileMmap` to bypass traditional flush logic and directly generate SST files from memory.

## 6. Summary

ToplingDB enhances RocksDB with the following capabilities:

- Plugin-based configuration and object reuse via YAML
- A new MemTable type (`cspp`) and its matching TableFactory
- DispatcherTable for multi-factory scheduling across levels
- Built-in Web Server for real-time monitoring and management
- Fine-grained statistics and observability controls
- Specialized DBOptions such as `memtable_as_log_index`

These extensions provide greater flexibility and tunability, especially suited for high-throughput write workloads and operational observability in production environments.