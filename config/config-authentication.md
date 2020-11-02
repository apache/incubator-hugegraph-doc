## 如何配置HugeGraph支持用户认证及扩展自定义用户认证系统

### 用户认证与权限控制概述
HugeGraph支持多用户认证、以及细粒度的权限访问控制，采用基于“用户-用户组-操作-资源”的4层设计，灵活控制用户角色与权限。
资源描述了图数据库中的数据，比如符合某一类条件的顶点，每一个资源包括type、label、properties三个要素，共有18种type、任意label、任意properties的组合形成的资源，一个资源的内部条件是且关系，多个资源之间的条件是或关系。用户可以属于一个或多个用户组，每个用户组可以拥有对任意个资源的操作权限，操作类型包括：读、写、删除、执行等种类。
HugeGraph支持动态创建用户、用户组、资源，支持动态分配或取消权限。初始化数据库时超级管理员用户被创建，后续可通过超级管理员创建各类角色用户，新创建的用户如果被分配足够权限后，可以由其创建或管理更多的用户。

举例说明：
```java
# 场景：某用户只有北京地区的数据读取权限
user(name=xx) -belong-> group(name=xx) -access(read)-> target(graph=graph1, resource={label: person, city: Beijing})
```

### 配置用户认证

HugeGraph默认不启用用户认证功能，可通过修改配置文件来启用该功能。内置实现了`StandardAuthenticator`和`ConfigAuthenticator`两种模式，`StandardAuthenticator`模式支持多用户认证与细粒度权限控制，`ConfigAuthenticator`模式支持简单的用户权限认证。此外，开发者可以自定义实现`HugeAuthenticator`接口来对接自身的权限系统。

用户认证方式均采用 [HTTP Basic Authentication](https://zh.wikipedia.org/wiki/HTTP%E5%9F%BA%E6%9C%AC%E8%AE%A4%E8%AF%81)。

#### StandardAuthenticator模式
`StandardAuthenticator`模式是通过在数据库后端存储用户信息来支持用户认证和权限控制，该实现基于数据库存储的用户的名称与密码进行认证（密码已被加密），基于用户的角色来细粒度控制用户权限。下面是具体的配置流程（重启服务生效）：

在配置文件`gremlin-server.yaml`中配置`authenticator`及其`rest-server`文件路径：

```yaml
authentication: {
  authenticator: com.baidu.hugegraph.auth.StandardAuthenticator,
  authenticationHandler: com.baidu.hugegraph.auth.WsAndHttpBasicAuthHandler,
  config: {tokens: /etc/hugegraph/rest-server.properties}
}
```

在配置文件`rest-server.properties`中配置`authenticator`及其`graph_store`信息：

```ini
auth.authenticator=com.baidu.hugegraph.auth.StandardAuthenticator
auth.graph_store=hugegraph
```
其中，`graph_store`配置项是指使用哪一个图才存储用户信息，如果存在多个图的话，选取任意一个均可。

在配置文件`hugegraph{n}.properties`中配置`gremlin.graph`信息：

```ini
gremlin.graph=com.baidu.hugegraph.auth.HugeFactoryAuthProxy
```

#### ConfigAuthenticator模式

`ConfigAuthenticator`模式是通过预先在配置文件中设置用户信息来支持用户认证，该实现是基于配置好的静态`tokens`来验证用户是否合法。下面是具体的配置流程（重启服务生效）：

在配置文件`gremlin-server.yaml`中配置`authenticator`及其`rest-server`文件路径：

```yaml
authentication: {
  authenticator: com.baidu.hugegraph.auth.ConfigAuthenticator,
  authenticationHandler: com.baidu.hugegraph.auth.WsAndHttpBasicAuthHandler,
  config: {tokens: /etc/hugegraph/rest-server.properties}
}
```

在配置文件`rest-server.properties`中配置`authenticator`及其`tokens`信息：

```ini
auth.authenticator=com.baidu.hugegraph.auth.ConfigAuthenticator
auth.admin_token=token-value-a
auth.user_tokens=[hugegraph1:token-value-1, hugegraph2:token-value-2]
```

在配置文件`hugegraph{n}.properties`中配置`gremlin.graph`信息：

```ini
gremlin.graph=com.baidu.hugegraph.auth.HugeFactoryAuthProxy
```

### 自定义用户认证系统

如果需要支持更加灵活的用户系统，可自定义authenticator进行扩展，自定义authenticator实现接口`com.baidu.hugegraph.auth.HugeAuthenticator`即可，然后修改配置文件中`authenticator`配置项指向该实现。
