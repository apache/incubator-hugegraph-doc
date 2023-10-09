---
title: "HugeGraph-Server Quick Start"
linkTitle: "Install/Build HugeGraph-Server"
weight: 1
---

### 1 HugeGraph-Server 概述

HugeGraph-Server 是 HugeGraph 项目的核心部分，包含 Core、Backend、API 等子模块。

Core 模块是 Tinkerpop 接口的实现，Backend 模块用于管理数据存储，目前支持的后端包括：Memory、Cassandra、ScyllaDB 以及 RocksDB，API 模块提供 HTTP Server，将 Client 的 HTTP 请求转化为对 Core 的调用。

> 文档中会大量出现 `HugeGraph-Server` 及 `HugeGraphServer` 这两种写法，其他组件也类似。这两种写法含义上并无大的差异，可以这么区分：`HugeGraph-Server` 表示服务端相关组件代码，`HugeGraphServer` 表示服务进程。

### 2 依赖

#### 2.1 安装 Java 11 (JDK 11)

请优先考虑在 Java 11 的环境上启动 `HugeGraph-Server`，目前同时保留对 Java 8 的兼容

**在往下阅读之前务必执行 `java -version` 命令查看 jdk 版本**

```bash
java -version
```

### 3 部署

有四种方式可以部署 HugeGraph-Server 组件：

- 方式 1：使用 Docker 容器 (推荐)
- 方式 2：下载 tar 包
- 方式 3：源码编译
- 方式 4：使用 tools 工具部署 (Outdated)

#### 3.1 使用 Docker 容器 (推荐)
<!-- 3.1 is linked by other place. if change 3.1's title, please check -->
可参考 [Docker 部署方式](https://github.com/apache/incubator-hugegraph/blob/master/hugegraph-dist/README.md)。

我们可以使用 `docker run -itd --name=graph -p 8080:8080 hugegraph/hugegraph` 去快速启动一个内置了 `RocksDB` 的 `Hugegraph server`.

可选项：

1. 可以使用 `docker exec -it graph bash` 进入容器完成一些操作
2. 可以使用 `docker run -itd --name=graph -p 8080:8080 -e PRELOAD="true" hugegraph/hugegraph` 在启动的时候预加载一个 **内置的**样例图。

另外，我们也可以使用 `docker-compose`完成部署，使用用 `docker-compose up -d`, 以下是一个样例的 `docker-compose.yml`:

```yaml
version: '3'
services:
  graph:
    image: hugegraph/hugegraph
    #environment:
    #  - PRELOAD=true
    ports:
      - 18080:8080
```

#### 3.2 下载 tar 包

```bash
# use the latest version, here is 1.0.0 for example
wget https://downloads.apache.org/incubator/hugegraph/1.0.0/apache-hugegraph-incubating-1.0.0.tar.gz
tar zxf *hugegraph*.tar.gz
```

#### 3.3 源码编译

源码编译前请确保安装了 wget 命令

下载 HugeGraph 源代码

```bash
git clone https://github.com/apache/hugegraph.git
```

编译打包生成 tar 包

```bash
cd hugegraph
mvn package -DskipTests
```

执行日志如下：

```bash
......
[INFO] Reactor Summary for hugegraph 1.0.0:
[INFO] 
[INFO] hugegraph .......................................... SUCCESS [  2.405 s]
[INFO] hugegraph-core ..................................... SUCCESS [ 13.405 s]
[INFO] hugegraph-api ...................................... SUCCESS [ 25.943 s]
[INFO] hugegraph-cassandra ................................ SUCCESS [ 54.270 s]
[INFO] hugegraph-scylladb ................................. SUCCESS [  1.032 s]
[INFO] hugegraph-rocksdb .................................. SUCCESS [ 34.752 s]
[INFO] hugegraph-mysql .................................... SUCCESS [  1.778 s]
[INFO] hugegraph-palo ..................................... SUCCESS [  1.070 s]
[INFO] hugegraph-hbase .................................... SUCCESS [ 32.124 s]
[INFO] hugegraph-postgresql ............................... SUCCESS [  1.823 s]
[INFO] hugegraph-dist ..................................... SUCCESS [ 17.426 s]
[INFO] hugegraph-example .................................. SUCCESS [  1.941 s]
[INFO] hugegraph-test ..................................... SUCCESS [01:01 min]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
......
```

执行成功后，在 hugegraph 目录下生成 `*hugegraph-*.tar.gz` 文件，就是编译生成的 tar 包。


#### 3.4 使用 tools 工具部署 (Outdated)

HugeGraph-Tools 提供了一键部署的命令行工具，用户可以使用该工具快速地一键下载、解压、配置并启动 HugeGraph-Server 和 HugeGraph-Hubble，最新的 HugeGraph-Toolchain 中已经包含所有的这些工具，直接下载它解压就有工具包集合了

```bash
# download toolchain package, it includes loader + tool + hubble, please check the latest version (here is 1.0.0)
wget https://downloads.apache.org/incubator/hugegraph/1.0.0/apache-hugegraph-toolchain-incubating-1.0.0.tar.gz
tar zxf *hugegraph-*.tar.gz
# enter the tool's package
cd *hugegraph*/*tool* 
```

> 注：`${version}` 为版本号，最新版本号可参考 [Download 页面](/docs/download/download)，或直接从 Download 页面点击链接下载

HugeGraph-Tools 的总入口脚本是 `bin/hugegraph`，用户可以使用 `help` 子命令查看其用法，这里只介绍一键部署的命令。

```bash
bin/hugegraph deploy -v {hugegraph-version} -p {install-path} [-u {download-path-prefix}]
```

`{hugegraph-version}` 表示要部署的 HugeGraphServer 及 HugeGraphStudio 的版本，用户可查看 `conf/version-mapping.yaml` 文件获取版本信息，`{install-path}` 指定 HugeGraphServer 及 HugeGraphStudio 的安装目录，`{download-path-prefix}` 可选，指定 HugeGraphServer 及 HugeGraphStudio tar 包的下载地址，不提供时使用默认下载地址，比如要启动 0.6 版本的 HugeGraph-Server 及 HugeGraphStudio 将上述命令写为 `bin/hugegraph deploy -v 0.6 -p services` 即可。

### 4 配置

如果需要快速启动 HugeGraph 仅用于测试，那么只需要进行少数几个配置项的修改即可（见下一节）。

详细的配置介绍请参考[配置文档](/docs/config/config-guide)及[配置项介绍](/docs/config/config-option)。

### 5 启动

#### 5.1 使用 Docker

在 [3.1 使用 Docker 容器](#31-使用-docker-容器-推荐)中，我们已经介绍了 如何使用 `docker` 部署 `hugegraph-server`, 我们还可以设置参数在 sever 启动的时候加载样例图

##### 5.1.1 启动 server 的时候创建示例图

在 docker 启动的时候设置环境变量 `PRELOAD=true`, 从而实现启动脚本的时候加载数据。

1. 使用`docker run`

    使用 `docker run -itd --name=graph -p 18080:8080 -e PRELOAD=true hugegraph/hugegraph:latest`

2. 使用`docker-compose`

    创建`docker-compose.yml`，具体文件如下

    ```yaml
    version: '3'
      services:
        graph:
          image: hugegraph/hugegraph:latest
          container_name: graph
          environment:
            - PRELOAD=true
          ports:
            - 18080:8080
    ```

    使用命令 `docker-compose up -d` 启动容器

使用 RESTful API 请求 `HugeGraphServer` 得到如下结果：

```javascript
> curl "http://localhost:18080/graphs/hugegraph/graph/vertices" | gunzip

{"vertices":[{"id":"2:lop","label":"software","type":"vertex","properties":{"name":"lop","lang":"java","price":328}},{"id":"1:josh","label":"person","type":"vertex","properties":{"name":"josh","age":32,"city":"Beijing"}},{"id":"1:marko","label":"person","type":"vertex","properties":{"name":"marko","age":29,"city":"Beijing"}},{"id":"1:peter","label":"person","type":"vertex","properties":{"name":"peter","age":35,"city":"Shanghai"}},{"id":"1:vadas","label":"person","type":"vertex","properties":{"name":"vadas","age":27,"city":"Hongkong"}},{"id":"2:ripple","label":"software","type":"vertex","properties":{"name":"ripple","lang":"java","price":199}}]}
```

代表创建示例图成功。


#### 5.2 使用启动脚本启动

启动分为"首次启动"和"非首次启动"，这么区分是因为在第一次启动前需要初始化后端数据库，然后启动服务。

而在人为停掉服务后，或者其他原因需要再次启动服务时，因为后端数据库是持久化存在的，直接启动服务即可。

HugeGraphServer 启动时会连接后端存储并尝试检查后端存储版本号，如果未初始化后端或者后端已初始化但版本不匹配时（旧版本数据），HugeGraphServer 会启动失败，并给出错误信息。

如果需要外部访问 HugeGraphServer，请修改 `rest-server.properties` 的 `restserver.url` 配置项（默认为 `http://127.0.0.1:8080`），修改成机器名或 IP 地址。

由于各种后端所需的配置（hugegraph.properties）及启动步骤略有不同，下面逐一对各后端的配置及启动做介绍。

##### 5.2.1 RocksDB

<details>
<summary>点击展开/折叠 RocksDB 配置及启动方法</summary>


> RocksDB 是一个嵌入式的数据库，不需要手动安装部署，要求 GCC 版本 >= 4.3.0（GLIBCXX_3.4.10），如不满足，需要提前升级 GCC

修改 `hugegraph.properties`

```properties
backend=rocksdb
serializer=binary
rocksdb.data_path=.
rocksdb.wal_path=.
```

初始化数据库（仅第一次启动时需要）

```bash
cd *hugegraph-${version}
bin/init-store.sh
```

启动 server

```bash
bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

提示的 url 与 `rest-server.properties` 中配置的 `restserver.url` 一致

</details>

##### 5.2.2 HBase

<details>
<summary>点击展开/折叠 HBase 配置及启动方法</summary>

> 用户需自行安装 HBase，要求版本 2.0 以上，[下载地址](https://hbase.apache.org/downloads.html)

修改 hugegraph.properties

```properties
backend=hbase
serializer=hbase

# hbase backend config
hbase.hosts=localhost
hbase.port=2181
# Note: recommend to modify the HBase partition number by the actual/env data amount & RS amount before init store
# it may influence the loading speed a lot
#hbase.enable_partition=true
#hbase.vertex_partitions=10
#hbase.edge_partitions=30
```

初始化数据库（仅第一次启动时需要）

```bash
cd *hugegraph-${version}
bin/init-store.sh
```

启动 server

```bash
bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

> 更多其它后端配置可参考[配置项介绍](/docs/config/config-option)

</details>

##### 5.2.3 MySQL

<details>
<summary>点击展开/折叠 MySQL 配置及启动方法</summary>

> 由于 MySQL 是在 GPL 协议下，与 Apache 协议不兼容，用户需自行安装 MySQL，[下载地址](https://dev.mysql.com/downloads/mysql/)

下载 MySQL 的[驱动包](https://repo1.maven.org/maven2/mysql/mysql-connector-java/)，比如 `mysql-connector-java-8.0.30.jar`，并放入 HugeGraph-Server 的 `lib` 目录下。

修改 `hugegraph.properties`，配置数据库 URL，用户名和密码，`store` 是数据库名，如果没有会被自动创建。

```properties
backend=mysql
serializer=mysql

store=hugegraph

# mysql backend config
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://127.0.0.1:3306
jdbc.username=
jdbc.password=
jdbc.reconnect_max_times=3
jdbc.reconnect_interval=3
jdbc.ssl_mode=false
```

初始化数据库（仅第一次启动时需要）

```bash
cd *hugegraph-${version}
bin/init-store.sh
```

启动 server

```bash
bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

</details>

##### 5.2.4 Cassandra

<details>
<summary>点击展开/折叠 Cassandra 配置及启动方法</summary>

> 用户需自行安装 Cassandra，要求版本 3.0 以上，[下载地址](http://cassandra.apache.org/download/)

修改 hugegraph.properties

```properties
backend=cassandra
serializer=cassandra

# cassandra backend config
cassandra.host=localhost
cassandra.port=9042
cassandra.username=
cassandra.password=
#cassandra.connect_timeout=5
#cassandra.read_timeout=20

#cassandra.keyspace.strategy=SimpleStrategy
#cassandra.keyspace.replication=3
```

初始化数据库（仅第一次启动时需要）

```bash
cd *hugegraph-${version}
bin/init-store.sh
Initing HugeGraph Store...
2017-12-01 11:26:51 1424  [main] [INFO ] org.apache.hugegraph.HugeGraph [] - Opening backend store: 'cassandra'
2017-12-01 11:26:52 2389  [main] [INFO ] org.apache.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph, try init keyspace later
2017-12-01 11:26:52 2472  [main] [INFO ] org.apache.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph, try init keyspace later
2017-12-01 11:26:52 2557  [main] [INFO ] org.apache.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph, try init keyspace later
2017-12-01 11:26:53 2797  [main] [INFO ] org.apache.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_graph
2017-12-01 11:26:53 2945  [main] [INFO ] org.apache.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_schema
2017-12-01 11:26:53 3044  [main] [INFO ] org.apache.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_index
2017-12-01 11:26:53 3046  [pool-3-thread-1] [INFO ] org.apache.hugegraph.backend.Transaction [] - Clear cache on event 'store.init'
2017-12-01 11:26:59 9720  [main] [INFO ] org.apache.hugegraph.HugeGraph [] - Opening backend store: 'cassandra'
2017-12-01 11:27:00 9805  [main] [INFO ] org.apache.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph1, try init keyspace later
2017-12-01 11:27:00 9886  [main] [INFO ] org.apache.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph1, try init keyspace later
2017-12-01 11:27:00 9955  [main] [INFO ] org.apache.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph1, try init keyspace later
2017-12-01 11:27:00 10175 [main] [INFO ] org.apache.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_graph
2017-12-01 11:27:00 10321 [main] [INFO ] org.apache.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_schema
2017-12-01 11:27:00 10413 [main] [INFO ] org.apache.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_index
2017-12-01 11:27:00 10413 [pool-3-thread-1] [INFO ] org.apache.hugegraph.backend.Transaction [] - Clear cache on event 'store.init'
```

启动 server

```bash
bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

</details>

##### 5.2.5 Memory

<details>
<summary>点击展开/折叠 Memory 配置及启动方法</summary>

修改 hugegraph.properties

```properties
backend=memory
serializer=text
```

> Memory 后端的数据是保存在内存中无法持久化的，不需要初始化后端，这也是唯一一个不需要初始化的后端。

启动 server

```bash
bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

提示的 url 与 rest-server.properties 中配置的 restserver.url 一致

</details>

##### 5.2.6 ScyllaDB

<details>
<summary>点击展开/折叠 ScyllaDB 配置及启动方法</summary>

> 用户需自行安装 ScyllaDB，推荐版本 2.1 以上，[下载地址](https://docs.scylladb.com/getting-started/)

修改 hugegraph.properties

```properties
backend=scylladb
serializer=scylladb

# cassandra backend config
cassandra.host=localhost
cassandra.port=9042
cassandra.username=
cassandra.password=
#cassandra.connect_timeout=5
#cassandra.read_timeout=20

#cassandra.keyspace.strategy=SimpleStrategy
#cassandra.keyspace.replication=3
```

由于 scylladb 数据库本身就是基于 cassandra 的"优化版"，如果用户未安装 scylladb，也可以直接使用 cassandra 作为后端存储，只需要把 backend 和 serializer 修改为 scylladb，host 和 post 指向 cassandra 集群的 seeds 和 port 即可，但是并不建议这样做，这样发挥不出 scylladb 本身的优势了。

初始化数据库（仅第一次启动时需要）

```bash
cd *hugegraph-${version}
bin/init-store.sh
```

启动 server

```bash
bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

</details>

##### 5.2.7 启动 server 的时候创建示例图

在脚本启动时候携带 `-p true`参数，表示 preload, 即创建示例图图

```
bin/start-hugegraph.sh -p true
Starting HugeGraphServer in daemon mode...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)......OK
```

并且使用 RESTful API 请求 `HugeGraphServer` 得到如下结果：

```javascript
> curl "http://localhost:8080/graphs/hugegraph/graph/vertices" | gunzip

{"vertices":[{"id":"2:lop","label":"software","type":"vertex","properties":{"name":"lop","lang":"java","price":328}},{"id":"1:josh","label":"person","type":"vertex","properties":{"name":"josh","age":32,"city":"Beijing"}},{"id":"1:marko","label":"person","type":"vertex","properties":{"name":"marko","age":29,"city":"Beijing"}},{"id":"1:peter","label":"person","type":"vertex","properties":{"name":"peter","age":35,"city":"Shanghai"}},{"id":"1:vadas","label":"person","type":"vertex","properties":{"name":"vadas","age":27,"city":"Hongkong"}},{"id":"2:ripple","label":"software","type":"vertex","properties":{"name":"ripple","lang":"java","price":199}}]}
```

代表创建示例图成功。

### 6 访问 Server

#### 6.1 服务启动状态校验

`jps` 查看服务进程

```bash
jps
6475 HugeGraphServer
```

`curl` 请求 RESTful API

```bash
echo `curl -o /dev/null -s -w %{http_code} "http://localhost:8080/graphs/hugegraph/graph/vertices"`
```

返回结果 200，代表 server 启动正常

#### 6.2 请求 Server

HugeGraphServer 的 RESTful API 包括多种类型的资源，典型的包括 graph、schema、gremlin、traverser 和 task

- `graph` 包含 `vertices`、`edges`
- `schema` 包含 `vertexlabels`、`propertykeys`、`edgelabels`、`indexlabels`
- `gremlin` 包含各种 `Gremlin` 语句，如 `g.v()`，可以同步或者异步执行
- `traverser` 包含各种高级查询，包括最短路径、交叉点、N 步可达邻居等
- `task` 包含异步任务的查询和删除

##### 6.2.1 获取 `hugegraph` 的顶点及相关属性

```bash
curl http://localhost:8080/graphs/hugegraph/graph/vertices 
```

_说明_

1. 由于图的点和边很多，对于 list 型的请求，比如获取所有顶点，获取所有边等，Server 会将数据压缩再返回，所以使用 curl 时得到一堆乱码，可以重定向至 `gunzip` 进行解压。推荐使用 Chrome 浏览器 + Restlet 插件发送 HTTP 请求进行测试。

    ```
    curl "http://localhost:8080/graphs/hugegraph/graph/vertices" | gunzip
    ```

2. 当前 HugeGraphServer 的默认配置只能是本机访问，可以修改配置，使其能在其他机器访问。

    ```
    vim conf/rest-server.properties
    
    restserver.url=http://0.0.0.0:8080
    ```

响应体如下：

```json
{
    "vertices": [
        {
            "id": "2lop",
            "label": "software",
            "type": "vertex",
            "properties": {
                "price": [
                    {
                        "id": "price",
                        "value": 328
                    }
                ],
                "name": [
                    {
                        "id": "name",
                        "value": "lop"
                    }
                ],
                "lang": [
                    {
                        "id": "lang",
                        "value": "java"
                    }
                ]
            }
        },
        {
            "id": "1josh",
            "label": "person",
            "type": "vertex",
            "properties": {
                "name": [
                    {
                        "id": "name",
                        "value": "josh"
                    }
                ],
                "age": [
                    {
                        "id": "age",
                        "value": 32
                    }
                ]
            }
        },
        ...
    ]
}
```

详细的 API 请参考 [RESTful-API](/docs/clients/restful-api) 文档

### 7 停止 Server

```bash
$cd *hugegraph-${version}
$bin/stop-hugegraph.sh
```

### 8 使用 IntelliJ IDEA 调试 Server

请参考[在 IDEA 中配置 Server 开发环境](/docs/contribution-guidelines/hugegraph-server-idea-setup)
