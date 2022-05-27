---
title: "Graphs API"
linkTitle: "Graphs"
weight: 12
---

### 6.1 Graphs

#### 6.1.1 列出数据库中全部的图

##### Method & Url

```
GET http://localhost:8080/graphs
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "graphs": [
        "hugegraph",
        "hugegraph1"
    ]
}
```

#### 6.1.2 查看某个图的信息

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "name": "hugegraph",
    "backend": "cassandra"
}
```

#### 6.1.3 清空某个图的全部数据，包括schema、vertex、edge和index等，**该操作需要管理员权限**

##### Params

由于清空图是一个比较危险的操作，为避免用户误调用，我们给API添加了用于确认的参数：

- confirm_message: 默认为`I'm sure to delete all data`

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/clear?confirm_message=I%27m+sure+to+delete+all+data
```

##### Response Status

```json
204
```

#### 6.1.4 克隆一个图，**该操作需要管理员权限**

##### Params

- clone_graph_name: 已有图的名称；从已有的图来克隆，用户可选择传递配置文件，传递时将替换已有图中的配置；

##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph_clone?clone_graph_name=hugegraph
```

##### Request Body 【可选】

```
gremlin.graph=com.baidu.hugegraph.auth.HugeFactoryAuthProxy
backend=rocksdb
serializer=binary
store=hugegraph_clone
rocksdb.data_path=./hg2
rocksdb.wal_path=./hg2
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "name": "hugegraph_clone",
    "backend": "rocksdb"
}
```

#### 6.1.5 创建一个图，**该操作需要管理员权限**

##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph2
```

##### Request Body

```
gremlin.graph=com.baidu.hugegraph.auth.HugeFactoryAuthProxy
backend=rocksdb
serializer=binary
store=hugegraph2
rocksdb.data_path=./hg2
rocksdb.wal_path=./hg2
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "name": "hugegraph2",
    "backend": "rocksdb"
}
```

#### 6.1.6 删除某个图及其全部数据

##### Params

由于删除图是一个比较危险的操作，为避免用户误调用，我们给API添加了用于确认的参数：

- confirm_message: 默认为`I'm sure to drop the graph`

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph_clone?confirm_message=I%27m%20sure%20to%20drop%20the%20graph
```

##### Response Status

```json
204
```

### 6.2 Conf

#### 6.2.1 查看某个图的配置，**该操作需要管理员权限**

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/conf
```

##### Response Status

```json
200
```

##### Response Body

```properties
# gremlin entrence to create graph
gremlin.graph=com.baidu.hugegraph.HugeFactory

# cache config
#schema.cache_capacity=1048576
#graph.cache_capacity=10485760
#graph.cache_expire=600

# schema illegal name template
#schema.illegal_name_regex=\s+|~.*

#vertex.default_label=vertex

backend=cassandra
serializer=cassandra

store=hugegraph
...
```

### 6.3 Mode

合法的图模式包括：NONE，RESTORING，MERGING，LOADING
    
- None 模式（默认），元数据和图数据的写入属于正常状态。特别的：
    - 元数据（schema）创建时不允许指定 ID
    - 图数据（vertex）在 id strategy 为 Automatic 时，不允许指定 ID
- LOADING：批量导入数据时自动启用，特别的：
    - 添加顶点/边时，不会检查必填属性是否传入

Restore 时存在两种不同的模式： Restoring 和 Merging

- Restoring 模式，恢复到一个新图中，特别的：
    - 元数据（schema）创建时允许指定 ID
    - 图数据（vertex）在 id strategy 为 Automatic 时，允许指定 ID
- Merging 模式，合并到一个已存在元数据和图数据的图中，特别的：
    - 元数据（schema）创建时不允许指定 ID
    - 图数据（vertex）在 id strategy 为 Automatic 时，允许指定 ID

正常情况下，图模式为 None，当需要 Restore 图时，需要根据需要临时修改图模式为 Restoring 模式或者 Merging 模式，并在完成 Restore 时，恢复图模式为 None。


#### 6.3.1 查看某个图的模式.

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/mode
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "mode": "NONE"
}
```

> 合法的图模式包括：NONE，RESTORING，MERGING

#### 6.3.2 设置某个图的模式. **该操作需要管理员权限**

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/mode
```

##### Request Body

```
"RESTORING"
```

> 合法的图模式包括：NONE，RESTORING，MERGING

##### Response Status

```json
200
```

##### Response Body

```json
{
    "mode": "RESTORING"
}
```

#### 6.3.3 查看某个图的读模式.

##### Params

- name: 图的名称

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/graph_read_mode
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "graph_read_mode": "ALL"
}
```

#### 6.3.4 设置某个图的读模式. **该操作需要管理员权限**

##### Params

- name: 图的名称

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/graph_read_mode
```

##### Request Body

```
"OLTP_ONLY"
```

> 合法的图模式包括：ALL，OLTP_ONLY，OLAP_ONLY

##### Response Status

```json
200
```

##### Response Body

```json
{
    "graph_read_mode": "OLTP_ONLY"
}
```

### 6.4 Snapshot

#### 6.4.1 创建快照

##### Params

- name: 图的名称

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/snapshot_create
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "hugegraph": "snapshot_created"
}
```

#### 6.4.2 快照恢复

##### Params

- name: 图的名称

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/snapshot_resume
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "hugegraph": "snapshot_resumed"
}
```

### 6.5 Compact

#### 6.5.1 手动压缩图，**该操作需要管理员权限**

##### Params

- name: 图的名称

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/compact
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "nodes": 1,
    "cluster_id": "local",
    "servers": {
        "local": "OK"
    }
}
```