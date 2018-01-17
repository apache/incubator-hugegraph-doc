#  HugeStudio Quick Start


## 1.HugeStudio概述


HugeStudio是HugeGraph的前端展示工具，是基于Web的图形化IDE环境，包括studio-api，studio-server，studio
-dist和studio-ui四个功能模块。HugeStudio是为用户提供图形数据库实践的最佳工具，功能包括：


**1.图数据的输入**
<br />

**2.图数据的展示**
<br />

**3.图数据的分析**

##### 注意：

- HugeStudio需要依赖HugeGraph Server，在安装和使用HugeStudio之前，请通过jps命令检查Cassandra，HugeGraphServer 
和HugeGremlinServer三个服务已经启动，如果没有启动这三个服务，请参考[HugeServer安装配置](http://hugegraph.baidu.com/quickstart/hugeserver.html)。


## 2.安装和运行HugeStudio


有两种方式可以获取HugeStudio：

* 下载源码包编译安装

* 下载二进制tar包


### 2.1  下载源码编译生成tar包


* 下载HugeStudio源码包：(暂时从icode上clone)

```
$ git clone ssh://liunanke@icode.baidu.com:8235/baidu/xbu-data/hugegraph-studio baidu/xbu-data/hugegraph-studio && scp -p -P 8235 liunanke@icode.baidu.com:hooks/commit-msg baidu/xbu-data/hugegraph-studio/.git/hooks/
```

* 编译生成tar包:

```
$ cd hugegraph-studio
$ mvn package -DskipTests
```
* 执行结果如下：

```
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] 
[INFO] hugegraph-studio ................................... SUCCESS [  0.735 s]
[INFO] studio-server: Embed tomcat server ................. SUCCESS [  3.825 s]
[INFO] studio-api: RESTful api for hugegraph-studio ....... SUCCESS [  5.918 s]
[INFO] studio-dist: Tar and Distribute Archives ........... SUCCESS [ 48.349 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 59.055 s
[INFO] Finished at: 2017-07-27T17:23:05+08:00
[INFO] Final Memory: 57M/794M
[INFO] ------------------------------------------------------------------------
```

* 执行成功后,在hugegraph-studio目录下生成hugestudio-release-0.X-SNAPSHOT文件夹以及
hugestudio-release-0.X-SNAPSHOT.tar.gz文件，即为编译生成的tar包。

### 2.2  下载二进制tar包


可以从以下地址下载:

```
wget http://yq01-sw-hdsserver16.yq01.baidu.com:8080/hadoop-web-proxy/yqns02/hugegraph/hugestudio/hugestudio-release-0.3-SNAPSHOT.tar.gz
```
下载完成后解压缩：

```
$ tar zxvf hugestudio-release-0.3-SNAPSHOT.tar.gz
```

注：如果在服务器部署，执行解压命令后，还需修改配置文件如下所示：
```
$ cd hugestudio-release-0.3-SNAPSHOT
$ vim conf/hugestudio.properties
```
将"server.httpBindAddress=localhost" 中的 localhost 修改成服务器地址，再进行下一步操作。




## 3. 启动HugeStudio


* 启动命令如下:

```
$ cd hugestudio-release-0.3-SNAPSHOT
$ bin/hugestudio.sh
```

* 启动成功结果如下：

```
19:05:12.779 [localhost-startStop-1] INFO  org.springframework.web.context.ContextLoader ID:  TS: - Root WebApplicationContext: initialization started
19:05:12.910 [localhost-startStop-1] INFO  org.springframework.web.context.support.XmlWebApplicationContext ID:  TS: - Refreshing Root WebApplicationContext: startup date [Thu Jul 27 19:05:12 CST 2017]; root of context hierarchy
19:05:12.973 [localhost-startStop-1] INFO  org.springframework.beans.factory.xml.XmlBeanDefinitionReader ID:  TS: - Loading XML bean definitions from class path resource [applicationContext.xml]
19:05:13.402 [localhost-startStop-1] INFO  org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor ID:  TS: - JSR-330 'javax.inject.Inject' annotation found and supported for autowiring
19:05:13.710 [localhost-startStop-1] WARN  com.baidu.hugegraph.config.HugeConfig ID:  TS: - The option: 'server.httpPort' is redundant
19:05:13.711 [localhost-startStop-1] WARN  com.baidu.hugegraph.config.HugeConfig ID:  TS: - The option: 'server.httpBindAddress' is redundant
19:05:13.712 [localhost-startStop-1] WARN  com.baidu.hugegraph.config.HugeConfig ID:  TS: - The option: 'server.ui' is redundant
19:05:13.712 [localhost-startStop-1] WARN  com.baidu.hugegraph.config.HugeConfig ID:  TS: - The option: 'server.api.war' is redundant
19:05:13.719 [localhost-startStop-1] INFO  com.baidu.hugegraph.studio.connections.repository.FileConnectionRepository ID:  TS: - connectionsDataDirectory=/Users/liunanke/.hugestudio/connections
19:05:13.744 [localhost-startStop-1] WARN  com.baidu.hugegraph.config.HugeConfig ID:  TS: - The option: 'server.httpPort' is redundant
19:05:13.744 [localhost-startStop-1] WARN  com.baidu.hugegraph.config.HugeConfig ID:  TS: - The option: 'server.httpBindAddress' is redundant
19:05:13.744 [localhost-startStop-1] WARN  com.baidu.hugegraph.config.HugeConfig ID:  TS: - The option: 'server.ui' is redundant
19:05:13.744 [localhost-startStop-1] WARN  com.baidu.hugegraph.config.HugeConfig ID:  TS: - The option: 'server.api.war' is redundant
19:05:13.745 [localhost-startStop-1] INFO  com.baidu.hugegraph.studio.notebook.repository.FileNotebookRepository ID:  TS: - notebooksDataDirectory is /Users/liunanke/.hugestudio/notebooks
19:05:13.753 [localhost-startStop-1] INFO  org.springframework.web.context.ContextLoader ID:  TS: - Root WebApplicationContext: initialization completed in 968 ms
····
19:05:14.873 [main] INFO  com.baidu.hugegraph.studio.HugeStudio ID:  TS: - HugeStudio is now running on: http://localhost:8080
```
<br />

接下来，打开浏览器访问 http://localhost:8080 即可使用HugeStudio，首页如下图：

![image](/images/images-stdio/home-page.png)
　　　　　　图 3-1 HugeStudio首页

## 4. HugeStudio 操作指南


#### 4.1 创建一个新的 connection


在创建notebook之前，首先要创建一个connection，用来绑定一个特定的graph。点击页面右上角setting 选择connections，进入 connections page，点击add按钮进行添加，如下图所示：
                                      ![image](/images/images-stdio/goto-connections.png)
　　　　　　　　　　　　　　　　　　　　　　　　图 4-1 跳转到Connections-Page                                                       

按要求填写信息，创建connection：
<br />
                                      ![image](/images/images-stdio/add-connection.png)
　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　图 4-2 创建connection

完成后可以看到创建成功的connection：
<br />
                                      ![image](/images/images-stdio/broswer-connection.png)
　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　图 4-3 浏览connection


#### 4.2 创建一个Notebook


创建完connection后，返回Notebooks page，选择添加notebook，在弹出框填入相应信息，选择一个connection，点击create，如下图所示：
                                      ![image](/images/images-stdio/add-notebook.png)
　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　图 4-4 创建notebook


完成后可以看到创建成功的notebook：
                                      ![image](/images/images-stdio/broswer-notebooks.png)
　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　图 4-5 浏览notebook


点击创建的notebook，进入notebook界面，notebook默认有一个cell，更改drop-down 选择Markdown，添加一些文字，点击cell右上角run 按钮既可展示出添加的内容，如下图所示：
                                      ![image](/images/images-stdio/cell-example-markdown.png)
 　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　 图 4-6 编辑markdown
#### 4.3 使用Gremlin语言创建一个Graph


##### 4.3.1 创建schema



这里以Software-graph为例子，数据中schema分为三类分别是：PropertyKey，VertexLabel和EdgeLabel。

<br />
首先在notebook的cell中创建PropertyKey，将以下语句输入到cell中：

```
graph.schema().propertyKey("name").asText().ifNotExist().create()
graph.schema().propertyKey("age").asInt().ifNotExist().create()
graph.schema().propertyKey("city").asText().ifNotExist().create()
graph.schema().propertyKey("lang").asText().ifNotExist().create()
graph.schema().propertyKey("date").asText().ifNotExist().create()
graph.schema().propertyKey("price").asInt().ifNotExist().create()
```

执行完成后，可以得到返回的数据，表明执行成功。如图所示：
                                      ![image](/images/images-stdio/add-schema.png)
                                                 
　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　图 4-7 创建schema

接下来进行顶点类型（VertexLabel）和 边类型 （EdgeLabel）的创建：

```
person = graph.schema().vertexLabel("person").properties("name", "age", "city").primaryKeys("name").ifNotExist().create()

software = graph.schema().vertexLabel("software").properties("name", "lang", "price").primaryKeys("name").ifNotExist().create()
```

```
knows = graph.schema().edgeLabel("knows").sourceLabel("person").targetLabel("person").properties("date").ifNotExist().create()

created = graph.schema().edgeLabel("created").sourceLabel("person").targetLabel("software").properties("date", "city").ifNotExist().create()
```

创建完成后，可以点击页面右上方的schema按钮，查看创建的schema内容的分类展示，如图：
                                      ![image](/images/images-stdio/schema-view.png)
    　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　 图 4-8 展示schema-view

##### 4.3.2 创建顶点（vertices）和边 （edges）


有了schema后，就可以根据schema创建特定的顶点和边了，这里我们定义两个person类型的顶点实例：marko 和 
vadas，在定义两者之间的关系knows：

```
marko = graph.addVertex(T.label, "person", "name", "marko", "age", 29, "city", "Beijing")
vadas = graph.addVertex(T.label, "person", "name", "vadas", "age", 27, "city", "Hongkong")

marko.addEdge("knows", vadas, "date", "20160110")
```

在页面中输入语句，这样我们就创建了两个顶点一条边，点击执行，结果如下图所示：
                                      ![image](/images/images-stdio/cell-example-2V-1E.png)
    　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　 图 4-9 插入两个顶点一条边
##### 4.3.3 向graph添加更多数据


```
marko = graph.addVertex(T.label, "person", "name", "marko", "age", 29, "city", "Beijing")
vadas = graph.addVertex(T.label, "person", "name", "vadas", "age", 27, "city", "Hongkong")
lop = graph.addVertex(T.label, "software", "name", "lop", "lang", "java", "price", 328)
josh = graph.addVertex(T.label, "person", "name", "josh", "age", 32, "city", "Beijing")
ripple = graph.addVertex(T.label, "software", "name", "ripple", "lang", "java", "price", 199)
peter = graph.addVertex(T.label, "person","name", "peter", "age", 29, "city", "Shanghai")

marko.addEdge("knows", vadas, "date", "20160110")
marko.addEdge("knows", josh, "date", "20130220")
marko.addEdge("created", lop, "date", "20171210", "city", "Shanghai")
josh.addEdge("created", ripple, "date", "20171210", "city", "Beijing")
josh.addEdge("created", lop, "date", "20091111", "city", "Beijing")

g.V()
```

如下图所示：
                                      ![image](/images/images-stdio/add-connection.png)
    　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　 图 4-10 插入更多数据

HugeStudio不仅支持通过graph的方式展示数据，还支持table和格式化json两种数据展示形式：


**Table:**
                                      ![image](/images/images-stdio/cell-table.png)
    　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　 图 4-11 Table展示数据


**Formative-Json:**
                                      ![image](/images/images-stdio/cell-json.png)
    　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　 图 4-12 Formative-Json展示数据



