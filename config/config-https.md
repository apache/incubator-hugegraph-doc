## 配置 HugeGraphServer 使用 https 协议

### 概述

HugeGraphServer 默认使用的是 http 协议，如果用户对请求的安全性有要求，可以配置成 https。

### 服务端配置

在 conf/rest-server.properties 配置文件中设置启用 https，默认配置文件中未写出该项，用户添加并修改即可，默认值是 http。

```ini
# http 或者 https，默认 http
restserver.protocol=https
# 服务端 keystore 文件路径，restserver.protocol=https 时该默认值自动生效，可按需修改此项
ssl.keystore_file=conf/hugegraph-server.keystore
# 服务端 keystore 文件密码，restserver.protocol=https 时该默认值自动生效，可按需修改此项
ssl.keystore_password=hugegraph
```

服务端的 conf 目录下已经给出了一个的 keystore 文件`hugegraph-server.keystore`，该文件的密码为`hugegraph`，
这两项都是在开启了 https 协议时的默认值，用户可以生成自己的 keystore 文件及密码，然后修改`ssl.keystore_file`和`ssl.keystore_password`的值。

### 客户端配置

#### 在 HugeGraph-Client 中使用 https

在构造 HugeClient 时传入 https 相关的配置，代码示例：

```java
String url = "https://localhost:8080";
String graphName = "hugegraph";
HugeClientBuilder builder = HugeClient.builder(url, graphName);
// 客户端 keystore 文件路径
String trustStoreFilePath = "hugegraph.truststore";
// 客户端 keystore 密码
String trustStorePassword = "hugegraph";
builder.configSSL(trustStoreFilePath, trustStorePassword);
HugeClient hugeClient = builder.build();
```

> 注意：HugeGraph-Client 在 1.9.0 版本以前是直接以 new 的方式创建，并且不支持 https 协议，在 1.9.0 版本以后改成以 builder 的方式创建，并支持配置 https 协议。

#### 在 HugeGraph-Loader 中使用 https

启动导入任务时，在命令行中添加如下选项：

```bash
# https
--protocol https
# 客户端证书文件路径，默认为 conf/hugegraph.truststore，当指定 --protocol=https 时该默认值自动生效
--trust-store-file {file}
# 客户端证书文件密码，默认为 hugegraph，当指定 --protocol=https 时该默认值自动生效
--trust-store-password {password}
```

hugegraph-loader 的 conf 目录下已经放了一个默认的客户端证书文件 hugegraph.truststore，其密码是 hugegraph。

#### 在 HugeGraph-Tools 中使用 https

执行命令时，在命令行中添加如下选项：

```bash
# 客户端证书文件路径，默认为 conf/hugegraph.truststore，当 url 中使用 https 协议时该默认值自动生效
--trust-store-file {file}
# 客户端证书文件密码，默认为 hugegraph，当 url 中使用 https 协议时该默认值自动生效
--trust-store-password {password}
# 执行迁移命令时，当 --target-url 中使用 https 协议时，目标 Server 所需的客户端证书文件的路径，必须显式指定
--target-trust-store-file {target-file}
# 执行迁移命令时，当 --target-url 中使用 https 协议时，目标 Server 所需的客户端证书文件的密码，必须显式指定
--target-trust-store-password {target-password}
```

hugegraph-tools 的 conf 目录下已经放了一个默认的客户端证书文件 hugegraph.truststore，其密码是 hugegraph。

### 如何生成证书文件

本部分给出生成证书的示例，如果默认的证书已经够用，或者已经知晓如何生成，可跳过。

#### 服务端

1. ⽣成服务端私钥，并且导⼊到服务端 keystore ⽂件中，server.keystore 是给服务端⽤的，其中保存着⾃⼰的私钥

```bash
keytool -genkey -alias serverkey -keyalg RSA -keystore server.keystore
```

过程中根据需求填写描述信息，默认证书的描述信息如下：

```
名字和姓⽒：hugegraph
组织单位名称：hugegraph
组织名称：hugegraph
城市或区域名称：BJ
州或省份名称：BJ
国家代码：CN
```

2. 根据服务端私钥，导出服务端证书

```bash
keytool -export -alias serverkey -keystore server.keystore -file server.crt
```

server.crt 就是服务端的证书

#### 客户端

```bash
keytool -import -alias serverkey -file server.crt -keystore client.jks
```

client.jks 是给客户端⽤的，其中保存着受信任的证书
