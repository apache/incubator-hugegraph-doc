---

title: "HugeGraph Toolchain Local Testing Guide"
linkTitle: "Toolchain Local Testing"
weight: 7
---

This guide aims to help developers efficiently run tests for the HugeGraph toolchain in a local environment, covering the processes of compiling sub-projects, installing dependent services, running tests, and generating coverage reports.

## 1. Foreword and Core Concepts

### 1.1 Core Dependency: HugeGraph Server

In the testing of the HugeGraph toolchain, **HugeGraph Server is the core dependency for the vast majority of integration and functional tests**. It provides the core services of the graph database, and many components in the toolchain (such as Client, Loader, Hubble, Spark Connector, Tools) need to interact with the Server to perform their functions and be tested. Therefore, a properly configured and running HugeGraph Server is a prerequisite for complete functional testing. This guide will explain how to install/build HugeGraph Server in the sections below.

### 1.2 Explanation of Test Suite Types

In the testing of the HugeGraph toolchain, you may encounter the following common types of test suites:

*   **Unit Tests**:
    *   **Goal**: To verify the correctness of the smallest testable units in the program (usually a single function, method, or class). They typically do not involve external dependencies (like databases, network services, etc.).

*   **API Tests (API Tests / ApiTestSuite)**:
    *   **Goal**: To verify the correctness, stability, and compliance of the APIs provided by the program. They usually simulate client requests, interact with the server, and check if the API's response data and processing mechanisms meet expectations.
    *   **Characteristics**: Requires a running server (like HugeGraph Server) to respond to API requests.

*   **Functional Tests (Functional Tests / FuncTestSuite)**:
    *   **Goal**: To verify that a specific function of a system or component works as required. They are used to simulate user scenarios or business processes, involve the interaction of multiple components, and are end-to-end tests.
    *   **Characteristics**: They take a relatively long time to execute, require a complete system environment (including all dependent services) to run, and can identify issues at the integration level.

## 2. Pre-Test Preparation

### 2.1 System and Software Requirements

*   **Operating System**: Linux or macOS is recommended. For Windows, please use WSL2.
*   **JDK**: >= 11. Ensure your `JAVA_HOME` environment variable is correctly configured.
*   **Maven**: Version 3.5 or higher is recommended for project building and dependency management.
*   **Python**: >= 3.11 (only required for HugeGraph-Hubble related tests). It is recommended to use a virtual environment to manage it and avoid version conflicts.

### 2.2 Clone the Code Repository

First, you need to clone the source code repository of the HugeGraph toolchain:

```bash
git clone https://github.com/${GITHUB_USER_NAME}/hugegraph-toolchain.git
cd hugegraph-toolchain
```

## 3. Deploying the Test Environment

Regarding the test environment, since HugeGraph Server is the core dependency for most integration and functional tests, you can refer to the [Community Edition Documentation](https://hugegraph.apache.org/docs/quickstart/hugegraph/hugegraph-server/) for instructions on installing/building HugeGraph-Server. In this testing guide, we will introduce two methods: deployment via script and deployment via Docker.

**Important Notes:**
* It is recommended to prioritize using a script for local deployment of HugeGraph Server. This method allows you to precisely control the Server version by specifying a Git Commit ID, ensuring high compatibility with your toolchain code version and effectively avoiding test anomalies caused by interface or implementation changes.

* Docker deployment is more suitable for quickly starting a default-configured HugeGraph Server. However, for fine-grained integration testing, especially when your toolchain code depends on features or fixes from a specific HugeGraph Server version, the version lag or default configuration of the Docker image may cause tests to fail. When there are interface/implementation changes between the toolchain code and HugeGraph Server, the convenience of Docker deployment might lead to test failures. In such cases, it is recommended to fall back to the script deployment method.

### 3.1 Quick Deployment of Test Environment Using a Script (Recommended)

This method allows you to compile and install a specific version of HugeGraph Server from the source code, ensuring consistency between the test environment and a specific HugeGraph Server version, which is crucial for reproducing issues or verifying compatibility.

#### 3.1.1 Variables and Parameters

*   **`$COMMIT_ID`**
    *   Specifies the Git Commit ID of the HugeGraph Server source code. This variable is used when you need to compile and install a specific version of HugeGraph Server from the source as a test dependency. It ensures consistency between the test environment and the specific HugeGraph Server version, which is crucial for reproducing issues or verifying compatibility. Pass it directly as a parameter to the `install-hugegraph-from-source.sh` script.

*   **`$DB_DATABASE` & `$DB_PASS`**
    *   Specify the name of the MySQL database and the root user password for the connection used in HugeGraph-Loader's JDBC tests. Providing this database connection information allows the Loader to read and write data correctly. Pass them directly as parameters to the `install-mysql.sh` script.

**Install and Start HugeGraph Server**

If you choose to install manually, you can use the following script to install HugeGraph Server. The script is located in the `/assembly/travis/` directory of any tool's repository. It is used to pull the HugeGraph Server source code from a specified commit ID, compile it, unzip it, and start the service via both http and https.
```bash
hugegraph-*/assembly/travis/install-hugegraph-from-source.sh $COMMIT_ID
```

*   `$COMMIT_ID`: Specifies the Git Commit ID of HugeGraph Server.
*   The default http port is 8080, and the https port is 8443. Please ensure they are not occupied before starting the server.

**Install and Start Hadoop (HDFS)** (Only required when running HDFS tests for hugegraph-loader):
```bash
hugegraph-loader/assembly/travis/install-hadoop.sh
```

**Install and Start MySQL** (Only required when running JDBC tests for hugegraph-loader):
```bash
hugegraph-loader/assembly/travis/install-mysql.sh $DB_DATABASE $DB_PASS
```

**Health Check**

```bash
curl http://localhost:8080/graphs
```
If it returns `{"graphs":["hugegraph"]}`, it means the server is ready to receive requests.

### Using Docker to Deploy the Test Environment

By using the officially released `hugegraph-server` Docker image, you can quickly start a HugeGraph Server. This method simplifies the setup of the test environment, ensures environmental consistency, and improves test repeatability. **However, please note that the Docker image may not be updated to the latest development version of HugeGraph Server in a timely manner. This means that if your toolchain code depends on the latest interfaces or features of HugeGraph Server, using the Docker image may lead to compatibility issues. In such cases, it is recommended to use the script method to deploy a specific `COMMIT_ID` of HugeGraph Server.**

#### Quick Start with Docker

```bash
docker run -itd --name=server -p 8080:8080 hugegraph/hugegraph:latest
```

This quickly starts a HugeGraph server with built-in RocksDB, which meets the requirements for most tests and toolchain components.

#### Example `docker-compose.yml` File

The following is an example `docker-compose.yml` file that defines the HugeGraph Server, MySQL, and Hadoop (HDFS) services. You can adjust it according to your actual testing needs.

```yaml
version: '3.8'

services:
  hugegraph-server:
    image: hugegraph/hugegraph:latest  # Can be replaced with a specific version, or build your own image
    container_name: hugegraph-server
    ports:
      - "8080:8080"  # HugeGraph Server HTTP port
    environment:
      # Configure HugeGraph Server parameters as needed, e.g., backend storage
      - HUGEGRAPH_SERVER_OPTIONS="-Dstore.backend=rocksdb"
    volumes:
      # If you need to persist data or mount configuration files, add volumes here
      # - ./hugegraph-data:/opt/hugegraph/data
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8080/graphs || exit 1"]
      interval: 5s
      timeout: 3s
      retries: 5
    networks:
      - hugegraph-net
  
  # If you need JDBC tests for hugegraph-loader, you can add the following service
  #   mysql:
  #     image: mysql:5.7
  #     container_name: mysql-db
  #     environment:
  #       MYSQL_ROOT_PASSWORD: ${DB_PASS:-your_mysql_root_password} # Read from environment variable, or use default
  #       MYSQL_DATABASE: ${DB_DATABASE:-hugegraph_test_db} # Read from environment variable, or use default
  #     ports:
  #       - "3306:3306"
  #     volumes:
  #       - ./mysql-data:/var/lib/mysql # Data persistence
  #     healthcheck:
  #       test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-p${DB_PASS:-your_mysql_root_password}"]
  #       interval: 5s
  #       timeout: 3s
  #       retries: 5
  #     networks:
  #       - hugegraph-net

  # If you need Hadoop/HDFS tests for hugegraph-loader, you can add the following services
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

#### Hadoop Configuration Mounts
📁 `./config/core-site.xml` content:

```xml
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://namenode:8020</value>
    </property>
</configuration>
```

📁 `./config/hdfs-site.xml` content:

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

**Explanation**:

*   **`hugegraph-server`**: Uses the `hugegraph/hugegraph:latest` image. You can replace it with a specific version as needed, or if you need to build the Server from source, you can create a custom Dockerfile and reference it here.
*   **`mysql`**: Uses the official `mysql:5.7` image. `MYSQL_ROOT_PASSWORD` and `MYSQL_DATABASE` can be passed in via environment variables (`DB_PASS`, `DB_DATABASE`) or use default values.
*   **`namenode` and `datanode`** (commented out): If you need to run HDFS tests for HugeGraph-Loader, you can uncomment and configure the Hadoop services.

#### Starting and Stopping the Docker Environment

1.  **Save `docker-compose.yml`**: Save the above content as a `docker-compose.yml` file, preferably in the root directory of the `hugegraph-toolchain` project or in a separate `docker` directory.

2.  **Start Services**: In the directory where the `docker-compose.yml` file is located, run the following command to start all services:

    ```bash
    docker compose up -d
    ```
    *   The `-d` parameter means running the containers in the background.

3.  **Check Service Status**: You can use the following commands to check the running status of the containers:

    ```bash
    docker compose ps
    lsof -i:8080 # server port
    lsof -i:8020 # hadoop port
    lsof -i:3306 # mysql port
    ```

4.  **Stop Services**: After testing is complete, you can stop and remove all containers:

    ```bash
    docker compose down
    ```

## 4. Start Testing

Generally, the local testing process for each tool is as follows, which will be explained in detail below.

<div style="text-align: center;">
    <img src="/docs/images/toolchain-test-mermaid-4.png" alt="HugeGraph Toolchain Testing Process">
</div>


### 4.1 hugegraph-client Local Testing (Java Version)

`hugegraph-client` is the Java client library for HugeGraph, used for interacting with HugeGraph Server. Its tests mainly verify the communication and data operations between the client and the server.

#### 4.1.1 Compile

First, compile the `hugegraph-client` module:

```bash
mvn -e compile -pl hugegraph-client -Dmaven.javadoc.skip=true -ntp
```

*   `-pl hugegraph-client`: Specifies to compile only the `hugegraph-client` module.
*   `-Dmaven.javadoc.skip=true`: Skips Javadoc generation.
*   `-ntp`: No transfer progress.

#### 4.1.2 Dependent Service Installation

Follow the instructions in [Deploying the Test Environment](#deploying-the-test-environment) to start `hugegraph-server`.

##### Server Authentication Settings (Authentication tests are not supported for Docker image versions <= 1.5.0)

Since the client's ApiTest includes authentication tests, you must ensure that the server's password is the same as in the test code; otherwise, data transfer between the client and server will fail. If you use the client's built-in script to install and start the server, you can skip this step.
However, if you start the server using other methods, you must perform the following authentication settings, as the default server does not have them set. For example, enter the container environment with `docker exec -it server bash` to make modifications.

```bash
# Step 1: Modify the authentication mode
vi conf/rest-server.properties
```
Change line 23 from `auth.authenticator=` to `auth.authenticator=org.apache.hugegraph.auth.StandardAuthenticator`

```bash
# Step 2: Set the password
bin/stop-hugegraph.sh
echo -e "pa" | bin/init-store.sh # This script initializes the HugeGraph store and sets default user credentials, including the password for authentication tests
bin/start-hugegraph.sh
```

#### 4.1.3 Run Tests

Go to the `hugegraph-client` module directory and run the tests:

```bash
cd hugegraph-client
mvn test -Dtest=UnitTestSuite -ntp
mvn test -Dtest=ApiTestSuite -ntp
mvn test -Dtest=FuncTestSuite -ntp
```

*   The unit test mainly depends on the compilation of `hugegraph-client` itself and is used to test the internal logic of the client.
*   Other test modules require a running HugeGraph-Server service.

### 4.2 hugegraph-loader Local Testing

`hugegraph-loader` is HugeGraph's data import tool, which supports importing data from various sources. It supports loading data from multiple sources (such as local files, HDFS, relational databases, etc.) into HugeGraph, involving interactions with services like HugeGraph Server, Hadoop, and MySQL.

#### 4.2.1 Compile

Compile the `hugegraph-client` and `hugegraph-loader` modules:

```bash
mvn install -pl hugegraph-client,hugegraph-loader -am -Dmaven.javadoc.skip=true -DskipTests -ntp
```

#### 4.2.2 Dependent Service Installation (Choose based on test type)

Follow the instructions in [Deploying the Test Environment](#deploying-the-test-environment) to start `hugegraph-server`, `Hadoop (HDFS)` (only required when running HDFS tests), and `MySQL` (only required when running JDBC tests).

<div style="text-align: center;">
    <img src="/docs/images/toolchain-test-mermaid-3.png" alt="image">
</div>

#### 4.2.3 Run Tests

Go to the `hugegraph-loader` module directory and run the tests. The tests for `hugegraph-loader` are categorized using Maven Profiles:

```bash
cd hugegraph-loader
mvn test -P unit -ntp
mvn test -P file -ntp
mvn test -P hdfs -ntp
mvn test -P jdbc -ntp
mvn test -P kafka -ntp
```

*   The unit test mainly depends on the compilation of `hugegraph-loader` itself and is used to test the internal logic of the loader component.
*   Other test modules require a running HugeGraph-Server service.
    *   `hdfs` also requires an available Hadoop (HDFS) environment.
    *   `jdbc` also requires an available MySQL database.

**Important Note**: Before running tests for a specific Profile, make sure the corresponding dependent services are started and accessible.

### 4.3 hugegraph-hubble Backend Local Testing

`hugegraph-hubble` is the visual management tool for HugeGraph. Its tests include backend unit tests and API tests.

#### 4.3.1 Compile

First, install `hugegraph-client` and `hugegraph-loader` (Hubble has an indirect dependency), then compile `hugegraph-hubble`:

```bash
# First, install hugegraph-client and hugegraph-loader, as Hubble's operation depends on them
mvn install -pl hugegraph-client,hugegraph-loader -am -Dmaven.javadoc.skip=true -DskipTests -ntp
# Then, compile hugegraph-hubble
cd hugegraph-hubble
mvn -e compile -Dmaven.javadoc.skip=true -ntp
```

#### 4.3.2 Dependent Service Installation

Follow the instructions in [Deploying the Test Environment](#deploying-the-test-environment) to start `hugegraph-server`.

**Install Other Hubble Dependencies**

*   **Python Dependencies**:
    ```bash
    python -m pip install -r hubble-dist/assembly/travis/requirements.txt
    ```
    *   **Note**: Hubble tests require Python >= 3.11. It is recommended to use a virtual environment: `python -m venv venv && source venv/bin/activate`.

*   **Hubble Packaging**:
    ```bash
    mvn package -Dmaven.test.skip=true
    cd apache-hugegraph-hubble-incubating-${version}/bin/bin
    ./start-hubble.sh -d
    ./stop-hubble.sh
    ```
    Package Hubble, verify that it can start and stop normally to ensure it is built correctly and executable, preparing for subsequent tests.

#### 4.3.3 Run Tests

Go to the `hugegraph-hubble` module directory and run the tests:

```bash
mvn test -P unit-test -pl hugegraph-hubble/hubble-be -ntp # Unit Test
hubble-dist/assembly/travis/run-api-test.sh # API Test
```

*   The unit test mainly depends on the compilation of `hubble-be` itself and runs the unit tests for the Hubble backend (Java part).
*   `run-api-test` requires a running HugeGraph-Server service, as well as the proper functioning of the client and loader.

**Important Note**: Before running API tests, make sure to install the client and loader, and ensure that both HugeGraph Server and HugeGraph-Hubble services are started and accessible.

### 4.4 hugegraph-spark-connector Local Testing

`hugegraph-spark-connector` provides integration capabilities between HugeGraph and Apache Spark. Its tests mainly verify the data connection and operations between Spark and HugeGraph.

#### 4.4.1 Compile

Compile the `hugegraph-client` and `hugegraph-spark-connector` modules:

```bash
mvn install -pl hugegraph-client,hugegraph-spark-connector -am -Dmaven.javadoc.skip=true -DskipTests -ntp
```

#### 4.4.2 Dependent Service Installation

Follow the instructions in [Deploying the Test Environment](#deploying-the-test-environment) to start `hugegraph-server`.

#### 4.4.3 Run Tests

Go to the `hugegraph-spark-connector` module directory and run the tests:

```bash
cd hugegraph-spark-connector
mvn test -ntp
```

*   Requires a running HugeGraph Server. These tests will connect to HugeGraph Server via Spark.

### 4.5 hugegraph-tools Local Testing

`hugegraph-tools` provides a command-line toolset for HugeGraph, used for data management, backup and recovery, etc. Its tests mainly verify the functionality of these tools.

#### 4.5.1 Compile

Compile the `hugegraph-client` and `hugegraph-tools` modules:

```bash
mvn install -pl hugegraph-client,hugegraph-tools -am -Dmaven.javadoc.skip=true -DskipTests -ntp
```

#### 4.5.2 Dependent Service Installation (Choose one)

Follow the instructions in [Deploying the Test Environment](#deploying-the-test-environment) to start `hugegraph-server`.

#### 4.5.3 Run Tests

Go to the `hugegraph-tools` module directory and run the functional tests:

```bash
cd hugegraph-tools
mvn test -Dtest=FuncTestSuite -pl hugegraph-tools -ntp
```

*   Depends on a running HugeGraph Server and the proper compilation of `hugegraph-client`.

## 5. Common Issues and Troubleshooting

This section lists some common problems that may be encountered during local testing of the HugeGraph toolchain and their troubleshooting methods.

*   **Service Not Started or Port Conflict**:
    *   **Problem Description**: Test fails with a message indicating it cannot connect to HugeGraph Server, MySQL, or other dependent services.
    *   **Troubleshooting**:
        *   Confirm that all necessary dependent services (HugeGraph Server, MySQL, Hadoop, etc.) have been started correctly, and ensure that the server's http service is running on port 8080.
        *   Check if the port the service is listening on is consistent with the test configuration and is not occupied by another program. You can use `lsof -i:<port_number>` (Linux/macOS) or `netstat -ano | findstr :<port_number>` (Windows) to check port usage.
        *   If using Docker, check the output of `docker compose ps` to ensure all containers are in the `Up` state, and check the container logs (`docker compose logs <service_name>`).

*   **Environment Variable or Parameter Configuration Error**:
    *   **Problem Description**: Command execution fails with a message about a file not found, insufficient permissions, or invalid parameters.
    *   **Troubleshooting**:
        *   Carefully check if the environment variables you set (e.g., `$COMMIT_ID`, `$DB_DATABASE`, `$DB_PASS`) are correct and have taken effect in the shell session where the command is executed.
        *   Confirm that the spelling and usage of Maven command parameters and Shell script parameters are correct, referring to the [3.2 Variables and Parameters](#3-2-variables-and-parameters) section.
        *   If you encounter script permission issues, first execute: `chmod +x hugegraph-*/assembly/travis/*.sh`.

*   **HDFS Test Issues**:
    *   **Problem Description**: HDFS tests for HugeGraph-Loader fail.
    *   **Troubleshooting**:
        *   Ensure that Hadoop's NameNode and DataNode services are running normally and the HDFS file system is accessible.
        *   Check Hadoop's logs, especially the DataNode's logs, to ensure that data blocks are being replicated and operated on correctly.
        *   If using Docker, ensure the Hadoop container is healthy and the test program can correctly connect to the HDFS service.

*   **JDBC Test Issues**:
    *   **Problem Description**: JDBC tests for HugeGraph-Loader fail.
    *   **Troubleshooting**:
        *   Ensure the MySQL database service is running normally and that the database name, username, and password you provided are correct.
        *   Check MySQL's logs for any connection or permission issues.
        *   If using Docker, ensure the MySQL container is healthy and the test program can correctly connect to the MySQL service.

## 6. References

*   **HugeGraph GitHub Repository**: [https://github.com/apache/hugegraph](https://github.com/apache/hugegraph)
*   **HugeGraph Toolchain GitHub Repository**: [https://github.com/apache/hugegraph-toolchain](https://github.com/apache/hugegraph-toolchain)
*   **HugeGraph Server Official Documentation**: [https://hugegraph.apache.org/docs/](https://hugegraph.apache.org/docs/)
*   **CI Script Path**: `.github/workflows/*-ci.yml` (CI configuration files in the HugeGraph toolchain project, which can be used as a reference)
*   **Dependent Service Installation Scripts**: `hugegraph-*/assembly/travis/` (Installation scripts used for Travis CI in the HugeGraph toolchain project, which can be used as a reference for manual installation)