# HugeGraph Design Concepts

## 1. Property Graph
常见的图数据表示模型有两种，分别是RDF（Resource Description Framework）模型和属性图（Property Graph）模型。
RDF和Property Graph都是最基础、最有名的图表示模式，都能够表示各种图的实体关系建模。
RDF是W3C标准，而Property Graph是工业标准，受到广大图数据库厂商的广泛支持。HugeGraph目前采用Property Graph。

HugeGraph对应的存储概念模型也是参考Property Graph而设计的，具体示例详见下图：

![image](/images/design/PropertyGraph.png)

在HugeGraph内部，顶点仅存储Id不包含任何属性信息，顶点所有的属性和Label都通过边来存储。如图所示顶点（Id=1）有3个属性分别是name、age和lives
，则由三条对应的边指向其具体的属性值，这三条边的Label和顶点属性名相同分别是name、age和lives。

在HugeGraph内部，顶点与顶点之间的关系也通过边来存储的。但关系的属性并没有像顶点一样分来存储，而是和关系存储在一起。

顶点属性值通过边指针方式存储时，如果要更新一个顶点特定的属性值直接通过覆盖写入即可，其弊端是冗余存储了VertexId；
如果要更新关系的属性需要通过read-and-modify方式，先读取所有属性，修改部分属性，然后再写入存储系统，更新效率较低。
从经验来看顶点属性的修改需求较多，而边的属性修改需求较少，例如PageRank和Graph Cluster等计算都需要频繁修改顶点的属性值。

## 2. 图分区方案
对于分布式图数据库而言，图的分区存储方式有两种：分别是边分割存储（Edge Cut）和点分割存储（Vertex Cut），如下图所示。
使用Edge Cut方式存储图时，任何一个顶点只会出现在一台机器上，而边可能分布在不同机器上，这种存储方式有可能导致边多次存储。
使用Vertex Cut方式存储图时，任何一条边只会出现在一台机器上，而每相同的一个点可能分布到不同机器上，这种存储方式可能会导致顶点多次存储。

![image](/images/design/GraphCut.png)

采用EdgeCut分区方案可以支持高性能的插入和更新操作，而VertexCut分区方案更适合静态图查询分析，因此EdgeCut适合OLTP图查询，VertexCut更适合OLAP的图查询。
HugeGraph目前采用EdgeCut的分区方案。

## 3. VertexId 策略
HugeGraph的Vertex支持三种ID策略，在同一个图数据库中不同的VertexLabel可以使用不同的Id策略，目前HugeGraph支持的Id策略分别是：
* AUTOMATIC：使用Snowflake算法自动生成全局唯一Id
* CUSTOMIZE：用户自定义Id，需自己保障Id的唯一性
* PRIMARY_KEY：通过VertexLabel+PrimaryKeyValues生成Id

默认的Id策略是AUTOMATIC，如果用户调用primaryKeys()方法并设置了正确的PrimaryKeys，则自动启用PRIMARY_KEY策略。
启用PRIMARY_KEY策略后HugeGraph能根据PrimaryKeys实现数据去重。
 
 1. AUTOMATIC ID策略
 ```
 schema.vertexLabel("person")
               .useAutomaticId()
               .properties("name", "age", "city")
               .create();
  graph.addVertex(T.label, "person","name", "marko", "age", 18, "city", "Beijing");
 ```
 
 2. PRIMARY_KEY ID策略
 ```
 schema.vertexLabel("person")
               .usePrimaryKeyId()
               .properties("name", "age", "city")
               .primaryKeys("name", "age")
               .create();
  graph.addVertex(T.label, "person","name", "marko", "age", 18, "city", "Beijing");
 ```

 3. CUSTOMIZE ID策略
 ```
 schema.vertexLabel("person")
               .useCustomizeId()
               .properties("name", "age", "city")
               .create();
 graph.addVertex(T.label, "person", T.id, "123456", "name", "marko","age", 18, "city", "Beijing");
 ```

如果用户需要Vertex去重，有三种方案分别是：

1. 采用PRIMARY_KEY策略，自动覆盖，适合大数据量批量插入，用户无法知道是否发生了覆盖行为
2. 采用AUTOMATIC策略，read-and-modify，适合小数据量插入，用户可以明确知道是否发生覆盖
3. 采用CUSTOMIZE策略，用户自己保证唯一


## 3. EdgeId 策略
HugeGraph的EdgeId是由`srcVertexId`+`edgeLabel`+`sortKey`+`tgtVertexId`四部分组合而成。其中`sortKey`是HugeGraph的一个重要概念。
在Edge中加入`sortKey`作为Edge的唯一标识的原因有两个：

1. 如果两个顶点之间存在多条相同Label的边可通过`sortKey`来区分
2. 对于SuperNode的节点，可以通过`sortKey`来排序截断。

由于EdgeId是由`srcVertexId`+`edgeLabel`+`sortKey`+`tgtVertexId`四部分组合，多次插入相同的Edge时HugeGraph会自动覆盖以实现去重。
需要注意的是如果批量插入模式下Edge的属性也将会覆盖。

另外由于HugeGraph的EdgeId采用自动去重策略，对于self-loop（一个顶点存在一条指向自身的边）的情况下HugeGraph认为仅有一条边，对于采用AUTOMATIC策略的图数据库（例如TitianDB
）则会认为该图存在两条边。

> HugeGraph的边仅支持有向边，无向边可以创建Out和In两条边来实现。
  