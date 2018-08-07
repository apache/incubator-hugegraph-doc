### 1.3 EdgeLabel

假设已经创建好了1.1.2中的 PropertyKeys 和 1.2.2中的 VertexLabels

#### 1.3.1 创建一个EdgeLabel

##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/schema/edgelabels
```

##### Request Body

```json
{
    "name": "created",
    "source_label": "person",
    "target_label": "software",
    "frequency": "SINGLE",
    "properties": [
        "date"
    ],
    "sort_keys": [],
    "nullable_keys": [],
    "enable_label_index": true
}
```

##### Response Status

```json
201
```

##### Response Body

```json
{
    "id": 1,
    "sort_keys": [
    ],
    "source_label": "person",
    "name": "created",
    "index_names": [
    ],
    "properties": [
        "date"
    ],
    "target_label": "software",
    "frequency": "SINGLE",
    "nullable_keys": [
    ],
    "enable_label_index": true,
    "user_data": {}
}
```

#### 1.3.2 为已存在的EdgeLabel添加properties或userdata，或者移除userdata（目前不支持移除properties）

##### Params

- action: 表示当前行为是添加还是移除，取值为`append`（添加）和`eliminate`（移除）

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/schema/edgelabels?action=append
```

##### Request Body

```json
{
    "name": "created",
    "properties": [
        "weight"
    ],
    "nullable_keys": [
        "weight"
    ]
}
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "id": 2,
    "sort_keys": [
    ],
    "source_label": "person",
    "name": "created",
    "index_names": [
    ],
    "properties": [
        "date",
        "weight"
    ],
    "target_label": "software",
    "frequency": "SINGLE",
    "nullable_keys": [
        "weight"
    ],
    "enable_label_index": true,
    "user_data": {}
}
```

#### 1.3.3 获取所有的EdgeLabel

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/schema/edgelabels
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "edgelabels": [
        {
            "id": 1,
            "sort_keys": [
            ],
            "source_label": "person",
            "name": "created",
            "index_names": [
            ],
            "properties": [
                "date",
                "weight"
            ],
            "target_label": "software",
            "frequency": "SINGLE",
            "nullable_keys": [
                "weight"
            ],
            "enable_label_index": true,
            "user_data": {}
        },
        {
            "id": 2,
            "sort_keys": [
            ],
            "source_label": "person",
            "name": "knows",
            "index_names": [
            ],
            "properties": [
                "date",
                "weight"
            ],
            "target_label": "person",
            "frequency": "SINGLE",
            "nullable_keys": [
            ],
            "enable_label_index": false,
            "user_data": {}
        }
    ]
}
```

#### 1.3.4 根据name获取EdgeLabel

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/schema/edgelabels/created
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "id": 1,
    "sort_keys": [
    ],
    "source_label": "person",
    "name": "created",
    "index_names": [
    ],
    "properties": [
        "date",
        "city",
        "weight"
    ],
    "target_label": "software",
    "frequency": "SINGLE",
    "nullable_keys": [
        "city",
        "weight"
    ],
    "enable_label_index": true,
    "user_data": {}
}
```

#### 1.3.5 根据name删除EdgeLabel

删除 EdgeLabel 会导致删除对应的边以及相关的索引数据，会产生一个异步任务

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/schema/edgelabels/created
```

##### Response Status

```json
202
```

##### Response Body

```json
{
    "task_id": 1
}
```

注：

> 可以通过`GET http://localhost:8080/graphs/hugegraph/tasks/1`（其中"1"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)