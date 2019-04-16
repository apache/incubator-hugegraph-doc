### 5.1 Graphs

#### 5.1.1 列出数据库中全部的图

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

#### 5.1.2 查看某个图的信息

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

#### 5.1.3 清空某个图的全部数据，包括schema、vertex、edge和index等，**该操作需要管理员权限**

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

### 5.2 Conf

#### 5.2.1 查看某个图的配置，**该操作需要管理员权限**

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

### 5.3 Mode

#### 5.3.1 查看某个图的模式. **该操作需要管理员权限**

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

#### 5.3.2 设置某个图的模式. **该操作需要管理员权限**

##### Params

- token: 默认为`162f7848-0b6d-4faf-b557-3a0797869c55`

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
