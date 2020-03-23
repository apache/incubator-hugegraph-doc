### 3.1 traverser API概述

HugeGraphServer为HugeGraph图数据库提供了RESTful API接口。除了顶点和边的CRUD基本操作以外，还提供了一些遍历（traverser）方法，我们称为`traverser API`。这些遍历方法实现了一些复杂的图算法，方便用户对图进行分析和挖掘。

HugeGraph支持的traverser API包括：

- K-out API，根据起始顶点，查找恰好N步可达的邻居
- K-neighbor API，根据起始顶点，查找N步以内可达的所有邻居
- Shortest Path API，查找两个顶点之间的最短路径
- Paths API，查找两个顶点间的全部路径
- Customized Paths API，从一批顶点出发，按（一种）模式遍历经过的全部路径
- Crosspoints API，查找两个顶点的交点（共同祖先或者共同子孙）
- Customized Crosspoints API，从一批顶点出发，按多种模式遍历，最后一步到达的顶点的交点
- Rings API，从起始顶点出发，可到达的环路路径
- Rays API，从起始顶点出发，可到达边界的路径（即无环路径）
- Vertices API
	- 按ID批量查询顶点；
	- 获取顶点的分区；
	- 按分区查询顶点；
- Edges API
	- 按ID批量查询边；
	- 获取边的分区；
	- 按分区查询边；

### 3.2. traverser API详解

使用方法中的例子，都是基于TinkerPop官网给出的图：

![tinkerpop示例图](http://tinkerpop.apache.org/docs/3.4.0/images/tinkerpop-modern.png)

数据导入程序如下：

```java
public class Loader {
    public static void main(String[] args) {
        HugeClient client = new HugeClient("http://127.0.0.1:8080", "hugegraph");
        SchemaManager schema = client.schema();
        schema.propertyKey("name").asText().ifNotExist().create();
        schema.propertyKey("age").asInt().ifNotExist().create();
        schema.propertyKey("city").asText().ifNotExist().create();
        schema.propertyKey("weight").asDouble().ifNotExist().create();
        schema.propertyKey("lang").asText().ifNotExist().create();
        schema.propertyKey("date").asText().ifNotExist().create();
        schema.propertyKey("price").asInt().ifNotExist().create();

        schema.vertexLabel("person")
              .properties("name", "age", "city")
              .primaryKeys("name")
              .nullableKeys("age")
              .ifNotExist()
              .create();

        schema.vertexLabel("software")
              .properties("name", "lang", "price")
              .primaryKeys("name")
              .nullableKeys("price")
              .ifNotExist()
              .create();

        schema.indexLabel("personByCity")
              .onV("person")
              .by("city")
              .secondary()
              .ifNotExist()
              .create();

        schema.indexLabel("personByAgeAndCity")
              .onV("person")
              .by("age", "city")
              .secondary()
              .ifNotExist()
              .create();

        schema.indexLabel("softwareByPrice")
              .onV("software")
              .by("price")
              .range()
              .ifNotExist()
              .create();

        schema.edgeLabel("knows")
              .multiTimes()
              .sourceLabel("person")
              .targetLabel("person")
              .properties("date", "weight")
              .sortKeys("date")
              .nullableKeys("weight")
              .ifNotExist()
              .create();

        schema.edgeLabel("created")
              .sourceLabel("person").targetLabel("software")
              .properties("date", "weight")
              .nullableKeys("weight")
              .ifNotExist()
              .create();

        schema.indexLabel("createdByDate")
              .onE("created")
              .by("date")
              .secondary()
              .ifNotExist()
              .create();

        schema.indexLabel("createdByWeight")
              .onE("created")
              .by("weight")
              .range()
              .ifNotExist()
              .create();

        schema.indexLabel("knowsByWeight")
              .onE("knows")
              .by("weight")
              .range()
              .ifNotExist()
              .create();

        GraphManager graph = client.graph();
        Vertex marko = graph.addVertex(T.label, "person", "name", "marko",
                                       "age", 29, "city", "Beijing");
        Vertex vadas = graph.addVertex(T.label, "person", "name", "vadas",
                                       "age", 27, "city", "Hongkong");
        Vertex lop = graph.addVertex(T.label, "software", "name", "lop",
                                     "lang", "java", "price", 328);
        Vertex josh = graph.addVertex(T.label, "person", "name", "josh",
                                      "age", 32, "city", "Beijing");
        Vertex ripple = graph.addVertex(T.label, "software", "name", "ripple",
                                        "lang", "java", "price", 199);
        Vertex peter = graph.addVertex(T.label, "person", "name", "peter",
                                       "age", 35, "city", "Shanghai");

        marko.addEdge("knows", vadas, "date", "20160110", "weight", 0.5);
        marko.addEdge("knows", josh, "date", "20130220", "weight", 1.0);
        marko.addEdge("created", lop, "date", "20171210", "weight", 0.4);
        josh.addEdge("created", lop, "date", "20091111", "weight", 0.4);
        josh.addEdge("created", ripple, "date", "20171210", "weight", 1.0);
        peter.addEdge("created", lop, "date", "20170324", "weight", 0.2);
    }
}
```

顶点ID为：

```
"2:ripple",
"1:vadas",
"1:peter",
"1:josh",
"1:marko",
"2:lop"
```

边ID为：

```
"S1:peter>2>>S2:lop",
"S1:josh>2>>S2:lop",
"S1:josh>2>>S2:ripple",
"S1:marko>1>20130220>S1:josh",
"S1:marko>1>20160110>S1:vadas",
"S1:marko>2>>S2:lop"
```

#### 3.2.1 K-out API

##### 3.2.1.1 功能介绍

根据起始顶点、方向、边的类型（可选）和深度depth，查找从起始顶点出发恰好depth步可达的顶点

###### Params

- source: 起始顶点id，必填项
- direction: 起始顶点向外发散的方向（OUT,IN,BOTH），选填项，默认是BOTH
- max_depth: 步数，必填项
- label: 边的类型，选填项，默认代表所有edge label
- nearest: nearest为true时，代表起始顶点到达结果顶点的最短路径长度为depth，不存在更短的路径；nearest为false时，代表起始顶点到结果顶点有一条长度为depth的路径（未必最短且可以有环），选填项，默认为true
- max_degree: 查询过程中，单个顶点最大边数目，选填项，默认为10000
- capacity: 遍历过程中最大的访问的顶点数目，选填项，默认为10000000
- limit: 返回的顶点的最大数目，选填项，默认为10000000

##### 3.2.1.2 使用方法

###### Method & Url

```
GET http://localhost:8080/graphs/{graph}/traversers/kout?source="1:marko"&max_depth=2
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "vertices":[
        "2:ripple",
        "1:peter"
    ]
}
```

##### 3.2.1.3 适用场景

查找恰好N步关系可达的顶点。两个例子：

- 家族关系中，查找一个人的所有孙子，person A通过连续的两条“儿子”边到达的顶点集合。
- 社交关系中发现潜在好友，例如：与目标用户相隔两层朋友关系的用户，可以通过连续两条“朋友”边到达的顶点。

#### 3.2.2 K-neighbor

##### 3.2.2.1 功能介绍

根据起始顶点、方向、边的类型（可选）和深度depth，查找包括起始顶点在内、depth步之内可达的所有顶点

> 相当于：起始顶点、K-out(1)、K-out(2)、... 、K-out(max_depth)的并集

###### Params

- source: 起始顶点id，必填项
- direction: 起始顶点向外发散的方向（OUT,IN,BOTH），选填项，默认是BOTH
- max_depth: 步数，必填项
- label: 边的类型，选填项，默认代表所有edge label
- max_degree: 查询过程中，单个顶点最大边数目，选填项，默认为10000
- limit: 返回的顶点的最大数目，也即遍历过程中最大的访问的顶点数目，选填项，默认为10000000

##### 3.2.2.2 使用方法

###### Method & Url

```
GET http://localhost:8080/graphs/{graph}/traversers/kneighbor?source=“1:marko”&max_depth=2
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "vertices":[
        "2:ripple",
        "1:marko",
        "1:josh",
        "1:vadas",
        "1:peter",
        "2:lop"
    ]
}
```

##### 3.2.2.3 适用场景

查找N步以内可达的所有顶点，例如：

- 家族关系中，查找一个人五服以内所有子孙，person A通过连续的5条“亲子”边到达的顶点集合。
- 社交关系中发现好友圈子，例如目标用户通过1条、2条、3条“朋友”边可到达的用户可以组成目标用户的朋友圈子

#### 3.2.3 Shortest Path

##### 3.2.3.1 功能介绍

根据起始顶点、目的顶点、方向、边的类型（可选）和最大深度，查找一条最短路径

###### Params

- source: 起始顶点id，必填项
- target: 目的顶点id，必填项
- direction: 起始顶点向外发散的方向（OUT,IN,BOTH），选填项，默认是BOTH
- max_depth: 最大步数，必填项
- label: 边的类型，选填项，默认代表所有edge label
- max_degree: 查询过程中，单个顶点最大边数目，选填项，默认为10000
- skip_degree: 查询过程中需要跳过的顶点的最小的边数目，即当顶点的边数目大于 skip_degree 时，跳过该顶点，可用于规避超级点，选填项，默认为0，表示不跳过任何点
- capacity: 遍历过程中最大的访问的顶点数目，选填项，默认为10000000

##### 3.2.3.2 使用方法

###### Method & Url

```
GET http://localhost:8080/graphs/{graph}/traversers/shortestpath?source="1:marko"&target="2:ripple"&max_depth=3
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "path":[
        "1:marko",
        "1:josh",
        "2:ripple"
    ]
}
```

##### 3.2.3.3 适用场景

查找两个顶点间的最短路径，例如：

- 社交关系网中，查找两个用户有关系的最短路径，即最近的朋友关系链
- 设备关联网络中，查找两个设备最短的关联关系

#### 3.2.4 Paths

##### 3.2.4.1 功能介绍

根据起始顶点、目的顶点、方向、边的类型（可选）和最大深度等条件查找所有路径

###### Params

- source: 起始顶点id，必填项
- target: 目的顶点id，必填项
- direction: 起始顶点向外发散的方向（OUT,IN,BOTH），选填项，默认是BOTH
- label: 边的类型，选填项，默认代表所有edge label
- max_depth: 步数，必填项
- max_degree: 查询过程中，单个顶点最大边数目，选填项，默认为10000
- capacity: 遍历过程中最大的访问的顶点数目，选填项，默认为10000000
- limit: 返回的路径的最大数目，选填项，默认为10

##### 3.2.4.2 使用方法

###### Method & Url

```
GET http://localhost:8080/graphs/{graph}/traversers/paths?source="1:marko"&target="1:josh"&max_depth=5
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "paths":[
        {
            "objects":[
                "1:marko",
                "1:josh"
            ]
        },
        {
            "objects":[
                "1:marko",
                "2:lop",
                "1:josh"
            ]
        }
    ]
}
```

##### 3.2.4.3 适用场景

查找两个顶点间的所有路径，例如：

- 社交网络中，查找两个用户所有可能的关系路径
- 设备关联网络中，查找两个设备之间所有的关联路径

#### 3.2.5 Crosspoints

##### 3.2.5.1 功能介绍

根据起始顶点、目的顶点、方向、边的类型（可选）和最大深度等条件查找相交点

###### Params

- source: 起始顶点id，必填项
- target: 目的顶点id，必填项
- direction: 起始顶点到目的顶点的方向, 目的点到起始点是反方向，BOTH时不考虑方向（OUT,IN,BOTH），选填项，默认是BOTH
- label: 边的类型，选填项，默认代表所有edge label
- max_depth: 步数，必填项
- max_degree: 查询过程中，单个顶点最大边数目，选填项，默认为10000
- capacity: 遍历过程中最大的访问的顶点数目，选填项，默认为10000000
- limit: 返回的交点的最大数目，选填项，默认为10

##### 3.2.5.2 使用方法

###### Method & Url

```
GET http://localhost:8080/graphs/{graph}/traversers/crosspoints?source="2:lop"&target="2:ripple"&max_depth=5&direction=IN
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "crosspoints":[
        {
            "crosspoint":"1:josh",
            "objects":[
                "2:lop",
                "1:josh",
                "2:ripple"
            ]
        }
    ]
}
```

##### 3.2.5.3 适用场景

查找两个顶点的交点及其路径，例如：

- 社交网络中，查找两个用户共同关注的话题或者大V
- 家族关系中，查找共同的祖先

#### 3.2.6 Rings

##### 3.2.6.1 功能介绍

根据起始顶点、方向、边的类型（可选）和最大深度等条件查找可达的环路

例如: 1 -> 25 -> 775 -> 14690 -> 25, 其中环路为 25 -> 775 -> 14690 -> 25

###### Params

- source: 起始顶点id，必填项
- direction: 起始顶点发出的边的方向（OUT,IN,BOTH），选填项，默认是BOTH
- label: 边的类型，选填项，默认代表所有edge label
- max_depth: 步数，必填项
- source_in_ring: 环路是否包含起点，选填项，默认为true
- max_degree: 查询过程中，单个顶点最大边数目，选填项，默认为10000
- capacity: 遍历过程中最大的访问的顶点数目，选填项，默认为10000000
- limit: 返回的可达环路的最大数目，选填项，默认为10

##### 3.2.6.2 使用方法

###### Method & Url

```
GET http://localhost:8080/graphs/{graph}/traversers/rings?source="1:marko"&max_depth=2
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "rings":[
        {
            "objects":[
                "1:marko",
                "1:josh",
                "1:marko"
            ]
        },
        {
            "objects":[
                "1:marko",
                "1:vadas",
                "1:marko"
            ]
        },
        {
            "objects":[
                "1:marko",
                "2:lop",
                "1:marko"
            ]
        }
    ]
}
```

##### 3.2.6.3 适用场景

查询起始顶点可达的环路，例如：

- 风控项目中，查询一个用户可达的循环担保的人或者设备
- 设备关联网络中，发现一个设备周围的循环引用的设备

#### 3.2.7 Rays

##### 3.2.7.1 功能介绍

根据起始顶点、方向、边的类型（可选）和最大深度等条件查找发散到边界顶点的路径

例如: 1 -> 25 -> 775 -> 14690 -> 2289 -> 18379, 其中 18379 为边界顶点，即没有从 18379 发出的边

###### Params

- source: 起始顶点id，必填项
- direction: 起始顶点发出的边的方向（OUT,IN,BOTH），选填项，默认是BOTH
- label: 边的类型，选填项，默认代表所有edge label
- max_depth: 步数，必填项
- max_degree: 查询过程中，单个顶点最大边数目，选填项，默认为10000
- capacity: 遍历过程中最大的访问的顶点数目，选填项，默认为10000000
- limit: 返回的非环路的最大数目，选填项，默认为10

##### 3.2.7.2 使用方法

###### Method & Url

```
GET http://localhost:8080/graphs/{graph}/traversers/rays?source="1:marko"&max_depth=2&direction=OUT
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "rays":[
        {
            "objects":[
                "1:marko",
                "1:vadas"
            ]
        },
        {
            "objects":[
                "1:marko",
                "2:lop"
            ]
        },
        {
            "objects":[
                "1:marko",
                "1:josh",
                "2:ripple"
            ]
        },
        {
            "objects":[
                "1:marko",
                "1:josh",
                "2:lop"
            ]
        }
    ]
}
```

##### 3.2.7.3 适用场景

查找起始顶点到某种关系的边界顶点的路径，例如：

- 家族关系中，查找一个人到所有还没有孩子的子孙的路径
- 设备关联网络中，找到某个设备到终端设备的路径

#### 3.2.8 Customized Paths

##### 3.2.8.1 功能介绍

根据一批起始顶点、边规则（包括方向、边的类型和属性过滤）和最大深度等条件查找符合条件的所有的路径

###### Params

- sources: 定义起始顶点，必填项，指定方式包括：
	- ids：通过顶点id列表提供起始顶点
	- labels和properties：如果没有指定ids，则使用label和properties的联合条件查询起始顶点
		- labels：顶点的类型列表
		- properties：通过属性的值查询起始顶点
		> 注意：properties中的属性值可以是列表，表示只要key对应的value在列表中就可以

- steps: 表示从起始顶点走过的路径规则，是一组Step的列表。必填项。每个Step的结构如下：
	- direction：表示边的方向（OUT,IN,BOTH），默认是BOTH
	- labels：边的类型列表
	- properties：通过属性的值过滤边
	- weight_by：根据指定的属性计算边的权重，sort_by不为NONE时有效，与default_weight互斥
	- default_weight：当边没有属性作为权重计算值时，采取的默认权重，sort_by不为NONE时有效，与weight_by互斥
	- degree：查询过程中，单个顶点最大边数目，默认为10000
	- sample：当需要对某个step的符合条件的边进行采样时设置，-1表示不采样，默认为采样100
- sort_by: 根据路径的权重排序，选填项，默认为 NONE：
	- NONE表示不排序，默认值
	- INCR表示按照路径权重的升序排序
	- DECR表示按照路径权重的降序排序
- capacity: 遍历过程中最大的访问的顶点数目，选填项，默认为10000000
- limit: 返回的路径的最大数目，选填项，默认为10
- with_vertex：true表示返回结果包含完整的顶点信息（路径中的全部顶点），false时表示只返回顶点id，选填项，默认为 false

##### 3.2.8.2 使用方法

###### Method & Url

```
POST http://localhost:8080/graphs/{graph}/traversers/customizedpaths
```

###### Request Body

```json
{
    "sources":{
        "ids":[

        ],
        "label":"person",
        "properties":{
            "name":"marko"
        }
    },
    "steps":[
        {
            "direction":"OUT",
            "labels":[
                "knows"
            ],
            "weight_by":"weight",
            "degree":-1
        },
        {
            "direction":"OUT",
            "labels":[
                "created"
            ],
            "default_weight":8,
            "degree":-1,
            "sample":1
        }
    ],
    "sort_by":"INCR",
    "with_vertex":true,
    "capacity":-1,
    "limit":-1
}
```

###### Response Status

```json
201
```

###### Response Body

```json
{
    "paths":[
        {
            "objects":[
                "1:marko",
                "1:josh",
                "2:lop"
            ],
            "weights":[
                1,
                8
            ]
        }
    ],
    "vertices":[
        {
            "id":"1:marko",
            "label":"person",
            "type":"vertex",
            "properties":{
                "city":[
                    {
                        "id":"1:marko>city",
                        "value":"Beijing"
                    }
                ],
                "name":[
                    {
                        "id":"1:marko>name",
                        "value":"marko"
                    }
                ],
                "age":[
                    {
                        "id":"1:marko>age",
                        "value":29
                    }
                ]
            }
        },
        {
            "id":"1:josh",
            "label":"person",
            "type":"vertex",
            "properties":{
                "city":[
                    {
                        "id":"1:josh>city",
                        "value":"Beijing"
                    }
                ],
                "name":[
                    {
                        "id":"1:josh>name",
                        "value":"josh"
                    }
                ],
                "age":[
                    {
                        "id":"1:josh>age",
                        "value":32
                    }
                ]
            }
        },
        {
            "id":"2:lop",
            "label":"software",
            "type":"vertex",
            "properties":{
                "price":[
                    {
                        "id":"2:lop>price",
                        "value":328
                    }
                ],
                "name":[
                    {
                        "id":"2:lop>name",
                        "value":"lop"
                    }
                ],
                "lang":[
                    {
                        "id":"2:lop>lang",
                        "value":"java"
                    }
                ]
            }
        }
    ]
}
```

##### 3.2.8.3 适用场景

适合查找各种复杂的路径集合，例如：

- 社交网络中，查找看过张艺谋所导演的电影的用户关注的大V的路径（张艺谋--->电影---->用户--->大V）
- 风控网络中，查找多个高风险用户的直系亲属的朋友的路径（高风险用户--->直系亲属--->朋友）

#### 3.2.9 Customized Crosspoints

##### 3.2.9.1 功能介绍

根据一批起始顶点、多种边规则（包括方向、边的类型和属性过滤）和最大深度等条件查找符合条件的所有的路径终点的交集

###### Params

- sources: 定义起始顶点，必填项，指定方式包括：
	- ids：通过顶点id列表提供起始顶点
	- labels和properties：如果没有指定ids，则使用label和properties的联合条件查询起始顶点
		- labels：顶点的类型列表
		- properties：通过属性的值查询起始顶点
		> 注意：properties中的属性值可以是列表，表示只要key对应的value在列表中就可以

- path_patterns: 表示从起始顶点走过的路径规则，是一组规则的列表。必填项。每个规则是一个PathPattern
	- 每个PathPattern是一组Step列表，每个Step结构如下：
		- direction：表示边的方向（OUT,IN,BOTH），默认是BOTH
		- labels：边的类型列表
		- properties：通过属性的值过滤边
		- degree：查询过程中，单个顶点最大边数目，默认为10000
- capacity: 遍历过程中最大的访问的顶点数目，选填项，默认为10000000
- limit: 返回的路径的最大数目，选填项，默认为10
- with_path：true表示返回交点所在的路径，false表示不返回交点所在的路径，选填项，默认为 false
- with_vertex，选填项，默认为 false：
	-  true表示返回结果包含完整的顶点信息（路径中的全部顶点）
		- with_path为true时，返回所有路径中的顶点的完整信息
		- with_path为false时，返回所有交点的完整信息
	- false时表示只返回顶点id

##### 3.2.9.2 使用方法

###### Method & Url

```
POST http://localhost:8080/graphs/{graph}/traversers/customizedcrosspoints
```

###### Request Body

```json
{
    "sources":{
        "ids":[
            "2:lop",
            "2:ripple"
        ]
    },
    "path_patterns":[
        {
            "steps":[
                {
                    "direction":"IN",
                    "labels":[
                        "created"
                    ],
                    "degree":-1
                }
            ]
        }
    ],
    "with_path":true,
    "with_vertex":true,
    "capacity":-1,
    "limit":-1
}
```

###### Response Status

```json
201
```

###### Response Body

```json
{
    "crosspoints":[
        "1:josh"
    ],
    "paths":[
        {
            "objects":[
                "2:ripple",
                "1:josh"
            ]
        },
        {
            "objects":[
                "2:lop",
                "1:josh"
            ]
        }
    ],
    "vertices":[
        {
            "id":"2:ripple",
            "label":"software",
            "type":"vertex",
            "properties":{
                "price":[
                    {
                        "id":"2:ripple>price",
                        "value":199
                    }
                ],
                "name":[
                    {
                        "id":"2:ripple>name",
                        "value":"ripple"
                    }
                ],
                "lang":[
                    {
                        "id":"2:ripple>lang",
                        "value":"java"
                    }
                ]
            }
        },
        {
            "id":"1:josh",
            "label":"person",
            "type":"vertex",
            "properties":{
                "city":[
                    {
                        "id":"1:josh>city",
                        "value":"Beijing"
                    }
                ],
                "name":[
                    {
                        "id":"1:josh>name",
                        "value":"josh"
                    }
                ],
                "age":[
                    {
                        "id":"1:josh>age",
                        "value":32
                    }
                ]
            }
        },
        {
            "id":"2:lop",
            "label":"software",
            "type":"vertex",
            "properties":{
                "price":[
                    {
                        "id":"2:lop>price",
                        "value":328
                    }
                ],
                "name":[
                    {
                        "id":"2:lop>name",
                        "value":"lop"
                    }
                ],
                "lang":[
                    {
                        "id":"2:lop>lang",
                        "value":"java"
                    }
                ]
            }
        }
    ]
}
```

##### 3.2.9.3 适用场景

查询一组顶点通过多种路径在终点有交集的情况。例如：

- 在商品图谱中，多款手机、学习机、游戏机通过不同的低级别的类目路径，最终都属于一级类目的电子设备

#### 3.2.10 Fusiform Similarity

##### 3.2.10.1 功能介绍

按照条件查询一批顶点对应的"梭形相似点"。当两个顶点跟很多共同的顶点之间有某种关系的时候，我们认为这两个点为"梭形相似点"。举个例子说明"梭形相似点"："读者A"读了100本书，可以定义读过这100本书中的80本以上的读者，是"读者A"的"梭形相似点"

###### Params

- sources: 定义起始顶点，必填项，指定方式包括：
	- ids：通过顶点id列表提供起始顶点
	- labels和properties：如果没有指定ids，则使用label和properties的联合条件查询起始顶点
		- labels：顶点的类型列表
		- properties：通过属性的值查询起始顶点
		> 注意：properties中的属性值可以是列表，表示只要key对应的value在列表中就可以

- label: 边的类型，选填项，默认代表所有edge label
- direction: 起始顶点向外发散的方向（OUT,IN,BOTH），选填项，默认是BOTH
- min_neighbors: 最少邻居数目，邻居数目少于这个阈值时，认为起点不具备"梭形相似点"。比如想要找一个"读者A"读过的书的"梭形相似点"，那么`min_neighbors`为100时，表示"读者A"至少要读过100本书才可以有"梭形相似点"，必填项
- alpha: 相似度，代表：起点与"梭形相似点"的共同邻居数目占起点的全部邻居数目的比例，必填项
- min_similars: "梭形相似点"的最少个数，只有当起点的"梭形相似点"数目大于或等于该值时，才会返回起点及其"梭形相似点"，选填项，默认值为1
- top: 返回一个起点的"梭形相似点"中相似度最高的top个，必填项，0表示全部
- group_property: 与`min_groups`一起使用，当起点跟其所有的"梭形相似点"某个属性的值有至少`min_groups`个不同值时，才会返回该起点及其"梭形相似点"。比如为"读者A"推荐"异地"书友时，需要设置`group_property`为读者的"城市"属性，`min_group`至少为2，选填项，不填代表不需要根据属性过滤
- min_groups: 与`group_property`一起使用，只有`group_property`设置时才有意义
- max_degree: 查询过程中，单个顶点最大边数目，选填项，默认为10000
- capacity: 遍历过程中最大的访问的顶点数目，选填项，默认为10000000
- limit: 返回的结果数目上限（一个起点及其"梭形相似点"算一个结果），选填项，默认为10
- with_intermediary: 是否返回起点及其"梭形相似点"共同关联的中间点，默认为false
- with_vertex，选填项，默认为 false：
	- true表示返回结果包含完整的顶点信息
	- false时表示只返回顶点id

##### 3.2.10.2 使用方法

###### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/traversers/fusiformsimilarity
```

###### Request Body

```json
{
    "sources":{
        "ids":[],
        "label": "person",
        "properties": {
            "name":"p1"
        }
    },
    "label":"read",
    "direction":"OUT",
    "min_neighbors":8,
    "alpha":0.75,
    "min_similars":1,
    "top":0,
    "group_property":"city",
    "min_group":2,
    "degree": 10000,
    "capacity": -1,
    "limit": -1,
    "with_intermediary": false,
    "with_vertex":true
}

```

###### Response Status

```json
201
```

###### Response Body

```json
{
    "similars": {
        "3:p1": [
            {
                "id": "3:p2",
                "score": 0.8888888888888888,
                "intermediaries": [
                ]
            },
            {
                "id": "3:p3",
                "score": 0.7777777777777778,
                "intermediaries": [
                ]
            }
        ]
    },
    "vertices": [
        {
            "id": "3:p1",
            "label": "person",
            "type": "vertex",
            "properties": {
                "name": "p1",
                "city": "Beijing"
            }
        },
        {
            "id": "3:p2",
            "label": "person",
            "type": "vertex",
            "properties": {
                "name": "p2",
                "city": "Shanghai"
            }
        },
        {
            "id": "3:p3",
            "label": "person",
            "type": "vertex",
            "properties": {
                "name": "p3",
                "city": "Beijing"
            }
        }
    ]
}
```

##### 3.2.10.3 适用场景

查询一组顶点相似度很高的顶点。例如：

- 跟一个读者有类似书单的读者
- 跟一个玩家玩类似游戏的玩家

#### 3.2.11 Vertices

##### 3.2.11.1 根据顶点的id列表，批量查询顶点

###### Params

- ids: 要查询的顶点id列表

###### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/vertices?ids="1:marko"&ids="2:lop"
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "vertices":[
        {
            "id":"1:marko",
            "label":"person",
            "type":"vertex",
            "properties":{
                "city":[
                    {
                        "id":"1:marko>city",
                        "value":"Beijing"
                    }
                ],
                "name":[
                    {
                        "id":"1:marko>name",
                        "value":"marko"
                    }
                ],
                "age":[
                    {
                        "id":"1:marko>age",
                        "value":29
                    }
                ]
            }
        },
        {
            "id":"2:lop",
            "label":"software",
            "type":"vertex",
            "properties":{
                "price":[
                    {
                        "id":"2:lop>price",
                        "value":328
                    }
                ],
                "name":[
                    {
                        "id":"2:lop>name",
                        "value":"lop"
                    }
                ],
                "lang":[
                    {
                        "id":"2:lop>lang",
                        "value":"java"
                    }
                ]
            }
        }
    ]
}
```

##### 3.2.11.2 获取顶点 Shard 信息

通过指定的分片大小split_size，获取顶点分片信息（可以与 3.2.10.3 中的 Scan 配合使用来获取顶点）。

###### Params

- split_size: 分片大小，必填项

###### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/vertices/shards?split_size=67108864
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "shards":[
        {
            "start": "0",
            "end": "2165893",
            "length": 0
        },
        {
            "start": "2165893",
            "end": "4331786",
            "length": 0
        },
        {
            "start": "4331786",
            "end": "6497679",
            "length": 0
        },
        {
            "start": "6497679",
            "end": "8663572",
            "length": 0
        },
        ......
    ]
}
```

##### 3.2.11.3 根据Shard信息批量获取顶点

通过指定的分片信息批量查询顶点（Shard信息的获取参见 3.2.10.2 Shard）。

###### Params

- start: 分片起始位置，必填项
- end: 分片结束位置，必填项
- page：分页位置，选填项，默认为null，不分页；当page为“”时表示分页的第一页，从start指示的位置开始
- page_limit：分页获取顶点时，一页中顶点数目的上限，选填项，默认为 100000

###### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/vertices/scan?start=0&end=4294967295
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "vertices":[
        {
            "id":"2:ripple",
            "label":"software",
            "type":"vertex",
            "properties":{
                "price":[
                    {
                        "id":"2:ripple>price",
                        "value":199
                    }
                ],
                "name":[
                    {
                        "id":"2:ripple>name",
                        "value":"ripple"
                    }
                ],
                "lang":[
                    {
                        "id":"2:ripple>lang",
                        "value":"java"
                    }
                ]
            }
        },
        {
            "id":"1:vadas",
            "label":"person",
            "type":"vertex",
            "properties":{
                "city":[
                    {
                        "id":"1:vadas>city",
                        "value":"Hongkong"
                    }
                ],
                "name":[
                    {
                        "id":"1:vadas>name",
                        "value":"vadas"
                    }
                ],
                "age":[
                    {
                        "id":"1:vadas>age",
                        "value":27
                    }
                ]
            }
        },
        {
            "id":"1:peter",
            "label":"person",
            "type":"vertex",
            "properties":{
                "city":[
                    {
                        "id":"1:peter>city",
                        "value":"Shanghai"
                    }
                ],
                "name":[
                    {
                        "id":"1:peter>name",
                        "value":"peter"
                    }
                ],
                "age":[
                    {
                        "id":"1:peter>age",
                        "value":35
                    }
                ]
            }
        },
        {
            "id":"1:josh",
            "label":"person",
            "type":"vertex",
            "properties":{
                "city":[
                    {
                        "id":"1:josh>city",
                        "value":"Beijing"
                    }
                ],
                "name":[
                    {
                        "id":"1:josh>name",
                        "value":"josh"
                    }
                ],
                "age":[
                    {
                        "id":"1:josh>age",
                        "value":32
                    }
                ]
            }
        },
        {
            "id":"1:marko",
            "label":"person",
            "type":"vertex",
            "properties":{
                "city":[
                    {
                        "id":"1:marko>city",
                        "value":"Beijing"
                    }
                ],
                "name":[
                    {
                        "id":"1:marko>name",
                        "value":"marko"
                    }
                ],
                "age":[
                    {
                        "id":"1:marko>age",
                        "value":29
                    }
                ]
            }
        },
        {
            "id":"2:lop",
            "label":"software",
            "type":"vertex",
            "properties":{
                "price":[
                    {
                        "id":"2:lop>price",
                        "value":328
                    }
                ],
                "name":[
                    {
                        "id":"2:lop>name",
                        "value":"lop"
                    }
                ],
                "lang":[
                    {
                        "id":"2:lop>lang",
                        "value":"java"
                    }
                ]
            }
        }
    ]
}
```

##### 3.2.11.4 适用场景

- 按id列表查询顶点，可用于批量查询顶点，比如在path查询到多条路径之后，可以进一步查询某条路径的所有顶点属性。
- 获取分片和按分片查询顶点，可以用来遍历全部顶点

#### 3.2.12 Edges

##### 3.2.12.1 根据边的id列表，批量查询边

###### Params

- ids: 要查询的边id列表

###### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/edges?ids="S1:josh>1>>S2:lop"&ids="S1:josh>1>>S2:ripple"
```

###### Response Status

```json
200
```

###### Response Body

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

##### 3.2.12.2 获取边 Shard 信息

通过指定的分片大小split_size，获取边分片信息（可以与 3.2.11.3 中的 Scan 配合使用来获取边）。

###### Params

- split_size: 分片大小，必填项

###### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/edges/shards?split_size=4294967295
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "shards":[
        {
            "start": "0",
            "end": "1073741823",
            "length": 0
        },
        {
            "start": "1073741823",
            "end": "2147483646",
            "length": 0
        },
        {
            "start": "2147483646",
            "end": "3221225469",
            "length": 0
        },
        {
            "start": "3221225469",
            "end": "4294967292",
            "length": 0
        },
        {
            "start": "4294967292",
            "end": "4294967295",
            "length": 0
        }
    ]
}
```

##### 3.2.12.3 根据 Shard 信息批量获取边

通过指定的分片信息批量查询边（Shard信息的获取参见 3.2.11.2）。

###### Params

- start: 分片起始位置，必填项
- end: 分片结束位置，必填项
- page：分页位置，选填项，默认为null，不分页；当page为“”时表示分页的第一页，从start指示的位置开始
- page_limit：分页获取边时，一页中边数目的上限，选填项，默认为 100000

###### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/traversers/edges/scan?start=0&end=3221225469
```

###### Response Status

```json
200
```

###### Response Body

```json
{
    "edges":[
        {
            "id":"S1:peter>2>>S2:lop",
            "label":"created",
            "type":"edge",
            "inVLabel":"software",
            "outVLabel":"person",
            "inV":"2:lop",
            "outV":"1:peter",
            "properties":{
                "weight":0.2,
                "date":"20170324"
            }
        },
        {
            "id":"S1:josh>2>>S2:lop",
            "label":"created",
            "type":"edge",
            "inVLabel":"software",
            "outVLabel":"person",
            "inV":"2:lop",
            "outV":"1:josh",
            "properties":{
                "weight":0.4,
                "date":"20091111"
            }
        },
        {
            "id":"S1:josh>2>>S2:ripple",
            "label":"created",
            "type":"edge",
            "inVLabel":"software",
            "outVLabel":"person",
            "inV":"2:ripple",
            "outV":"1:josh",
            "properties":{
                "weight":1,
                "date":"20171210"
            }
        },
        {
            "id":"S1:marko>1>20130220>S1:josh",
            "label":"knows",
            "type":"edge",
            "inVLabel":"person",
            "outVLabel":"person",
            "inV":"1:josh",
            "outV":"1:marko",
            "properties":{
                "weight":1,
                "date":"20130220"
            }
        },
        {
            "id":"S1:marko>1>20160110>S1:vadas",
            "label":"knows",
            "type":"edge",
            "inVLabel":"person",
            "outVLabel":"person",
            "inV":"1:vadas",
            "outV":"1:marko",
            "properties":{
                "weight":0.5,
                "date":"20160110"
            }
        },
        {
            "id":"S1:marko>2>>S2:lop",
            "label":"created",
            "type":"edge",
            "inVLabel":"software",
            "outVLabel":"person",
            "inV":"2:lop",
            "outV":"1:marko",
            "properties":{
                "weight":0.4,
                "date":"20171210"
            }
        }
    ]
}
```

##### 3.2.12.4 适用场景

- 按id列表查询边，可用于批量查询边
- 获取分片和按分片查询边，可以用来遍历全部边
