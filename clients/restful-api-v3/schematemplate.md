### 12.1 Schema template

在 HugeGraph 中，支持元数据模板（schema template），可以批量的创建元数据。

#### 12.1.1 创建一个元数据模板

##### 功能介绍

创建一个元数据模板

##### URI

```
POST /graphspaces/${graphspace}/schematemplates
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| name  | 是 | String  |   |   |  schematemplate 的名字 |
| schema  | 是 | String  |   |   |  schematemplate 的 groovy 内容 |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| name  |String| schematemplate 的名字 |
| schema |String| schematemplate 的 groovy 内容 |

##### 使用示例

###### Method & Url

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

##### 功能介绍

列出某个图空间的所有元数据模板

##### URI

```
GET /graphspaces/${graphspace}/schematemplates
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| schema_templates  |Array| schematemplate 的名字列表 |

##### 使用示例

###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/schematemplates
```


###### Request Body

无

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

##### 功能介绍

创建键值对或者更新键值对


##### URI

```
GET /graphspaces/${graphspace}/schematemplates/${schematemplate}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| schematemplate  | 是 | String  |   |   | schematemplate 的名字  |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| name  |String| schematemplate 的名字 |
| schema |String| schematemplate 的 groovy 内容 |

##### 使用示例

###### Method & Url

```
GET http://127.0.0.1:8080/graphspaces/gs1/schematemplates/st1
```

###### Request Body

无

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

##### 功能介绍

删除某个元数据模板

##### URI

```
DELETE /graphspaces/${graphspace}/schematemplates/${schematemplate}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| schematemplate  | 是 | String  |   |   | schematemplate 的名字  |

##### Body参数

无

##### Response

无

##### 使用示例

###### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/schematemplates/st1
```

###### Request Body

无

###### Response Status

```json
204
```

###### Response Body

无
