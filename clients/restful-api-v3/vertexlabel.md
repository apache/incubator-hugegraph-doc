### 4.4.2.顶点类型
VertextLabel的描述字段详细说明

| 字段               | 说明                                                                                                                  |
| ------------------ | --------------------------------------------------------------------------------------------------------------------- |
| id                 | 顶点类型id值                                                                                                          |
| name               | 顶点类型名称，必填                                                                                                    |
| id_strategy        | 顶点类型的ID策略，参考可选值                                                                                          |
| properties         | 顶点类型关联的属性类型                                                                                                |
| primary_keys       | 主键属性，当ID策略为PRIMARY_KEY时必须有值，其他ID策略时必须为空；                                                     |
| enable_label_index | 是否开启类型索引，默认关闭                                                                                            |
| index_names        | 顶点类型创建的索引， 详情见3.4                                                                                        |
| nullable_keys      | 可为空的属性                                                                                                          |
| user_data          | 设置顶点类型的通用信息，作用同属性类型                                                                                |
| ttl                | 顶点存活时间, 如没有设置ttl_start_time，则默默认起点时间以插入时间计算，否则以制定字段作为起点时间。从v0.11.2版本支持 |
| ttl_start_time     | 顶点存活时间的起点字段设置。从v0.11.2版本支持                                                                         |

id_strategy可选值:

- DEFAULT: 如果设置了 primary_keys，则采用PRIMARY_KEY策略，否则采用AUTOMATIC策略
- AUTOMATIC: Snowflake算法自动生成ID
- PRIMARY_KEY: 主键策略生成ID
- CUSTOMIZE_STRING: 用户自定义字符串ID
- CUSTOMIZE_NUMBER: 用户自动移数字ID
- CUSTOMIZE_UUID: 用户自定义UUID

从 hugegraph-server v0.11.2 版本开始支持顶点的 TTL 功能。顶点的 TTL 是通过 VertexLabel 来设置的。比如希望 person 类型的顶点存活时间为一天，需要在创建 person VertexLabel 的时候将 TTL 字段设置为 86400000，即单位为毫秒。

另外，当顶点中带有"创建时间"的属性且希望以"创建时间"属性作为计算顶点存活时间的起点时，可以设置 VertexLabel 中的 ttl_start_time 字段。

#### 4.4.2.1.创建顶点类型

##### 功能介绍
创建一个VertexLabel

##### URI
```
POST /graphspaces/${graphspace}/graphs/${hugegraph}/schema/vertexlabels
```

##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |

##### Body参数
| 名称               | 是否必填 | 类型         | 默认值  | 取值范围              | 说明                       |
| ------------------ | -------- | ------------ | ------- | --------------------- | -------------------------- |
| name               | 是       | String       |         |                       | 属性类型的名称             |
| id_strategy        | 否       | String       | DEFAULT | 参考id_strategy可选值 | 属性类型的ID生成策略       |
| properties         | 否       | List[String] | []      |                       | 顶点类型关联的属性类       |
| primary_keys       | 否       | List[String] | []      |                       | 顶点类型的主键列           |
| index_names        | 否       | List[String] | []      |                       | 顶点类型创建的索引         |
| nullable_keys      | 否       | List[String] | []      |                       | 可为空的属性               |
| enable_label_index | 否       | Boolean      | false   |                       | 是否开启类型索引，默认关闭 |
| user_data          | 否       | Map          |         |                       | 顶点类型的通用信息         |
| ttl                | 否       | Int          |         |                       | 顶点存活时间               |
| ttl_start_time     | 否       | String       |         |                       | 顶点存活时间的起点字段     |

##### Response
| 名称               | 类型         | 说明                   |
| ------------------ | ------------ | ---------------------- |
| id                 | Int          | 顶点类型id             |
| name               | String       | 顶点类型名称           |
| id_strategy        | String       | 顶点类型的ID策略       |
| properties         | List[String] | 顶点类型关联的属性类型 |
| primary_keys       | List[String] | 主键属性               |
| index_names        | List[String] | 顶点类型创建的索引     |
| nullable_keys      | List[String] | 可为空的属性           |
| enable_label_index | Boolean      | 是否开启类型索引       |
| user_data          | Map          | 设置顶点类型的通用信息 |
| ttl                | Int          | 顶点存活时间           |
| ttl_start_time     | String       | 顶点存活时间的起点字段 |

##### 使用示例

person VertexLabel 有 createdTime 属性，且 createdTime 是 Date 类型的参数，希望 person 类型的顶点从创建开始存活一天的时间，那么创建 person VertexLabel 的 Request Body。

###### Method & Url
```
POST http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/vertexlabels
```

###### Request Body

```json
{
    "name": "person",
    "id_strategy": "DEFAULT",
    "properties": [
        "name",
        "age"
    ],
    "primary_keys": [
        "name"
    ],
    "nullable_keys": [],
    "ttl": 86400000,
    "ttl_start_time": "createdTime",
    "enable_label_index": true
}
```

###### Response Status

```json
201
```

###### Response Body

```json
{
    "id": 1,
    "primary_keys": [
        "name"
    ],
    "id_strategy": "PRIMARY_KEY",
    "name": "person2",
    "index_names": [
    ],
    "properties": [
        "name",
        "age"
    ],
    "nullable_keys": [
    ],
    "enable_label_index": true,
    "ttl": 86400000,
    "ttl_start_time": "createdTime",
    "user_data": {}
}
```

#### 4.4.2.2.更新VertexLabel

##### 功能介绍
为已存在的VertexLabel添加properties或userdata，或者移除userdata（目前不支持移除properties）

##### URI
```
PUT /graphspaces/${graphspace}/graphs/${hugegraph}/schema/vertexlabels/${name}?action=${action}
```

##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围                | 说明                                               |
| ---------- | -------- | ------ | ------ | ----------------------- | -------------------------------------------------- |
| graphspace | 是       | String |        |                         | 图空间名称                                         |
| hugegraph  | 是       | String |        |                         | 图名称                                             |
| name       | 是       | String |        |                         | 顶点类型名                                         |
| action     | 是       | String |        | ["append", "eliminate"] | 表示当前行为是添加(`append`)还是移除(`eliminate`） |

##### Body参数
| 名称          | 是否必填 | 类型         | 默认值 | 取值范围 | 说明                       |
| ------------- | -------- | ------------ | ------ | -------- | -------------------------- |
| name          | 是       | String       |        |          | 顶点类型名                 |
| properties    | 否       | List[String] | []     |          | 新增的顶点类型关联的属性类 |
| nullable_keys | 否       | List[String] | []     |          | 新增的可为空的属性         |
| user_data     | 是       | Map          |        |          | 顶点类型的通用信息         |

##### Response
| 名称               | 类型         | 说明                   |
| ------------------ | ------------ | ---------------------- |
| id                 | int          | 顶点类型id             |
| name               | String       | 顶点类型名称           |
| id_strategy        | String       | 顶点类型的ID策略       |
| properties         | List[String] | 顶点类型关联的属性类型 |
| primary_keys       | List[String] | 主键属性               |
| index_names        | List[String] | 顶点类型创建的索引     |
| nullable_keys      | List[String] | 可为空的属性           |
| enable_label_index | Boolean      | 是否开启类型索引       |
| user_data          | Map          | 设置顶点类型的通用信息 |

##### 使用示例
###### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/vertexlabels/person?action=append
```

###### Request Body

```json
{
    "name": "person",
    "properties": [
        "city"
    ],
    "nullable_keys": ["city"],
    "user_data": {
        "super": "animal"
    }
}
```

###### Response Status
```json
200
```

###### Response Body
```json
{
    "id": 1,
    "primary_keys": [
        "name"
    ],
    "id_strategy": "PRIMARY_KEY",
    "name": "person",
    "index_names": [
    ],
    "properties": [
        "city",
        "name",
        "age"
    ],
    "nullable_keys": [
        "city"
    ],
    "enable_label_index": true,
    "user_data": {
        "super": "animal"
    }
}
```

#### 4.4.2.3.获取所有的VertexLabel

##### 功能介绍
获取所有的VertexLabel列表

##### URI
```
GET /graphspaces/${grphspace}/graphs/${hugegraph}/schema/vertexlabels
```
##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |
##### Body参数
无

##### Response
| 名称         | 类型      | 说明     |
| ------------ | --------- | -------- |
| vertexlabels | List[Map] | 顶点类型 |

##### 使用示例
###### Method & Url
```
GET http://localhost:8080/graphspaces/${graphspace}/graphs/${hugegraph}/schema/vertexlabels
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "vertexlabels": [
        {
            "id": 1,
            "primary_keys": [
                "name"
            ],
            "id_strategy": "PRIMARY_KEY",
            "name": "person",
            "index_names": [
            ],
            "properties": [
                "city",
                "name",
                "age"
            ],
            "nullable_keys": [
                "city"
            ],
            "enable_label_index": true,
            "user_data": {
                "super": "animal"
            }
        },
        {
            "id": 2,
            "primary_keys": [
                "name"
            ],
            "id_strategy": "PRIMARY_KEY",
            "name": "software",
            "index_names": [
            ],
            "properties": [
                "price",
                "name",
                "lang"
            ],
            "nullable_keys": [
                "price"
            ],
            "enable_label_index": false,
            "user_data": {}
        }
    ]
}
```

#### 4.4.2.4.获取单个VertexLabel

##### 功能介绍
根据name获取VertexLabel

##### URI
```
GET /graphspaces/${graphspace}/graphs/${hugegraph}/schema/vertexlabels/${name}
```
##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |
| name       | 是       | String |        |          | 顶点类型名 |

##### Body参数
无

##### 使用示例
###### Method & Url

```
GET http://localhost:8080/graphspaces/${grphspace}/graphs/${hugegraph}/schema/vertexlabels/person
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "id": 1,
    "primary_keys": [
        "name"
    ],
    "id_strategy": "PRIMARY_KEY",
    "name": "person",
    "index_names": [
    ],
    "properties": [
        "city",
        "name",
        "age"
    ],
    "nullable_keys": [
        "city"
    ],
    "enable_label_index": true,
    "user_data": {
        "super": "animal"
    }
}
```

#### 8.4.2.5.删除VertexLabel

##### 功能介绍
根据name删除VertexLabel

删除 VertexLabel 会导致删除对应的顶点以及相关的索引数据，会产生一个异步任务

##### URI
```
DELETE /graphspaces/${graphspace}/graphs/${hugegraph}/schema/vertexlabels/${name}
```

##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |
| name       | 是       | String |        |          | 顶点类型名 |
##### Body参数
无

##### Response
| 名称    | 类型   | 说明             |
| ------- | ------ | ---------------- |
| task_id | String | 删除操作的任务id |


##### 使用示例
###### Method & Url

```
DELETE http://localhost:8080/graphspaces/${graphspace}/graphs/${hugegraph}/schema/vertexlabels/person
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

> 可以通过`GET /graphspaces/${graphspace}/graphs/${hugegraph}/tasks/1`（其中"1"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)
