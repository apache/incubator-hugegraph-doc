## 4.4.元数据
### 4.4.1.属性

属性类型的描述字段详细说明:

| 字段       | 说明                                                                                                                    |
| ---------- | ----------------------------------------------------------------------------------------------------------------------- |
| id         | 属性类型的id值, 同一图中，不存在同ID的两个属性类型                                                                      |
| name       | 属性类型名称                                                                                                            |
| data_type  | 属性类型的数据类型，包括：bool、byte、int、long、float、double、string、date、uuid、blob，默认string类型                |
| ardinality | 属性类型的基数，包括：single、list、set，默认single                                                                     |
| properties | 属性的属性，对于属性而言，此项为空                                                                                      |
| user_data  | 设置属性类型的通用信息，比如可设置age属性的取值范围，最小为0，最大为100；目前此项不做任何校验，只为后期拓展提供预留入口 |


#### 4.4.1.1.创建属性

##### 功能介绍
创建一个PropertyKey

##### URI
```
POST /graphspaces/${graphspace}/graphs/${hugegraph}/schema/propertykeys
```

##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |

##### Body参数
| 名称        | 是否必填 | 类型   | 默认值 | 取值范围 | 说明               |
| ----------- | -------- | ------ | ------ | -------- | ------------------ |
| name        | 是       | String |        |          | 属性类型的名称     |
| data_type   | 是       | String |        |          | 属性类型的数据类型 |
| cardinality | 是       | String |        |          | 属性类型的基数     |

##### Response
| 名称        | 类型   | 说明                             |
| ----------- | ------ | -------------------------------- |
| id          | Int    | 新创建的属性类型对应的唯一ID     |
| name        | String | 新创建的属性类型的name           |
| data_type   | String | 新创建的属性类型的数据类型       |
| cardinality | String | 新创建的属性类型的基数           |
| properties  | List   | 新创建的属性类型的属性，固定为空 |
| user_data   | Map    | 属性类型的通用信息               |

##### 使用示例

###### Method & Url
```
POST http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/propertykeys
```

###### Request Body

```json
{
    "name": "age",
    "data_type": "INT",
    "cardinality": "SINGLE"
}
```

###### Response Status

```json
202
```

###### Response Body

```json
{
    "id": 2,
    "name": "age",
    "data_type": "INT",
    "cardinality": "SINGLE",
    "properties": [],
    "user_data": {}
}
```

#### 4.4.1.2.更新PropertyKey

##### 功能介绍
仅允许为已存在的 PropertyKey 添加或移除 userdata

PropertyKey的name、data_type等信息均不支持更改。

##### URI
```
PUT /graphspaces/${graphspace}/graphs/${hugegraph}/schema/propertykeys/${name}?action=append
```

##### URI参数

| 名称       | 是否必填 | 类型   | 默认值 | 取值范围                | 说明                                              |
| ---------- | -------- | ------ | ------ | ----------------------- | ------------------------------------------------- |
| graphspace | 是       | String |        |                         | 图空间名称                                        |
| hugegraph  | 是       | String |        |                         | 图名称                                            |
| name       | 是       | String |        |                         | 属性类型名                                        |
| action     | 是       | String |        | ["append", "eliminate"] | 表示当前行为是添加("append")还是移除("eliminate") |

##### Body参数
| 名称      | 是否必填 | 类型   | 默认值 | 取值范围 | 说明               |
| --------- | -------- | ------ | ------ | -------- | ------------------ |
| name      | 是       | String |        |          | 属性类型名         |
| user_data | 是       | Map    |        |          | 属性类型的通用信息 |

##### Response
| 名称        | 类型   | 说明                             |
| ----------- | ------ | -------------------------------- |
| id          | Int    | 新创建的属性类型对应的唯一ID     |
| name        | String | 新创建的属性类型的name           |
| data_type   | String | 新创建的属性类型的数据类型       |
| cardinality | String | 新创建的属性类型的基数           |
| properties  | List   | 新创建的属性类型的属性，固定为空 |
| user_data   | Map    | 属性类型的通用信息               |

##### 使用示例
###### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/propertykeys/age?action=append
```

###### Request Body

```json
{
    "name": "age",
    "user_data": {
        "min": 0,
        "max": 100
    }
}
```

###### Response Status

```json
202
```

###### Response Body

```json
{
    "id": 2,
    "name": "age",
    "data_type": "INT",
    "cardinality": "SINGLE",
    "properties": [],
    "user_data": {
        "min": 0,
        "max": 100
    }
}
```

#### 4.4.1.3.获取所有的 PropertyKey

##### 功能介绍

获取所有的PropertyKey列表


##### URI
```
GET /graphspaces/${graphspace}/graphs/${hugegraph}/schema/propertykeys
```

##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |

##### Body参数
无

##### Response
| 名称         | 类型      | 说明            |
| ------------ | --------- | --------------- |
| propertykeys | List[Map] | propertykey列表 |

##### 使用示例
###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/propertykeys
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "propertykeys": [
        {
            "id": 3,
            "name": "city",
            "data_type": "TEXT",
            "cardinality": "SINGLE",
            "properties": [],
            "user_data": {}
        },
        {
            "id": 2,
            "name": "age",
            "data_type": "INT",
            "cardinality": "SINGLE",
            "properties": [],
            "user_data": {}
        },
        {
            "id": 5,
            "name": "lang",
            "data_type": "TEXT",
            "cardinality": "SINGLE",
            "properties": [],
            "user_data": {}
        },
        {
            "id": 4,
            "name": "weight",
            "data_type": "DOUBLE",
            "cardinality": "SINGLE",
            "properties": [],
            "user_data": {}
        },
        {
            "id": 6,
            "name": "date",
            "data_type": "TEXT",
            "cardinality": "SINGLE",
            "properties": [],
            "user_data": {}
        },
        {
            "id": 1,
            "name": "name",
            "data_type": "TEXT",
            "cardinality": "SINGLE",
            "properties": [],
            "user_data": {}
        },
        {
            "id": 7,
            "name": "price",
            "data_type": "INT",
            "cardinality": "SINGLE",
            "properties": [],
            "user_data": {}
        }
    ]
}
```

#### 4.4.1.4.获取单个PropertyKey

##### 功能介绍
根据name获取PropertyKey

##### URI
```
GET /graphspaces/${graphspace}/graphs/${hugegraph}/schema/propertykeys/${name}
```

##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |
| name       | 是       | String |        |          | 属性类型名 |

##### Body参数
无

##### Response
| 名称        | 类型   | 说明                             |
| ----------- | ------ | -------------------------------- |
| id          | Int    | 新创建的属性类型对应的唯一ID     |
| name        | String | 新创建的属性类型的name           |
| data_type   | String | 新创建的属性类型的数据类型       |
| cardinality | String | 新创建的属性类型的基数           |
| properties  | List   | 新创建的属性类型的属性，固定为空 |
| user_data   | Map    | 属性类型的通用信息               |

##### 使用示例
###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/propertykeys/age
```
其中，`age`为要获取的PropertyKey的名字

###### Response Status

```json
200
```

###### Response Body

```json
{
    "id": 2,
    "name": "age",
    "data_type": "INT",
    "cardinality": "SINGLE",
    "properties": [],
    "user_data": {}
}
```

#### 4.4.1.5.删除单个PropertyKey

##### 功能介绍
根据name删除PropertyKey

##### URI
```
DELETE /graphspaces/${graphspace}/graphs/${hugegraph}/schema/propertykeys/${name}
```

##### URI参数
| 名称       | 是否必填 | 类型   | 默认值 | 取值范围 | 说明       |
| ---------- | -------- | ------ | ------ | -------- | ---------- |
| graphspace | 是       | String |        |          | 图空间名称 |
| hugegraph  | 是       | String |        |          | 图名称     |
| name       | 是       | String |        |          | 属性类型名 |

##### Body参数
无

##### Response
| 名称    | 类型   | 说明             |
| ------- | ------ | ---------------- |
| task_id | String | 删除操作的任务id |


##### 使用示例
###### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema/propertykeys/age
```

其中，`age`为要获取的PropertyKey的名字

###### Response Status

```json
202
```

###### Response Body

```json
{
    "task_id" : 0
}
```
