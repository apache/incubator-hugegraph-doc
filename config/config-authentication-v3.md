## HugeGraph 用户鉴权配置及使用 V3

### 概述
HugeGraph 为了方便不同用户场景下的鉴权使用，目前内置了权限模式 `StandardAuthenticator`，支持多用户认证、以及细粒度的权限访问控制，采用基于 “用户-用户组-操作-资源” 的 4 层设计，灵活控制用户角色与权限 (支持多 GraphServer)

其中 `StandardAuthenticator` 模式的几个核心设计：
- 初始化时创建超级管理员 (`admin`) 用户，后续通过超级管理员创建其它用户，新创建的用户被分配足够权限后，可以创建或管理更多的用户
- 支持动态创建用户、用户组、资源，支持动态分配或取消权限
- 用户可以属于一个或多个用户组，每个用户组可以拥有对任意个资源的操作权限，操作类型包括：读、写、删除、执行、图空间管理、OP管理等种类
- "资源" 描述了图数据库中的数据，比如符合某一类条件的顶点，每一个资源包括 `type`、`label`、`properties`三个要素，共有 18 种类型、任意 label、任意 properties 可组合形成的资源，一个资源的内部条件是且关系，多个资源之间的条件是或关系

举例说明：

```java
// 场景：某用户只有北京地区的数据读取权限
user(name=xx) -belong-> group(name=xx) -access(read)-> target(graphspace=DEFAULT, graph=graph1, resource={label: person, city: Beijing})
```

### 部署流程

用户认证方式均采用 [HTTP Basic Authentication](https://zh.wikipedia.org/wiki/HTTP%E5%9F%BA%E6%9C%AC%E8%AE%A4%E8%AF%81) ，简单说就是在发送 HTTP 请求时在 `Authentication` 设置选择 `Basic` 然后输入对应的用户名和密码，对应 HTTP 明文如下所示 :

```http
GET http://localhost:8080/graphs/hugegraph/schema/vertexlabels
Authorization: Basic username xxxxxx
```

Graph Server 安装包hugegraph-xx.xx.xx.gz，需要配置的文件如下所示：

```
# ls /path/hugegraph-xx.xx.xx/conf

├── graphs
├── computer.yaml
├── gremlin-driver-settings.yaml
├── gremlin-server.yaml 			# Modify
├── hugegraph-community.license
├── hugegraph-server.keystore
├── log4j2.xml
├── remote-objects.yaml
├── remote.yaml
└── rest-server.properties 			# Modify
```

#### 配置 Graph Server

* 配置 gremlin-server.yaml

```yaml
......
graphs: {}

authentication: {
  authenticator: com.baidu.hugegraph.auth.StandardAuthenticator,
  authenticationHandler: com.baidu.hugegraph.auth.WsAndHttpBasicAuthHandler,
  config: {tokens: conf/rest-server.properties}
}

scriptEngines: {......
```

* 配置 hugegraph.properties

```properties
# 将开头默认的 "com.baidu.hugegraph.HugeFactory" 替换为下⾯的
gremlin.graph=com.baidu.hugegraph.auth.HugeFactoryAuthProxy
```

* 配置 rest-server.properties

```properties
# bind url
# ①. 此处需要修改为当前机器具体的 ip/域名
restserver.url=http://127.0.0.1:8080
# gremlin server url, need to be consistent with host and port in gremlin-server.yaml
#gremlinserver.url=http://127.0.0.1:8182
#restserver.request_timeout=30

# graphs directory
graphs=./conf/graphs
graph.load_from_local_config=true

# meta server info
# ②. 此处修改为实际的集群名称和Metaf服务器地址
cluster=hg
meta.endpoints=[http://127.0.0.1:2379]

# start ignore graph loading error, only take effect if the value is true
server.start_ignore_single_graph_error=true

# The maximum thread ratio for batch writing, only take effect if the batch.max_write_threads is 0
batch.max_write_ratio=80
batch.max_write_threads=0

# authentication configs
# ③. 此处需要取消注释, 修改为如下
auth.authenticator=com.baidu.hugegraph.auth.StandardAuthenticator

# for ConfigAuthenticator mode
#auth.admin_token=
#auth.user_tokens=[]

# k8s api, default not support
k8s.api=false
k8s.namespace=hugegraph-computer-system
k8s.kubeconfig=conf/kube.kubeconfig
k8s.hugegraph_url=http://127.0.0.1:8080
k8s.enable_internal_algorithm=true
k8s.internal_algorithm_image_url=hugegraph/hugegraph-computer-based-algorithm:beta1
k8s.internal_algorithm=[page-rank, degree-centrality, wcc, triangle-count, rings, rings-with-filter, betweenness-centrality, closeness-centrality, lpa, links, kcore, louvain, clustering-coefficient]
k8s.algorithms=[ \
    page-rank:com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams, \
    degree-centrality:com.baidu.hugegraph.computer.algorithm.centrality.degree.DegreeCentralityParams, \
    wcc:com.baidu.hugegraph.computer.algorithm.community.wcc.WccParams, \
    triangle-count:com.baidu.hugegraph.computer.algorithm.community.trianglecount.TriangleCountParams, \
    rings:com.baidu.hugegraph.computer.algorithm.path.rings.RingsDetectionParams, \
    rings-with-filter:com.baidu.hugegraph.computer.algorithm.path.rings.filter.RingsDetectionWithFilterParams, \
    betweenness-centrality:com.baidu.hugegraph.computer.algorithm.centrality.betweenness.BetweennessCentralityParams, \
    closeness-centrality:com.baidu.hugegraph.computer.algorithm.centrality.closeness.ClosenessCentralityParams, \
    lpa:com.baidu.hugegraph.computer.algorithm.community.lpa.LpaParams, \
    links:com.baidu.hugegraph.computer.algorithm.path.links.LinksParams, \
    kcore:com.baidu.hugegraph.computer.algorithm.community.kcore.KCoreParams, \
    louvain:com.baidu.hugegraph.computer.algorithm.community.louvain.LouvainParams, \
    clustering-coefficient:com.baidu.hugegraph.computer.algorithm.community.cc.ClusteringCoefficientParams \
]

# lightweight load balancing (beta)
server.id=server-1
server.role=master
```

* 启动 Graph Server

```bash
cd /path/to/hugegraph-xx.xx.xx
sh ./bin/init-store.sh
sh ./bin/start-hugegraph.sh
```

### 自定义用户认证系统

如果需要支持更加灵活的用户系统，可自定义authenticator进行扩展，自定义authenticator实现接口`com.baidu.hugegraph.auth.HugeAuthenticator`即可，然后修改配置文件中`authenticator`配置项指向该实现。
