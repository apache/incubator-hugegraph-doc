### 1.1 Schema

HugeGraph 提供单一接口获取和更新某个图的全部 Schema 信息，包括：PropertyKey、VertexLabel、EdgeLabel 和 IndexLabel。

#### 1.1.1 获取全部schema信息

##### Params

- format: 返回 schema 的格式，默认为 json，可选值为 [json, groovy]

##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema
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
            "id": 7,
            "name": "price",
            "data_type": "INT",
            "cardinality": "SINGLE",
            "aggregate_type": "NONE",
            "write_type": "OLTP",
            "properties": [
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:40.741"
            }
        },
        {
            "id": 6,
            "name": "date",
            "data_type": "TEXT",
            "cardinality": "SINGLE",
            "aggregate_type": "NONE",
            "write_type": "OLTP",
            "properties": [
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:40.729"
            }
        },
        {
            "id": 3,
            "name": "city",
            "data_type": "TEXT",
            "cardinality": "SINGLE",
            "aggregate_type": "NONE",
            "write_type": "OLTP",
            "properties": [
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:40.691"
            }
        },
        {
            "id": 2,
            "name": "age",
            "data_type": "INT",
            "cardinality": "SINGLE",
            "aggregate_type": "NONE",
            "write_type": "OLTP",
            "properties": [
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:40.678"
            }
        },
        {
            "id": 5,
            "name": "lang",
            "data_type": "TEXT",
            "cardinality": "SINGLE",
            "aggregate_type": "NONE",
            "write_type": "OLTP",
            "properties": [
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:40.718"
            }
        },
        {
            "id": 4,
            "name": "weight",
            "data_type": "DOUBLE",
            "cardinality": "SINGLE",
            "aggregate_type": "NONE",
            "write_type": "OLTP",
            "properties": [
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:40.707"
            }
        },
        {
            "id": 1,
            "name": "name",
            "data_type": "TEXT",
            "cardinality": "SINGLE",
            "aggregate_type": "NONE",
            "write_type": "OLTP",
            "properties": [
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:40.609"
            }
        }
    ],
    "vertexlabels": [
        {
            "id": 1,
            "name": "person",
            "id_strategy": "PRIMARY_KEY",
            "primary_keys": [
                "name"
            ],
            "nullable_keys": [
                "age"
            ],
            "index_labels": [
                "personByCity",
                "personByAgeAndCity"
            ],
            "properties": [
                "name",
                "age",
                "city"
            ],
            "status": "CREATED",
            "ttl": 0,
            "enable_label_index": true,
            "user_data": {
                "~create_time": "2021-09-03 15:13:40.783"
            }
        },
        {
            "id": 2,
            "name": "software",
            "id_strategy": "PRIMARY_KEY",
            "primary_keys": [
                "name"
            ],
            "nullable_keys": [
                "price"
            ],
            "index_labels": [
                "softwareByPrice"
            ],
            "properties": [
                "name",
                "lang",
                "price"
            ],
            "status": "CREATED",
            "ttl": 0,
            "enable_label_index": true,
            "user_data": {
                "~create_time": "2021-09-03 15:13:40.840"
            }
        }
    ],
    "edgelabels": [
        {
            "id": 1,
            "name": "knows",
            "source_label": "person",
            "target_label": "person",
            "frequency": "MULTIPLE",
            "sort_keys": [
                "date"
            ],
            "nullable_keys": [
                "weight"
            ],
            "index_labels": [
                "knowsByWeight"
            ],
            "properties": [
                "weight",
                "date"
            ],
            "status": "CREATED",
            "ttl": 0,
            "enable_label_index": true,
            "user_data": {
                "~create_time": "2021-09-03 15:13:41.840"
            }
        },
        {
            "id": 2,
            "name": "created",
            "source_label": "person",
            "target_label": "software",
            "frequency": "SINGLE",
            "sort_keys": [
            ],
            "nullable_keys": [
                "weight"
            ],
            "index_labels": [
                "createdByDate",
                "createdByWeight"
            ],
            "properties": [
                "weight",
                "date"
            ],
            "status": "CREATED",
            "ttl": 0,
            "enable_label_index": true,
            "user_data": {
                "~create_time": "2021-09-03 15:13:41.868"
            }
        }
    ],
    "indexlabels": [
        {
            "id": 1,
            "name": "personByCity",
            "base_type": "VERTEX_LABEL",
            "base_value": "person",
            "index_type": "SECONDARY",
            "fields": [
                "city"
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:40.886"
            }
        },
        {
            "id": 4,
            "name": "createdByDate",
            "base_type": "EDGE_LABEL",
            "base_value": "created",
            "index_type": "SECONDARY",
            "fields": [
                "date"
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:41.878"
            }
        },
        {
            "id": 5,
            "name": "createdByWeight",
            "base_type": "EDGE_LABEL",
            "base_value": "created",
            "index_type": "RANGE_DOUBLE",
            "fields": [
                "weight"
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:42.117"
            }
        },
        {
            "id": 2,
            "name": "personByAgeAndCity",
            "base_type": "VERTEX_LABEL",
            "base_value": "person",
            "index_type": "SECONDARY",
            "fields": [
                "age",
                "city"
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:41.351"
            }
        },
        {
            "id": 3,
            "name": "softwareByPrice",
            "base_type": "VERTEX_LABEL",
            "base_value": "software",
            "index_type": "RANGE_INT",
            "fields": [
                "price"
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:41.587"
            }
        },
        {
            "id": 6,
            "name": "knowsByWeight",
            "base_type": "EDGE_LABEL",
            "base_value": "knows",
            "index_type": "RANGE_DOUBLE",
            "fields": [
                "weight"
            ],
            "status": "CREATED",
            "user_data": {
                "~create_time": "2021-09-03 15:13:42.376"
            }
        }
    ]
}
```


**以 groovy 形式查询 schema**

##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema
```

##### Response Status

```json
200
```

##### Response Body

```json
{"schema":"graph.schema().propertyKey(\"price\").asInt().ifNotExist().create();\ngraph.schema().propertyKey(\"date\").asText().ifNotExist().create();\ngraph.schema().propertyKey(\"city\").asText().ifNotExist().create();\ngraph.schema().propertyKey(\"age\").asInt().ifNotExist().create();\ngraph.schema().propertyKey(\"lang\").asText().ifNotExist().create();\ngraph.schema().propertyKey(\"weight\").asDouble().ifNotExist().create();\ngraph.schema().propertyKey(\"name\").asText().ifNotExist().create();\n\ngraph.schema().vertexLabel(\"person\").properties(\"name\",\"age\",\"city\").primaryKeys(\"name\").nullableKeys(\"age\").enableLabelIndex(true).ifNotExist().create();\ngraph.schema().vertexLabel(\"software\").properties(\"name\",\"lang\",\"price\").primaryKeys(\"name\").nullableKeys(\"price\").enableLabelIndex(true).ifNotExist().create();\n\ngraph.schema().edgeLabel(\"knows\").sourceLabel(\"person\").targetLabel(\"person\").properties(\"weight\",\"date\").multiTimes().sortKeys(\"date\").nullableKeys(\"weight\").enableLabelIndex(true).ifNotExist().create();\ngraph.schema().edgeLabel(\"created\").sourceLabel(\"person\").targetLabel(\"software\").properties(\"weight\",\"date\").nullableKeys(\"weight\").enableLabelIndex(true).ifNotExist().create();\n\ngraph.schema().indexLabel(\"personByCity\").onV(\"person\").by(\"city\").secondary().ifNotExist().create();\ngraph.schema().indexLabel(\"personByAge\").onV(\"person\").by(\"age\").range().ifNotExist().create();\ngraph.schema().indexLabel(\"softwareByPrice\").onV(\"software\").by(\"price\").range().ifNotExist().create();\ngraph.schema().indexLabel(\"createdByDate\").onE(\"created\").by(\"date\").secondary().ifNotExist().create();\ngraph.schema().indexLabel(\"createdByWeight\").onE(\"created\").by(\"weight\").range().ifNotExist().create();\ngraph.schema().indexLabel(\"knowsByWeight\").onE(\"knows\").by(\"weight\").range().ifNotExist().create();\n"}
```

#### 1.1.2 以 groovy 形式更新schema信息

##### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/schema
```

##### Request body

```json
{
  "schema": "graph.schema().propertyKey('name').asText().ifNotExist().create();graph.schema().propertyKey('age').asInt().ifNotExist().create();graph.schema().propertyKey('city').asText().ifNotExist().create();graph.schema().propertyKey('lang').asText().ifNotExist().create();graph.schema().propertyKey('date').asText().ifNotExist().create();graph.schema().propertyKey('price').asInt().ifNotExist().create();person=graph.schema().vertexLabel('person').properties('name','age','city').primaryKeys('name').ifNotExist().create();knows=graph.schema().edgeLabel('knows').sourceLabel('person').targetLabel('person').properties('date').ifNotExist().create();"
}
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "schema":"inited"
}
```
