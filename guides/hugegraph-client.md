# HugeClient Guides


版本：1.3.0-SNAPSHOT

依赖HugeGraph-Common版本：1.2.0-SNAPSHOT

发布时间：2017-08-11


## 1\. HugeClient

HugeClient 是操作 HugeGraph 的总入口，用户必须先创建出 HugeClient 对象，与 HugeGraph-Server 建立连接（伪连接）后，才能获取 schema、graph 以及 gremlin 的操作入口对象。

目前 HugeClient 只允许连接服务端已存在的图，无法自定义图进行创建。其创建方法如下：

```
// server地址："http://localhost:8080"
// 图名："hugegraph"
HugeClient hugeClient = HugeClient.open("http://localhost:8080", "hugegraph");
```

## 2\. 元数据


### 2.1 SchemaManager


SchemaManager 用于管理 HugeGraph 中的四种元数据，分别是PropertyKey（属性）、VertexLabel（顶点类型）、EdgeLabel（边类型）和 IndexLabel（索引类型）。在定义元数据信息之前必须先创建 SchemaManager 对象。

用户可使用如下方法获得SchemaManager对象：

```
schema = hugeClient.schema()
```

下面分别对三种元数据的定义过程进行介绍。


### 2.2 PropertyKey


PropertyKey 用来定义顶点和边的属性，暂不支持定义属性的属性。

目前 PropertyKey 允许定义的约束信息包括：name、datatype、cardinality，下面逐一介绍。

- name: 属性的名字，用来区分不同的 PropertyKey，不允许有同名的属性；

interface                | param | must set
------------------------ | ----- | --------
propertyKey(String name) | name  | y

- datatype：属性值类型，必须从下表中选择符合具体业务场景的一项显式设置；

interface     | datatype
------------- | ---------
asText()      | String
asInt()       | Integer
asTimestamp() | Timestamp
asUuid()      | UUID
asBoolean()   | Boolean
asByte()      | Byte
asBlob()      | Byte[]
asDouble()    | Double
asFloat()     | Float
asLong()      | Long

- cardinality：属性值是单值还是多值，多值的情况下又分为允许有重复值和不允许有重复值，该项默认为 single，如有必要可从下表中选择一项设置；

interface     | cardinality | description
------------- | ----------- | -------------------------------------------
valueSingle() | single      | single value
valueList()   | list        | multi-values that allow duplicate value
valueSet()    | set         | multi-values that not allow duplicate value

下面给出一个创建 PropertyKey 的示例：

```
schema.propertyKey("name").asText().valueSet().ifNotExist().create()
```

- ifNotExist()：为 create 添加判断机制，若当前 PropertyKey 已经存在则不再创建，否则创建该属性。若不添加判断，在 properkey 存在的情况下会抛出异常信息，下同，不再赘述。


### 2.3 VertexLabel


VertexLabel 用来定义顶点类型，描述顶点的约束信息：

目前 VertexLabel 允许定义的约束信息包括：name、idStrategy、properties、primaryKeys，下面逐一介绍。

- name: 属性的名字，用来区分不同的 VertexLabel，不允许有同名的属性；

interface                | param | must set
------------------------ | ----- | --------
vertexLabel(String name) | name  | y

- idStrategy: 每一个 VertexLabel 都可以选择自己的 Id 策略，目前有三种策略供选择，即 Automatic（自动生成）、Customize（用户传入）和 PrimaryKey（主属性键）。其中 Automatic 使用 Snowflake 算法生成 Id，Customize 需要用户自行传入字符串类型的 Id，PrimaryKey 则允许用户从 VertexLabel 的属性中选择若干主属性作为区分的依据，HugeGraph 内部会根据主属性的值拼接生成 Id。idStrategy 默认使用 Automatic的，但如果用户没有显式设置 idStrategy 又调用了 primaryKeys(...) 方法设置了主属性，则 idStrategy 将自动使用 PrimaryKey 的；

interface       | idStrategy | description
--------------- | ---------- | ------------------------------------------------------
useAutomaticId  | Automatic  | generate id automaticly by Snowflake algorithom
useCustomizeId  | Customize  | passed id by user
usePrimaryKeyId | PrimaryKey | choose some important prop as primary key to splice id

- properties: 定义顶点的属性

interface                        | description
-------------------------------- | -------------------------
properties(String... properties) | allow to pass multi props

- primaryKeys: 当用户选择了 PrimaryKey 的 Id 策略时，需要从 VertexLabel 的属性中选择若干主属性作为区分的依据；

interface                   | description
--------------------------- | -----------------------------------------
primaryKeys(String... keys) | allow to choose multi prop as primaryKeys

需要注意的是，Id 策略的选择与 primaryKeys 的设置有一些相互约束，不能随意调用，约束关系见下表：

|                   | useAutomaticId | useCustomizeId | usePrimaryKeyId
| ----------------- | -------------- | -------------- | ---------------
| unset primaryKeys | Automatic      | Customize      | ERROR
| set primaryKeys   | ERROR          | ERROR          | PrimaryKey

下面给出几个创建和追加 VertexLabel 的示例：

```
// 使用 Automatic 的 Id 策略
schema.vertexLabel("person").properties("name", "age").ifNotExist().create();
schema.vertexLabel("person").useAutomaticId().properties("name", "age").primaryKeys("name").ifNotExist().create();

// 使用 Customize 的 Id 策略
schema.vertexLabel("person").useCustomizeId().properties("name", "age").ifNotExist().create();

// 使用 PrimaryKey 的 Id 策略
schema.vertexLabel("person").properties("name", "age").primaryKeys("name").ifNotExist().create();
schema.vertexLabel("person").usePrimaryKeyId().properties("name", "age").primaryKeys("name").ifNotExist().create();

schema.vertexLabel("person").properties("price").append();
```


### 2.4 EdgeLabel


EdgeLabel 用来定义边类型，描述边的约束信息。

目前 EdgeLabel 允许定义的约束信息包括：name、sourceLabel、targetLabel、frequency、properties、sortKeys，下面逐一介绍。

- name: 属性的名字，用来区分不同的 EdgeLabel，不允许有同名的属性；

interface              | param | must set
---------------------- | ----- | --------
edgeLabel(String name) | name  | y

- sourceLabel: 边连接的源顶点类型名，只允许设置一个；

- targetLabel: 边连接的目标顶点类型名，只允许设置一个；

interface                 | param | must set
------------------------- | ----- | --------
sourceLabel(String label) | label | y
targetLabel(String label) | label | y

- frequency: 字面意思是频率，表示在两个具体的顶点间某个关系出现的次数，可以是单次（single）或多次（frequency），默认为single；

interface    | frequency | description
------------ | --------- | -----------------------------------
singleTime() | single    | a relationship can only occur once
multiTimes() | multiple  | a relationship can occur many times

- properties: 定义边的属性

interface                        | description
-------------------------------- | -------------------------
properties(String... properties) | allow to pass multi props

- sortKeys: 当 EdgeLabel 的 frequency 为 multiple 时，需要某些属性来区分这多次的关系，故引入了 sortKeys（排序键）；

interface                | description
------------------------ | --------------------------------------
sortKeys(String... keys) | allow to choose multi prop as sortKeys

下面给出几个创建和追加 EdgeLabel 的示例：

```
schema.edgeLabel("knows").link("person", "person").properties("date").ifNotExist().create();
schema.edgeLabel("created").multiTimes().link("person", "software").properties("date").sortKeys("date").ifNotExist().create();

schema.edgeLabel("knows").properties("price").append();
```


### 2.5 IndexLabel


IndexLabel 用来定义索引类型，描述索引的约束信息，主要是为了方便查询。

目前 IndexLabel 允许定义的约束信息包括：name、baseType、baseValue、indexFeilds、indexType，下面逐一介绍。

- name: 属性的名字，用来区分不同的 IndexLabel，不允许有同名的属性；

interface               | param | must set
----------------------- | ----- | --------
indexLabel(String name) | name  | y

- baseType: 表示要为 VertexLabel 还是 EdgeLabel 建立索引；

- baseValue: 指定要建立索引的 VertexLabel 或 EdgeLabel 的名称；

interface             | param     | description
--------------------- | --------- | ----------------------------------------
onV(String baseValue) | baseValue | build index for VertexLabel: 'baseValue'
onE(String baseValue) | baseValue | build index for EdgeLabel: 'baseValue'

- indexFeilds: 要在哪些属性上建立索引，可以是为多列建立联合索引；

interface            | param | description
-------------------- | ----- | ---------------------------------------------------------
by(String... fields) | files | allow to build index for multi fields for secondary index

- indexType: 建立的索引类型，目前支持两种，即 Secondary 和 Search。Secondary 允许建立联合索引，支持前缀搜索，Search 支持数值类型的范围查询；

interface   | indexType | description
----------- | --------- | ---------------------------------------
secondary() | Secondary | support prefix search
search()    | Search    | supports range search for numeric types

下面给出创建 IndexLabel 的示例：

```
schema.indexLabel("personByAge").onV("person").by("age").search().ifNotExist().create();
schema.indexLabel("createdByDate").onE("created").by("date").secondary().ifNotExist().create();
```


## 3\. 图数据


### 3.1 Vertex


顶点是构成图的最基本元素，一个图中可以有非常多的顶点。下面给出一个添加顶点的例子：

```
Vertex marko = graph.addVertex(T.label, "person", "name", "marko", "age", 29);
Vertex lop = graph.addVertex(T.label, "software", "name", "lop", "lang", "java", "price", 328);
```

- 添加顶点的关键是定义顶点属性，添加顶点函数的参数个数必须为偶数，且满足`key1 -> val1, key2 -> val2 ···`的顺序排列，键值对之间的顺序是自由的。

- 参数中必须包含一对特殊的键值对，就是`T.label -> "val"`，用来定义该顶点的类别，以便于程序从缓存或后端获取到该VertexLabel的schema定义，然后做后续的约束检查。例子中的label定义为person。

- 如果顶点类型的 Id 策略为 Automatic，则不允许用户传入 id 键值对。

- 如果顶点类型的 Id 策略为 Customize，则用户需要自己传入 id 的值，键值对形如：`"T.id", "123456"`。

- 如果顶点类型的 Id 策略为 PrimaryKey，参数还必须全部包含该`primaryKeys`对应属性的名和值，如果不设置会抛出异常。比如之前`person`的`primaryKeys`是`name`，例子中就设置了`name`的值为`marko`。

- 剩下的参数就是顶点其他属性的设置，但并非必须。

- 调用`addVertex`方法后，顶点会立刻被插入到后端存储系统中。


### 3.2 Edge


有了点，还需要边才能构成完整的图。下面给出一个添加边的例子：

```
Edge knows1 = marko.addEdge("knows", vadas);
```

由（源）顶点来调用添加边的函数，函数第一个参数为边的label，第二个参数是目标顶点，这两个参数的位置和顺序是固定的。后续的参数就是`key1 -> val1, key2 -> val2 ···`的顺序排列，设置边的属性，键值对顺序自由。

**注意：当frequency为multiple时必须要设置sortKeys对应属性键的值。**

### 4\. 完整示例

完整示例见[HugeClient](http://hugegraph.baidu.com/quickstart/hugeclient.html)
