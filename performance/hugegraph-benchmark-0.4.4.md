# 1. 测试环境


## 1.1 软硬件信息


CPU                                          | Memory | 网卡       | 磁盘
-------------------------------------------- | ------ | --------- | ---------
48 Intel(R) Xeon(R) CPU E5-2650 v4 @ 2.20GHz | 128G   | 10000Mbps | 750GB SSD


## 1.2 服务配置

- HugeGraph版本：0.4.4，RestServer和Gremlin Server和backends都在同一台服务器上

- Cassandra版本：cassandra-3.10，commitlog和data共用SSD

- RocksDB版本：rocksdbjni-5.8.6

- Titan版本：0.5.4, 使用thrift+Cassandra模式


# 2. 测试结果


## 2.1 Batch插入性能


Backend    | email-enron(30w) | amazon0601(300w) | com-youtube.ungraph(300w) 
---------- | ---------------- | ---------------- | --------------------------
Titan      | 9.516            | 88.123           | 111.586          
RocksDB    | 2.345            | 14.076           | 16.636     
Cassandra  | 11.930           | 108.709          | 101.959
Memory     | 3.077            | 15.204           | 13.841


### 结论


- RocksDB和Memory后端插入性能优于Cassandra

- HugeGraph和Titan同样使用Cassandra作为后端的情况下，插入性能接近


## 2.2 遍历性能


### 2.2.1 说明


- FN(Find Neighbor), 遍历所有vertex, 根据vertex查邻接edge, 通过edge和vertex查other vertex

- FA(Find Adjacent), 遍历所有edge，根据edge获得source vertex和target vertex


### 2.2.2 FN性能


Backend    | email-enron(30w) | amazon0601(300w) | com-youtube.ungraph(300w) 
---------- | ---------------- | ---------------- | --------------------------
Titan      | 7.724            | 70.935           | 128.884         
RocksDB    | 8.876            | 65.852           | 63.388     
Cassandra  | 13.125           | 126.959          | 102.580
Memory     | 22.309           | 207.411          | 165.609


### 2.2.3 FA性能


Backend    | email-enron(30w) | amazon0601(300w) | com-youtube.ungraph(300w) 
---------- | ---------------- | ---------------- | --------------------------
Titan      | 7.119            | 63.353           | 115.633        
RocksDB    | 6.032            | 64.526           | 52.721     
Cassandra  | 9.410            | 102.766          | 94.197
Memory     | 12.340           | 195.444          | 140.89


### 结论


- HugeGraph RocksDB > Titan thrift+Cassandra > HugeGraph Cassandra > HugeGraph Memory


## 2.3 HugeGraph-图常用分析方法性能


### 说明


- FS(Find Shortest Path), 寻找最短路径

- K-neighbor，从起始vertex出发，通过K跳边能够到达的所有顶点, 包括1, 2, 3...(K-1), K跳边可达vertex

- K-out, 从起始vertex出发，恰好经过K跳out边能够到达的顶点


### FS性能


Backend    | email-enron(30w) | amazon0601(300w) | com-youtube.ungraph(300w) 
---------- | ---------------- | ---------------- | --------------------------
Titan      | 11.333           | 0.313            | 376.06        
RocksDB    | 44.391           | 2.221            | 268.792     
Cassandra  | 39.845           | 3.337            | 331.113
Memory     | 35.638           | 2.059            | 388.987

- 在数据规模小或者顶点关联关系少的场景下，Titan最短路径性能优于HugeGraph

- 随着数据规模增大且顶点的关联度增高，HugeGraph最短路径性能优于Titan


### K-neighbor性能


顶点    | 深度    | 一度    | 二度    | 三度   | 四度    | 五度    | 六度
------ | ------ | -----  | ------ | ------ | ------ | ------ | -----
v1     | 时间    | 0.031s | 0.033s | 0.048s | 0.500s | 11.27s | OOM
v111   | 时间    | 0.027s | 0.034s | 0.115  | 1.36s  | OOM    | —
v1111  | 时间    | 0.039s | 0.027s | 0.052s | 0.511s | 10.96s | OOM

- 注：HugeGraph Server的JVM内存设置为32GB，数据量过大时会出现OOM


### K-out性能


顶点   | 深度  | 一度   | 二度    | 三度    | 四度    | 五度        | 六度
----- | ---- | ------ | ------ | ------ | ------ | ---------- | -----
v1    | 时间  | 0.054s | 0.057s | 0.109s | 0.526s | 3.77s      | OOM
      | 度    | 10	  | 133	   | 2453   | 50,830 | 1,128,688  | 
v111  | 时间  | 0.032s | 0.042s | 0.136s | 1.25s  | 20.62s     | OOM
      | 度    | 10	  | 211	   | 4944   | 113150 | 2,629,970  |
v1111 | 时间  | 0.039s | 0.045s | 0.053s | 1.10s  | 2.92s      | OOM
      | 度    | 10	  | 140	   | 2555   | 50825  | 1,070,230  |

- 注：HugeGraph Server的JVM内存设置为32GB，数据量过大时会出现OOM


### 结论


- FS场景，HugeGraph性能优于Titan

- K-neighbor和K-out场景，HugeGraph能够实现在5度范围内秒级返回结果