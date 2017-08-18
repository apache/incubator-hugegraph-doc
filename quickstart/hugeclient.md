# HugeClient Quick Start

##  1. HugeClient 概述


HugeGraph-Client目前只提供了Java版，用户可以使用HugeGraph-Client连接HugeGraph-Server，并编写Java代码操作HugeGraph，比如元数据和图数据的增删改查，或者执行gremlin语句。


##  2. 环境要求


* jdk1.8
* maven-3.3.9
 
**注：HugeClient只依赖于JDK，maven环境只提供更方便快捷的下载HugeClient jar包，也可换其他依赖管理工具，例如Gradle。暂时HugeClient jar包只部署在maven私服**


## 3.使用流程


使用HugeClient的基本步骤如下:
    
   1. 新建Eclipse/ IDEA Maven项目；
   2. 在pom文件中添加HugeClient依赖；
   3. 创建类，调用HugeClient接口；

详细使用过程见下节完整示例。


## 4. 完整示例


### 4.1 新建Maven工程


可以选择Eclipse或者Intellij Idea创建工程：

* [Eclipse新建Maven工程](http://www.vogella.com/tutorials/EclipseMaven/article.html)
* [Intellij Idea 创建maven工程](https://vaadin.com/docs/-/part/framework/getting-started/getting-started-idea.html)
 
### 4.2 引入hugegraph-client依赖
目前有以下两种方式在项目中引入hugegraph-client.jar包，如下：

(1)修改本地Maven的setting.xml文件，添加百度profile，如下：


```
  <profile>
      <id>baidu</id>
      <repositories>
        <repository>
          <id>baidu-nexus</id>
          <url>http://maven.scm.baidu.com:8081/nexus/content/groups/public</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>true</enabled>
          </snapshots>
        </repository>
        <repository>
          <id>Baidu_Local</id>
          <url>http://maven.scm.baidu.com:8081/nexus/content/repositories/Baidu_Local</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>true</enabled>
          </snapshots>
        </repository>
        <repository>
          <id>Baidu_Local_Snapshots</id>
          <url>http://maven.scm.baidu.com:8081/nexus/content/repositories/Baidu_Local_Snapshots</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>true</enabled>
          </snapshots>
        </repository>
      </repositories>
      <pluginRepositories>
        <pluginRepository>
          <id>baidu-nexus</id>
          <url>http://maven.scm.baidu.com:8081/nexus/content/groups/public</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>true</enabled>
          </snapshots>
        </pluginRepository>
      </pluginRepositories>
  </profile>
  <activeProfiles>
           <activeProfile>baidu</activeProfile>
  </activeProfiles>
```
 
(2)在项目pom文件中引入百度私服仓库：


```
<repositories>
    <repository>
        <id>Baidu_Local_Snapshots</id>
        <url>http://maven.scm.baidu.com:8081/nexus/content/repositories/Baidu_Local_Snapshots</url>
    </repository>
</repositories>
```

使用方式（1）或（2）添加百度仓库地址后，在pom文件中添加依赖，即可引入jar包：

```
<dependencies>
    <dependency>
        <groupId>com.baidu.hugegraph</groupId>
        <artifactId>hugegraph-client</artifactId>
        <version>1.3.0-SNAPSHOT</version>
    </dependency>    
</dependencies>
```
其中，`com.baidu.hugegraph.hugegraph-client` 为hugegraph-client的相关依赖。


### 4.3 新建Example类，如下：


```
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import com.baidu.hugegraph.driver.GraphManager;
import com.baidu.hugegraph.driver.GremlinManager;
import com.baidu.hugegraph.driver.HugeClient;
import com.baidu.hugegraph.driver.SchemaManager;
import com.baidu.hugegraph.structure.GraphElement;
import com.baidu.hugegraph.structure.constant.T;
import com.baidu.hugegraph.structure.graph.Edge;
import com.baidu.hugegraph.structure.graph.Path;
import com.baidu.hugegraph.structure.graph.Vertex;
import com.baidu.hugegraph.structure.gremlin.Result;
import com.baidu.hugegraph.structure.gremlin.ResultSet;
import com.baidu.hugegraph.structure.schema.EdgeLabel;
import com.baidu.hugegraph.structure.schema.VertexLabel;

public class SingleExample {

    public static void main(String[] args) throws IOException {
        // If connect failed will throw a exception.
        HugeClient hugeClient = HugeClient.open("http://localhost:8080", "hugegraph");

        SchemaManager schema = hugeClient.schema();

        schema.propertyKey("name").asText().ifNotExist().create();
        schema.propertyKey("age").asInt().ifNotExist().create();
        schema.propertyKey("lang").asText().ifNotExist().create();
        schema.propertyKey("date").asText().ifNotExist().create();
        schema.propertyKey("price").asInt().ifNotExist().create();

        VertexLabel person = schema.vertexLabel("person")
                .properties("name", "age")
                .primaryKeys("name")
                .ifNotExist()
                .create();

        schema.vertexLabel("person")
                .properties("price")
                .append();

        VertexLabel software = schema.vertexLabel("software")
                .useCustomizeId()
                .properties("name", "lang", "price")
                .ifNotExist()
                .create();

        schema.indexLabel("personByName")
                .on(person).by("name")
                .secondary()
                .ifNotExist()
                .create();

        schema.indexLabel("softwareByPrice")
                .on(software).by("price")
                .search()
                .ifNotExist()
                .create();

        EdgeLabel knows = schema.edgeLabel("knows")
                .link("person", "person")
                .properties("date")
                .ifNotExist()
                .create();

        EdgeLabel created = schema.edgeLabel("created")
                .link("person", "software")
                .properties("date")
                .ifNotExist()
                .create();

        schema.indexLabel("createdByDate")
                .on(created).by("date")
                .secondary()
                .ifNotExist()
                .create();

        // get schema object by name
        System.out.println(schema.getPropertyKey("name"));
        System.out.println(schema.getVertexLabel("person"));
        System.out.println(schema.getEdgeLabel("knows"));
        System.out.println(schema.getIndexLabel("createdByDate"));

        // list all schema objects
        System.out.println(schema.getPropertyKeys());
        System.out.println(schema.getVertexLabels());
        System.out.println(schema.getEdgeLabels());
        System.out.println(schema.getIndexLabels());

        GraphManager graph = hugeClient.graph();

        Vertex marko = graph.addVertex(T.label, "person",
                "name", "marko", "age", 29);
        Vertex vadas = graph.addVertex(T.label, "person",
                "name", "vadas", "age", 27);
        Vertex lop = graph.addVertex(T.label, "software", T.id, "software-lop",
                "name", "lop", "lang", "java", "price", 328);
        Vertex josh = graph.addVertex(T.label, "person",
                "name", "josh", "age", 32);
        Vertex ripple = graph.addVertex(T.label, "software", T.id, "123456",
                "name", "ripple", "lang", "java", "price", 199);
        Vertex peter = graph.addVertex(T.label, "person",
                "name", "peter", "age", 35);

        marko.addEdge("knows", vadas, "date", "20160110");
        marko.addEdge("knows", josh, "date", "20130220");
        marko.addEdge("created", lop, "date", "20171210");
        josh.addEdge("created", ripple, "date", "20171210");
        josh.addEdge("created", lop, "date", "20091111");
        peter.addEdge("created", lop, "date", "20170324");

        GremlinManager gremlin = hugeClient.gremlin();
        System.out.println("==== Vertex ====");
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
                List<GraphElement> elements = ((Path) object).objects();
                elements.stream().forEach(element -> {
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


## 4.4 运行Example

运行Example之前需要启动Sever,启动过程见[HugeServer Quick Start](http://hugegraph.baidu.com/quickstart/hugeserver.html)

## 4.5 Example示例说明

示例说明见[HugeClient基本概念介绍](http://hugegraph.baidu.com/document/hugeclient-doc.html)