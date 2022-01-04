### 10.1 Graph Space

在 HugeGraph 中，多租户是通过图空间（graph space）来实现的，资源的分配和隔离可以通过图空间进行。

#### 10.1.1 创建一个图空间

##### Method & Url

```
POST http://localhost:8080/graphspaces
```

##### Request Body

```json
{
  "name": "gs1",
  "description": "1st graph space",
  "cpu_limit": 1000,
  "memory_limit": 1024,
  "storage_limit": 1000,
  "oltp_namespace": "hugegraph-server",
  "olap_namespace": "hugegraph-server",
  "storage_namespace": "hugegraph-server",
  "max_graph_number": 100,
  "max_role_number": 10,
  "configs": {}
}
```

##### Response Status

```json
201
```

##### Response Body

```json
{
    "name": "gs1",
    "description": "1st graph space",
    "cpu_limit": 1000,
    "memory_limit": 1024,
    "storage_limit": 1000,
    "oltp_namespace": "hugegraph-server",
    "olap_namespace": "hugegraph-server",
    "storage_namespace": "hugegraph-server",
    "max_graph_number": 100,
    "max_role_number": 10,
    "cpu_used": 0,
    "memory_used": 0,
    "storage_used": 0,
    "graph_number_used": 0,
    "role_number_used": 0
}
```

#### 10.1.2 列出系统所有图空间

##### Method & Url

```
GET http://localhost:8080/graphspaces
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "graphSpaces":[
        "gs1",
        "DEFAULT"
    ]
}
```

#### 10.1.3 查看某个图空间

##### Method & Url

```
GET http://127.0.0.1:8080/graphspaces/gs1
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "name": "gs1",
    "description": "1st graph space",
    "cpu_limit": 2147483647,
    "memory_limit": 2147483647,
    "storage_limit": 2147483647,
    "oltp_namespace": "hugegraph-server",
    "olap_namespace": "hugegraph-server",
    "storage_namespace": "hugegraph-server",
    "max_graph_number": 2147483647,
    "max_role_number": 2147483647,
    "cpu_used": 0,
    "memory_used": 0,
    "storage_used": 0,
    "graph_number_used": 0,
    "role_number_used": 0
}
```

#### 10.1.4 更新某个图空间

##### Method & Url

```
PUT http://127.0.0.1:8080/graphspaces/gs1
```

##### Request Body

```json
{
    "action": "update",
    "update": {
        "name": "gs1",
        "description": "1st graph space",
        "cpu_limit": 2000,
        "memory_limit": 40960,
        "storage_limit": 2147483647,
        "oltp_namespace": "hugegraph-server",
        "olap_namespace": "hugegraph-server",
        "storage_namespace": "hugegraph-server",
        "max_graph_number": 1000,
        "max_role_number": 100,
        "cpu_used": 0,
        "memory_used": 0,
        "storage_used": 0,
        "graph_number_used": 0,
        "role_number_used": 0
    }
}
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "name": "gs1",
    "description": "1st graph space",
    "cpu_limit": 2000,
    "memory_limit": 40960,
    "storage_limit": 2147483647,
    "oltp_namespace": "hugegraph-server",
    "olap_namespace": "hugegraph-server",
    "storage_namespace": "hugegraph-server",
    "max_graph_number": 1000,
    "max_role_number": 100,
    "cpu_used": 0,
    "memory_used": 0,
    "storage_used": 0,
    "graph_number_used": 0,
    "role_number_used": 0
}
```

#### 10.1.5 删除某个图空间

##### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1?confirm_message=I%27m+sure+to+drop+the+graph+space
```

> 注意：删除图空间，会导致图空间的全部资源被释放。

##### Response Status

```json
204
```
