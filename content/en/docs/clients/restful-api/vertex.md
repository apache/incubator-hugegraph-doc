---
title: "Vertex API"
linkTitle: "Vertex"
weight: 7
---

### 2.1 Vertex

In vertex types, the Id strategy determines the type of the vertex Id, with the corresponding relationships as follows:

| Id_Strategy      | id type |
|------------------|---------|
| AUTOMATIC        | number  |
| PRIMARY_KEY      | string  |
| CUSTOMIZE_STRING | string  |
| CUSTOMIZE_NUMBER | number  |
| CUSTOMIZE_UUID   | uuid    |

For the `GET/PUT/DELETE` API of a vertex, the id part in the URL should be passed as the id value with type information. This type information is indicated by whether the JSON string is enclosed in quotes, meaning:

- When the id type is number, the id in the URL is without quotes, for example: xxx/vertices/123456.
- When the id type is string, the id in the URL is enclosed in quotes, for example: xxx/vertices/"123456".

-------------------------------------------------------------------

The following examples assume that the aforementioned schema information has been created.

#### 2.1.1 Create a vertex

##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/graph/vertices
```

##### Request Body

```json
{
    "label": "person",
    "properties": {
        "name": "marko",
        "age": 29
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
    "id": "1:marko",
    "label": "person",
    "type": "vertex",
    "properties": {
        "name": [
            {
                "id": "1:marko>name",
                "value": "marko"
            }
        ],
        "age": [
            {
                "id": "1:marko>age",
                "value": 29
            }
        ]
    }
}
```

#### 2.1.2 Create multiple vertices

##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/graph/vertices/batch
```

##### Request Body

```json
[
    {
        "label": "person",
        "properties": {
            "name": "marko",
            "age": 29
        }
    },
    {
        "label": "software",
        "properties": {
            "name": "ripple",
            "lang": "java",
            "price": 199
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
    "1:marko",
    "2:ripple"
]
```

#### 2.1.3 Update vertex properties

##### Method & Url

```
PUT http://127.0.0.1:8080/graphs/hugegraph/graph/vertices/"1:marko"?action=append
```

##### Request Body

```json
{
    "label": "person",
    "properties": {
        "age": 30,
        "city": "Beijing"
    }
}
```

> Note: There are three categories for property values: single, set, and list. If it is single, it means adding or updating the property value. If it is set or list, it means appending the property value.

##### Response Status

```json
200
```

##### Response Body

```json
{
    "id": "1:marko",
    "label": "person",
    "type": "vertex",
    "properties": {
        "city": [
            {
                "id": "1:marko>city",
                "value": "Beijing"
            }
        ],
        "name": [
            {
                "id": "1:marko>name",
                "value": "marko"
            }
        ],
        "age": [
            {
                "id": "1:marko>age",
                "value": 30
            }
        ]
    }
}
```

#### 2.1.4 Batch Update Vertex Properties

##### Function Description

Batch update properties of vertices and support various update strategies, including:

- SUM: Numeric accumulation
- BIGGER: Take the larger value between two numbers/dates
- SMALLER: Take the smaller value between two numbers/dates
- UNION: Take the union of set properties
- INTERSECTION: Take the intersection of set properties
- APPEND: Append elements to list properties
- ELIMINATE: Remove elements from list/set properties
- OVERRIDE: Override existing properties, if the new property is null, the old property is still used

Assuming the original vertex and properties are:

```json
{
    "vertices":[
        {
            "id":"2:lop",
            "label":"software",
            "type":"vertex",
            "properties":{
                "name":"lop",
                "lang":"java",
                "price":328
            }
        },
        {
            "id":"1:josh",
            "label":"person",
            "type":"vertex",
            "properties":{
                "name":"josh",
                "age":32,
                "city":"Beijing",
                "weight":0.1,
                "hobby":[
                    "reading",
                    "football"
                ]
            }
        }
    ]
}
```

##### Method & Url

```
PUT http://127.0.0.1:8080/graphs/hugegraph/graph/vertices/batch
```

##### Request Body

```json
{
    "vertices":[
        {
            "label":"software",
            "type":"vertex",
            "properties":{
                "name":"lop",
                "lang":"c++",
                "price":299
            }
        },
        {
            "label":"person",
            "type":"vertex",
            "properties":{
                "name":"josh",
                "city":"Shanghai",
                "weight":0.2,
                "hobby":[
                    "swiming"
                ]
            }
        }
    ],
    "update_strategies":{
        "price":"BIGGER",
        "age":"OVERRIDE",
        "city":"OVERRIDE",
        "weight":"SUM",
        "hobby":"UNION"
    },
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
    "vertices": [
        {
            "id": "2:lop",
            "label": "software",
            "type": "vertex",
            "properties": {
                "name": "lop",
                "lang": "c++",
                "price": 328
            }
        },
        {
            "id": "1:josh",
            "label": "person",
            "type": "vertex",
            "properties": {
                "name": "josh",
                "age": 32,
                "city": "Shanghai",
                "weight": 0.3,
                "hobby": [
                    "swiming",
                    "reading",
                    "football"
                ]
            }
        }
    ]
}
```

Result Analysis:

- The lang property does not specify an update strategy and is directly overwritten by the new value, regardless of whether the new value is null.
- The price property specifies the BIGGER update strategy. The old property value is 328, and the new property value is 299, so the old property value of 328 is retained.
- The age property specifies the OVERRIDE update strategy, but the new property value does not include age, which is equivalent to age being null. Therefore, the original property value of 32 is still retained.
- The city property also specifies the OVERRIDE update strategy, and the new property value is not null, so it overrides the old value.
- The weight property specifies the SUM update strategy. The old property value is 0.1, and the new property value is 0.2. The final value is 0.3.
- The hobby property (cardinality is Set) specifies the UNION update strategy, so the new value is taken as the union with the old value.

The usage of other update strategies can be inferred in a similar manner and will not be further elaborated.

#### 2.1.5 Delete Vertex Properties

##### Method & Url

```
PUT http://127.0.0.1:8080/graphs/hugegraph/graph/vertices/"1:marko"?action=eliminate
```

##### Request Body

```json
{
    "label": "person",
    "properties": {
        "city": "Beijing"
    }
}
```

> Note: Here, the properties (keys and all values) will be directly deleted, regardless of whether the property values are single, set, or list.

##### Response Status

```json
200
```

##### Response Body

```json
{
    "id": "1:marko",
    "label": "person",
    "type": "vertex",
    "properties": {
        "name": [
            {
                "id": "1:marko>name",
                "value": "marko"
            }
        ],
        "age": [
            {
                "id": "1:marko>age",
                "value": 30
            }
        ]
    }
}
```

#### 2.1.6 Get Vertices that Meet the Criteria

##### Params

- label: Vertex type
- properties: Property key-value pairs (precondition: indexes are created for property queries)
- limit: Maximum number of results
- page: Page number

All of the above parameters are optional. If the `page` parameter is provided, the `limit` parameter must also be provided, and no other parameters are allowed. `label, properties`, and `limit` can be combined in any way.

Property key-value pairs consist of the property name and value in JSON format. Multiple property key-value pairs are allowed as query conditions. The property value supports exact matching, range matching, and fuzzy matching. For exact matching, use the format `properties={"age":29}`, for range matching, use the format `properties={"age":"P.gt(29)"}`, and for fuzzy matching, use the format `properties={"city": "P.textcontains("ChengDu China")}`. The following expressions are supported for range matching:

| Expression                        | Explanation                                    |
|------------------------------------|---------------------------------------------|
| P.eq(number)                       | Vertices with property value equal to `number`         |
| P.neq(number)                      | Vertices with property value not equal to `number`     |
| P.lt(number)                       | Vertices with property value less than `number`         |
| P.lte(number)                      | Vertices with property value less than or equal to `number`   |
| P.gt(number)                       | Vertices with property value greater than `number`         |
| P.gte(number)                      | Vertices with property value greater than or equal to `number`   |
| P.between(number1,number2)         | Vertices with property value greater than or equal to `number1` and less than `number2`  |
| P.inside(number1,number2)          | Vertices with property value greater than `number1` and less than `number2`    |
| P.outside(number1,number2)         | Vertices with property value less than `number1` and greater than `number2`    |
| P.within(value1,value2,value3,...) | Vertices with property value equal to any of the given `values`     |

**Query all vertices with age 20 and label person**

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/graph/vertices?label=person&properties={"age":29}&limit=1
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "vertices": [
        {
            "id": "1:marko",
            "label": "person",
            "type": "vertex",
            "properties": {
                "city": [
                    {
                        "id": "1:marko>city",
                        "value": "Beijing"
                    }
                ],
                "name": [
                    {
                        "id": "1:marko>name",
                        "value": "marko"
                    }
                ],
                "age": [
                    {
                        "id": "1:marko>age",
                        "value": 29
                    }
                ]
            }
        }
    ]
}
```

**Paginate through all vertices, retrieve the first page (page without parameter value), limited to 3 records**

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/graph/vertices?page&limit=3
```

##### Response Status

```json
200
```

##### Response Body

```json
{
	"vertices": [{
			"id": "2:ripple",
			"label": "software",
			"type": "vertex",
			"properties": {
				"price": [{
					"id": "2:ripple>price",
					"value": 199
				}],
				"name": [{
					"id": "2:ripple>name",
					"value": "ripple"
				}],
				"lang": [{
					"id": "2:ripple>lang",
					"value": "java"
				}]
			}
		},
		{
			"id": "1:vadas",
			"label": "person",
			"type": "vertex",
			"properties": {
				"city": [{
					"id": "1:vadas>city",
					"value": "Hongkong"
				}],
				"name": [{
					"id": "1:vadas>name",
					"value": "vadas"
				}],
				"age": [{
					"id": "1:vadas>age",
					"value": 27
				}]
			}
		},
		{
			"id": "1:peter",
			"label": "person",
			"type": "vertex",
			"properties": {
				"city": [{
					"id": "1:peter>city",
					"value": "Shanghai"
				}],
				"name": [{
					"id": "1:peter>name",
					"value": "peter"
				}],
				"age": [{
					"id": "1:peter>age",
					"value": 35
				}]
			}
		}
	],
	"page": "001000100853313a706574657200f07ffffffc00e797c6349be736fffc8699e8a502efe10004"
}
```

The returned body contains information about the page number of the next page, `"page": "001000100853313a706574657200f07ffffffc00e797c6349be736fffc8699e8a502efe10004"`. When querying the next page, assign this value to the `page` parameter.

**Paginate and retrieve all vertices, including the next page (passing the `page` value returned from the previous page), limited to 3 items.**

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/graph/vertices?page=001000100853313a706574657200f07ffffffc00e797c6349be736fffc8699e8a502efe10004&limit=3
```

##### Response Status

```json
200
```

##### Response Body

```json
{
	"vertices": [{
			"id": "1:josh",
			"label": "person",
			"type": "vertex",
			"properties": {
				"city": [{
					"id": "1:josh>city",
					"value": "Beijing"
				}],
				"name": [{
					"id": "1:josh>name",
					"value": "josh"
				}],
				"age": [{
					"id": "1:josh>age",
					"value": 32
				}]
			}
		},
		{
			"id": "1:marko",
			"label": "person",
			"type": "vertex",
			"properties": {
				"city": [{
					"id": "1:marko>city",
					"value": "Beijing"
				}],
				"name": [{
					"id": "1:marko>name",
					"value": "marko"
				}],
				"age": [{
					"id": "1:marko>age",
					"value": 29
				}]
			}
		},
		{
			"id": "2:lop",
			"label": "software",
			"type": "vertex",
			"properties": {
				"price": [{
					"id": "2:lop>price",
					"value": 328
				}],
				"name": [{
					"id": "2:lop>name",
					"value": "lop"
				}],
				"lang": [{
					"id": "2:lop>lang",
					"value": "java"
				}]
			}
		}
	],
	"page": null
}
```

At this point, `"page": null` indicates that there are no more pages available. (Note: When using Cassandra as the backend for performance reasons, if the returned page happens to be the last page, the `page` value may not be empty. When requesting the next page using that `page` value, it will return `empty data` and `page = null`. The same applies to other similar situations.)

#### 2.1.7 Retrieve Vertex by ID

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/graph/vertices/"1:marko"
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "id": "1:marko",
    "label": "person",
    "type": "vertex",
    "properties": {
        "name": [
            {
                "id": "1:marko>name",
                "value": "marko"
            }
        ],
        "age": [
            {
                "id": "1:marko>age",
                "value": 29
            }
        ]
    }
}
```

#### 2.1.8 Delete Vertex by ID

##### Params

- label: Vertex type, optional parameter

**Delete the vertex based on ID only.**

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/graph/vertices/"1:marko"
```

##### Response Status

```json
204
```

**Delete Vertex by Label+ID**

When deleting a vertex by specifying both the Label parameter and the ID, it generally offers better performance compared to deleting by ID alone.

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/graph/vertices/"1:marko"?label=person
```

##### Response Status
```json
204
```
