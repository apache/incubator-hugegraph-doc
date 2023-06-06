---
title: "在 IDEA 中配置 HugeGraph-Server 开发环境"
linkTitle: "在 IDEA 中配置 HugeGraph-Server 开发环境"
weight: 4
---

> 注意：下述配置仅供参考，基于[这个版本](https://github.com/apache/incubator-hugegraph/commit/a946ad1de4e8f922251a5241ffc957c33379677f)，在 Linux 和 macOS 平台下进行了测试。

### 背景

在 [Quick Start](/docs/quickstart/hugegraph-server/) 部分已经介绍了使用**脚本**启停 HugeGraphServer 的流程。下面以 Linux 平台为例，介绍使用 **IntelliJ IDEA** 运行与调试 HugeGraph-Server 的流程。

本地启动的核心与**脚本启动**是一样的：

1. 初始化数据库后端，执行 `InitStore` 类初始化图
2. 启动 HugeGraphServer，执行 `HugeGraphServer` 类加载初始化的图信息启动

在执行下述流程之前，请确保已经克隆了 HugeGraph 的源代码，并且已经配置了 JDK 11 等开发环境。

```bash
git clone https://github.com/apache/hugegraph.git
```

### 步骤

#### 1. 配置文件拷贝

为了避免配置文件的更改影响 Git 的追踪，建议将所需的配置文件拷贝到一个单独的文件夹中：

```bash
cp -r hugegraph-dist/src/assembly/static/scripts hugegraph-dist/src/assembly/static/conf path-to-your-directory
```

将 `path-to-your-directory` 替换为你创建的文件夹的路径。

#### 2. `InitStore` 类初始化图

首先，需要在配置文件中配置数据库后端。以 RocksDB 为例，在 `path-to-your-directory/conf/graphs/hugegraph.properties` 文件中进行以下配置：

```properties
backend=rocksdb
serializer=binary
rocksdb.data_path=.
rocksdb.wal_path=.
```

然后，打开 IntelliJ IDEA 的 `Run/Debug Configurations` 面板，创建一个新的 Application 配置，按照以下步骤进行配置：

- 在 `Use classpath of module` 中选择 `hugegraph-dist`
- 将 `Main class` 设置为 `org.apache.hugegraph.cmd.InitStore`
- 设置运行参数为 `conf/graphs/hugegraph.properties`，这里的路径是相对于工作路径的，需要将工作路径设置为 `path-to-your-directory`

配置完成后运行，如果运行成功，将会输出以下类似运行日志：

```java
2023-06-05 00:43:37 [main] [INFO] o.a.h.u.ConfigUtil - Scanning option 'graphs' directory './conf/graphs'
2023-06-05 00:43:37 [main] [INFO] o.a.h.c.InitStore - Init graph with config file: ./conf/graphs/hugegraph.properties
......
2023-06-05 00:43:39 [main] [INFO] o.a.h.b.s.r.RocksDBStore - Write down the backend version: 1.11
2023-06-05 00:43:39 [main] [INFO] o.a.h.StandardHugeGraph - Graph 'hugegraph' has been initialized
2023-06-05 00:43:39 [main] [INFO] o.a.h.StandardHugeGraph - Close graph standardhugegraph[hugegraph]
2023-06-05 00:43:39 [db-open-1] [INFO] o.a.h.b.s.r.RocksDBStore - Opening RocksDB with data path: ./m
2023-06-05 00:43:39 [db-open-1] [INFO] o.a.h.b.s.r.RocksDBStore - Opening RocksDB with data path: ./s
2023-06-05 00:43:39 [db-open-1] [INFO] o.a.h.b.s.r.RocksDBStore - Opening RocksDB with data path: ./g
2023-06-05 00:43:39 [main] [INFO] o.a.h.HugeFactory - HugeFactory shutdown
2023-06-05 00:43:39 [hugegraph-shutdown] [INFO] o.a.h.HugeFactory - HugeGraph is shutting down
```

#### 3. 运行 `HugeGraphServer`

类似地，打开 IntelliJ IDEA 的 `Run/Debug Configurations` 面板，创建一个新的 `Application` 配置，按照以下步骤进行配置：

- 在 `Use classpath of module` 中选择 `hugegraph-dist`
- 将 `Main class` 设置为 `org.apache.hugegraph.dist.HugeGraphServer`
- 设置运行参数为 `conf/gremlin-server.yaml conf/rest-server.properties`，同样地，这里的路径是相对于工作路径的，需要将工作路径设置为 `path-to-your-directory`

配置完成后运行，如果看到以下类似日志，表示 `HugeGraphServer` 已经成功启动：

```java
......
2023-06-05 00:51:56 [gremlin-server-boss-1] [INFO] o.a.t.g.s.GremlinServer - Gremlin Server configured with worker thread pool of 1, gremlin pool of 8 and boss thread pool of 1.
2023-06-05 00:51:56 [gremlin-server-boss-1] [INFO] o.a.t.g.s.GremlinServer - Channel started at port 8182.
```

#### 4. 调试 `HugeGraphServer` (可选)

在完成上述配置后，可以尝试对 `HugeGraphServer` 进行调试。在调试模式下运行 `HugeGraphServer`，并在以下[位置](https://github.com/apache/hugegraph/blob/a946ad1de4e8f922251a5241ffc957c33379677f/hugegraph-api/src/main/java/org/apache/hugegraph/api/graph/VertexAPI.java#L238)设置断点：

```java
public String list(@Context GraphManager manager,
                   @PathParam("graph") String graph, @QueryParam("label") String label,
                   @QueryParam("properties") String properties, ......) {
    // ignore log
    Map<String, Object> props = parseProperties(properties);
```

然后，使用 RESTful API 请求 `HugeGraphServer`：

```bash
curl "http://localhost:8080/graphs/hugegraph/graph/vertices" | gunzip
```

此时，可以在调试器中查看详细的变量信息。

### 可能遇到的问题

*** java: package sun.misc does not exist ***

原因可能是在使用 Java 11 编译时触发了交叉编译，导致项目中使用的 `sun.misc.Unsafe` 找不到符号。有两种解决方案可供选择：

1. 在 IntelliJ IDEA 的 `Preferences/Settings` 中找到 `Java Compiler` 面板，然后关闭 `--release` 选项 (推荐)
2. 或者将项目的 SDK 版本设置为 8

##### 参考

1. [HugeGraph-Server Quick Start](/docs/quickstart/hugegraph-server/)
2. [hugegraph-server 本地调试文档 (Win/Unix)](https://gist.github.com/imbajin/1661450f000cd62a67e46d4f1abfe82c)
3. ["package sun.misc does not exist" compilation error](https://youtrack.jetbrains.com/issue/IDEA-180033)
4. [Cannot compile: java: package sun.misc does not exist](https://youtrack.jetbrains.com/issue/IDEA-201168)
