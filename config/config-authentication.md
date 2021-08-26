## HugeGraph 用户鉴权配置及使用

### 概述
HugeGraph 为了方便不同用户场景下的鉴权使用，目前内置了两套权限模式：
1. 简单的`ConfigAuthenticator`模式，通过本地配置文件存储用户名和密码 (仅支持单 GraphServer)
2. 完备的`StandardAuthenticator`（即 `Graph Server + Auth Server`）模式，支持多用户认证、以及细粒度的权限访问控制，采用基于 “用户-用户组-操作-资源” 的 4 层设计，灵活控制用户角色与权限 (支持多 GraphServer)

其中 `StandardAuthenticator` 模式的几个核心设计：
- 初始化时创建超级管理员 (`admin`) 用户，后续通过超级管理员创建其它用户，新创建的用户被分配足够权限后，可以创建或管理更多的用户
- 支持动态创建用户、用户组、资源，支持动态分配或取消权限
- 用户可以属于一个或多个用户组，每个用户组可以拥有对任意个资源的操作权限，操作类型包括：读、写、删除、执行等种类
- "资源" 描述了图数据库中的数据，比如符合某一类条件的顶点，每一个资源包括 `type`、`label`、`properties`三个要素，共有 18 种类型、任意 label、任意 properties 可组合形成的资源，一个资源的内部条件是且关系，多个资源之间的条件是或关系

举例说明：

```java
// 场景：某用户只有北京地区的数据读取权限
user(name=xx) -belong-> group(name=xx) -access(read)-> target(graph=graph1, resource={label: person, city: Beijing})
```

备注：下面重点针对`StandardAuthenticator`（即`Graph Server + Auth Server`）模式部署流程进行介绍

### `StandardAuthenticator`（`Graph Server + Auth Server`）模式下部署流程

用户认证方式均采用 [HTTP Basic Authentication](https://zh.wikipedia.org/wiki/HTTP%E5%9F%BA%E6%9C%AC%E8%AE%A4%E8%AF%81) ，简单说就是在发送 HTTP 请求时在 `Authentication` 设置选择 `Basic` 然后输入对应的用户名和密码，对应 HTTP 明文如下所示 :

```http
GET http://localhost:8080/graphs/hugegraph/schema/vertexlabels
Authorization: Basic username xxxxxx
```

Graph Server 和 Auth Server使用同一套hugegraph-xx.xx.xx.gz安装包，需要配置的文件如下所示：

```
# ls /path/hugegraph-xx.xx.xx/conf

├── computer.yaml
├── gremlin-driver-settings.yaml
├── gremlin-server.yaml 			# Modify
├── hugegraph-community.license
├── hugegraph.properties 			# Modify just for Graph Server 
├── hugegraph-server.keystore
├── log4j2.xml
├── remote-objects.yaml
├── remote.yaml
├── rest-server.properties 			# Modify
└── system.properties
```

#### 配置 Auth Server

* 配置 gremlin-server.yaml

```yaml
......
graphs: {
  system: conf/system.properties
}

authentication: {
  authenticator: com.baidu.hugegraph.auth.StandardAuthenticator,
  authenticationHandler: com.baidu.hugegraph.auth.WsAndHttpBasicAuthHandler,
  config: {tokens: conf/rest-server.properties}
}

scriptEngines: {......
```

* 配置 rest-server.properties （重点关注序号标记）

```properties
# bind url
# ①. 此处需要修改为当前机器具体的 ip/域名
restserver.url=http://127.0.0.1:8080
# gremlin server url, need to be consistent with host and port in gremlin-server.yaml
#gremlinserver.url=http://127.0.0.1:8182

# graphs list with pair NAME:CONF_PATH
# ②. 此处修改为如下
# graphs=[hugegraph:conf/hugegraph.properties]
graphs=[system:conf/system.properties]

# The maximum thread ratio for batch writing, only take effect if the batch.max_write_threads is 0
batch.max_write_ratio=80
batch.max_write_threads=0

# authentication configs
# choose 'com.baidu.hugegraph.auth.StandardAuthenticator' or 'com.baidu.hugegraph.auth.ConfigAuthenticator'
# ③. 此处需要取消注释, 修改为如下
auth.authenticator=com.baidu.hugegraph.auth.StandardAuthenticator

# for StandardAuthenticator mode
# ④. 此处需要取消注释, 名字需与上⾯ "graphs" 值保持⼀致
auth.graph_store=system
# auth client config
#auth.remote_url=127.0.0.1:8899,127.0.0.1:8898,127.0.0.1:8897

# for ConfigAuthenticator mode
#auth.admin_token=
#auth.user_tokens=[]

# rpc group configs of multi graph servers
# rpc server configs
# ⑤. 此处需要修改为当前机器具体的 ip 和域名
rpc.server_host=127.0.0.1
rpc.server_port=8090
#rpc.server_timeout=30

# rpc client configs (like enable to keep cache consistency)
# ⑥. 此处需要注释(关闭)
#rpc.remote_url=127.0.0.1:8090
#rpc.client_connect_timeout=20
#rpc.client_reconnect_period=10
#rpc.client_read_timeout=40
#rpc.client_retries=3
#rpc.client_load_balancer=consistentHash

# lightweight load balancing (beta)
server.id=server-1
server.role=master
```

* 启动 Auth Server

```bash
cd /path/to/hugegraph-xx.xx.xx
sh ./bin/init-store.sh
sh ./bin/start-hugegraph.sh
```

#### 配置 Graph Server

* 配置 gremlin-server.yaml

```yaml
......
graphs: {
  hugegraph: conf/hugegraph.properties,
  system: conf/system.properties
}

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

# graphs list with pair NAME:CONF_PATH
# ②. 新增 system: conf/system.properties
graphs=[hugegraph:conf/hugegraph.properties, system: conf/system.properties]

# The maximum thread ratio for batch writing, only take effect if the batch.max_write_threads is 0
batch.max_write_ratio=80
batch.max_write_threads=0

# authentication configs
# choose 'com.baidu.hugegraph.auth.StandardAuthenticator' or 'com.baidu.hugegraph.auth.ConfigAuthenticator'
# ③. 此处需要取消注释, 修改为如下
auth.authenticator=com.baidu.hugegraph.auth.StandardAuthenticator

# for StandardAuthenticator mode
#auth.graph_store=hugegraph
# auth client config
# ④. 此处需要取消注释, 填写 AuthServer RPC 设置的 IP 和端⼝ (重点)
auth.remote_url=AuthServerIP:8090

# for ConfigAuthenticator mode
#auth.admin_token=
#auth.user_tokens=[]

# rpc group configs of multi graph servers
# rpc server configs
# ⑤. 此处需要注释(关闭)
#rpc.server_host=127.0.0.1
#rpc.server_port=8090
#rpc.server_timeout=30

# rpc client configs (like enable to keep cache consistency)
# ⑥. 此处需要注释(关闭)
#rpc.remote_url=127.0.0.1:8090
#rpc.client_connect_timeout=20
#rpc.client_reconnect_period=10
#rpc.client_read_timeout=40
#rpc.client_retries=3
#rpc.client_load_balancer=consistentHash

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
