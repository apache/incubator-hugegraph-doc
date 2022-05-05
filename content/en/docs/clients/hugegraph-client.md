---
title: "HugeGraph Java Client"
linkTitle: "HugeGraph Java Client"
weight: 2
---

The code in this document is written in `java`, but its style is very similar to `gremlin(groovy)`. The user only needs to replace the variable declaration in the code with `def` or remove it directly,
You can convert `java` code into `groovy`; in addition, each line of statement can be without a semicolon at the end, `groovy` considers a line to be a statement.
The `gremlin(groovy)` written by the user in `HugeGraph-Studio` can refer to the `java` code in this document, and some examples will be given below.

### 1 HugeGraph-Client

HugeGraph-Client is the general entry for operating graph. Users must first create a HugeGraph-Client object and establish a connection (pseudo connection) with HugeGraph-Server before they can obtain the operation entry objects of schema, graph and gremlin.

Currently, HugeGraph-Client only allows connections to existing graphs on the server, and cannot create custom graphs. Its creation method is as follows:

```java
// HugeGraphServer address: "http://localhost:8080"
// Graph Name: "hugegraph"
HugeClient hugeClient = HugeClient.builder("http://localhost:8080", "hugegraph")
                                  .configTimeout(20) // 20s timeout
                                  .configUser("**", "**") // enable auth 
                                  .build();
```

If the above process of creating HugeClient fails, an exception will be thrown, and the user needs to use try-catch. If successful, continue to get schema, graph and gremlin manager.

When operating through `gremlin` in `HugeGraph-Hubble`(or `HugeGraph-Studio`), `HugeClient` is not required and can be ignored.

### 2 Schema

#### 2.1 SchemaManager

SchemaManager is used to manage four kinds of schema in HugeGraph, namely PropertyKey (property type), VertexLabel (vertex type), EdgeLabel (edge type) and IndexLabel (index label). A SchemaManager object can be created for schema information definition.

The user can obtain the SchemaManager object using the following methods:

```java
SchemaManager schema = hugeClient.schema()
```

Create a `schema` object via `gremlin` in `HugeGraph-Hubble`:

```groovy
schema = graph.schema()
```

The definition process of the 4 kinds of schema is described below.

#### 2.2 PropertyKey

##### 2.2.1 Interface and parameter introduction

PropertyKey is used to standardize the property constraints of vertices and edges, and properties of properties are not currently supported.

The constraint information that PropertyKey allows to define includes: name, datatype, cardinality, and userdata, which are introduced one by one below.

- name: The name of the property, used to distinguish different PropertyKeys, PropertyKeys with the same name are not allowed.

interface                | param | must set
------------------------ | ----- | --------
propertyKey(String name) | name  | y

- datatype: property value type, you must select an explicit setting from the following table that conforms to the specific business scenario:

interface     | Java Class
------------- | ----------
asText()      | String
asInt()       | Integer
asDate()      | Date
asUuid()      | UUID
asBoolean()   | Boolean
asByte()      | Byte
asBlob()      | Byte[]
asDouble()    | Double
asFloat()     | Float
asLong()      | Long

- cardinality: Whether the property value is single-valued or multi-valued, in the case of multi-valued, it is divided into allowing-duplicate values and not-allowing-duplicate values. This item is single by default. If necessary, you can select a setting from the following table:

interface     | cardinality | description
------------- | ----------- | -------------------------------------------
valueSingle() | single      | single value
valueList()   | list        | multi-values that allow duplicate value
valueSet()    | set         | multi-values that not allow duplicate value

- userdata: Users can add some constraints or additional information by themselves, and then check whether the incoming properties satisfy the constraints, or extract additional information when necessary:

interface                          | description
---------------------------------- | ----------------------------------------------
userdata(String key, Object value) | The same key, the latter will cover the former


##### 2.2.2 Create PropertyKey

```java
schema.propertyKey("name").asText().valueSet().ifNotExist().create()
```

The syntax of creating the above `PropertyKey` object through `gremlin` in `HugeGraph-Hubble` is exactly the same. If the user does not define the `schema` variable, it should be written like this:

```groovy
graph.schema().propertyKey("name").asText().valueSet().ifNotExist().create()
```

In the following examples, the syntax of `gremlin` and `java` is exactly the same, so we won't repeat them.

- ifNotExist(): Add a judgment mechanism for create, if the current PropertyKey already exists, it will not be created, otherwise the property will be created. If no ifNotExist() is added, an exception will be thrown if a properkey with the same name already exists. The same as below, and will not be repeated there.

##### 2.2.3 Delete PropertyKey

```java
schema.propertyKey("name").remove()
```

##### 2.2.4 Query PropertyKey

```java
// Get PropertyKey
schema.getPropertyKey("name")

// Get attributes of PropertyKey
schema.getPropertyKey("name").cardinality()
schema.getPropertyKey("name").dataType()
schema.getPropertyKey("name").name()
schema.getPropertyKey("name").userdata()
```

#### 2.3 VertexLabel

##### 2.3.1 Interface and parameter introduction

VertexLabel is used to define the vertex type and describe the constraint information of the vertex.

The constraint information that VertexLabel allows to define include: name, idStrategy, properties, primaryKeys and nullableKeys, which are introduced one by one below.

- name: The name of the VertexLabel, used to distinguish different VertexLabels, VertexLabels with the same name are not allowed.

interface                | param | must set
------------------------ | ----- | --------
vertexLabel(String name) | name  | y

- idStrategy: Each VertexLabel can choose its own Id strategy. There are currently three strategies to choose from, namely Automatic (automatically generated), Customize (user input) and PrimaryKey (primary attribute key). Among them, Automatic uses the Snowflake algorithm to generate Id, Customize requires the user to pass in the Id of string or number type, and PrimaryKey allows the user to select several properties of VertexLabel as the basis for differentiation. HugeGraph will be spliced and generated Id according to the value of the primary properties. idStrategy uses Automatic by default, but if the user does not explicitly set idStrategy and calls the primaryKeys(...) method to set the primary property, then idStrategy will automatically use PrimaryKey.

interface             | idStrategy        | description
--------------------- | ----------------- | ------------------------------------------------------
useAutomaticId        | AUTOMATIC         | generate id automaticly by Snowflake algorithom
useCustomizeStringId  | CUSTOMIZE_STRING  | passed id by user, must be string type
useCustomizeNumberId  | CUSTOMIZE_NUMBER  | passed id by user, must be number type
usePrimaryKeyId       | PRIMARY_KEY       | choose some important prop as primary key to splice id

- properties: define the properties of the vertex, the incoming parameter is the name of the PropertyKey.

interface                        | description
-------------------------------- | -------------------------
properties(String... properties) | allow to pass multi properties

- primaryKeys: When the user selects the Id strategy of PrimaryKey, several primary properties need to be selected from the properties of VertexLabel as the basis for differentiation;

interface                   | description
--------------------------- | -----------------------------------------
primaryKeys(String... keys) | allow to choose multi prop as primaryKeys

Note that the selection of the Id strategy and the setting of primaryKeys have some mutual constraints, which cannot be called at will. The constraints are shown in the following table:

|                   | useAutomaticId | useCustomizeStringId | useCustomizeNumberId | usePrimaryKeyId
| ----------------- | -------------- | -------------------- | -------------------- | ---------------
| unset primaryKeys | AUTOMATIC      | CUSTOMIZE_STRING     | CUSTOMIZE_NUMBER     | ERROR
| set primaryKeys   | ERROR          | ERROR                | ERROR                | PRIMARY_KEY

- nullableKeys: For properties set by the properties(...) method, all of them are non-nullable by default, that is, the property must be assigned a value when creating a vertex, which may impose too strict integrity requirements on user data. In order to avoid such strong constraints, the user can set some properties to be nullable through this method, so that the properties can be unassigned when adding vertices.

interface                          | description
---------------------------------- | -------------------------
nullableKeys(String... properties) | allow to pass multi props

Note: primaryKeys and nullableKeys cannot intersect, because a property cannot be both primary and nullable.

- enableLabelIndex: The user can specify whether to create an index for the label. If you don't create it, you can't globally search for the vertices and edges of the specified label. If you create it, you can search globally, like `g.V().hasLabel('person'), g.E().has('label', 'person')` query, but the performance will be slower when inserting data, and it will take up more storage space. This defaults to true.

interface                          | description
---------------------------------- | -------------------------------
enableLabelIndex(boolean enable)   | Whether to create a label index

- userdata: Users can add some constraints or additional information by themselves, and then check whether the incoming properties meet the constraints, or extract additional information when necessary.

interface                          | description
---------------------------------- | ----------------------------------------------
userdata(String key, Object value) | The same key, the latter will cover the former

##### 2.3.2 Create VertexLabel

```java
// Use Automatic Id strategy
schema.vertexLabel("person").properties("name", "age").ifNotExist().create();
schema.vertexLabel("person").useAutomaticId().properties("name", "age").ifNotExist().create();

// Use Customize_String Id strategy
schema.vertexLabel("person").useCustomizeStringId().properties("name", "age").ifNotExist().create();
// Use Customize_Number Id strategy
schema.vertexLabel("person").useCustomizeNumberId().properties("name", "age").ifNotExist().create();

// Use PrimaryKey Id strategy
schema.vertexLabel("person").properties("name", "age").primaryKeys("name").ifNotExist().create();
schema.vertexLabel("person").usePrimaryKeyId().properties("name", "age").primaryKeys("name").ifNotExist().create();
```

##### 2.3.3 Update VertexLabel

VertexLabel can append constraints, but only properties and nullableKeys, and the appended properties must also be added to the nullableKeys collection.

```java
schema.vertexLabel("person").properties("price").nullableKeys("price").append();
```

##### 2.3.4 Delete VertexLabel

```java
schema.vertexLabel("person").remove();
```

##### 2.3.5 Query VertexLabel

```java
// Get VertexLabel
schema.getVertexLabel("name")

// Get attributes of VertexLabel
schema.getVertexLabel("person").idStrategy()
schema.getVertexLabel("person").primaryKeys()
schema.getVertexLabel("person").name()
schema.getVertexLabel("person").properties()
schema.getVertexLabel("person").nullableKeys()
schema.getVertexLabel("person").userdata()
```

#### 2.4 EdgeLabel

##### 2.4.1 Interface and parameter introduction

EdgeLabel is used to define the edge type and describe the constraint information of the edge.

The constraint information that EdgeLabel allows to define include: name, sourceLabel, targetLabel, frequency, properties, sortKeys and nullableKeys, which are introduced one by one below.

- name: The name of the EdgeLabel, used to distinguish different EdgeLabels, EdgeLabels with the same name are not allowed.

interface              | param | must set
---------------------- | ----- | --------
edgeLabel(String name) | name  | y

- sourceLabel: The name of the source vertex type of the edge link, only one is allowed;

- targetLabel: The name of the target vertex type of the edge link, only one is allowed;

interface                 | param | must set
------------------------- | ----- | --------
sourceLabel(String label) | label | y
targetLabel(String label) | label | y

- frequency: Indicating the number of times a relationship occurs between two specific vertices, which can be single (single) or multiple (frequency), the default is single.

interface    | frequency | description
------------ | --------- | -----------------------------------
singleTime() | single    | a relationship can only occur once
multiTimes() | multiple  | a relationship can occur many times

- properties: Define the properties of the edge.

interface                        | description
-------------------------------- | -------------------------
properties(String... properties) | allow to pass multi props

- sortKeys: When the frequency of EdgeLabel is multiple, some properties are needed to distinguish the multiple relationships, so sortKeys (sorted keys) is introduced;

interface                | description
------------------------ | --------------------------------------
sortKeys(String... keys) | allow to choose multi prop as sortKeys

- nullableKeys: Consistent with the concept of nullableKeys in vertices.

Note: sortKeys and nullableKeys also cannot intersect.

- enableLabelIndex: It is consistent with the concept of enableLabelIndex in the vertex.

- userdata: Users can add some constraints or additional information by themselves, and then check whether the incoming properties meet the constraints, or extract additional information when necessary.

interface                          | description
---------------------------------- | ----------------------------------------------
userdata(String key, Object value) | The same key, the latter will cover the former

##### 2.4.2 Create EdgeLabel

```java
schema.edgeLabel("knows").link("person", "person").properties("date").ifNotExist().create();
schema.edgeLabel("created").multiTimes().link("person", "software").properties("date").sortKeys("date").ifNotExist().create();
```

##### 2.4.3 Update EdgeLabel

```java
schema.edgeLabel("knows").properties("price").nullableKeys("price").append();
```

##### 2.4.4 Delete EdgeLabel

```java
schema.edgeLabel("knows").remove();
```

##### 2.4.5 Qeury EdgeLabel

```java
// Get EdgeLabel
schema.getEdgeLabel("knows")

// Get attributes of EdgeLabel
schema.getEdgeLabel("knows").frequency()
schema.getEdgeLabel("knows").sourceLabel()
schema.getEdgeLabel("knows").targetLabel()
schema.getEdgeLabel("knows").sortKeys()
schema.getEdgeLabel("knows").name()
schema.getEdgeLabel("knows").properties()
schema.getEdgeLabel("knows").nullableKeys()
schema.getEdgeLabel("knows").userdata()
```

#### 2.5 IndexLabel

##### 2.5.1 Interface and parameter introduction

IndexLabel is used to define the index type and describe the constraint information of the index, mainly for the convenience of query.

The constraint information that IndexLabel allows to define include: name, baseType, baseValue, indexFeilds, indexType, which are introduced one by one below.

- name: The name of the IndexLabel, used to distinguish different IndexLabels, IndexLabels with the same name are not allowed.

interface               | param | must set
----------------------- | ----- | --------
indexLabel(String name) | name  | y

- baseType: Indicates whether to index VertexLabel or EdgeLabel, used in conjunction with the baseValue below.

- baseValue: Specifies the name of the VertexLabel or EdgeLabel to be indexed.

interface             | param     | description
--------------------- | --------- | ----------------------------------------
onV(String baseValue) | baseValue | build index for VertexLabel: 'baseValue'
onE(String baseValue) | baseValue | build index for EdgeLabel: 'baseValue'

- indexFields: on which fields to index, it can be a joint index for multiple columns.

interface            | param | description
-------------------- | ----- | ---------------------------------------------------------
by(String... fields) | files | allow to build index for multi fields for secondary index

- indexType: 建立的索引类型，目前支持五种，即 Secondary、Range、Search、Shard 和 Unique。
    - Secondary 支持精确匹配的二级索引，允许建立联合索引，联合索引支持索引前缀搜索
        - 单个属性，支持相等查询，比如：person顶点的city属性的二级索引，可以用`g.V().has("city", "北京")
        `查询"city属性值是北京"的全部顶点
        - 联合索引，支持前缀查询和相等查询，比如：person顶点的city和street属性的联合索引，可以用`g.V().has
        ("city", "北京").has('street', '中关村街道')
        `查询"city属性值是北京且street属性值是中关村"的全部顶点，或者`g.V()
        .has("city", "北京")`查询"city属性值是北京"的全部顶点
        > secondary index的查询都是基于"是"或者"相等"的查询条件，不支持"部分匹配"
    - Range 支持数值类型的范围查询
        - 必须是单个数字或者日期属性，比如：person顶点的age属性的范围索引，可以用`g.V().has("age", P.gt(18))
        `查询"age属性值大于18"的顶点。除了`P.gt()`以外，还支持`P.gte()`, `P.lte()`, `P.lt()`,
        `P.eq()`, `P.between()`, `P.inside()`和`P.outside()`等
    - Search 支持全文检索的索引
        - 必须是单个文本属性，比如：person顶点的address属性的全文索引，可以用`g.V().has("address", Text
        .contains('大厦')`查询"address属性中包含大厦"的全部顶点
        > search index的查询是基于"是"或者"包含"的查询条件
    - Shard 支持前缀匹配 + 数字范围查询的索引
        - N个属性的分片索引，支持前缀相等情况下的范围查询，比如：person顶点的city和age属性的分片索引，可以用`g.V().has
        ("city", "北京").has("age", P.between(18, 30))
        `查询"city属性是北京且年龄大于等于18小于30"的全部顶点
        - shard index N个属性全是文本属性时，等价于secondary index
        - shard index只有单个数字或者日期属性时，等价于range index
        > shard index可以有任意数字或者日期属性，但是查询时最多只能提供一个范围查找条件，且该范围查找条件的属性的前缀属性都是相等查询条件
    - Unique 支持属性值唯一性约束，即可以限定属性的值不重复，允许联合索引，但不支持查询
        - 单个或者多个属性的唯一性索引，不可用来查询，只可对属性的值进行限定，当出现重复值时将报错

interface   | indexType | description
----------- | --------- | ---------------------------------------
secondary() | Secondary | support prefix search
range()     | Range     | support range(numeric or date type) search
search()    | Search    | support full text search
shard()     | Shard     | support prefix + range(numeric or date type) search
unique()    | Unique    | support unique props value, not support search

##### 2.5.2 Create IndexLabel

```java
schema.indexLabel("personByAge").onV("person").by("age").range().ifNotExist().create();
schema.indexLabel("createdByDate").onE("created").by("date").secondary().ifNotExist().create();
schema.indexLabel("personByLived").onE("person").by("lived").search().ifNotExist().create();
schema.indexLabel("personByCityAndAge").onV("person").by("city", "age").shard().ifNotExist().create();
schema.indexLabel("personById").onV("person").by("id").unique().ifNotExist().create();
```

##### 2.5.3 Delete IndexLabel

```java
schema.indexLabel("personByAge").remove()
```

##### 2.5.4 Query IndexLabel

```java
// Get IndexLabel
schema.getIndexLabel("personByAge")

// Get attributes of IndexLabel
schema.getIndexLabel("personByAge").baseType()
schema.getIndexLabel("personByAge").baseValue()
schema.getIndexLabel("personByAge").indexFields()
schema.getIndexLabel("personByAge").indexType()
schema.getIndexLabel("personByAge").name()
```

### 3 图数据

#### 3.1 Vertex

顶点是构成图的最基本元素，一个图中可以有非常多的顶点。下面给出一个添加顶点的例子：

```java
Vertex marko = graph.addVertex(T.label, "person", "name", "marko", "age", 29);
Vertex lop = graph.addVertex(T.label, "software", "name", "lop", "lang", "java", "price", 328);
```

- 添加顶点的关键是顶点属性，添加顶点函数的参数个数必须为偶数，且满足`key1 -> val1, key2 -> val2 ···`的顺序排列，键值对之间的顺序是自由的。
- 参数中必须包含一对特殊的键值对，就是`T.label -> "val"`，用来定义该顶点的类别，以便于程序从缓存或后端获取到该VertexLabel的schema定义，然后做后续的约束检查。例子中的label定义为person。
- 如果顶点类型的 Id 策略为 `AUTOMATIC`，则不允许用户传入 id 键值对。
- 如果顶点类型的 Id 策略为 `CUSTOMIZE_STRING`，则用户需要自己传入 String 类型 id 的值，键值对形如：`"T.id", "123456"`。
- 如果顶点类型的 Id 策略为 `CUSTOMIZE_NUMBER`，则用户需要自己传入 Number 类型 id 的值，键值对形如：`"T.id", 123456`。
- 如果顶点类型的 Id 策略为 `PRIMARY_KEY`，参数还必须全部包含该`primaryKeys`对应属性的名和值，如果不设置会抛出异常。比如之前`person`的`primaryKeys`是`name`，例子中就设置了`name`的值为`marko`。
- 对于非 nullableKeys 的属性，必须要赋值。
- 剩下的参数就是顶点其他属性的设置，但并非必须。
- 调用`addVertex`方法后，顶点会立刻被插入到后端存储系统中。

#### 3.2 Edge

有了点，还需要边才能构成完整的图。下面给出一个添加边的例子：

```java
Edge knows1 = marko.addEdge("knows", vadas, "city", "Beijing");
```

- 由（源）顶点来调用添加边的函数，函数第一个参数为边的label，第二个参数是目标顶点，这两个参数的位置和顺序是固定的。后续的参数就是`key1 -> val1, key2 -> val2 ···`的顺序排列，设置边的属性，键值对顺序自由。
- 源顶点和目标顶点必须符合 EdgeLabel 中 sourcelabel 和 targetlabel 的定义，不能随意添加。
- 对于非 nullableKeys 的属性，必须要赋值。

**注意：当frequency为multiple时必须要设置sortKeys对应属性类型的值。**

### 4 简单示例

简单示例见[HugeGraph-Client](/docs/quickstart/hugegraph-client)
