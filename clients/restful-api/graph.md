### 5.1 Graph

#### 5.1.1 列出数据库中全部的图

##### Method

```
GET
```

##### Url

```
http://localhost:8080/graphs
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "graphs":[
        "hugegraph",
        "hugegraph1"
    ]
}
```

#### 5.1.2 清空某个图的全部数据，包括schema、vertex、edge和索引等，**该操作需要管理员权限**

##### Method

```
DELETE
```

##### Params

由于清空图是一个比较危险的操作，为避免用户误调用，我们给API添加了一些用于确认的参数，目前有两个：

- token: 默认为`162f7848-0b6d-4faf-b557-3a0797869c55`
- confirm_message: 默认为`I'm sure to delete all data`

##### Url

```
http://localhost:8080/graphs/hugegraph/clear?token=162f7848-0b6d-4faf-b557-3a0797869c55&confirm_message=I%27m+sure+to+delete+all+data
```

##### Response Status

```json
204
```

### 5.2 Conf

#### 5.2.1 查看某个图的配置，**该操作需要管理员权限**

##### Method

```
GET
```

##### Params

- token: 默认为`162f7848-0b6d-4faf-b557-3a0797869c55`

##### Url

```
http://localhost:8080/graphs/hugegraph/conf?token=162f7848-0b6d-4faf-b557-3a0797869c55
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
#store.schema=huge_schema
#store.graph=huge_graph
#store.index=huge_index

# rocksdb backend config
rocksdb.data_path=.
rocksdb.wal_path=.
......
```