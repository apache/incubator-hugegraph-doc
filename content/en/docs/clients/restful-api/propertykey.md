---
title: "PropertyKey API"
linkTitle: "PropertyKey"
weight: 2
---

### 1.2 PropertyKey

Params说明：

- name：属性类型名称，必填
- data_type：属性类型数据类型，包括：bool、byte、int、long、float、double、string、date、uuid、blob，默认string类型
- cardinality：属性类型基数，包括：single、list、set，默认single

请求体字段说明：

- id：属性类型id值
- properties：属性的属性，对于属性而言，此项为空
- user_data：设置属性类型的通用信息，比如可设置age属性的取值范围，最小为0，最大为100；目前此项不做任何校验，只为后期拓展提供预留入口


#### 1.2.1 创建一个 PropertyKey

##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/schema/propertykeys
```

##### Request Body

```json
{
    "name": "age",
    "data_type": "INT",
    "cardinality": "SINGLE"
}
```

##### Response Status

```json
202
```

##### Response Body

```json
{
    "property_key": {
        "id": 1,
        "name": "age",
        "data_type": "INT",
        "cardinality": "SINGLE",
        "aggregate_type": "NONE",
        "write_type": "OLTP",
        "properties": [],
        "status": "CREATED",
        "user_data": {
            "~create_time": "2022-05-13 13:47:23.745"
        }
    },
    "task_id": 0
}
```

#### 1.2.2 为已存在的 PropertyKey 添加或移除 userdata

##### Params

- action: 表示当前行为是添加还是移除，取值为`append`（添加）和`eliminate`（移除）

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/schema/propertykeys/age?action=append
```

##### Request Body

```json
{
    "name": "age",
    "user_data": {
        "min": 0,
        "max": 100
    }
}
```

##### Response Status

```json
202
```

##### Response Body

```json
{
    "property_key": {
        "id": 1,
        "name": "age",
        "data_type": "INT",
        "cardinality": "SINGLE",
        "aggregate_type": "NONE",
        "write_type": "OLTP",
        "properties": [],
        "status": "CREATED",
        "user_data": {
            "min": 0,
            "max": 100,
            "~create_time": "2022-05-13 13:47:23.745"
        }
    },
    "task_id": 0
}
```

#### 1.2.3 获取所有的 PropertyKey

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/schema/propertykeys
```

##### Response Status

```json
200
```

##### Response Body

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

#### 1.2.4 根据name获取PropertyKey

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/schema/propertykeys/age
```

其中，`age`为要获取的PropertyKey的名字

##### Response Status

```json
200
```

##### Response Body

```json
{
    "id": 1,
    "name": "age",
    "data_type": "INT",
    "cardinality": "SINGLE",
    "aggregate_type": "NONE",
    "write_type": "OLTP",
    "properties": [],
    "status": "CREATED",
    "user_data": {
        "min": 0,
        "max": 100,
        "~create_time": "2022-05-13 13:47:23.745"
    }
}
```

#### 1.2.5 根据name删除PropertyKey

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/schema/propertykeys/age
```

其中，`age`为要获取的PropertyKey的名字

##### Response Status

```json
202
```

##### Response Body

```json
{
    "task_id" : 0
}
```
