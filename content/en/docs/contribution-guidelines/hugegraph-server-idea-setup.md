---
title: "How to Set Up HugeGraph-Server Development Environment in IDEA"
linkTitle: "How to Set Up HugeGraph-Server Development Environment in IDEA"
weight: 4
---

> Note: The following configuration is for reference purposes only, and has been tested on Linux and macOS platforms based on [this version](https://github.com/apache/incubator-hugegraph/commit/a946ad1de4e8f922251a5241ffc957c33379677f).

### Background

The [Quick Start](/docs/quickstart/hugegraph-server/) section provides instructions on how to start and stop HugeGraphServer using scripts. However, for developers, this method may not be convenient as it is not integrated with IDE tools and can be difficult to debug. In this guide, we will explain how to run and debug HugeGraph-Server on the Linux platform using IntelliJ IDEA.

The process of local startup is similar to **script startup** and involves the following steps:

1. Initialize the database backend by executing the `InitStore` class to initialize the graph.
2. Start HugeGraphServer by executing the `HugeGraphServer` class to load the initialized graph information and start the server.

Before proceeding with the following process, make sure that you have cloned the source code of HugeGraph and have configured the development environment, such as JDK 11.

```
git clone https://github.com/apache/hugegraph.git
cd hugegraph
```

### Steps

#### 1. Copy Configuration Files

To avoid the impact of configuration file changes on Git tracking, it is recommended to copy the required configuration files to a separate folder. Run the following command to copy the files:

```
cp -r hugegraph-dist/src/assembly/static/scripts hugegraph-dist/src/assembly/static/conf <path-to-your-directory>
```

Replace `<path-to-your-directory>` with the path to the directory where you want to copy the files.

#### 2. Configure `InitStore`

Next, you need to configure the database backend in the copied files. In this example, we will use RocksDB. Open `<path-to-your-directory>/conf/graphs/hugegraph.properties` and configure it as follows:

```
backend=rocksdb
serializer=binary
rocksdb.data_path=.
rocksdb.wal_path=.
```

Then, open the `Run/Debug configurations` panel of IDEA and create a new `Application` with the following configurations:

- Select `Use classpath of module` as `hugegraph-dist`
- Set `Main class` to `org.apache.hugegraph.cmd.InitStore`
- Set the running parameter to `conf/graphs/hugegraph.properties`. The path here is relative to the working directory, so you need to set the working directory to `<path-to-your-directory>`

After the configuration is complete, run it. If the operation is successful, the following running log will be printed:

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

#### 3. Configure `HugeGraphServer`

Similarly, open the `Run/Debug configurations` panel of IDEA and create a new `Application` with the following configurations:

- Select `Use classpath of module` as `hugegraph-dist`
- Set `Main class` to `org.apache.hugegraph.dist.HugeGraphServer`
- Set the running parameter to `conf/gremlin-server.yaml conf/rest-server.properties`. Similarly, the path here is relative to the working directory, so you need to set the working directory to `<path-to-your-directory>`

After the configuration is complete, run it. If you see the following log, it means that `HugeGraphServer` has been successfully started:

```
......
2023-06-05 00:51:56 [gremlin-server-boss-1] [INFO] o.a.t.g.s.GremlinServer - Gremlin Server configured with worker thread pool of 1, gremlin pool of 8 and boss thread pool of 1.
2023-06-05 00:51:56 [gremlin-server-boss-1] [INFO] o.a.t.g.s.GremlinServer - Channel started at port 8182.
```

#### 4. Debugging `HugeGraphServer`

After completing the above configuration, you can try to debug `HugeGraphServer`. Run `HugeGraphServer` in debug mode, and set breakpoints at the corresponding [location](https://github.com/apache/hugegraph/blob/a946ad1de4e8f922251a5241ffc957c33379677f/hugegraph-api/src/main/java/org/apache/hugegraph/api/graph/VertexAPI.java#L238):

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
Then use the RESTful API to request `HugeGraphServer`:
```
curl "http://localhost:8080/graphs/hugegraph/graph/vertices" | gunzip
```
At this point, you can view detailed variable information in the Debugger.

### Possible Issues

#### java: package sun.misc does not exist

The reason may be that cross-compilation is triggered when using Java 11 to compile, causing the symbol of `sun.misc.Unsafe` used in the project to not be found. There are two solutions:

1. Set the Project SDK to 8, or
2. In the `Java Compiler` panel of IDEA's `Preference`, turn off the `--release` option

### Reference

1. [HugeGraph-Server Quick Start](/docs/quickstart/hugegraph-server/)
2. [Local Debugging Guide for HugeGraph Server (Win/Unix)](https://gist.github.com/imbajin/1661450f000cd62a67e46d4f1abfe82c)
3. ["package sun.misc does not exist" compilation error](https://youtrack.jetbrains.com/issue/IDEA-180033)
4. [Cannot compile: java: package sun.misc does not exist](https://youtrack.jetbrains.com/issue/IDEA-201168)