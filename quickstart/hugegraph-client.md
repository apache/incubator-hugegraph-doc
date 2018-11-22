## HugeGraph-Client Quick Start

### 1 概述

HugeGraph-Client向HugeGraph-Server发出HTTP请求，获取并解析Server的执行结果。目前仅提供了Java版，用户可以使用HugeGraph-Client编写Java代码操作HugeGraph，比如元数据和图数据的增删改查，或者执行gremlin语句。

### 2 环境要求

- jdk1.8
- maven-3.3.9

### 3 使用流程

使用HugeGraph-Client的基本步骤如下:

- 新建Eclipse/ IDEA Maven项目；
- 在pom文件中添加HugeGraph-Client依赖；
- 创建类，调用HugeGraph-Client接口；

详细使用过程见下节完整示例。

### 4 完整示例

#### 4.1 新建Maven工程

可以选择Eclipse或者Intellij Idea创建工程：

- [Eclipse新建Maven工程](http://www.vogella.com/tutorials/EclipseMaven/article.html)
- [Intellij Idea 创建maven工程](https://vaadin.com/docs/-/part/framework/getting-started/getting-started-idea.html)

#### 4.2 添加hugegraph-client依赖

添加hugegraph-client依赖

```xml
<dependencies>
    <dependency>
        <groupId>com.baidu.hugegraph</groupId>
        <artifactId>hugegraph-client</artifactId>
        <version>${version}</version>
    </dependency>    
</dependencies>
```

#### 4.3 Example

##### 4.3.1 SingleExample

```java
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import com.baidu.hugegraph.driver.GraphManager;
import com.baidu.hugegraph.driver.GremlinManager;
import com.baidu.hugegraph.driver.HugeClient;
import com.baidu.hugegraph.driver.SchemaManager;
import com.baidu.hugegraph.structure.constant.T;
import com.baidu.hugegraph.structure.graph.Edge;
import com.baidu.hugegraph.structure.graph.Path;
import com.baidu.hugegraph.structure.graph.Vertex;
import com.baidu.hugegraph.structure.gremlin.Result;
import com.baidu.hugegraph.structure.gremlin.ResultSet;

public class SingleExample {

    public static void main(String[] args) throws IOException {
        // If connect failed will throw a exception.
        HugeClient hugeClient = new HugeClient("http://localhost:8080", "hugegraph");

        SchemaManager schema = hugeClient.schema();

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
              .ifNotExist()
              .create();

        schema.vertexLabel("software")
              .properties("name", "lang", "price")
              .primaryKeys("name")
              .ifNotExist()
              .create();

        schema.indexLabel("personByName")
              .onV("person")
              .by("name")
              .secondary()
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
              .sourceLabel("person")
              .targetLabel("person")
              .properties("date", "weight")
              .ifNotExist()
              .create();

        schema.edgeLabel("created")
              .sourceLabel("person").targetLabel("software")
              .properties("date", "weight")
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


        GraphManager graph = hugeClient.graph();
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

        GremlinManager gremlin = hugeClient.gremlin();
        ResultSet resultSet = gremlin.gremlin("g.V().outE().path()").execute();
        Iterator<Result> results = resultSet.iterator();
        results.forEachRemaining(result -> {
            System.out.println(result.getObject().getClass());
            Object object = result.getObject();
            if (object instanceof Vertex) {
                System.out.println(((Vertex) object).id());
            } else if (object instanceof Edge) {
                System.out.println(((Edge) object).id());
            } else if (object instanceof Path) {
                List<Object> elements = ((Path) object).objects();
                elements.forEach(element -> {
                    System.out.println(element.getClass());
                    System.out.println(element);
                });
            } else {
                System.out.println(object);
            }
        });
    }
}
```

##### 4.3.2 BatchExample

```java
import java.util.LinkedList;
import java.util.List;

import com.baidu.hugegraph.driver.GraphManager;
import com.baidu.hugegraph.driver.HugeClient;
import com.baidu.hugegraph.driver.SchemaManager;
import com.baidu.hugegraph.structure.graph.Edge;
import com.baidu.hugegraph.structure.graph.Vertex;

public class BatchExample {

    public static void main(String[] args) {
        // If connect failed will throw a exception.
        HugeClient hugeClient = new HugeClient("http://localhost:8080", "hugegraph");

        SchemaManager schema = hugeClient.schema();

        schema.propertyKey("name").asText().ifNotExist().create();
        schema.propertyKey("age").asInt().ifNotExist().create();
        schema.propertyKey("lang").asText().ifNotExist().create();
        schema.propertyKey("date").asText().ifNotExist().create();
        schema.propertyKey("price").asInt().ifNotExist().create();

        schema.vertexLabel("person")
              .properties("name", "age")
              .primaryKeys("name")
              .ifNotExist()
              .create();

        schema.vertexLabel("person")
              .properties("price")
              .nullableKeys("price")
              .append();

        schema.vertexLabel("software")
              .properties("name", "lang", "price")
              .primaryKeys("name")
              .ifNotExist()
              .create();

        schema.indexLabel("softwareByPrice")
              .onV("software").by("price")
              .range()
              .ifNotExist()
              .create();

        schema.edgeLabel("knows")
              .link("person", "person")
              .properties("date")
              .ifNotExist()
              .create();

        schema.edgeLabel("created")
              .link("person", "software")
              .properties("date")
              .ifNotExist()
              .create();

        schema.indexLabel("createdByDate")
              .onE("created").by("date")
              .secondary()
              .ifNotExist()
              .create();

        GraphManager graph = hugeClient.graph();

        Vertex marko = new Vertex("person").property("name", "marko")
                                           .property("age", 29);
        Vertex vadas = new Vertex("person").property("name", "vadas")
                                           .property("age", 27);
        Vertex lop = new Vertex("software").property("name", "lop")
                                           .property("lang", "java")
                                           .property("price", 328);
        Vertex josh = new Vertex("person").property("name", "josh")
                                          .property("age", 32);
        Vertex ripple = new Vertex("software").property("name", "ripple")
                                              .property("lang", "java")
                                              .property("price", 199);
        Vertex peter = new Vertex("person").property("name", "peter")
                                           .property("age", 35);

        // Create a list to put vertex(Default max size is 500)
        List<Vertex> vertices = new LinkedList<>();
        vertices.add(marko);
        vertices.add(vadas);
        vertices.add(lop);
        vertices.add(josh);
        vertices.add(ripple);
        vertices.add(peter);

        // Post a vertex list to server
        vertices = graph.addVertices(vertices);
        vertices.forEach(vertex -> System.out.println(vertex));

        Edge markoKnowsVadas = new Edge("knows").source(marko).target(vadas)
                                                .property("date", "20160110");
        Edge markoKnowsJosh = new Edge("knows").source(marko).target(josh)
                                               .property("date", "20130220");
        Edge markoCreateLop = new Edge("created").source(marko).target(lop)
                                                 .property("date", "20171210");
        Edge joshCreateRipple = new Edge("created").source(josh).target(ripple)
                                                   .property("date", "20171210");
        Edge joshCreateLop = new Edge("created").source(josh).target(lop)
                                                .property("date", "20091111");
        Edge peterCreateLop = new Edge("created").source(peter).target(lop)
                                                 .property("date", "20170324");

        // Create a list to put edge(Default max size is 500)
        List<Edge> edges = new LinkedList<>();
        edges.add(markoKnowsVadas);
        edges.add(markoKnowsJosh);
        edges.add(markoCreateLop);
        edges.add(joshCreateRipple);
        edges.add(joshCreateLop);
        edges.add(peterCreateLop);

        // Post a edge list to server
        edges = graph.addEdges(edges, false);
        edges.forEach(edge -> System.out.println(edge));
    }
}
```

### 4.4 运行Example

运行Example之前需要启动Sever, 启动过程见[HugeGraph-Server Quick Start](/quickstart/hugegraph-server.md)

### 4.5 Example示例说明

示例说明见[HugeGraph-Client基本API介绍](/clients/hugegraph-client.md)
