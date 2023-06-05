---
title: "如何在 IDEA 中搭建 HugeGraph-Server 开发环境"
linkTitle: "如何在 IDEA 中搭建 HugeGraph-Server 开发环境"
weight: 4
---

> 注意：下述配置仅供参考，基于[这个版本](https://github.com/apache/incubator-hugegraph/commit/a946ad1de4e8f922251a5241ffc957c33379677f)，在 Linux 和 macOS 平台下进行了测试。

### 背景

在 [Quick Start](/docs/quickstart/hugegraph-server/) 部分中已经给出了使用脚本启停 HugeGraphServer 的流程，但是对于开发者而言，这种方式没有与 IDE 工具集成，使用脚本会较为繁琐，调试起来也比较麻烦。下面以 Linux 平台为例，介绍使用 IntelliJ IDEA 运行与调试 HugeGraph-Server 的流程。

本地启动的核心与**脚本启动**是一样的：

1. 初始化数据库后端, 执行 `InitStore` 类初始化图
2. 启动 HugeGraphServer，执行 `HugeGraphServer` 类加载初始化的图信息启动

在进行下述流程前，请确保已经 clone 了 HugeGraph 的源代码，并且已经配置了 JDK 11 等开发环境。

```
git clone https://github.com/apache/hugegraph.git
cd hugegraph
```

### 步骤

#### 1. 配置文件拷贝

为了避免配置文件的变动影响 Git 的追踪，建议将所需的配置文件拷贝到一个单独的文件夹中：

```
cp -r hugegraph-dist/src/assembly/static/scripts hugegraph-dist/src/assembly/static/conf <path-to-your-directory>
```

#### 2. `InitStore` 运行配置

首先，需要在拷贝的文件中配置数据库后端，这里以 RocksDB 为例，打开 `<path-to-your-directory>/conf/graphs/hugegraph.properties`，配置如下：

```
backend=rocksdb
serializer=binary
rocksdb.data_path=.
rocksdb.wal_path=.
```

然后，打开 IDEA 的 `Run/Debug configurations` 面板，新建一个 `Application`，进行如下配置：

- 选中 `Use classpath of module`  为 `hugegraph-dist`
- 设置 `Main class` 为 `org.apache.hugegraph.cmd.InitStore` 类
- 设置运行参数为 `conf/graphs/hugegraph.properties`，这里的路径是相对于工作路径的，需要设置工作路径为 `<path-to-your-directory>`

配置完成后运行，如果运行成功，会打印下述运行日志：

```
2023-06-05 00:43:37 [main] [INFO] o.a.h.u.ConfigUtil - Scanning option 'graphs' directory './conf/graphs'
2023-06-05 00:43:37 [main] [INFO] o.a.h.c.InitStore - Init graph with config file: ./conf/graphs/hugegraph.properties
2023-06-05 00:43:38 [db-open-1] [INFO] o.a.h.b.s.r.RocksDBStore - Opening RocksDB with data path: ./m
2023-06-05 00:43:38 [db-open-1] [INFO] o.a.h.b.s.r.RocksDBStore - Failed to open RocksDB './m' with database 'hugegraph', try to init CF later
2023-06-05 00:43:38 [main] [INFO] o.a.h.b.c.CacheManager - Init RamCache for 'schema-id-hugegraph' with capacity 10000
2023-06-05 00:43:38 [main] [INFO] o.a.h.b.c.CacheManager - Init RamCache for 'schema-name-hugegraph' with capacity 10000
2023-06-05 00:43:38 [db-open-1] [INFO] o.a.h.b.s.r.RocksDBStore - Opening RocksDB with data path: ./s
main dict load finished, time elapsed 697 ms
model load finished, time elapsed 64 ms.
2023-06-05 00:43:39 [db-open-1] [INFO] o.a.h.b.s.r.RocksDBStore - Opening RocksDB with data path: ./g
2023-06-05 00:43:39 [main] [INFO] o.c.o.l.Uns - OHC using JNA OS native malloc/free
2023-06-05 00:43:39 [main] [INFO] o.a.h.b.c.CacheManager - Init LevelCache for 'vertex-hugegraph' with capacity 10000:10000000
2023-06-05 00:43:39 [main] [INFO] o.a.h.b.c.CacheManager - Init LevelCache for 'edge-hugegraph' with capacity 1000:1000000
2023-06-05 00:43:39 [main] [INFO] o.a.h.b.c.CacheManager - Init RamCache for 'users-hugegraph' with capacity 10240
2023-06-05 00:43:39 [main] [INFO] o.a.h.b.c.CacheManager - Init RamCache for 'users_pwd-hugegraph' with capacity 10240
2023-06-05 00:43:39 [main] [INFO] o.a.h.b.c.CacheManager - Init RamCache for 'token-hugegraph' with capacity 10240
2023-06-05 00:43:39 [main] [INFO] o.a.h.b.s.r.RocksDBStore - Write down the backend version: 1.11
2023-06-05 00:43:39 [main] [INFO] o.a.h.StandardHugeGraph - Graph 'hugegraph' has been initialized
2023-06-05 00:43:39 [main] [INFO] o.a.h.StandardHugeGraph - Close graph standardhugegraph[hugegraph]
2023-06-05 00:43:39 [db-open-1] [INFO] o.a.h.b.s.r.RocksDBStore - Opening RocksDB with data path: ./m
2023-06-05 00:43:39 [db-open-1] [INFO] o.a.h.b.s.r.RocksDBStore - Opening RocksDB with data path: ./s
2023-06-05 00:43:39 [db-open-1] [INFO] o.a.h.b.s.r.RocksDBStore - Opening RocksDB with data path: ./g
2023-06-05 00:43:39 [main] [INFO] o.a.h.HugeFactory - HugeFactory shutdown
2023-06-05 00:43:39 [hugegraph-shutdown] [INFO] o.a.h.HugeFactory - HugeGraph is shutting down
```

#### 3. `HugeGraphServer` 运行配置

类似的，打开 IDEA 的 `Run/Debug configurations` 面板，新建一个 `Application`，进行如下配置：

- 选中 `Use classpath of module`  为 `hugegraph-dist`
- 设置 `Main class` 为 `org.apache.hugegraph.dist.HugeGraphServer` 类
- 设置运行参数为 `conf/gremlin-server.yaml conf/rest-server.properties`，同样的，这里的路径是相对于工作路径的，需要设置工作路径为 `<path-to-your-directory>`

配置完成后运行，如果看到下述日志，代表 `HugeGraphServer` 已经成功启动：

```
......
2023-06-05 00:51:56 [gremlin-server-boss-1] [INFO] o.a.t.g.s.GremlinServer - Gremlin Server configured with worker thread pool of 1, gremlin pool of 8 and boss thread pool of 1.
2023-06-05 00:51:56 [gremlin-server-boss-1] [INFO] o.a.t.g.s.GremlinServer - Channel started at port 8182.
```

#### 4. 调试 `HugeGraphServer`

在完成上述配置后，可以尝试对 `HugeGraphServer` 进行调试，使用调试模式运行 `HugeGraphServer` 后，在下述对应的[位置](https://github.com/apache/hugegraph/blob/a946ad1de4e8f922251a5241ffc957c33379677f/hugegraph-api/src/main/java/org/apache/hugegraph/api/graph/VertexAPI.java#L238)打断点：

```java
@GET
@Timed
@Compress
@Produces(APPLICATION_JSON_WITH_CHARSET)
@RolesAllowed({"admin", "$owner=$graph $action=vertex_read"})
public String list(@Context GraphManager manager,
                   @PathParam("graph") String graph,
                   @QueryParam("label") String label,
                   @QueryParam("properties") String properties,
                   @QueryParam("keep_start_p")
                   @DefaultValue("false") boolean keepStartP,
                   @QueryParam("offset") @DefaultValue("0") long offset,
                   @QueryParam("page") String page,
                   @QueryParam("limit") @DefaultValue("100") long limit) {
    LOG.debug("Graph [{}] query vertices by label: {}, properties: {}, " +
              "offset: {}, page: {}, limit: {}",
              graph, label, properties, offset, page, limit);
    Map<String, Object> props = parseProperties(properties);
```
然后使用 RESTful API 请求 `HugeGraphServer`
```
curl "http://localhost:8080/graphs/hugegraph/graph/vertices" | gunzip
```
此时可以在 Debugger 中查看详细的变量信息。

### 可能出现的问题

#### java: package sun.misc does not exist

原因可能因为使用 Java 11 编译时触发了交叉编译，导致项目中使用的 `sun.misc.Unsafe` 找不到符号，有两种解决方案：

1. 设置 Project SDK 为 8，或者
2. 在 IDEA 的 `Preference` 中找到 `Java Compiler` 面板，然后关闭 `--release` 选项

### 参考

1. [HugeGraph-Server Quick Start](/docs/quickstart/hugegraph-server/)
2. [hugegraph-server 本地调试文档 (Win/Unix)](https://gist.github.com/imbajin/1661450f000cd62a67e46d4f1abfe82c)
3. ["package sun.misc does not exist" compilation error](https://youtrack.jetbrains.com/issue/IDEA-180033)
4. [Cannot compile: java: package sun.misc does not exist](https://youtrack.jetbrains.com/issue/IDEA-201168)