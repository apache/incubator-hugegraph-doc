### 1.1 PropertyKey

#### 1.1.1 创建一个 PropertyKey

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
201
```

##### Response Body

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

#### 1.1.2 为已存在的 PropertyKey 添加或移除 userdata

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
201
```

##### Response Body

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

#### 1.1.3 获取所有的 PropertyKey

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

#### 1.1.4 根据name获取PropertyKey

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
    "id": 2,
    "name": "age",
    "data_type": "INT",
    "cardinality": "SINGLE",
    "properties": [],
    "user_data": {}
}
```

#### 1.1.5 根据name删除PropertyKey

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/schema/propertykeys/age
```

其中，`age`为要获取的PropertyKey的名字

##### Response Status

```json
204
```
