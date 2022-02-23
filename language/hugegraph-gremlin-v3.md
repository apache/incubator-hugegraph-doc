# 7.附录

## 7.1.HugeGraph Gremlin语法使用手册

HugeGraph支持[Apache TinkerPop3](https://tinkerpop.apache.org)的图形遍历查询语言[Gremlin](https://tinkerpop.apache.org/gremlin.html)。 SQL是关系型数据库查询语言，而Gremlin是一种通用的图数据库查询语言，Gremlin可用于创建图的实体（Vertex和Edge）、修改实体内部属性、删除实体，也可执行图的查询操作。

Gremlin可用于创建图的实体（Vertex和Edge）、修改实体内部属性、删除实体，更主要的是可用于执行图的查询及分析操作。

### 7.1.1.Gremlin标准语法

以下是HugeGraph⽀持的Gremlin标准语法：

序号   | 类型    | 语法列表                | 语句详情
----- | ------- | ---------------------- | --------------------------
1     | 查询语言 | ⽀持业界通⽤的查询语⾔     | 使⽤gremlin语⾔
2     | 查询语言 | ⽀持动态查询能⼒          | Hubble组件中可以执⾏任意gremlin语句
3     | 查询语言 | ⽀持传参    | Hubble组件中gremlin语⾔执⾏"g.V().has('age', gt(age))"
4     | 查询语言 | ⽀持预编译   | Hubble组件中gremlin语⾔多次执⾏"g.V().has('age', gt(age))"
5     | 查询语言 | ⽀持顶点的增加   | Hubble组件中gremlin语⾔执⾏ "graph.addVertex(T.label, "person", "name", "marko", "age", 29, "city", "Beijing")"
6     | 查询语言 | ⽀持顶点的查询 | Hubble组件中gremlin语⾔执⾏"g.V()"
7     | 查询语言 | ⽀持顶点的修改  | Hubble组件中gremlin语⾔执⾏"graph.addVertex(T.label, "person", "name", "marko", "age", 111, "city", "tianJin")"
8     | 查询语言 | ⽀持顶点的删除 | Hubble组件中gremlin语⾔执⾏"g.V('1:marko').drop()"
9     | 查询语言 | ⽀持边的增加 | Hubble组件中gremlin语⾔<br>1、执⾏ "marko = graph.addVertex(T.label, "person", "name", "marko", "age", 29, "city", "Beijing")"<br>2、执⾏"vadas = graph.addVertex(T.label, "person", "name", "vadas", "age", 27, "city", "Hongkong")"<br>3、执⾏"marko.addEdge("knows", vadas, "date", "20160110")"
10     | 查询语言 | ⽀持边的查询    | Hubble组件中gremlin语⾔执⾏"g.E()"
11     | 查询语言 | ⽀持边的修改  | Hubble组件中gremlin语⾔<br>1、执⾏ "marko = graph.addVertex(T.label, "person", "name", "marko", "age", 29, "city", "Beijing")"<br>2、执⾏"vadas = graph.addVertex(T.label, "person", "name", "vadas", "age", 27, "city", "Hongkong")"<br>3、执⾏"marko.addEdge("knows", vadas, "date", "20200110")"
12     | 查询语言 | ⽀持边的删除   | Hubble组件中gremlin语⾔执⾏"g.E("S1:marko>1>>S1:vadas").drop()"
13     | 查询语言 | ⽀持点和边的合并  | Hubble组件中gremlin语⾔<br>1、执⾏ "marko = graph.addVertex(T.label, "person", "name", "marko", "age", 29, "city", "Beijing")"<br>2、执⾏"vadas = graph.addVertex(T.label, "person", "name", "vadas", "age", 27, "city", "Hongkong")"<br>3、执⾏"marko.addEdge("knows", vadas, "date", "20200110")"<br>4、执⾏ "graph.addVertex(T.label, "person", "name", "marko", "age", 29, "city", "BaoDing")"<br>5、执⾏"marko.addEdge("knows", vadas, "date", "20190110")"
14     | 表达式 | ⽀持遍历查询顶点 | Hubble组件中gremlin语⾔执⾏"g.V()"
15     | 表达式 | ⽀持遍历查询边 | Hubble组件中gremlin语⾔执⾏"g.E()"
16     | 表达式 | ⽀持遍历邻接点  | Hubble组件中gremlin语⾔执⾏"g.V().out()"
17     | 表达式 | ⽀持遍历邻接边  | Hubble组件中gremlin语⾔执⾏"g.V('1:josh').out()"
18     | 表达式 | ⽀持多度查询  | Hubble组件中gremlin语⾔执⾏"g.V('1:josh').out('created').in('created').out('knows')"
19     | 表达式 | ⽀持去重  | Hubble组件中gremlin语⾔执⾏"g.V().hasLabel('person').values('age').dedup()"
20     | 表达式 | ⽀持排序  | Hubble组件中gremlin语⾔执⾏"g.V().hasLabel('person').order().by('age')"
21     | 表达式 | ⽀持查询结果限制-limit  | Hubble组件中gremlin语⾔执⾏"g.V().limit(3)"
22     | 表达式 | ⽀持查询结果限制-range  | Hubble组件中gremlin语⾔执⾏"g.V().range(2,4)"
23     | 表达式 | ⽀持查询结果限制-tail  | Hubble组件中gremlin语⾔执⾏"g.V().tail(2)"
24     | 表达式 | ⽀持查询结 果限制-skip  | Hubble组件中gremlin语⾔执⾏"g.V().skip(3)"
25     | 表达式 | ⽀持条件查询-hasLabel  | Hubble组件中gremlin语⾔执⾏"g.V().hasLabel('person')"
26     | 表达式 | ⽀持条件查询-has  | Hubble组件中gremlin语⾔执⾏"g.V().has('person', 'name', 'josh')"<br>注意：   has语句涉及到的属性name，需要提前建⽴⼆级索引
27     | 表达式 | ⽀持条件查询多层-has  | Hubble组件中gremlin语⾔执⾏"g.V().out().has('name','vadas').has('age',27))"<br>注意：   has语句涉及到的属性name，需要提前建⽴⼆级索引；   has语句涉及到的属性age，需要提 前建⽴范围索引；
28     | 表达式 | ⽀持条件查询-hasId  | Hubble组件中gremlin语⾔执⾏"g.V().hasId('1:vadas')"
29     | 表达式 | ⽀持条件查询-hasKey  | Hubble组件中gremlin语⾔执⾏"g.V().properties().hasKey('city')"
30     | 表达式 | ⽀持条件查询-hasValue  | Hubble组件中gremlin语⾔执⾏"g.V().properties().hasValue('Beijing')"
31     | 表达式 | ⽀持过滤查询-filter | Hubble组件中gremlin语⾔执⾏"g.V().filter(label().is('person'))"
32     | 表达式 | ⽀持过滤查询-coin  | Hubble组件中gremlin语⾔执⾏"g.V().coin(0.5)"
33     | 表达式 | ⽀持过滤查询-where  | ubble组件中gremlin语⾔执⾏"g.V('1:marko').as('a').out('created').in('created').where(neq('a'))"
34     | 表达式 | ⽀持-union  | Hubble组件中gremlin执⾏"g.V('1:josh').union(out('created'), both('knows'))"
35     | 表达式 | ⽀持-as  | Hubble组件中gremlin执⾏"g.V().as('a').out('created').as('b').select('a','b')"
36     | 表达式 | ⽀持-select  | Hubble组件中gremlin执⾏"g.V().as('a').out('created').as('b').select('a','b')"
37     | 表达式 | ⽀持统计-count | Hubble组件中gremlin语⾔执⾏"g.V().hasLabel('person').count()"
38     | 表达式 | ⽀持-flod  | Hubble组件中gremlin语⾔执⾏"g.V().out('knows').values('name').fold()"
39     | 表达式 | ⽀持分组-group by | Hubble组件中gremlin语⾔执⾏"g.V().group().by(label).by('name')"
40     | 表达式 | ⽀持判断-is | Hubble组件中gremlin语⾔执⾏"g.V().values('age').is(32)"
41     | 表达式 | ⽀持模式匹配-match  | Hubble组件中gremlin语⾔执⾏"g.V().match(__.as('a').out('created').has('name', 'lop').as('b'),__.as('b').in('created').has('age', 29).as('c'))"
42     | 表达式 | ⽀持定义常量-choose ... constant  | Hubble组件中gremlin语⾔执⾏"g.V().choose(hasLabel('person'),values('name'),constant('inhuman'))"
43     | 表达式 | ⽀持注⼊-inject | Hubble组件中gremlin语⾔执⾏"g.V('1:marko').in('created').values('name').inject('Tom') "
44     | 表达式 | ⽀持分⽀操作-coalesce  | Hubble组件中gremlin语⾔执⾏"g.V('1:marko').coalesce(outE('knows'), outE('created'))"
45     | 表达式 | ⽀持分⽀操作-optional  | Hubble组件中gremlin语⾔执⾏"g.V('1:marko').optional(out('created'))"
46     | 表达式 | ⽀持取样-sample | Hubble组件中gremlin语⾔执⾏"g.V().outE().sample(1)"
47     | 表达式 | ⽀持-aggregate | Hubble组件中gremlin执⾏"g.V().limit(2).aggregate('agg').cap('agg')"
48     | 运算符和函数 | ⽀持函数-sum | Hubble组件中gremlin执⾏"g.V().hasLabel('person').values('age').sum()"
49     | 运算符和函数 | ⽀持函数-max | Hubble组件中gremlin执⾏"g.V().hasLabel('person').values('age').max()"
50     | 运算符和函数 | ⽀持函数-min | Hubble组件中gremlin执⾏"g.V().hasLabel('person').values('age').min()"
51     | 运算符和函数 | ⽀持函数-mean | Hubble组件中gremlin执⾏"g.V().hasLabel('person').values('age').mean()"
52     | 运算符和函数 | ⽀持运算符-math | Hubble组件中gremlin语⾔执⾏"g.V().as('a').out('knows').as('b').math('a + b').by('age')"
53     | 运算符和函数 | ⽀持运算符-not | Hubble组件中gremlin语⾔执⾏"g.V().not(hasLabel('person'))"
54     | 运算符和函数 | ⽀持-多值条件within、without | Hubble组件中gremlin语⾔执⾏<br>1、  "g.V().out().has('name',within('vadas','josh'))"<br>2、  "g.V().out().has('name',without('vadas','josh'))"
55     | 运算符和函数 | ⽀持⽐较运算符lt、lte、gt、gte | Hubble组件中gremlin语⾔执⾏<br>1、  "g.V().out().has('age', lt(30))"<br>2、  "g.V().out().has('age', lte(30))"<br>3、  "g.V().out().has('age', gt(30))"<br>4、  "g.V().out().has('age', gte(30))"<br>5、  "g.V().values('age').is(lt(30))"<br>6、  "g.V().values('age').is(lte(30))"<br>7、  "g.V().values('age').is(gt(30))"<br>8、  "g.V().values('age').is(gte(30))"
56     | 运算符和函数 | ⽀持范围查询inside、between、outside  | Hubble组件中gremlin语⾔执⾏<br>1、  "g.V().out().has('age', inside(30,40))"<br>2、  "g.V().out().has('age', outside(30,40))"<br>3、  "g.V().out().has('age', between(30,40))"<br>4、  "g.V().values('age').is(inside(30, 40))"；<br>5、  "g.V().values('age').is(outside(30, 40))"；<br>6、  "g.V().values('age').is(between(30, 40))"；
57     | 运算符和函数 | ⽀持运算不等于  | Hubble组件中gremlin语⾔执⾏"g.V('1:marko').as('a').out('created').in('created').where(neq('a'))"
58     | 运算符和函数 | ⽀持运算等于  | Hubble组件中gremlin语⾔执⾏"g.V().filter {it.get().label() == 'person'}"
59     | 运算符和函数 | ⽀持逻辑或  | Hubble组件中图展示部分，执⾏"g.V().or(outE('knows'), outE('created')).values('name')"
60     | 运算符和函数 | ⽀持逻辑与  | Hubble组件中gremlin执⾏"g.V().where(outE('created').and().values('age').is(29)).values('name')"
61     | 运算符和函数 | ⽀持逻辑⾮  | Hubble组件中gremlin执⾏"g.V().not(hasLabel('person')).label()"
62     | 非安全操作 | ⽀持检查⽂件读  | Hubble组件中gremlin执⾏"new FileInputStream(FileDescriptor.in)"
63     | 非安全操作 | ⽀持检查⽂件写  | Hubble组件中gremlin执⾏"new FileOutputStream(new File(\"\"))"
64     | 非安全操作 | ⽀持检查命令执⾏  | Hubble组件中gremlin执⾏"process=Runtime.getRuntime().exec('cat /etc/passwd');process.waitFor()"
65     | 非安全操作 | ⽀持检查⽹络攻击  | Hubble组件中gremlin执⾏"new Socket("localhost", 8200)"
66     | 属性约束  | ⽀持属性类型约束  | 执⾏插⼊顶点（错误的属性类型）age属性值字符串graph.addVertex(T.label, "person", "name", "vadas", "age", "26", "city", "Hongkong")
67     | 属性约束  | ⽀持属性⾮空约束  | 执⾏插⼊顶点（city属性为空）graph.addVertex(T.label, "person", "name", "vadas", "age", 27, "city", null)
68     | 属性约束  | ⽀持索引唯⼀性约束-unqiue  | 1、   Hubble组件中gremlin执⾏"schema.indexLabel("personByAge").onV("person").by("age").unique().ifNotExist().create();"<br>2、重复插⼊相同的age值属性的点
69     | 超级点索引加速查询 | ⽀持通过点内索引查询边  | 1 、⾸先在没有创建索引的情况下查询超级点，记录耗时情况<br>2、然后在有索引的情况下通过索引查询超级点，记录耗时情况(sortKey)<br>举例：查询某⼿机号呼出的⼀周范围内的时间集合<br>g.V('137XXX').outE('call').has('time', between('20200518','20200524'))
70     | 顶点ID创建 | ⽀持⾃动⽣成ID  | 1、利⽤hubble组件进⾏元数据配置操作中，进⾏顶点的创建可以选择⾃动⽣成ID<br>2、添加相同的顶点数据
71     | 顶点ID创建 | ⽀持主键ID  | 1、利⽤hubble组件进⾏元数据配置操作中，进⾏顶点的创建可以选择主键ID<br>2、添加重复的顶点数据
72     | 顶点ID创建 | ⽀持⾃定义传⼊ID  | 1、利⽤hubble组件进⾏元数据配置操作中，进⾏顶点的创建可以选择⾃定义传⼊ID  （⾃定义字符 串或数字）<br>2、添加重复的顶点数据

### 7.1.2.Schema语法

schema相关的语法虽然不是Gremlin标准语法，但却是HugeGraph的核⼼功能，也可以通过Gremlin接⼝进⾏操作。

HugeGraph中的元数据主要⽤来定义和约束顶点、边、属性和索引，包括：

- PropertyKey：属性的类型
- VertexLabel：顶点的类型
- EdgeLabel：边的类型
- IndexLabel：索引的类型

四种元数据的依赖关系如下（虚线上⾯的依赖虚线下⾯的）：

```bash
            IndexLabel
            /      \
           /        \
          /        EdgeLabel
         /        /       /
        /        /       /
      VertexLabel       /
           \           /
            \         /
           PropertyKey
```

根据依赖关系，下⾯将按照PropertyKey、VertexLabel、EdgeLabel和IndexLabel的顺序依次介绍元数据。

#### 7.1.2.1.PropertyKey

PropertyKey定义属性的类型，包括名字、类型、基数等。例如：

```groovy
graph.schema().propertyKey("name").asText().create(); //创建姓名属性(文本类型)
graph.schema().propertyKey("age").asInt().create(); //创建年龄属性(整数类型)
graph.schema().propertyKey("addr").asText().create(); //创建地址属性(文本类型)
graph.schema().propertyKey("lang").asText().create(); //创建语言属性(文本类型)
graph.schema().propertyKey("tag").asText().create(); //创建标签属性(文本类型)
graph.schema().propertyKey("weight").asFloat().create(); //创建权重属性(浮点类型)
```

以PropertyKey的name为例：

> + propertyKey("name"): 表示属性的名字为“name”
> + asText(): 表示属性的类型为⽂本
> + valueSingle(): 表示属性的基数为single，即单值类型


定义PropertyKey可⽤的完整⽅法说明：

名字是字符串：propertyKey(String)

类型包括：

> + asText(): 字符串类型，是默认值
> + asInt(): 整型
> + asDate(): ⽇期类型
> + asUuid(): UUID类型
> + asBoolean(): 布尔型
> + asByte(): 字节型
> + asBlob(): 字节数组型
> + asDouble(): 双精度浮点型
> + asFloat(): 单精度浮点型
> + asLong(): ⻓整型

基数包括：

> + valueSingle(): 值是单值类型，是默认值
> + valueList(): 值是列表类型
> + valueSet(): 值是集合类型

#### 7.1.2.2.VertexLabel

VertexLabel是顶点的类型，每个顶点都有对应的VertexLabel，⼀个VertexLabel可以有多个具体的顶点。  VertexLabel可以定义⼀类 顶点的类型名称、拥有的属性、   ID策略、是否创建按类型的索引等。例如：

```groovy
// 创建顶点类型：⼈ "person"，包含姓名、年龄、地址等属性，使⽤⾃定义的字符串作为 ID
graph.schema().vertexLabel("person")
              .properties("name", "age", "addr", "weight")
              .nullableKeys("addr", "weight")
              .useCustomizeStringId()
              .create()

// 创建顶点类型：软件"software"，包含名称、使⽤语⾔、标签等属性，使⽤名称作为主键
graph.schema().vertexLabel("software")
              .properties("name", "lang", "tag", "weight")
              .primaryKeys("name")
              .create()

// 创建顶点类型：语⾔"language"，包含名称、使⽤语⾔等属性，使⽤名称作为主键
graph.schema().vertexLabel("language")
              .properties("name", "lang", "weight")
              .primaryKeys("name")
              .create()
```

以VertexLabel为例：

> + vertexLabel("person") 表示顶点类型的名字为“person”
> + properties("name", "age", "addr", "weight") 表示 weight 类型的属性
> + nullableKeys("addr", "weight") 表示 person 类型的顶点可以不包含PropertyKey  addr 和 weight 类型的属性
> + useCustomizeStringId() 表示 person 类型的顶点使⽤指定的String类型的ID
> + 默认包含 enableLabelIndex(true) ，表示可以按类型查找 person 类型的顶点

定义VertexLable可⽤的完整⽅法说明：

> + 名字是字符串，vertexLabel(String)
> + 包含的属性，properties(String...) ，必须是系统中已经创建过的PropertyKey的名字
> + 可空属性，nullableKeys(String...) ，必须是 properties 的⼦集
> + ID策略:
>   + useAutomaticId() ，⾃动ID策略，该类型的每个顶点会在创建时由系统提供⼀个数字ID
>   + usePrimaryKeyId() ，主键ID策略，该类型的顶点的ID是通过拼接 primaryKeys(String...) 中的多个属性的值组成 
>   + useCustomizeStringId() ，指定String ID策略，该类型的顶点在创建时使⽤指定的String作为顶点ID
>   + useCustomizeNumberId() ，指定Number ID策略，该类型的顶点在创建时使⽤指定的Number作为顶点ID
> + 类型索引，enableLabelIndex(Boolean) ，是否创建类型索引，如果创建了类型索引，就可以⾼效按类型查询顶点。

#### 7.1.2.3.EdgeLabel

EdgeLabel是边的类型，每条边都有对应的EdgeLabel，⼀个EdgeLabel可以有多条具体的边。EdgeLabel可以定义⼀类边的类型名 称、拥有的属性、是否创建按类型的索引等。例如：

```groovy
// 创建边类型：⼈认识⼈ "knows"，此类边由"person"指向 "person"
graph.schema().edgeLabel("knows")
              .sourceLabel("person").targetLabel("person")
              .properties("weight")
              .create()

// 创建边类型：⼈创建软件"created"，此类边由"person"指向 "software"
graph.schema().edgeLabel("created")
              .sourceLabel("person").targetLabel("software")
              .properties("weight")
              .create()

// 创建边类型：软件包含软件"contains"，此类边由"software"指向 "software"
graph.schema().edgeLabel("contains")
              .sourceLabel("software").targetLabel("software")
              .properties("weight")
              .create()

// 创建边类型：软件定义语⾔"define"，此类边由"software"指向 "language"
graph.schema().edgeLabel("define")
              .sourceLabel("software").targetLabel("language")
              .properties("weight")
              .create()

// 创建边类型：软件实现软件"implements"，此类边由"software"指向 "software"
graph.schema().edgeLabel("implements")
              .sourceLabel("software").targetLabel("software")
              .properties("weight")
              .create()

// 创建边类型：软件⽀持语⾔"supports"，此类边由"software"指向 "language"
graph.schema().edgeLabel("supports")
              .sourceLabel("software").targetLabel("language")
              .properties("weight")
              .create()
```

以EdgeLabel的knows为例：

> + edgeLabel("knows") 表示边的类型的名字为“knows”
> + sourceLabel("person") 表示 knows 类型的边从 person 类型的顶点发出
> + targetLabel("person") 表示 knows 类型的边指向 person 类型的顶点
> + properties("weight") 表示 knows 类型的边包含PropertyKey weight 类型的属性
> + singleTime() 是默认值，表示从任意⼀个 person 顶点到另⼀个 person 顶点之间只能有⼀条 knows 类型的边

定义EdgeLabel可⽤的完整⽅法说明：

> + 名字是字符串，edgeLabel(String)
> + 包含的属性，properties(String...) ，必须是系统中已经创建过的PropertyKey的名字
> + 可空属性，nullableKeys(String...) ，必须是 properties 的⼦集
> + 频度，表示从⼀个点出发到另⼀个点的该类型的边是否可以存在多条
>   + singleTime() 表示只能有⼀条
>   + multiTimes() 表示可以有多条，此时需要指定 sortKeys(String...)
> + 排序键，    sortKeys(String...) ，当频度为 multiTimes() 时，可⽤于区分不同的该类型的边
> + ID策略，边没有ID策略，所有类型的边都⽤拼接的字符串ID
>   + singleTime() 时，ID格式为“sourceVertexId>label>>targetLabelId”
>   + multiTimes() 时，ID格式为“sourceVertexId>label>sortKeys>targetLabelId”
> + 类型索引，enableLabelIndex(Boolean) ，是否创建类型索引，如果创建了类型索引，就可以⾼效按类型查询边。

#### 7.1.2.4.IndexLabel

IndexLabel是索引的类型，定义对X类型的顶点或者边的Ys属性建⽴Z类型的索引。其中：

> + X表示VertexLabel或者EdgeLabel
> + Ys表示X的⼀个或者多个PropertyKey属性
> + Z表示索引的种类
>   + ⼆级索引
>       + 单列索引
>       + 联合索引
>   + 范围索引
>   + 全⽂索引
>   + 分⽚索引
>   + 唯⼀索引

```groovy
// 创建索引类型：   "personByName"，可以按“name”属性的值快速查询对应的“person”顶点
schema.indexLabel("personByName")
      .onV("person")
      .by("name")
      .secondary()
      .create();

// 创建索引类型：   "personByAge"，可以按“age”属性的范围快速查询对应的“person”顶点
schema.indexLabel("personByAge")
      .onV("person")
      .by("age")
      .range()
      .create();

// 创建索引类型：   "knowsByWeight"，可以按“weight”属性的范围快速查询对应的“knows”边
schema.indexLabel("knowsByWeight")
      .onE("knows")
      .by("weight")
      .range()
      .ifNotExist()
      .create();
```

以IndexLabel  personByName 为例：

> + indexLabel("personByName") 表示IndexLabel的名字为“personByName”
> + onV("person") 表示对 person 类型的顶点建⽴索引，还有 onE(String) 表示对某个类型的边建⽴索引
> + by("name") 表示对顶点或者边的“name”属性的值建⽴索引
> + secondary() 表示建⽴的是⼆级索引，即可以快速查询属性的值等于某个具体值的顶点或者边

定义IndexLabel可⽤的完整⽅法说明：

> + 名字是字符串，    indexLabel(String)
> + on语句，表示是对哪个类型的顶点或者边建⽴索引
>   + onV(String) 表示对某个类型的顶点建⽴索引
>   + onE(String) 表示对某个类型的边建⽴索引
> + 属性列表，    by(String...) 表示对于顶点或者边的哪些属性的值建⽴索引
> + 索引类型: 建⽴的索引类型，⽬前⽀持五种，即 Secondary、   Range、  Search、  Shard 和 Unique。
>   + Secondary ⽀持精确匹配的⼆级索引，允许建⽴联合索引，联合索引⽀持索引前缀搜索
>       + 单个属性，⽀持相等查询，⽐如：   person顶点的city属性的⼆级索引，可以⽤ g.V().has("city", "北京") 查询"city属性值是北京"的全部顶点
>       + 联合索引，⽀持前缀查询和相等查询，⽐如：   person顶点的city和street属性的联合索引，可以⽤ g.V().has("city", "北京").has('street', '中关村街道') 查询"city属性值是北京且street属性值是中关村"的全部顶点，或 者 g.V().has("city", "北京") 查询"city属性值是北京"的全部顶点
>       
>       注意：secondary index的查询都是基于"是"或者"相等"的查询条件，不⽀持"部分匹配"
>   + Range ⽀持数值类型的范围查询
>       + 必须是单个数字或者⽇期属性，⽐如：   person顶点的age属性的范围索引，可以⽤ g.V().has("age", P.gt(18))查询"age属性值⼤于18"的顶点。除了 P.gt() 以外，还⽀持 P.gte() ,  P.lte() ,  P.lt() , P.eq() ,  P.between() ,  P.inside() 和 P.outside() 等
>   + Search ⽀持全⽂检索的索引
>       + 必须是单个⽂本属性，⽐如：   person顶点的address属性的全⽂索引，可以⽤ g.V().has("address", Text  .contains('⼤厦 ') 查询"address属性中包含⼤厦"的全部顶点。⽬前仅⽀持 Text.contains() ⼀种模糊查询。
> 
>       注意：search index的查询是基于"是"或者"包含"的查询条件
>   + Shard ⽀持前缀匹配 + 数字范围查询的索引
>       + N个属性的分⽚索引，⽀持前缀相等情况下的范围查询，⽐如：   person顶点的city和age属性的分⽚索引，可以⽤ g.V().has("city", "北京").has("age", P.between(18, 30)) 查询"city属性是北京且年龄⼤于等于18⼩于30"的全部顶点
>       + shard index N个属性全是⽂本属性时，等价于secondary index
>       + shard index只有单个数字或者⽇期属性时，等价于range index
>       注意：shard index可以有任意数字或者⽇期属性，但是查询时最多只能提供⼀个范围查找条件，且该范围查找条件的属性
>   + Unique ⽀持属性值唯⼀性约束，即可以限定属性的值不重复，允许联合索引，但不⽀持查询
>       + 单个或者多个属性的唯⼀性索引，不可⽤来查询，只可对属性的值进⾏限定，当出现重复值时将报错

以上四种元数据创建时，可以添加 ifNotExist() ，如  ...ifNotExist().create() ，表示不存在时才创建，存在则返回已 存在的同名元数据类型

### 7.1.3.常⽤Gremlin算法

#### 7.1.3.1.Kout--3度邻居

只需要邻居点

```groovy
g.V( '1:marko').repeat(out().limit(10000)).times(3).dedup()
```

需要路径（仅点信息）

```groovy
g.V( '1:marko').repeat(out().limit(10000)).times(3).dedup().path()
```


需要路径（点边信息）

```groovy
g.V( '1:marko').repeat(outE().inV().limit(10000)).times(3).dedup().path()
```

#### 7.1.3.2.Kneighbor--3度以内邻居

只需要邻居点

```groovy
g.V( '1:marko').repeat(out().limit(10000)).emit().times(3).dedup()
```

需要路径（仅点信息）

```groovy
g.V( '1:marko').repeat(out().limit(10000)).emit().times(3).dedup().path()
```

需要路径（点边信息）

```groovy
g.V( '1:marko').repeat(outE().inV().limit(10000)).emit().times(3).dedup().path()
```

#### 7.1.3.3.Shortestpath--6度以内最短路径

```groovy
g.V( '1:marko').repeat(bothE().otherV().simplePath()).until(hasId( '2:ripple').or().loops().is(P.gte(6))).hasId( '2:ripple').path().limit(1)
```