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
- limit: 查询最大数目
- page: 页号

以上参数都是可选的，如果提供page参数，必须提供limit参数，不允许带其他参数。`label, properties`和`limit`可以任意组合。

**查询所有 age 为 20 且 label 为 person 的顶点**

##### Url

```
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

**分页查询所有顶点，获取第一页（page不带参数值），限定3条**

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/vertices?page&limit=3
```

##### Response Status

```json
200
```

##### Response Body

```json
{
	"vertices": [{
			"id": "2:ripple",
			"label": "software",
			"type": "vertex",
			"properties": {
				"price": [{
					"id": "2:ripple>price",
					"value": 199
				}],
				"name": [{
					"id": "2:ripple>name",
					"value": "ripple"
				}],
				"lang": [{
					"id": "2:ripple>lang",
					"value": "java"
				}]
			}
		},
		{
			"id": "1:vadas",
			"label": "person",
			"type": "vertex",
			"properties": {
				"city": [{
					"id": "1:vadas>city",
					"value": "Hongkong"
				}],
				"name": [{
					"id": "1:vadas>name",
					"value": "vadas"
				}],
				"age": [{
					"id": "1:vadas>age",
					"value": 27
				}]
			}
		},
		{
			"id": "1:peter",
			"label": "person",
			"type": "vertex",
			"properties": {
				"city": [{
					"id": "1:peter>city",
					"value": "Shanghai"
				}],
				"name": [{
					"id": "1:peter>name",
					"value": "peter"
				}],
				"age": [{
					"id": "1:peter>age",
					"value": 35
				}]
			}
		}
	],
	"page": "001000100853313a706574657200f07ffffffc00e797c6349be736fffc8699e8a502efe10004"
}
```

返回的body里面是带有下一页的页号信息的，`"page": "001000100853313a706574657200f07ffffffc00e797c6349be736fffc8699e8a502efe10004"`，
在查询下一页的时候将该值赋给page参数。

**分页查询所有顶点，获取下一页（page带上上一页返回的page值），限定3条**

##### Url

```
http://localhost:8080/graphs/hugegraph/graph/vertices?page=001000100853313a706574657200f07ffffffc00e797c6349be736fffc8699e8a502efe10004&limit=3
```

##### Response Status

```json
200
```

##### Response Body

```json
{
	"vertices": [{
			"id": "1:josh",
			"label": "person",
			"type": "vertex",
			"properties": {
				"city": [{
					"id": "1:josh>city",
					"value": "Beijing"
				}],
				"name": [{
					"id": "1:josh>name",
					"value": "josh"
				}],
				"age": [{
					"id": "1:josh>age",
					"value": 32
				}]
			}
		},
		{
			"id": "1:marko",
			"label": "person",
			"type": "vertex",
			"properties": {
				"city": [{
					"id": "1:marko>city",
					"value": "Beijing"
				}],
				"name": [{
					"id": "1:marko>name",
					"value": "marko"
				}],
				"age": [{
					"id": "1:marko>age",
					"value": 29
				}]
			}
		},
		{
			"id": "2:lop",
			"label": "software",
			"type": "vertex",
			"properties": {
				"price": [{
					"id": "2:lop>price",
					"value": 328
				}],
				"name": [{
					"id": "2:lop>name",
					"value": "lop"
				}],
				"lang": [{
					"id": "2:lop>lang",
					"value": "java"
				}]
			}
		}
	],
	"page": "null"
}
```

此时`"page": "null"`表示已经没有下一页了。

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