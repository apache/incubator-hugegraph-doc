---
title: "HugeGraph工具链本地测试指南"
linkTitle: "Toolchain本地测试"
weight: 7
---

本指南旨在帮助开发者高效地在本地环境下运行 HugeGraph 工具链相关测试，涵盖各子项目的编译、依赖服务安装、测试与覆盖率报告生成等流程。

## 1. 前言与核心概念

### 1.1 核心依赖说明：HugeGraph Server

在 HugeGraph 工具链的测试中，**HugeGraph Server 是绝大多数集成测试和功能测试的核心依赖**。它提供了图数据库的核心服务，工具链中的许多组件（如 Client、Loader、Hubble、Spark Connector、Tools）都需要与 Server 进行交互才能完成其功能并进行测试。因此，配置好 HugeGraph Server 正常运行是完整进行功能测试的前提，本指南将在下文介绍如何安装/构建HugeGraph Server。

### 1.2 测试套件类型解释

在 HugeGraph 工具链的测试中，您可能会遇到以下几种常见的测试套件类型：

*   **单元测试 (Unit Tests)**：
    *   **目标**：验证程序中最小可测试单元（通常是单个函数、方法或类）的正确性。通常不涉及外部依赖（如数据库、网络服务等）

*   **API 测试 (API Tests / ApiTestSuite)**：
    *   **目标**：验证程序对外提供API的正确性、稳定性和符合性。它们通常模拟客户端请求，与server进行交互，检查 API 的响应数据、处理机制是否符合预期。
    *   **特点**：需要一个正在运行的服务端（如 HugeGraph Server）来响应 API 请求。


*   **功能测试 (Functional Tests / FuncTestSuite)**：
    *   **目标**：验证系统或组件的特定功能是否按照需求正常工作。用于模拟用户场景或业务流程，涉及多个组件的交互，是端到端的测试。
    *   **特点**：执行时间相对较长，需要完整的系统环境（包括所有依赖服务）来运行，能够发现集成层面的问题。

## 2. 测试前准备

### 2.1 系统与软件要求

*   **操作系统**：建议 Linux, macOS。Windows 平台请使用 WSL2。
*   **JDK**：>= 11。确保您的 `JAVA_HOME` 环境变量已正确配置。
*   **Maven**：建议 3.5 及以上。用于项目构建和依赖管理。
*   **Python**：>= 3.11（仅HugeGraph-Hubble 相关测试需用）。建议使用虚拟环境进行管理，以避免版本冲突。 

### 2.2 克隆代码仓库

首先，您需要克隆 HugeGraph 工具链的源代码仓库：

```bash
git clone https://github.com/${GITHUB_USER_NAME}/hugegraph-toolchain.git
cd hugegraph-toolchain
```

## 3. 部署测试环境

关于测试环境，由于HugeGraph Server 是绝大多数集成测试和功能测试的核心依赖，有关安装/构建 HugeGraph-Server，可参考访问 [社区版文档](https://hugegraph.apache.org/cn/docs/quickstart/hugegraph/hugegraph-server/)。在本测试指南中，我们会介绍通过脚本部署与通过docker部署两种方式。

重要提示：
* 推荐优先使用脚本进行本地部署 HugeGraph Server。 这种方式允许您通过指定 Git Commit ID 来精确控制 Server 版本，确保与您的工具链代码版本高度匹配，从而有效避免因接口或实现变动导致测试异常的问题。

* Docker 部署方式更适合快速启动一个默认配置的 HugeGraph Server，但在进行精细化的集成测试时，特别是当您的工具链代码依赖于特定 HugeGraph Server 版本的功能或修复时，Docker 镜像的版本滞后或默认配置可能导致测试不通过。当工具链代码与 HugeGraph Server 存在接口/实现变动时，Docker 部署的便捷性可能反而导致测试失败，此时推荐回退到脚本部署方式。

### 3.1 使用脚本快速部署测试环境（推荐）

这种方式允许您从源代码编译和安装特定版本的 HugeGraph Server，确保测试环境与特定 HugeGraph Server 版本的一致性，这对于复现问题或验证兼容性至关重要。

#### 3.1.1 变量与参数

*   **`$COMMIT_ID`**
    *   指定 HugeGraph Server 源代码的 Git Commit ID。当您需要从源代码编译和安装特定版本的 HugeGraph Server 作为测试依赖时，会使用此变量,确保测试环境与特定 HugeGraph Server 版本的一致性，这对于复现问题或验证兼容性至关重要。使用时直接接作为参数传递给 install-hugegraph-from-source.sh 脚本。

*   **`$DB_DATABASE` 与 `$DB_PASS`**
    *   指定 HugeGraph-Loader 进行 JDBC 测试时所连接的 MySQL 数据库的名称和root 用户密码。提供数据库连接信息，使 Loader 能够正确地读写数据。使用时直接接作为参数传递给 使用时直接接作为参数传递给 install-mysql.sh 脚本。

#### 3.1.2 执行流程

**安装并启动 HugeGraph Server**

如果您选择手动安装，可以使用以下脚本来安装 HugeGraph Server。该脚本位于任意工具仓库的`/assembly/travis/` 目录下
用于从指定 commit id 拉取 HugeGraph Server 源码、编译、解压并分别以 http/https 启动服务
```bash
hugegraph-*/assembly/travis/install-hugegraph-from-source.sh $COMMIT_ID
```

*   `$COMMIT_ID`：指定 HugeGraph Server 的 Git Commit ID。
*   默认http占用端口为8080，https占用端口为8443，请确保其在server启动前未被占用。
  
**安装并启动Hadoop (HDFS)** (仅当运行 hugegraph-loader的HDFS 测试时需要)：
```bash
hugegraph-loader/assembly/travis/install-hadoop.sh
```

**安装并启动MySQL** (仅当运行 hugegraph-loader的JDBC 测试时需要)：
```bash
hugegraph-loader/assembly/travis/install-mysql.sh $DB_DATABASE $DB_PASS
```


**健康性检查** 

```bash
curl http://localhost:8080/graphs
```
若返回 `{"graphs":["hugegraph"]}`，则表示服务器已准备就绪，可以接收请求。

### 3.2 使用 Docker 部署测试环境

通过使用官方发布的 hugegraph-server Docker 镜像，您可以快速启动一个 HugeGraph Server。这种方式简化了测试环境的搭建、确保环境一致性并提高测试的可重复性。**然而，请注意，Docker 镜像可能不会及时更新到 HugeGraph Server 的最新开发版本。这意味着如果您的工具链代码依赖于 HugeGraph Server 的最新接口或功能，使用 Docker 镜像可能会导致兼容性问题。在这种情况下，建议使用脚本方式部署特定 `COMMIT_ID` 的 HugeGraph Server。**

#### docker快速启动

```bash
docker run -itd --name=server -p 8080:8080 hugegraph/hugegraph:latest
```

快速启动一个内置了 RocksDB 的 Hugegraph server。满足大部分测试与toolchain组件运行的要求。

#### 示例 `docker-compose.yml` 文件

以下是一个示例 `docker-compose.yml` 文件，它定义了 HugeGraph Server、MySQL 和 Hadoop (HDFS) 服务。您可以根据实际测试需求进行调整。

```yaml
version: '3.8'

services:
  hugegraph-server:
    image: hugegraph/hugegraph:latest  # 可以替换为特定版本，或构建自己的镜像
    container_name: hugegraph-server
    ports:
      - "8080:8080"  # HugeGraph Server HTTP 端口
    environment:
      # 根据需要配置HugeGraph Server的参数，例如后端存储
      - HUGEGRAPH_SERVER_OPTIONS="-Dstore.backend=rocksdb"
    volumes:
      # 如果需要持久化数据或挂载配置文件，可以在这里添加卷
      # - ./hugegraph-data:/opt/hugegraph/data
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8080/graphs || exit 1"]
      interval: 5s
      timeout: 3s
      retries: 5
    networks:
      - hugegraph-net
  
  # 如果需要hugegraph-loader的JDBC测试，可以添加以下服务
  #   mysql:
  #     image: mysql:5.7
  #     container_name: mysql-db
  #     environment:
  #       MYSQL_ROOT_PASSWORD: ${DB_PASS:-your_mysql_root_password} # 从环境变量读取，或使用默认值
  #       MYSQL_DATABASE: ${DB_DATABASE:-hugegraph_test_db} # 从环境变量读取，或使用默认值
  #     ports:
  #       - "3306:3306"
  #     volumes:
  #       - ./mysql-data:/var/lib/mysql # 数据持久化
  #     healthcheck:
  #       test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-p${DB_PASS:-your_mysql_root_password}"]
  #       interval: 5s
  #       timeout: 3s
  #       retries: 5
  #     networks:
  #       - hugegraph-net

  # 如果需要hugegraph-loader的Hadoop/HDFS测试，可以添加以下服务
  #   namenode:
  #     image: johannestang/hadoop-namenode:2.0.0-hadoop2.8.5-java8
  #     container_name: namenode
  #     ports:
  #       - "0.0.0.0:9870:9870"
  #       - "0.0.0.0:8020:8020"
  #     environment:
  #       - CLUSTER_NAME=test-cluster
  #       - HDFS_NAMENODE_USER=root
  #       - HADOOP_CONF_DIR=/hadoop/etc/hadoop
  #     volumes:
  #       - ./config/core-site.xml:/hadoop/etc/hadoop/core-site.xml
  #       - ./config/hdfs-site.xml:/hadoop/etc/hadoop/hdfs-site.xml
  #       - namenode_data:/hadoop/dfs/name
  #     command: bash -c "hdfs namenode -format && /entrypoint.sh"
  #     healthcheck:
  #       test: ["CMD", "hdfs", "dfsadmin", "-report"]
  #       interval: 5s
  #       timeout: 3s
  #       retries: 5
  #     networks:
  #       - hugegraph-net

  #   datanode:
  #     image: johannestang/hadoop-datanode:2.0.0-hadoop2.8.5-java8
  #     container_name: datanode
  #     depends_on:
  #       - namenode
  #     environment:
  #       - CLUSTER_NAME=test-cluster
  #       - HDFS_DATANODE_USER=root
  #       - HADOOP_CONF_DIR=/hadoop/etc/hadoop
  #     volumes:
  #       - ./config/core-site.xml:/hadoop/etc/hadoop/core-site.xml
  #       - ./config/hdfs-site.xml:/hadoop/etc/hadoop/hdfs-site.xml
  #       - datanode_data:/hadoop/dfs/data
  #     healthcheck:
  #       test: ["CMD", "hdfs", "dfsadmin", "-report"]
  #       interval: 5s
  #       timeout: 3s
  #       retries: 5
  #     networks:
  #       - hugegraph-net

networks:
  hugegraph-net:
    driver: bridge
```

#### hadoop配置挂载
📁 ./config/core-site.xml 内容：

```xml
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://namenode:8020</value>
    </property>
</configuration>
```

📁 ./config/hdfs-site.xml 内容：

```xml
<configuration>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/opt/hdfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/opt/hdfs/data</value>
    </property>
    <property>
        <name>dfs.permissions.superusergroup</name>
        <value>hadoop</value>
    </property>
    <property>
        <name>dfs.support.append</name>
        <value>true</value>
    </property>
</configuration>
```

**说明**：

*   **`hugegraph-server`**：使用 `hugegraph/hugegraph:latest` 镜像。您可以根据需要替换为特定版本，或者如果您需要从源代码构建 Server，可以创建一个自定义的 Dockerfile 并在此处引用。
*   **`mysql`**：使用官方 `mysql:5.7` 镜像。`MYSQL_ROOT_PASSWORD` 和 `MYSQL_DATABASE` 可以通过环境变量 (`DB_PASS`, `DB_DATABASE`) 传入，或者使用默认值。
*   **`namenode` 和 `datanode`** (注释掉的部分)：如果您需要运行 HugeGraph-Loader 的 HDFS 测试，可以取消注释并配置 Hadoop 服务。


#### 启动和停止 Docker 环境

1.  **保存 `docker-compose.yml`**：将上述内容保存为 `docker-compose.yml` 文件，建议放在 `hugegraph-toolchain` 项目的根目录下或一个独立的 `docker` 目录中。

2.  **启动服务**：在 `docker-compose.yml` 文件所在的目录下，运行以下命令启动所有服务：

    ```bash
    docker compose up -d
    ```
    *   `-d` 参数表示在后台运行容器。

3.  **检查服务状态**：您可以使用以下命令检查容器的运行状态：

    ```bash
    docker compose ps
    lsof -i:8080 # server端口
    lsof -i:8020 # hadoop端口
    lsof -i:3306 # mysql端口
    ```

4.  **停止服务**：测试完成后，您可以停止并移除所有容器：

    ```bash
    docker compose down
    ```

## 4. 开始测试

通常来说，各个工具的本地测试大致流程如下，下面将进行细致的说明

<div style="text-align: center;">
    <img src="/docs/images/toolchain-test-mermaid-2.png" alt="HugeGraph工具链测试流程图">
</div>

### 4.1 hugegraph-client 本地测试 (Java 版本)

`hugegraph-client` 是 HugeGraph 的 Java 客户端库，用于与 HugeGraph Server 进行交互。其测试主要验证客户端与服务端的通信和数据操作。

#### 4.1.1 编译

首先，编译 `hugegraph-client` 模块：

```bash
mvn -e compile -pl hugegraph-client -Dmaven.javadoc.skip=true -ntp
```

*   `-pl hugegraph-client`：指定只编译 `hugegraph-client` 模块。
*   `-Dmaven.javadoc.skip=true`：跳过 Javadoc 生成。
*   `-ntp`：不显示传输进度。

#### 4.1.2 依赖服务安装

按照 [部署测试环境](#部署测试环境) 部署测试环境 中的说明，启动 `hugegraph-server` 。

##### server鉴权设置（docker镜像版本<=1.5.0不支持鉴权测试）

由于client的ApiTest包含鉴权测试，需确保server的密码与测试代码中相同，否则client与server的数据传递将无法正常进行。若使用client自带的脚本安装并启动server，可跳过此步。
但若使用其他方式启动，由于默认server并未设置，因此须进行如下鉴权设置。如 `docker exec -it server bash`  进入容器环境进行修改

```bash
# 第一步：修改鉴权模式
vi conf/rest-server.properties 
```
将line 23的 `auth.authenticator=` 修改为 `auth.authenticator=org.apache.hugegraph.auth.StandardAuthenticator`

```bash
# 第二步：设置密码
bin/stop-hugegraph.sh
echo -e "pa" | bin/init-store.sh # 此脚本初始化 HugeGraph 存储并设置默认用户凭据，包括用于鉴权测试的密码
bin/start-hugegraph.sh
```

#### 4.1.3 运行测试

进入 `hugegraph-client` 模块目录，并运行测试：

```bash
cd hugegraph-client
mvn test -Dtest=UnitTestSuite -ntp
mvn test -Dtest=ApiTestSuite -ntp
mvn test -Dtest=FuncTestSuite -ntp
```

*  unit test 主要依赖 `hugegraph-client` 自身的编译, 用于测试客户端内部的逻辑。
* 其他测试模块都需要依赖一个正在运行的 HugeGraph-Server 服务

### 4.2 hugegraph-loader 本地测试

`hugegraph-loader` 是 HugeGraph 的数据导入工具，支持从多种数据源导入数据。支持从多种数据源（如本地文件、HDFS、关系型数据库等）加载数据到 HugeGraph 中，涉及与 HugeGraph Server、Hadoop、MySQL 等服务的交互。

#### 4.2.1 编译

编译 `hugegraph-client` 和 `hugegraph-loader` 模块：

```bash
mvn install -pl hugegraph-client,hugegraph-loader -am -Dmaven.javadoc.skip=true -DskipTests -ntp
```

#### 4.2.2 依赖服务安装 (根据测试类型选择)

按照 [部署测试环境](#部署测试环境) 部署测试环境 中的说明，启动 `hugegraph-server`，`Hadoop (HDFS)` (仅当运行 HDFS 测试时需要)， `MySQL` (仅当运行 JDBC 测试时需要)。

<div style="text-align: center;">
    <img src="/docs/images/toolchain-test-mermaid-1.png" alt="image">
</div>

#### 4.2.3 运行测试

进入 `hugegraph-loader` 模块目录，并运行测试。`hugegraph-loader` 的测试通过 Maven Profile 进行分类：

```bash
cd hugegraph-loader
mvn test -P unit -ntp
mvn test -P file -ntp
mvn test -P hdfs -ntp
mvn test -P jdbc -ntp
mvn test -P kafka -ntp
```

*  unit test 主要依赖 `hugegraph-loader` 自身的编译, 用于测试 loader 组件内部的逻辑。
* 其他测试模块都需要依赖一个正在运行的 HugeGraph-Server 服务
    * hdfs 还额外依赖 一个可用的 Hadoop (HDFS) 环境;
    * jdbc还额外依赖一个可用的 MySQL 数据库。


**重要提示**：运行特定 Profile 的测试前，请务必确保相应的依赖服务已启动并可访问。

### 4.3 hugegraph-hubble 后端本地测试

`hugegraph-hubble` 是 HugeGraph 的可视化管理工具。其测试包括后端单元测试和 API 测试。

#### 4.3.1 编译

首先，install `hugegraph-client` 和 `hugegraph-loader` (Hubble 间接依赖)，然后编译 `hugegraph-hubble`：

```bash
# 首先，安装 hugegraph-client 和 hugegraph-loader，因为 Hubble 运行依赖它们
mvn install -pl hugegraph-client,hugegraph-loader -am -Dmaven.javadoc.skip=true -DskipTests -ntp
# 然后，编译 hugegraph-hubble
cd hugegraph-hubble
mvn -e compile -Dmaven.javadoc.skip=true -ntp
```

#### 4.3.2 依赖服务安装 

按照 [部署测试环境](#部署测试环境) 部署测试环境 中的说明，启动 `hugegraph-server` 。

**安装 Hubble 其他依赖**

*   **Python 依赖**：
    ```bash
    python -m pip install -r hubble-dist/assembly/travis/requirements.txt
    ```
    *   **注意**：Hubble 测试需要 Python >= 3.11。建议使用虚拟环境：`python -m venv venv && source venv/bin/activate`。

*   **Hubble 打包**：
    ```bash
    mvn package -Dmaven.test.skip=true
    cd apache-hugegraph-hubble-incubating-${version}/bin/bin
    ./start-hubble.sh -d
    ./stop-hubble.sh
    ```
    打包 Hubble，验证其能否正常启动和关闭，确保正确构建并可执行，为后续测试做准备。

#### 4.3.3 运行测试

进入 `hugegraph-hubble` 模块目录，并运行测试：

```bash
mvn test -P unit-test -pl hugegraph-hubble/hubble-be -ntp # 单元测试
hubble-dist/assembly/travis/run-api-test.sh #API测试
```

*  unit test 主要依赖 `hubble-be` 自身的编译, 运行 Hubble 后端（Java 部分）的单元测试。
*  run-api-test需要依赖一个正在运行的 HugeGraph-Server 服务，以及client与loader的正常运行。


**重要提示**：运行 API 测试前，请务必完成client与loader的install，并确保 HugeGraph Server 和 HugeGraph-Hubble 服务均已启动并可访问。

### 4.4 hugegraph-spark-connector 本地测试

`hugegraph-spark-connector` 提供了 HugeGraph 与 Apache Spark 的集成能力。其测试主要验证 Spark 与 HugeGraph 的数据连接和操作。

#### 4.4.1 编译

编译 `hugegraph-client` 和 `hugegraph-spark-connector` 模块：

```bash
mvn install -pl hugegraph-client,hugegraph-spark-connector -am -Dmaven.javadoc.skip=true -DskipTests -ntp
```

#### 4.4.2 依赖服务安装

按照 [部署测试环境](#部署测试环境) 部署测试环境 中的说明，启动 `hugegraph-server` 。

#### 4.4.3 运行测试

进入 `hugegraph-spark-connector` 模块目录，并运行测试：

```bash
cd hugegraph-spark-connector
mvn test -ntp
```

* 一个正在运行的 HugeGraph Server。这些测试会通过 Spark 连接 HugeGraph Server。

### 4.5 hugegraph-tools 本地测试

`hugegraph-tools` 提供了 HugeGraph 的命令行工具集，用于数据管理、备份恢复等操作。其测试主要验证这些工具的功能。

#### 4.5.1 编译

编译 `hugegraph-client` 和 `hugegraph-tools` 模块：

```bash
mvn install -pl hugegraph-client,hugegraph-tools -am -Dmaven.javadoc.skip=true -DskipTests -ntp
```

#### 4.5.2 依赖服务安装 (二选一)

按照 [部署测试环境](#部署测试环境) 部署测试环境 中的说明，启动 `hugegraph-server` 。

#### 4.5.3 运行测试

进入 `hugegraph-tools` 模块目录，并运行功能测试：

```bash
cd hugegraph-tools
mvn test -Dtest=FuncTestSuite -pl hugegraph-tools -ntp
```

* 依赖一个正在运行的 HugeGraph Server 和 `hugegraph-client` 的正常编译。


## 5. 常见问题与故障排除

本节列举了在 HugeGraph 工具链本地测试过程中可能遇到的一些常见问题及其排查方法。

*   **服务未启动或端口冲突**：
    *   **问题描述**：测试失败，提示无法连接到 HugeGraph Server、MySQL 或其他依赖服务。
    *   **排查方法**：
        *   确认所有必要的依赖服务（HugeGraph Server、MySQL、Hadoop 等）已正确启动，且必须确保server的http服务运行在8080端口。
        *   检查服务监听的端口是否与测试配置一致，并且没有被其他程序占用。您可以使用 `lsof -i:<端口号>` (Linux/macOS) 或 `netstat -ano | findstr :<端口号>` (Windows) 来检查端口占用情况。
        *   如果使用 Docker，请检查 `docker compose ps` 输出，确保所有容器都处于 `Up` 状态，并检查容器日志 (`docker compose logs <service_name>`)。

*   **环境变量或参数配置错误**：
    *   **问题描述**：命令执行失败，提示找不到文件、权限不足或参数无效。
    *   **排查方法**：
        *   仔细检查您设置的环境变量（如 `$COMMIT_ID`, `$DB_DATABASE`, `$DB_PASS`）是否正确，并且在执行命令的 shell 会话中已生效。
        *   确认 Maven 命令参数和 Shell 脚本参数的拼写和用法是否正确，参考 [3.2 变量与参数](#32-变量与参数) 章节。
        *   如遇脚本权限问题，先执行：`chmod +x hugegraph-*/assembly/travis/*.sh`。

*   **HDFS 测试问题**：
    *   **问题描述**：HugeGraph-Loader 的 HDFS 测试失败。
    *   **排查方法**：
        *   确保 Hadoop 的 NameNode 和 DataNode 服务正常运行，并且 HDFS 文件系统可访问。
        *   检查 Hadoop 的日志，特别是 DataNode 的日志，确保数据块正常复制和操作。
        *   如果使用 Docker，请确保 Hadoop 容器健康运行，并且测试程序能够正确连接到 HDFS 服务。

*   **JDBC 测试问题**：
    *   **问题描述**：HugeGraph-Loader 的 JDBC 测试失败。
    *   **排查方法**：
        *   确保 MySQL 数据库服务正常运行，并且您提供的数据库名、用户名和密码正确。
        *   检查 MySQL 的日志，看是否有连接或权限问题。
        *   如果使用 Docker，请确保 MySQL 容器健康运行，并且测试程序能够正确连接到 MySQL 服务。

## 6. 参考资料

*   **HugeGraph GitHub 仓库**：[https://github.com/apache/hugegraph](https://github.com/apache/hugegraph)
*   **HugeGraph 工具链 GitHub 仓库**：[https://github.com/apache/hugegraph-toolchain](https://github.com/apache/hugegraph-toolchain)
*   **HugeGraph Server 官方文档**：[https://hugegraph.apache.org/docs/](https://hugegraph.apache.org/docs/)
*   **CI 脚本路径**：`.github/workflows/*-ci.yml` (HugeGraph 工具链项目中的 CI 配置文件，可作为参考)
*   **依赖服务安装脚本**：`hugegraph-*/assembly/travis/` (HugeGraph 工具链项目中用于 Travis CI 的安装脚本，可作为手动安装的参考)