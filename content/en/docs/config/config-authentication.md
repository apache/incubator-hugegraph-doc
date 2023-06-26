---
title: "Built-in User Authentication and Authorization Configuration and Usage in HugeGraph"
linkTitle: "Config Authentication"
weight: 3
---

### Overview
To facilitate authentication usage in different user scenarios, HugeGraph currently provides two built-in authorization modes:
1. Simple `ConfigAuthenticator` mode, which stores usernames and passwords in a local configuration file (supports only a single GraphServer).
2. Comprehensive `StandardAuthenticator` mode, which supports multi-user authentication and fine-grained access control. It adopts a 4-layer design based on "User-UserGroup-Operation-Resource" to flexibly control user roles and permissions (supports multiple GraphServers).

Some key designs of the `StandardAuthenticator` mode include:
- During initialization, a super administrator (`admin`) user is created. Subsequently, other users can be created by the super administrator. Once newly created users are assigned sufficient permissions, they can create or manage more users.
- It supports dynamic creation of users, user groups, and resources, as well as dynamic allocation or revocation of permissions.
- Users can belong to one or multiple user groups. Each user group can have permissions to operate on any number of resources. The types of operations include read, write, delete, execute, and others.
- "Resource" describes the data in the graph database, such as vertices that meet certain criteria. Each resource consists of three elements: `type`, `label`, and `properties`. There are 18 types in total, with the ability to combine any label and properties. The internal condition of a resource is an AND relationship, while the condition between multiple resources is an OR relationship.

Here is an example to illustrate:

```java
// Scenario: A user only has data read permission for the Beijing area
user(name=xx) -belong-> group(name=xx) -access(read)-> target(graph=graph1, resource={label: person, city: Beijing})
```

### Configure User Authentication

By default, HugeGraph does **not enable** user authentication. You need to modify the configuration file to enable this feature. HugeGraph provides two built-in authentication modes: `StandardAuthenticator` and `ConfigAuthenticator`. The `StandardAuthenticator` mode supports multi-user authentication and fine-grained permission control, while the `ConfigAuthenticator` mode supports simple user permission authentication. Additionally, developers can implement their own `HugeAuthenticator` interface to integrate with their existing authentication systems.

Both authentication modes adopt [HTTP Basic Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication). In simple terms, when sending an HTTP request, you need to set the `Authentication` header to `Basic` and provide the corresponding username and password. The corresponding HTTP plaintext format is as follows:

```http
GET http://localhost:8080/graphs/hugegraph/schema/vertexlabels
Authorization: Basic admin xxxx
```

#### StandardAuthenticator Mode
The `StandardAuthenticator` mode supports user authentication and permission control by storing user information in the database backend. This implementation authenticates users based on their names and passwords (encrypted) stored in the database and controls user permissions based on their roles. Below is the specific configuration process (requires service restart):

Configure the `authenticator` and its `rest-server` file path in the `gremlin-server.yaml` configuration file:

```yaml
authentication: {
  authenticator: com.baidu.hugegraph.auth.StandardAuthenticator,
  authenticationHandler: com.baidu.hugegraph.auth.WsAndHttpBasicAuthHandler,
  config: {tokens: conf/rest-server.properties}
}
```

Configure the `authenticator` and `graph_store` information in the `rest-server.properties` configuration file:

```properties
auth.authenticator=com.baidu.hugegraph.auth.StandardAuthenticator
auth.graph_store=hugegraph

# Auth Client Config
# If GraphServer and AuthServer are deployed separately, you also need to specify the following configuration. Fill in the IP:RPC port of AuthServer.
# auth.remote_url=127.0.0.1:8899,127.0.0.1:8898,127.0.0.1:8897

```
In the above configuration, the `graph_store` option specifies which graph to use for storing user information. If there are multiple graphs, you can choose any of them.

In the `hugegraph{n}.properties` configuration file, configure the `gremlin.graph` information:

```properties
gremlin.graph=com.baidu.hugegraph.auth.HugeFactoryAuthProxy
```

For detailed API calls and explanations regarding permissions, please refer to the [Authentication-API](/docs/clients/restful-api/auth) documentation.

#### ConfigAuthenticator Mode

The `ConfigAuthenticator` mode supports user authentication by predefining user information in the configuration file. This implementation verifies the legitimacy of users based on preconfigured static `tokens`. Below is the specific configuration process (requires service restart):

Configure the `authenticator` and its `rest-server` file path in the `gremlin-server.yaml` configuration file:

```yaml
authentication: {
  authenticator: com.baidu.hugegraph.auth.ConfigAuthenticator,
  authenticationHandler: com.baidu.hugegraph.auth.WsAndHttpBasicAuthHandler,
  config: {tokens: conf/rest-server.properties}
}
```

Configure the `authenticator` and its `tokens` information in the `rest-server.properties` configuration file:

```properties
auth.authenticator=com.baidu.hugegraph.auth.ConfigAuthenticator
auth.admin_token=token-value-a
auth.user_tokens=[hugegraph1:token-value-1, hugegraph2:token-value-2]
```

In the `hugegraph{n}.properties` configuration file, configure the `gremlin.graph` information:

```properties
gremlin.graph=com.baidu.hugegraph.auth.HugeFactoryAuthProxy
```

### Custom User Authentication System

If you need to support a more flexible user system, you can customize the authenticator for extension. Simply implement the `com.baidu.hugegraph.auth.HugeAuthenticator` interface with your custom authenticator, and then modify the `authenticator` configuration item in the configuration file to point to your implementation.
