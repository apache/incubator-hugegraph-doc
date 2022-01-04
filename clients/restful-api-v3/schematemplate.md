### 12.1 Schema template

在 HugeGraph 中，支持元数据模板（schema template），可以批量的创建元数据。

#### 12.1.1 创建一个元数据模板

##### Method & Url

```
POST http://127.0.0.1:8080/graphspaces/gs1/schematemplates
```

##### Request Body

```json
{
  "name": "st1",
  "schema": "graph.schema().propertyKey('name').asText().ifNotExist().create();graph.schema().propertyKey('age').asInt().ifNotExist().create();graph.schema().propertyKey('city').asText().ifNotExist().create();graph.schema().propertyKey('lang').asText().ifNotExist().create();graph.schema().propertyKey('date').asText().ifNotExist().create();graph.schema().propertyKey('price').asInt().ifNotExist().create();person=graph.schema().vertexLabel('person').properties('name','age','city').primaryKeys('name').ifNotExist().create();knows=graph.schema().edgeLabel('knows').sourceLabel('person').targetLabel('person').properties('date').ifNotExist().create();"
}
```

##### Response Status

```json
201
```

##### Response Body

```json
{
    "name": "st1",
    "schema": "graph.schema().propertyKey('name').asText().ifNotExist().create();graph.schema().propertyKey('age').asInt().ifNotExist().create();graph.schema().propertyKey('city').asText().ifNotExist().create();graph.schema().propertyKey('lang').asText().ifNotExist().create();graph.schema().propertyKey('date').asText().ifNotExist().create();graph.schema().propertyKey('price').asInt().ifNotExist().create();person=graph.schema().vertexLabel('person').properties('name','age','city').primaryKeys('name').ifNotExist().create();knows=graph.schema().edgeLabel('knows').sourceLabel('person').targetLabel('person').properties('date').ifNotExist().create();"
}
```

#### 12.1.2 列出某个图空间的所有元数据模板

##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/schematemplates
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "schema_templates": [
        "s1"
    ]
}

```

#### 12.1.3 查看某个元数据模板

##### Method & Url

```
GET http://127.0.0.1:8080/graphspaces/gs1/schematemplates/st1
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "name": "s1",
    "schema": "graph.schema().propertyKey('name').asText().ifNotExist().create();graph.schema().propertyKey('age').asInt().ifNotExist().create();graph.schema().propertyKey('city').asText().ifNotExist().create();graph.schema().propertyKey('lang').asText().ifNotExist().create();graph.schema().propertyKey('date').asText().ifNotExist().create();graph.schema().propertyKey('price').asInt().ifNotExist().create();person=graph.schema().vertexLabel('person').properties('name','age','city').primaryKeys('name').ifNotExist().create();knows=graph.schema().edgeLabel('knows').sourceLabel('person').targetLabel('person').properties('date').ifNotExist().create();"
}
```

#### 12.1.4 删除某个元数据模板

##### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/schematemplates/st1
```

##### Response Status

```json
204
```
