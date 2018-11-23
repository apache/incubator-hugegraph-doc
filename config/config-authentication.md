## 如何配置HugeGraph支持用户认证及扩展自定义用户认证系统

### 配置用户认证

HugeGraph默认不启用用户认证功能，可通过修改配置文件来启用该功能。默认实现了`StandardAuthenticator`类来支持用户认证，该实现是基于配置好的静态`tokens`来验证用户是否合法，认证方式使用HTTP Basic Authentication。下面是具体的配置流程（重启服务生效）：

在配置文件`gremlin-server.yaml`中配置`authenticator`及其`rest-server`文件路径：

```yaml
authentication: {
  authenticator: com.baidu.hugegraph.auth.StandardAuthenticator,
  config: {tokens: /etc/hugegraph/rest-server.properties}
}
```

在配置文件`rest-server.properties`中配置`authenticator`及其`tokens`信息：

```ini
auth.authenticator=com.baidu.hugegraph.auth.StandardAuthenticator
auth.admin_token=token-value-a
auth.user_tokens=[hugegraph1:token-value-1, hugegraph2:token-value-2]
```

在配置文件`hugegraph{n}.properties`中配置`gremlin.graph`信息：

```ini
gremlin.graph=com.baidu.hugegraph.auth.HugeFactoryAuthProxy
```

### 自定义用户认证系统

如果需要支持更加灵活的用户系统，可自定义authenticator进行扩展，自定义authenticator实现接口`com.baidu.hugegraph.auth.HugeAuthenticator`即可，然后修改配置文件中`authenticator`指向该实现。