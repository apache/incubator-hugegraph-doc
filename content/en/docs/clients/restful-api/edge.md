---
title: "Edge API"
linkTitle: "Edge"
weight: 8
---

### 2.2 Edge

The modification of the vertex ID format also affects the ID of the edge, as well as the formats of the source vertex and target vertex IDs.

The EdgeId is formed by concatenating `src-vertex-id + direction + label + sort-values + tgt-vertex-id`, but the vertex ID types are not distinguished by quotation marks here. Instead, they are distinguished by prefixes:

- When the ID type is number, the vertex ID in the EdgeId has a prefix `L`, like "L123456>1>>L987654".
- When the ID type is string, the vertex ID in the EdgeId has a prefix `S`, like "S1:peter>1>>S2:lop".

--------------------------------------------------------------------------------

The following examples assume that various schemas and vertex information mentioned above have been created.

#### 2.2.1 Creating an Edge

Params Explanation

- label: The name of the edge type, required.
- outV: The ID of the source vertex, required.
- inV: The ID of the target vertex, required.
- outVLabel: The type of the source vertex, required.
- inVLabel: The type of the target vertex, required.
- properties: The properties associated with the edge. The internal structure of the object is as follows:
  1. name: The name of the property.
  2. value: The value of the property.


##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/graph/edges
```

##### Request Body

```json
{
    "label": "created",
    "outV": "1:peter",
    "inV": "2:lop",
    "outVLabel": "person",
    "inVLabel": "software",
    "properties": {
        "date": "2017-5-18",
        "weight": 0.2
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
    "id": "S1:peter>1>>S2:lop",
    "label": "created",
    "type": "edge",
    "inVLabel": "software",
    "outVLabel": "person",
    "inV": "2:lop",
    "outV": "1:peter",
    "properties": {
        "date": "2017-5-18",
        "weight": 0.2
    }
}
```

#### 2.2.2 Creating Multiple Edges

##### Params

- check_vertex: Whether to check vertex existence (true | false). When set to true and the source or target vertex of the edge being inserted does not exist, an error will be reported.

##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/graph/edges/batch
```

##### Request Body

```json
[
    {
        "label": "created",
        "outV": "1:peter",
        "inV": "2:lop",
        "outVLabel": "person",
        "inVLabel": "software",
        "properties": {
            "date": "2017-5-18",
            "weight": 0.2
        }
    },
    {
        "label": "knows",
        "outV": "1:marko",
        "inV": "1:vadas",
        "outVLabel": "person",
        "inVLabel": "person",
        "properties": {
            "date": "2016-01-10",
            "weight": 0.5
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
    "S1:peter>1>>S2:lop",
    "S1:marko>2>>S1:vadas"
]
```

#### 2.2.3 Updating Edge Properties

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/graph/edges/S1:peter>1>>S2:lop?action=append
```

##### Request Body

```json
{
    "properties": {
        "weight": 1.0
    }
}
```

> Note: There are three categories of property values: single, set, and list. If it is single, it means adding or updating the property value. If it is set or list, it means appending the property value.

##### Response Status

```json
200
```

##### Response Body

```json
{
    "id": "S1:peter>1>>S2:lop",
    "label": "created",
    "type": "edge",
    "inVLabel": "software",
    "outVLabel": "person",
    "inV": "2:lop",
    "outV": "1:peter",
    "properties": {
        "date": "2017-5-18",
        "weight": 1
    }
}
```

#### 2.2.4 Batch Updating Edge Properties

##### Function Description

Similar to batch updating vertex properties.

Assuming the original edge and its properties are:

```json
{
    "edges":[
        {
            "id":"S1:josh>2>>S2:ripple",
            "label":"created",
            "type":"edge",
            "outV":"1:josh",
            "outVLabel":"person",
            "inV":"2:ripple",
            "inVLabel":"software",
            "properties":{
                "weight":1,
                "date":1512835200000
            }
        },
        {
            "id":"S1:marko>1>7JooBil0>S1:josh",
            "label":"knows",
            "type":"edge",
            "outV":"1:marko",
            "outVLabel":"person",
            "inV":"1:josh",
            "inVLabel":"person",
            "properties":{
                "weight":1,
                "date":1361289600000
            }
        }
    ]
}
```

##### Method & Url

```
PUT http://127.0.0.1:8080/graphs/hugegraph/graph/edges/batch
```

##### Request Body

```json
{
    "edges":[
        {
            "id":"S1:josh>2>>S2:ripple",
            "label":"created",
            "outV":"1:josh",
            "outVLabel":"person",
            "inV":"2:ripple",
            "inVLabel":"software",
            "properties":{
                "weight":0.1,
                "date":1522835200000
            }
        },
        {
            "id":"S1:marko>1>7JooBil0>S1:josh",
            "label":"knows",
            "outV":"1:marko",
            "outVLabel":"person",
            "inV":"1:josh",
            "inVLabel":"person",
            "properties":{
                "weight":0.2,
                "date":1301289600000
            }
        }
    ],
    "update_strategies":{
        "weight":"SUM",
        "date":"BIGGER"
    },
    "check_vertex": false,
    "create_if_not_exist":true
}
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "edges":[
        {
            "id":"S1:josh>2>>S2:ripple",
            "label":"created",
            "type":"edge",
            "outV":"1:josh",
            "outVLabel":"person",
            "inV":"2:ripple",
            "inVLabel":"software",
            "properties":{
                "weight":1.1,
                "date":1522835200000
            }
        },
        {
            "id":"S1:marko>1>7JooBil0>S1:josh",
            "label":"knows",
            "type":"edge",
            "outV":"1:marko",
            "outVLabel":"person",
            "inV":"1:josh",
            "inVLabel":"person",
            "properties":{
                "weight":1.2,
                "date":1301289600000
            }
        }
    ]
}
```

#### 2.2.5 Deleting Edge Properties

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/graph/edges/S1:peter>1>>S2:lop?action=eliminate
```

##### Request Body

```json
{
    "properties": {
        "weight": 1.0
    }
}
```

> Note: This will directly delete the properties (removing the key and all values), regardless of whether the property values are single, set, or list.

##### Response Status

```json
200
```

##### Response Body

```json
{
    "id": "S1:peter>1>>S2:lop",
    "label": "created",
    "type": "edge",
    "inVLabel": "software",
    "outVLabel": "person",
    "inV": "2:lop",
    "outV": "1:peter",
    "properties": {
        "date": "20170324"
    }
}
```

#### 2.2.6 Fetching Edges that Match the Criteria

##### Params

- vertex_id: Vertex ID
- direction: Direction of the edge (OUT | IN | BOTH)
- label: Edge label
- properties: Key-value pairs of properties (previously indexed for property-based queries)
- offset: Offset, default is 0
- limit: Number of results to query, default is 100
- page: Page number

The supported query options are as follows:

- When the vertex_id parameter is provided, the page parameter cannot be used. The direction, label, and properties parameters are optional, while offset and limit can be used to restrict the result range.
- When the vertex_id parameter is not provided, the label and properties parameters are optional.
    - If the page parameter is used: the offset parameter is not available (either not provided or set to 0), the direction parameter is not available, and at most one property can be specified.
    - If the page parameter is not used: the offset and limit parameters can be used to restrict the result range, and the direction parameter is ignored.

Property key-value pairs consist of the attribute name and attribute value in JSON format. Multiple property key-value pairs are allowed as query conditions. The attribute value supports exact matching, range matching, and fuzzy matching. For exact matching, it is in the form `properties={"weight": 0.8}`. For range matching, it is in the form `properties={"age": "P.gt(0.8)"}`. For fuzzy matching, it is in the form `properties={"city": "P.textcontains("ChengDu China")}`. The supported expressions for range matching are as follows:

| Expression                            | Description                          |
| ------------------------------------ | ------------------------------------ |
| P.eq(number)                         | Edges with attribute value equal to `number`              |
| P.neq(number)                        | Edges with attribute value not equal to `number`             |
| P.lt(number)                         | Edges with attribute value less than `number`              |
| P.lte(number)                        | Edges with attribute value less than or equal to `number`            |
| P.gt(number)                         | Edges with attribute value greater than `number`              |
| P.gte(number)                        | Edges with attribute value greater than or equal to `number`            |
| P.between(number1, number2)          | Edges with attribute value greater than or equal to `number1` and less than `number2` |
| P.inside(number1, number2)           | Edges with attribute value greater than `number1` and less than `number2`   |
| P.outside(number1, number2)          | Edges with attribute value less than `number1` and greater than `number2`   |
| P.within(value1, value2, value3, ...) | Edges with attribute value equal to any of the given `values`         |

**Query for edges connected to vertex person:josh (vertex_id="1:josh") with label created**

##### Method & Url

```
GET http://127.0.0.1:8080/graphs/hugegraph/graph/edges?vertex_id="1:josh"&direction=BOTH&label=created&properties={}
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "edges": [
        {
            "id": "S1:josh>1>>S2:lop",
            "label": "created",
            "type": "edge",
            "inVLabel": "software",
            "outVLabel": "person",
            "inV": "2:lop",
            "outV": "1:josh",
            "properties": {
                "date": "20091111",
                "weight": 0.4
            }
        },
        {
            "id": "S1:josh>1>>S2:ripple",
            "label": "created",
            "type": "edge",
            "inVLabel": "software",
            "outVLabel": "person",
            "inV": "2:ripple",
            "outV": "1:josh",
            "properties": {
                "date": "20171210",
                "weight": 1
            }
        }
    ]
}
```

**Paginated query for all edges, fetching the first page (page without a parameter value), limited to 3 records**

##### Method & Url

```
GET http://127.0.0.1:8080/graphs/hugegraph/graph/edges?page&limit=3
```

##### Response Status

```json
200
```

##### Response Body

```json
{
	"edges": [{
			"id": "S1:peter>2>>S2:lop",
			"label": "created",
			"type": "edge",
			"inVLabel": "software",
			"outVLabel": "person",
			"inV": "2:lop",
			"outV": "1:peter",
			"properties": {
				"weight": 0.2,
				"date": "20170324"
			}
		},
		{
			"id": "S1:josh>2>>S2:lop",
			"label": "created",
			"type": "edge",
			"inVLabel": "software",
			"outVLabel": "person",
			"inV": "2:lop",
			"outV": "1:josh",
			"properties": {
				"weight": 0.4,
				"date": "20091111"
			}
		},
		{
			"id": "S1:josh>2>>S2:ripple",
			"label": "created",
			"type": "edge",
			"inVLabel": "software",
			"outVLabel": "person",
			"inV": "2:ripple",
			"outV": "1:josh",
			"properties": {
				"weight": 1,
				"date": "20171210"
			}
		}
	],
	"page": "002500100753313a6a6f73681210010004000000020953323a726970706c65f07ffffffcf07ffffffd8460d63f4b398dd2721ed4fdb7716b420004"
}
```

The returned body contains the information of the next page, `"page": "002500100753313a6a6f73681210010004000000020953323a726970706c65f07ffffffcf07ffffffd8460d63f4b398dd2721ed4fdb7716b420004"`. When querying the next page, assign this value to the page parameter.

**Paginated query for all edges, fetching the next page (page with the value returned from the previous page), limited to 3 records**

##### Method & Url

```
GET http://127.0.0.1:8080/graphs/hugegraph/graph/edges?page=002500100753313a6a6f73681210010004000000020953323a726970706c65f07ffffffcf07ffffffd8460d63f4b398dd2721ed4fdb7716b420004&limit=3
```

##### Response Status

```json
200
```

##### Response Body

```json
{
	"edges": [{
			"id": "S1:marko>1>20130220>S1:josh",
			"label": "knows",
			"type": "edge",
			"inVLabel": "person",
			"outVLabel": "person",
			"inV": "1:josh",
			"outV": "1:marko",
			"properties": {
				"weight": 1,
				"date": "20130220"
			}
		},
		{
			"id": "S1:marko>1>20160110>S1:vadas",
			"label": "knows",
			"type": "edge",
			"inVLabel": "person",
			"outVLabel": "person",
			"inV": "1:vadas",
			"outV": "1:marko",
			"properties": {
				"weight": 0.5,
				"date": "20160110"
			}
		},
		{
			"id": "S1:marko>2>>S2:lop",
			"label": "created",
			"type": "edge",
			"inVLabel": "software",
			"outVLabel": "person",
			"inV": "2:lop",
			"outV": "1:marko",
			"properties": {
				"weight": 0.4,
				"date": "20171210"
			}
		}
	],
	"page": null
}
```

When `"page": null` is returned, it indicates that there are no more pages available. (Note: When the backend is Cassandra, for performance considerations, if the returned page happens to be the last page, the `page` value may not be empty. When requesting the next page data using that `page` value, it will return `empty data` and `page = null`. Similar situations apply for other cases.)

#### 2.2.7 Fetching Edge by ID

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/graph/edges/S1:peter>1>>S2:lop
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "id": "S1:peter>1>>S2:lop",
    "label": "created",
    "type": "edge",
    "inVLabel": "software",
    "outVLabel": "person",
    "inV": "2:lop",
    "outV": "1:peter",
    "properties": {
        "date": "2017-5-18",
        "weight": 0.2
    }
}
```

#### 2.2.8 Deleting Edge by ID

##### Params

- label: Edge type, optional parameter

**Deleting Edge by ID only**

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/graph/edges/S1:peter>1>>S2:lop
```

##### Response Status

```json
204
```

**Deleting Edge by Label+ID**

In general, specifying the Label parameter along with the ID to delete an edge will provide better performance compared to deleting by ID only.

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/graph/edges/S1:peter>1>>S2:lop?label=person
```

##### Response Status

```json
204
```
