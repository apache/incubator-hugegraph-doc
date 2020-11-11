## 配置 HugeGraphServer 使用 https 协议

### 概述

HugeGraphServer 默认使用的是 http 协议，如果用户对请求的安全性有要求，可以配置成 https。

### 服务端配置协议

在 conf/rest-server.properties 配置文件中设置启用 https，默认配置文件中未写出该项，用户添加并修改即可，默认值是 http。

```ini
# http 或者 https 默认https
server.protocol=https
# 服务端证书文件路径
ssl.server_keystore_file=server.keystore
# 服务端证书文件密码
ssl.server_keystore_password=123456
```

### 客户端配置

#### 在 HugeGraph-Client 中使用 https

在构造 HugeClient 时传入 https 相关的配置，代码示例：

```java
HugeClientBuilder builder = HugeClient.builder(address, graph)
                                      .configTimeout(options.timeout);
// https 协议
String protocol = "https";
// 客户端证书文件路径
String trustStoreFilePath = "client.keystore"
// 客户端证书密码
String trustStorePassword = "123456";
builder.configSSL(protocol, trustStoreFilePath, trustStorePassword);

HugeClient client = builder.build();
```

> 注意：HugeGraph-Client 在 1.9.0 版本以前是直接以 new 的方式创建，并且不支持 https 协议，在 1.9.0 版本以后改成以 builder 的方式创建，并支持配置 https 协议。

#### 在 HugeGraph-Loader 中使用 https

启动导入任务时，在命令行中添加如下选项：

```bash
# https
--protocol https
# 客户端证书路径
--trust-store-file {file}
# 客户端证书密码
--trust-store-password {password}
```

#### 在 HugeGraph-Tools 中使用 https

执行命令时，在命令行中添加如下选项：

```bash
# https
--protocol https
# 客户端证书路径
--trust-store-file {file}
# 客户端证书密码
--trust-store-password {password}
```

> 注意：服务端没有对客户端证书内容做强制校验，所以客户端可以自行生成证书文件。

### 客户端如何生成证书文件

这里只是给出生成证书的简单示例，如果用户已经知晓如何生成，可跳过。若想了解更详细的生成步骤，请自行搜索相关内容。

可以使用 JRE 自带的 keytool 工具生成

```bash
keytool -genkeypair -alias certificatekey -keyalg RSA -validity 7 -keystore keystore.jks
```
