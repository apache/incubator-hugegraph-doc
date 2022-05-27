---
title: "Graphs API"
linkTitle: "Graphs"
weight: 12
---

### 6.1 Graphs

#### 6.1.1 List all graphs

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

#### 6.1.2 Get details of the graph

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

#### 6.1.3 Clear all data of a graph，include: schema、vertex、edge and index .etc，**This operation requires administrator privileges**

##### Params

Since emptying the graph is a dangerous operation, we have added parameters for confirmation to the API to 
avoid false calls by users：

- confirm_message: default by `I'm sure to delete all data`

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/clear?confirm_message=I%27m+sure+to+delete+all+data
```

##### Response Status

```json
204
```

#### 6.1.4 Clone graph，**This operation requires administrator privileges**

##### Params

- clone_graph_name: name of an exist graph.
                    To clone from an existing graph, the user can choose to transfer the configuration file, 
                    which will replace the configuration in the existing graph

##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph_clone?clone_graph_name=hugegraph
```

##### Request Body [Optional]

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

#### 6.1.5 Create graph，**This operation requires administrator privileges**

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

#### 6.1.6 Delete graph and it's data

##### Params

Since deleting a graph is a dangerous operation, we have added parameters for confirmation to the API to 
avoid false calls by users：

- confirm_message: default by `I'm sure to drop the graph`

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph_clone?confirm_message=I%27m%20sure%20to%20drop%20the%20graph
```

##### Response Status

```json
204
```

### 6.2 Conf

#### 6.2.1 Get configuration for a graph，**This operation requires administrator privileges**

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

Allowed graph mode values are：NONE，RESTORING，MERGING，LOADING
    
- None mode is regular mode
    - Not allowed create schema with specified id
    - Not support create vertex with id for AUTOMATIC id strategy
- LOADING mode used to load data via hugegraph-loader.
    - When adding vertices / edges, it is not checked whether the required attributes are passed in

Restore has two different modes： Restoring and Merging

- Restoring mode is used to restore schema and graph data to an new graph.
    - Support create schema with specified id
    - Support create vertex with id for AUTOMATIC id strategy
- Merging mode is used to merge schema and graph data to an existing graph.
    - Not allowed create schema with specified id
    - Support create vertex with id for AUTOMATIC id strategy

Under normal circumstances, the graph mode is None. When you need to restore the graph, 
you need to temporarily modify the graph mode to Restoring or Merging as needed. 
When you complete the restore, change the graph mode to None.

#### 6.3.1 Get graph mode.

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

> Allowed graph mode values are：NONE，RESTORING，MERGING

#### 6.3.2 Modify graph mode. **This operation requires administrator privileges**

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/mode
```

##### Request Body

```
"RESTORING"
```

> Allowed graph mode values are：NONE，RESTORING，MERGING

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

#### 6.3.3 Get graph's read mode.

##### Params

- name: name of a graph

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

#### 6.3.4 Modify graph's read mode. **This operation requires administrator privileges**

##### Params

- name: name of a graph

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/graph_read_mode
```

##### Request Body

```
"OLTP_ONLY"
```

> Allowed read mode values are：ALL，OLTP_ONLY，OLAP_ONLY

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

#### 6.4.1 Create a snapshot

##### Params

- name: name of a graph

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

#### 6.4.2 Resume a snapshot

##### Params

- name: name of a graph

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

#### 6.5.1 Manually compact graph，**This operation requires administrator privileges**

##### Params

- name: name of a graph

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