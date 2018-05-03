## HugeGraphServer Quick Start

### 1 概述

HugeGraph Server 是 HugeGraph 项目的核心部分，包含Core、Backend、API等子模块。

Core模块是Tinkerpop接口的实现，Backend模块用于管理数据存储，目前支持的后端包括：Memory、Cassandra、ScyllaDB以及RocksDB，API模块提供HTTP Server，将Client的HTTP请求转化为对Core的调用。

### 2 依赖

#### 2.1 安装JDK-1.8

HugeGraph Server 是基于jdk-1.8编写的，代码用到了较多jdk-1.8中的类和方法，请用户自行安装配置。

**在往下阅读之前务必执行`java -version`命令查看jdk版本**

```bash
$ java -version
java version "1.8.0_121"
Java(TM) SE Runtime Environment (build 1.8.0_121-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.121-b13, mixed mode)
```

#### 2.2 安装GCC-4.3.0(GLIBCXX_3.4.10)或更新版本（可选）

如果使用的是RocksDB后端，请务必执行`gcc --version`命令查看gcc版本；若使用其他后端，则不需要。

```bash
$ gcc --version
gcc (GCC) 4.4.6 20120305 (Red Hat 4.4.6-4)
Copyright (C) 2010 Free Software Foundation, Inc.
```

### 3 下载

有两种方式可以获取HugeGraph Server：

- 下载tar包（推荐）
- 源码编译

#### 3.1 下载tar包

```bash
$ wget http://yq01-sw-hdsserver16.yq01.baidu.com:8080/hadoop-web-proxy/yqns02/hugegraph/hugegraph-release-${version}-SNAPSHOT.tar.gz
$ tar -zxvf hugegraph-release-${version}-SNAPSHOT.tar.gz
```

_注：${version}为版本号，最新版本号可参考[Download](../download.md)页面，或直接从Download页面点击链接下载_

#### 3.2 源码编译

下载HugeGraph源代码（目前仅支持从icode上clone）

```bash
$ git clone ssh://${username}@icode.baidu.com:8235/baidu/xbu-data/hugegraph baidu/xbu-data/hugegraph && scp -p -P 8235 ${username}@icode.baidu.com:hooks/commit-msg baidu/xbu-data/hugegraph/.git/hooks/
```

编译打包生成tar包（编译前检查分支，并切换至master2）:

```bash
$ git checkout master2
$ cd hugegraph
$ mvn package -DskipTests
```

执行日志如下：

```bash
......
[INFO] Reactor Summary:
[INFO] 
[INFO] hugegraph .......................................... SUCCESS [  0.003 s]
[INFO] hugegraph-core ..................................... SUCCESS [ 15.335 s]
[INFO] hugegraph-api ...................................... SUCCESS [  0.829 s]
[INFO] hugegraph-cassandra ................................ SUCCESS [  1.095 s]
[INFO] hugegraph-scylladb ................................. SUCCESS [  0.313 s]
[INFO] hugegraph-rocksdb .................................. SUCCESS [  0.506 s]
[INFO] hugegraph-mysql .................................... SUCCESS [  0.412 s]
[INFO] hugegraph-palo ..................................... SUCCESS [  0.359 s]
[INFO] hugegraph-dist ..................................... SUCCESS [  7.470 s]
[INFO] hugegraph-example .................................. SUCCESS [  0.403 s]
[INFO] hugegraph-test ..................................... SUCCESS [  1.509 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
......
```

执行成功后，在hugegraph目录下生成 hugegraph-release-*.tar.gz 文件，就是编译生成的tar包。

### 4 配置

如果需要快速启动HugeGraph仅用于测试，那么只需要进行少数几个配置项的修改即可。详细的配置介绍请
参考[配置文档](http://hugegraph.baidu.com/guides/config-guide.html)及[配置项](http://hugegraph.baidu.com/guides/config-option.html)

### 5 启动

启动分为"首次启动"和"非首次启动"，这么区分是因为在第一次启动前需要初始化后端数据库，然后启动服务。
而在人为停掉服务后，或者其他原因需要再次启动服务时，因为后端数据库是持久化存在的，直接启动服务即可。

如果在第一次没有初始化过数据库就直接启动服务了，HugeGraphServer也不会报错，这是因为
HugeGraphServer不依赖于后端存储启动（特别是多后端存储时），只有在具体操作后端存储时才给出错误。

如果需要外部访问HugeGraphServer，请修改`rest-server.properties`的`restserver.url`配置项
（默认为`http://127.0.0.1:8080`），修改成机器名或IP地址。

由于各种后端所需的配置（hugegraph.properties）及启动步骤略有不同，下面逐一对各后端的配置及启动做介绍。

#### 5.1 Memory

修改 hugegraph.properties

```properties
backend=memory
serializer=text
```

> Memory后端的数据是保存在内存中无法持久化的，不需要初始化后端，这也是唯一一个不需要初始化的后端。

启动 server

```bash
$ bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

提示的 url 与 rest-server.properties 中配置的 restserver.url 一致

#### 5.2 RocksDB

修改 hugegraph.properties

```properties
backend=rocksdb
serializer=binary
rocksdb.data_path=.
rocksdb.wal_path=.
```

> RocksDB是一个嵌入式的数据库，直接将数据写磁盘上，不需要安装部署, 但要求编译器版本 >= GCC 4.3.0（GLIBCXX_3.4.10），如不满足，需要提前升级

初始化数据库（仅第一次启动时需要）

```bash
$ cd hugegraph-release
$ bin/init-store.sh
```

启动server

```bash
$ bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

#### 5.3 Cassandra

> 使用 cassandra 之前，用户需自行安装[cassandra](http://cassandra.apache.org/doc/latest/)（版本 3.0 以上）

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
$ cd hugegraph-release
$ bin/init-store.sh
Initing HugeGraph Store...
2017-12-01 11:26:51 1424  [main] [INFO ] com.baidu.hugegraph.HugeGraph [] - Opening backend store: 'cassandra'
2017-12-01 11:26:52 2389  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph, try init keyspace later
2017-12-01 11:26:52 2472  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph, try init keyspace later
2017-12-01 11:26:52 2557  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph, try init keyspace later
2017-12-01 11:26:53 2797  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_graph
2017-12-01 11:26:53 2945  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_schema
2017-12-01 11:26:53 3044  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_index
2017-12-01 11:26:53 3046  [pool-3-thread-1] [INFO ] com.baidu.hugegraph.backend.Transaction [] - Clear cache on event 'store.init'
2017-12-01 11:26:59 9720  [main] [INFO ] com.baidu.hugegraph.HugeGraph [] - Opening backend store: 'cassandra'
2017-12-01 11:27:00 9805  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph1, try init keyspace later
2017-12-01 11:27:00 9886  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph1, try init keyspace later
2017-12-01 11:27:00 9955  [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Failed to connect keyspace: hugegraph1, try init keyspace later
2017-12-01 11:27:00 10175 [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_graph
2017-12-01 11:27:00 10321 [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_schema
2017-12-01 11:27:00 10413 [main] [INFO ] com.baidu.hugegraph.backend.store.cassandra.CassandraStore [] - Store initialized: huge_index
2017-12-01 11:27:00 10413 [pool-3-thread-1] [INFO ] com.baidu.hugegraph.backend.Transaction [] - Clear cache on event 'store.init'
```

启动server

```bash
$ bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

#### 5.4 ScyllaDB

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

由于 scylladb 数据库本身就是基于 cassandra 的"优化版"，如果用户未安装 scylladb ，也可以直接使用 cassandra 作为后端存储，只需要把 backend 和 serializer 修改为 scylladb，host 和 post 指向 cassandra 集群的 seeds 和 port 即可，但是并不建议这样做，这样发挥不出 scylladb 本身的优势了。

初始化数据库（仅第一次启动时需要）

```bash
$ cd hugegraph-release
$ bin/init-store.sh
```

启动server

```bash
$ bin/start-hugegraph.sh
Starting HugeGraphServer...
Connecting to HugeGraphServer (http://127.0.0.1:8080/graphs)....OK
```

### 6 访问Server

#### 6.1 服务启动状态校验

`jps`查看服务进程

```bash
$ jps
6475 HugeGraphServer
```

`curl`请求`RestfulAPI`

```bash
$ echo `curl -o /dev/null -s -w %{http_code} "http://localhost:8080/graphs/hugegraph/graph/vertices"`
```

返回结果200，代表server启动正常

#### 6.2 请求Server

HugeGraphServer的RestAPI包括三种类型的资源，分别是graph、schema、gremlin，

- `graph`包含`vertices`、`edges`
- `schema` 包含`vertexlabels`、 `propertykeys`、 `edgelabels`、`indexlabels`
- `gremlin`包含各种`Gremlin`语句，如`g.v()`

##### 5.2.1 获取`hugegraph`的顶点及相关属性

```bash
$ curl http://localhost:8080/graphs/hugegraph/graph/vertices 
```

_说明_

1. 由于图的点和边很多，对于 list 型的请求，比如获取所有顶点，获取所有边等，Server 会将数据压缩再返回，
所以使用 curl 时得到一堆乱码，可以重定向至 gunzip 进行解压。推荐使用 Chrome 浏览器 + Restlet 插件发送 HTTP 请求进行测试。

    ```
    curl "http://localhost:8080/graphs/hugegraph/graph/vertices" | gunzip
    ```

2. 当前HugeGraphServer的默认配置只能是本机访问，可以修改配置，使其能在其他机器访问。

    ```
    $ vim conf/rest-server.properties
    
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

详细的API请参考[Restful-API](http://hugegraph.baidu.com/clients/hugegraph-api.html)文档

### 7 停止Server

```bash
$cd hugegraph-release
$bin/stop-hugegraph.sh
```
