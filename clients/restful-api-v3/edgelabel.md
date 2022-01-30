### 4.4.3.边类型

EdgeLabel的描述字段详细说明

| 字段               | 说明                                                                                                                |
| ------------------ | ------------------------------------------------------------------------------------------------------------------- |
| name               | 顶点类型名称，必填                                                                                                  |
| source_label       | 源顶点类型的名称，必填                                                                                              |
| target_label       | 目标顶点类型的名称，必填                                                                                            |
| frequency          | 两个点之间是否可以有多条边，可以取值SINGLE和MULTIPLE，非必填，默认值SINGLE                                          |
| properties         | 边类型关联的属性类型，选填                                                                                          |
| index_names        | 边类型创建的索引                                                                                                    |
| sort_keys          | 当允许关联多次时，指定区分键属性列表                                                                                |
| nullable_keys      | 可为空的属性，选填，默认可为空                                                                                      |
| enable_label_index | 是否开启类型索引，默认关闭                                                                                          |
| ttl                | 边存活时间, 如没有设置ttl_start_time，则默默认起点时间以插入时间计算，否则以制定字段作为起点时间。从v0.11.2版本支持 |
| ttl_start_time     | 边存活时间的起点字段设置。从v0.11.2版本支持                                                                         |

从 hugegraph-server v0.11.2 版本开始支持边的 TTL 功能。边的 TTL 是通过 EdgeLabel 来设置的。

另外，当边中带有"创建时间"的属性且希望以"创建时间"属性作为计算边存活时间的起点时，可以设置 EdgeLabel 中的 ttl_start_time 字段。

#### 4.4.3.1.建边类型

##### 功能介绍
创建一个EdgeLabel

##### URI
```
POST /graphspaces/${graphspace}/graphs/${hugegraph}/schema/edgelabels
```
##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |

##### Body参数
| 名称               | 是否必填 | 类型         | 默认值 | 取值范围              | 说明                               |
| ------------------ | -------- | ------------ | ------ | --------------------- | ---------------------------------- |
| name               | 是       | String       |        |                       | 属性类型的名称                     |
| source_label       | 是       | String       |        |                       | 源顶点类型的名称                   |
| target_label       | 是       | String       |        |                       | 目标顶点类型的名称                 |
| frequency          | 否       | String       | SINGLE | ["SINGLE","MULTIPLE"] | 两个点之间是否可以有多条边         |
| properties         | 否       | List[String] | []     |                       | 边类型关联的属性类型               |
| index_names        | 否       | List[String] | []     |                       | 顶点类型创建的索引                 |
| sort_keys          | 否       | List[String] | []     |                       | 当允许关联多次时，指定区分键属性列 |
| nullable_keys      | 否       | List[String] | []     |                       | 可为空的属性                       |
| enable_label_index | 否       | Boolean      | false  |                       | 是否开启类型索引，默认关闭         |
| user_data          | 否       | Map          |        |                       | 边类型的通用信息                   |
| ttl                | 否       | Int          |        |                       | 边存活时间                         |
| ttl_start_time     | 否       | String       |        |                       | 边存活时间的起点字段               |

##### Request
| 名称               | 类型         | 说明                               |
| ------------------ | ------------ | ---------------------------------- |
| id                 | Int          | 边类型id                           |
| name               | String       | 边类型名称                         |
| source_label       | String       | 源顶点类型的名称                   |
| target_label       | String       | 目标顶点类型的名称                 |
| frequency          | String       | 两个点之间是否可以有多条边         |
| properties         | List[String] | 边类型关联的属性类型               |
| nullable_keys      | List[String] | 可为空的属性                       |
| index_names        | List[String] | 边类型创建的索引                   |
| sort_keys          | List[String] | 当允许关联多次时，指定区分键属性列 |
| enable_label_index | Boolean      | 是否开启类型索引                   |
| user_data          | Map          | 设置顶点类型的通用信息             |
| ttl                | Int          | 边存活时间                         |
| ttl_start_time     | String       | 边存活时间的起点字段               |



##### 使用示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/edgelabels
```

###### Request Body

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

###### Response Status

```json
201
```

###### Response Body

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

从 hugegraph-server v0.11.2 版本开始支持边的 TTL 功能。边的 TTL 是通过 EdgeLabel 来设置的。比如希望 knows 类型的边存活时间为一天，需要在创建 knows EdgeLabel 的时候将 TTL 字段设置为 86400000，即单位为毫秒。

```json
{
    "id": 1,
    "sort_keys": [
    ],
    "source_label": "person",
    "name": "knows",
    "index_names": [
    ],
    "properties": [
        "date",
        "createdTime"
    ],
    "target_label": "person",
    "frequency": "SINGLE",
    "nullable_keys": [
    ],
    "enable_label_index": true,
    "ttl": 86400000,
    "user_data": {}
}
```

另外，当边中带有"创建时间"的属性且希望以"创建时间"属性作为计算边存活时间的起点时，可以设置 EdgeLabel 中的 ttl_start_time 字段。比如 knows EdgeLabel 有 createdTime 属性，且 createdTime 是 Date 类型的参数，希望 knows 类型的边从创建开始存活一天的时间，那么创建 knows EdgeLabel 的 Request Body 如下：

```json
{
    "id": 1,
    "sort_keys": [
    ],
    "source_label": "person",
    "name": "knows",
    "index_names": [
    ],
    "properties": [
        "date",
        "createdTime"
    ],
    "target_label": "person",
    "frequency": "SINGLE",
    "nullable_keys": [
    ],
    "enable_label_index": true,
    "ttl": 86400000,
    "ttl_start_time": "createdTime",
    "user_data": {}
}
```

#### 4.4.3.2.更新EdgeLabel
##### 功能介绍
为已存在的EdgeLabel添加properties或userdata，或者移除userdata（目前不支持移除properties）

##### URI
```
PUT /graphspaces/${graphspace}/graphs/${hugegraph}/schema/edgelabels/${name}?action=${action}
```

##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围                | 说明                                               |
| ---------- | -------- | ------ | ------ | ----------------------- | -------------------------------------------------- |
| graphspace | 是       | String |        |                         | 图空间名称                                         |
| hugegraph  | 是       | String |        |                         | 图名称                                             |
| name       | 是       | String |        |                         | 边类型名                                           |
| action     | 是       | String |        | ["append", "eliminate"] | 表示当前行为是添加(`append`)还是移除(`eliminate`） |

##### Body参数
| 名称          | 是否必填 | 类型         | 默认值 | 取值范围 | 说明                     |
| ------------- | -------- | ------------ | ------ | -------- | ------------------------ |
| name          | 是       | String       |        |          | 顶点类型名               |
| properties    | 否       | List[String] | []     |          | 新增的边类型关联的属性类 |
| nullable_keys | 否       | List[String] | []     |          | 新增的可为空的属性       |
| user_data     | 是       | Map          |        |          | 边类型的通用信息         |

##### Response
| 名称               | 类型         | 说明                               |
| ------------------ | ------------ | ---------------------------------- |
| id                 | Int          | 边类型id                           |
| name               | String       | 边类型名称                         |
| source_label       | String       | 源顶点类型的名称                   |
| target_label       | String       | 目标顶点类型的名称                 |
| frequency          | String       | 两个点之间是否可以有多条边         |
| properties         | List[String] | 边类型关联的属性类型               |
| nullable_keys      | List[String] | 可为空的属性                       |
| index_names        | List[String] | 边类型创建的索引                   |
| sort_keys          | List[String] | 当允许关联多次时，指定区分键属性列 |
| enable_label_index | Boolean      | 是否开启类型索引                   |
| user_data          | Map          | 设置顶点类型的通用信息             |
| ttl                | Int          | 边存活时间                         |
| ttl_start_time     | String       | 边存活时间的起点字段               |


##### 使用示例
###### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/edgelabels/created?action=append
```

###### Request Body

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

###### Response Status

```json
200
```

###### Response Body

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

#### 4.4.3.3.获取所有的EdgeLabel

##### 功能介绍

获取所有的EdgeLabel列表

##### URI
```
GET /graphspaces/${graphspace}/graphs/${hugegraph}/schema/edgelabels
```
##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |

##### Body参数
无

##### Response
| 名称       | 类型      | 说明       |
| ---------- | --------- | ---------- |
| edgelabels | List[Map] | 边类型列表 |

##### 使用示例
###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/edgelabels
```

###### Response Status

```json
200
```

###### Response Body

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

#### 4.4.3.4.获取一个EdgeLabel

##### 功能介绍
根据name获取EdgeLabel

##### URI
```
GET /graphspaces/${graphspace}/graphs/${hugegraph}/schema/edgelabels/${name}
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
| 名称               | 类型         | 说明                               |
| ------------------ | ------------ | ---------------------------------- |
| id                 | Int          | 边类型id                           |
| name               | String       | 边类型名称                         |
| source_label       | String       | 源顶点类型的名称                   |
| target_label       | String       | 目标顶点类型的名称                 |
| frequency          | String       | 两个点之间是否可以有多条边         |
| properties         | List[String] | 边类型关联的属性类型               |
| nullable_keys      | List[String] | 可为空的属性                       |
| index_names        | List[String] | 边类型创建的索引                   |
| sort_keys          | List[String] | 当允许关联多次时，指定区分键属性列 |
| enable_label_index | Boolean      | 是否开启类型索引                   |
| user_data          | Map          | 设置顶点类型的通用信息             |
| ttl                | Int          | 边存活时间                         |
| ttl_start_time     | String       | 边存活时间的起点字段               |

##### 使用示例
###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/edgelabels/created
```

###### Response Status

```json
200
```

###### Response Body

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

#### 4.4.3.5.删除EdgeLabel

##### 功能介绍
根据name删除EdgeLabel

删除 EdgeLabel 会导致删除对应的边以及相关的索引数据，会产生一个异步任务

##### URI
```
DELETE /graphspaces/${graphspace}/graphs/${hugegraph}/schema/edgelabels/${name}
```

##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |
| name       | 是       | String |        |          | 边类型名   |

##### Body参数
无

##### Response
| 名称    | 类型   | 说明             |
| ------- | ------ | ---------------- |
| task_id | String | 删除操作的任务id |

##### 使用示例
###### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/edgelabels/created
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
