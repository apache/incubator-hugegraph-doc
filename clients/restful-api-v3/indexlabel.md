### 4.4.4.索引类型

假设已经创建好了1.1.3中的 PropertyKeys 、1.2.3中的 VertexLabels 以及 1.3.3中的 EdgeLabels

index_type可选值列表

- SECONDARY: 支持精确匹配的二级索引，允许建立联合索引，联合索引支持索引前缀搜索
  - 单个属性，支持相等查询
  - 联合索引，支持前缀查询和相等查询
- Range: 支持数值类型的范围查询
   -  RANGE_INT
   -  RANGE_FLOAT
   -  RANGE_LONG
   -  RANGE_DOUBLE
- SEARCH: 支持全文检索的索引。
  - 必须是单个文本属性
- SHARD：支持前缀匹配 + 数字范围查询的索引
  - shard index N个属性全是文本属性时，等价于secondary index
  - shard index只有单个数字或者日期属性时，等价于range index
- UNIQUE: 支持属性值唯一性约束，即可以限定属性的值不重复，允许联合索引，但不支持查询
  - 单个或者多个属性的唯一性索引，不可用来查询，只可对属性的值进行限定，当出现重复值时将报错

#### 4.4.4.1.创建索引类型

##### 功能介绍
创建一个IndexLabel, 会产生一个异步任务

##### URI
```
POST /graphspaces/${graphspace}/graphs/${hugegraph}/schema/indexlabels
```
##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |

##### Body参数
| 名称       | 是否必填 | 类型         | 默认值 | 取值范围 | 说明             |
| ---------- | -------- | ------------ | ------ | -------- | ---------------- |
| name       | 是       | String       |        |          | 属性类型的名称   |
| base_type  | 是       | String       |        |          | 创建索引的类型   |
| base_value | 是       | String       |        |          | 创建索引的类型值 |
| index_type | 是       | String       |        |          | 索引类型         |
| fields     | 是       | List[String] |        |          | 创建索引的属性列 |

##### Response
| 名称        | 类型 | 说明                  |
| ----------- | ---- | --------------------- |
| index_label | Map  | 索引信息              |
| task_id     | Int  | 构建索引任务的task id |

##### 使用示例
###### Method & Url

```
POST http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/indexlabels
```

###### Request Body

```json
{
    "name": "personByCity",
    "base_type": "VERTEX_LABEL",
    "base_value": "person",
    "index_type": "SECONDARY",
    "fields": [
        "city"
    ]
}
```

###### Response Status

```json
202
```

###### Response Body

```json
{
    "index_label": {
        "id": 1,
        "base_type": "VERTEX_LABEL",
        "base_value": "person",
        "name": "personByCity",
        "fields": [
            "city"
        ],
        "index_type": "SECONDARY"
    },
    "task_id": 2
}
```

#### 4.4.4.2.获取所有的IndexLabel

##### 功能介绍

获取所有的IndexLabel列表

##### URI
```
GET /graphspaces/${graphspace}/graphs/${hugegraph}/schema/indexlabels
```
##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |

##### Body参数
无
##### Response
| 名称        | 类型      | 说明         |
| ----------- | --------- | ------------ |
| indexlabels | List[Map] | 索引类型列表 |

##### 使用示例
###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/indexlabels
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "indexlabels": [
        {
            "id": 3,
            "base_type": "VERTEX_LABEL",
            "base_value": "software",
            "name": "softwareByPrice",
            "fields": [
                "price"
            ],
            "index_type": "RANGE"
        },
        {
            "id": 4,
            "base_type": "EDGE_LABEL",
            "base_value": "created",
            "name": "createdByDate",
            "fields": [
                "date"
            ],
            "index_type": "SECONDARY"
        },
        {
            "id": 1,
            "base_type": "VERTEX_LABEL",
            "base_value": "person",
            "name": "personByCity",
            "fields": [
                "city"
            ],
            "index_type": "SECONDARY"
        },
        {
            "id": 3,
            "base_type": "VERTEX_LABEL",
            "base_value": "person",
            "name": "personByAgeAndCity",
            "fields": [
                "age",
                "city"
            ],
            "index_type": "SECONDARY"
        }
    ]
}
```

#### 4.4.4.3.获取单个IndexLabel

##### 功能介绍
根据name获取IndexLabel

##### URI
```
GET /graphspaces/${graphspace}/graphs/${hugegraph}/schema/indexlabels/${name}
```
##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |
| name       | 是       | String |        |          | 索引类型名 |

##### Body参数
无

##### 使用示例
###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/indexlabels/personByCity
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "id": 1,
    "base_type": "VERTEX_LABEL",
    "base_value": "person",
    "name": "personByCity",
    "fields": [
        "city"
    ],
    "index_type": "SECONDARY"
}
```

#### 4.4.4.4.删除单个IndexLabel

##### 功能介绍
根据name删除IndexLabel

删除 IndexLabel 会导致删除相关的索引数据，会产生一个异步任务

##### URI
```
DELETE /graphspaces/${graphspace}/graphs/${hugegraph}/schema/indexlabels/${name}
```

##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |
| name       | 是       | String |        |          | 索引类型名 |

##### Body参数
无

##### Response
| 名称    | 类型   | 说明             |
| ------- | ------ | ---------------- |
| task_id | String | 删除操作的任务id |

##### 使用示例
###### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/indexlabels/personByCity
```

###### Response Status

```json
202
```

###### Response Body

```json
{
    "task_id": 1
}
```

注：

> 可以通过`GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/tasks/1`（其中"1"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)
