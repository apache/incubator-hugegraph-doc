### 2.1 Vertex

0.4 版本对顶点 Id 做了比较大的改动，VertexLabel 中的 Id 策略决定了顶点的 Id 类型，其对应关系如下：

Id_Strategy      | id type
---------------- | -------
AUTOMATIC        | number
PRIMARY_KEY      | string
CUSTOMIZE_STRING | string
CUSTOMIZE_NUMBER | number

顶点的GET/PUT/DELETE API中url的 id 部分传入的应是带有类型信息的id值，这个类型信息用 json 串是否带引号表示，也就是说：

- 当 id 类型为 number 时，url 中的 id 不带引号，形如 xxx/vertices/123456
- 当 id 类型为 string 时，url 中的 id 带引号，形如 xxx/vertices/"123456"

-------------------------------------------------------------------

假设已经创建好了上述的各种schema

#### 2.1.1 创建一个顶点

##### Method

```
POST
```

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/vertices
```

##### Request Body

```json
{
    "label": "person",
    "properties": {
        "name": "marko",
        "age": 29
    }
}
```

##### Response Status

```json
201
```

##### Response Body

```json
{
    "id": "1:marko",
    "label": "person",
    "type": "vertex",
    "properties": {
        "name": [
            {
                "id": "1:marko>name",
                "value": "marko"
            }
        ],
        "age": [
            {
                "id": "1:marko>age",
                "value": 29
            }
        ]
    }
}
```

#### 2.1.2 创建多个顶点

##### Method

```
POST
```

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/vertices/batch
```

##### Request Body

```json
[
    {
        "label": "person",
        "properties": {
            "name": "marko",
            "age": 29
        }
    },
    {
        "label": "software",
        "properties": {
            "name": "ripple",
            "lang": "java",
            "price": 199
        }
    }
]
```

##### Response Status

```json
201
```

##### Response Body

```json
[
    "1:marko",
    "2:ripple"
]
```

#### 2.1.3 更新顶点属性

##### Method

```
PUT
```

##### Url

```
http://127.0.0.1:8080/graphs/hugegraph/graph/vertices/"1:marko"?action=append
```

##### Request Body

```json
{
    "label": "person",
    "properties": {
        "age": 30,
        "city": "Beijing"
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
    "id": "1:marko",
    "label": "person",
    "type": "vertex",
    "properties": {
        "city": [
            {
                "id": "1:marko>city",
                "value": "Beijing"
            }
        ],
        "name": [
            {
                "id": "1:marko>name",
                "value": "marko"
            }
        ],
        "age": [
            {
                "id": "1:marko>age",
                "value": 30
            }
        ]
    }
}
```

#### 2.1.4 删除顶点属性

##### Method

```
PUT
```

##### Url

```
http://127.0.0.1:8080/graphs/hugegraph/graph/vertices/"1:marko"?action=eliminate
```

##### Request Body

```json
{
    "label": "person",
    "properties": {
        "city": "Beijing"
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
    "id": "1:marko",
    "label": "person",
    "type": "vertex",
    "properties": {
        "name": [
            {
                "id": "1:marko>name",
                "value": "marko"
            }
        ],
        "age": [
            {
                "id": "1:marko>age",
                "value": 30
            }
        ]
    }
}
```

#### 2.1.5 获取符合条件的顶点

##### Method

```
GET
```

##### Params

- label: 顶点标签
- properties: 属性键值对(根据属性查询的前提是建立了索引)
- limit: 查询数目

以上参数都是可选的，且可以任意组合

##### Url

```
# 查询所有 age 为 20 且 label 为 person 的顶点
http://localhost:8080/graphs/hugegraph/graph/vertices?label=person&properties={"age":29}&limit=1
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "vertices": [
        {
            "id": "1:marko",
            "label": "person",
            "type": "vertex",
            "properties": {
                "city": [
                    {
                        "id": "1:marko>city",
                        "value": "Beijing"
                    }
                ],
                "name": [
                    {
                        "id": "1:marko>name",
                        "value": "marko"
                    }
                ],
                "age": [
                    {
                        "id": "1:marko>age",
                        "value": 29
                    }
                ]
            }
        }
    ]
}
```

#### 2.1.6 根据Id获取顶点

##### Method

```
GET
```

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/vertices/"1:marko"
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "id": "1:marko",
    "label": "person",
    "type": "vertex",
    "properties": {
        "name": [
            {
                "id": "1:marko>name",
                "value": "marko"
            }
        ],
        "age": [
            {
                "id": "1:marko>age",
                "value": 29
            }
        ]
    }
}
```

#### 2.1.7 根据Id删除顶点

##### Method

```
DELETE
```

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/vertices/"1:marko"
```

##### Response Status

```json
204
```