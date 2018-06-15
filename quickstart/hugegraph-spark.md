## HugeGraph-Spark Quick Start

### 1 项目依赖

HugeGraph-Spark依赖hugegraph 和 spark-2.1.1，需要添加相关项目依赖：

- 下载spark-2.1.1
- [启动HugeGraph-Server](/quickstart/hugegraph-server.html)

### 2 下载 HugeGraph-Spark

提供两种方式下载hugespark：

- 直接下载具有hugespark功能的spark安装包：

  [Spark-2.1.1-Hugespark下载地址](https://hugegraph.github.io/hugegraph-doc/downloads/hugespark/hugespark-${version}.tar.gz)

  下载完成后解压即可：

  ```bash
    $ tar -zxvf hugespark-${version}.tar.gz
  ```

- 下载源码，编译hugespark jar包，配置本机spark；

#### 2.1 源码编译

下载spark-2.1.1,解压spark（[Spark文档参考](http://spark.apache.org)），删除过期的guava.jar包

```bash
rm -rf  jars/guava-14.0.1.jar
rm -rf  jars/jackson-module-scala_2.11-2.6.5.jar
rm -rf  jars/jackson-annotations-2.6.5.jar
rm -rf  jars/jackson-module-paranamer-2.6.5.jar
rm -rf  jars/jackson-databind-2.6.5.jar
rm -rf  jars/jackson-core-2.6.5.jar
```

hugespark源码下载

```bash
$ git clone https://github.com/hugegraph/hugegraph-spark.git
```

使用[Apache Maven](http://maven.apache.org/)构建，示例如下：

```bash
$ cd hugegraph-spark
$ mvn -DskipTests clean assembly:assembly
```

将编译完成的jar包拷贝到spark安装目录下

```bash
$ cp baidu/xbu-data/hugegraph-spark/target/hugegraph-spark-0.1.0-SNAPSHOT-jar-with-dependencies.jar ${spark-dir}/spark-2.1.1/jars/
```

### 3 配置

可以通过spark-default.properties或者命令行修改相关配置：

配置项如下：

配置名称                           | 默认值                 | 说明
------------------------------ | ------------------- | --------------------------------------------------------------------------------------------------------------
`spark.hugegraph.snapshot.dir` | `/tmp/hugesnapshot` | 首次加载hugegraph RDD 保存的位置
`spark.hugegraph.conf.url`     |                     | 获得hugegraph 配置的url，例如，<http://localhost:8080/graphs/hugegraph/conf?token=162f7848-0b6d-4faf-b557-3a0797869c55>
`spark.hugegraph.split.size`   | 67108864            | 从hugegraph中获取顶点和边时数据分割的大小，默认64M

提供两种添加配置项的方法：

- 在conf/spark-defaults.conf中修改

  首次安装的用户需要将spark-defaults.conf.default文件拷贝一份，如下：

  ```bash
    $ cd spark-2.1.1/conf
    $ cp spark-defaults.conf.default spark-defaults.conf
  ```

  然后将上表中的配置项按照示例添加即可。

- 命令行修改配置示例：

  ```bash
    $ spark-shell --conf spark.hugegraph.snapshot.dir=/tmp/hugesnapshot2
  ```

### 4 HugeGraph-Spark Shell 使用

启动Scala shell ：

```bash
./bin/spark-shell
```

导入hugegraph相关类

```scala
import com.baidu.hugegraph.spark._
```

初始化graph对象，并创建snapshot

```scala
val graph = sc.hugeGraph("test","${spark.hugegraph.conf.url}")
```

其中`${spark.hugegraph.conf.url}`默认为`conf/spark-defaults.conf`中配置的参数，可以直接通过`val graph = sc.hugeGraph("test")`来调用。

#### 4.1 操作

数据导入成功后可以对graph进行相关操作，示例如下：

获取边的个数

```scala
graph.vertices.count()
```

获取边的个数

```scala
graph.edges.count()
```

出度top 100

```scala
val top100 = graph.outDegrees.top(100)
val top100HugeGraphID = sc.makeRDD(top100).join(graph.vertices).collect
top100HugeGraphID.map(e=> (e._2._2.vertexIdString,e._2._1)).foreach(println)
```

或使用隐式方法：

```scala
implicit val degreeTop = new Ordering[(Long,Int)]{
    override def compare(a: (Long,Int), b: (Long,Int)) =a._2.compare(b._2)
}
```

PageRank

PageRank的结果仍未一个图，包含`vertices` and `edges`。

```scala
val ranks = graph.pageRank(0.0001)
```

获取 PageRank的top100的顶点 访问vertices的PageRank的过程中会隐式调用myOrd方法，每个vertices包含 (Long,Double)对，comapares方法中仅依据double值比较。

```scala
val top100 = ranks.vertices.top(100)
```

### 5 限制

- 一个分区的的元素个数需要小于40 亿(1<<32)
- 分区的个数需要小于20亿(1<< 31).
