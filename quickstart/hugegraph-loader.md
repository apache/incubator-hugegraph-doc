## HugeGraph-Loader Quick Start

### 1 概述

HugeGraph-Loader 是 HugeGragh 的数据导入组件，能够将多种数据源的数据转化为图的顶点和边并批量导入到图数据库中。

目前支持的数据源包括：

- 本地磁盘文件或目录，支持 TEXT、CSV 和 JSON 格式的文件，支持压缩文件
- HDFS 文件或目录，支持压缩文件
- 主流关系型数据库，如 MySQL、PostgreSQL、Oracle、SQL Server

本地磁盘文件和 HDFS 文件支持断点续传。

后面会具体说明。

> 注意：使用 HugeGraph-Loader 需要依赖 HugeGraph Server 服务，下载和启动 Server 请参考 [HugeGraph-Server Quick Start](/quickstart/hugegraph-server.html)

### 2 获取 HugeGraph-Loader

有两种方式可以获取 HugeGraph-Loader：

- 下载已编译的压缩包
- 克隆源码编译安装

#### 2.1 下载已编译的压缩包

下载最新版本的 HugeGraph-Loader release 包：

```bash
wget https://github.com/hugegraph/hugegraph-loader/releases/download/v${version}/hugegraph-loader-${version}.tar.gz
tar zxvf hugegraph-loader-${version}.tar.gz
```

#### 2.2 克隆源码编译安装

克隆最新版本的 HugeGraph-Loader 源码包：

```bash
$ git clone https://github.com/hugegraph/hugegraph-loader.git
```

由于Oracle ojdbc license的限制，需要手动安装ojdbc到本地maven仓库。
访问[Oracle jdbc 下载](https://www.oracle.com/database/technologies/appdev/jdbc-downloads.html)页面。选择Oracle Database 12c Release 2 (12.2.0.1) drivers，如下图所示。
![在这里插入图片描述](images/oracle-download.png)
打开链接后，选择“ojdbc8.jar”, 如下图所示。
![在这里插入图片描述](images/ojdbc8.png)
 把ojdbc8安装到本地maven仓库，进入``ojdbc8.jar``所在目录，执行以下命令。
```
mvn install:install-file -Dfile=./ojdbc8.jar -DgroupId=com.oracle   -DartifactId=ojdbc8 -Dversion=12.2.0.1 -Dpackaging=jar
```

编译生成 tar 包:

```bash
cd hugegraph-loader
mvn clean package -DskipTests
```

### 3 使用流程

使用 HugeGraph-Loader 的基本流程分为以下几步：

- 编写图模型
- 准备数据文件
- 编写输入源映射文件
- 执行命令导入

#### 3.1 编写图模型

这一步是建模的过程，用户需要对自己已有的数据和想要创建的图模型有一个清晰的构想，然后编写 schema 建立图模型。

比如想创建一个拥有两类顶点及两类边的图，顶点是"人"和"软件"，边是"人认识人"和"人创造软件"，并且这些顶点和边都带有一些属性，比如顶点"人"有："姓名"、"年龄"等属性，
"软件"有："名字"、"售卖价格"等属性；边"认识"有: "日期"属性等。

<center>
  <img src="/images/demo-graph-model.png" alt="image">
  <p>示例图模型</p>
</center>

在设计好了图模型之后，我们可以用`groovy`编写出`schema`的定义，并保存至文件中，这里命名为`schema.groovy`。

```groovy
// 创建一些属性
schema.propertyKey("name").asText().ifNotExist().create();
schema.propertyKey("age").asInt().ifNotExist().create();
schema.propertyKey("city").asText().ifNotExist().create();
schema.propertyKey("date").asText().ifNotExist().create();
schema.propertyKey("price").asDouble().ifNotExist().create();

// 创建 person 顶点类型，其拥有三个属性：name, age, city，主键是 name
schema.vertexLabel("person").properties("name", "age", "city").primaryKeys("name").ifNotExist().create();
// 创建 software 顶点类型，其拥有两个属性：name, price，主键是 name
schema.vertexLabel("software").properties("name", "price").primaryKeys("name").ifNotExist().create();

// 创建 knows 边类型，这类边是从 person 指向 person 的
schema.edgeLabel("knows").sourceLabel("person").targetLabel("person").ifNotExist().create();
// 创建 created 边类型，这类边是从 person 指向 software 的
schema.edgeLabel("created").sourceLabel("person").targetLabel("software").ifNotExist().create();
```

> 关于 schema 的详细说明请参考 [hugegraph-client](/clients/hugegraph-client.md) 中对应部分。

#### 3.2 准备数据

目前 HugeGraph-Loader 支持的数据源包括：

- 本地磁盘文件或目录
- HDFS 文件或目录
- 部分关系型数据库

##### 3.2.1 数据源结构

###### 3.2.1.1 本地磁盘文件或目录

用户可以指定本地磁盘文件作为数据源，如果数据分散在多个文件中，也支持以某个目录作为数据源，但暂时不支持以多个目录作为数据源。

比如：我的数据分散在多个文件中，part-0、part-1 ... part-n，要想执行导入，必须保证它们是放在一个目录下的。然后在 loader 的映射文件中，将`path`指定为该目录即可。

支持的文件格式包括：

- TEXT
- CSV
- JSON

TEXT 是自定义分隔符的文本文件，第一行通常是标题，记录了每一列的名称，也允许没有标题行（在映射文件中指定）。其余的每行代表一条记录，会被转化为一个顶点/边；行的每一列对应一个字段，会被转化为顶点/边的 id、label 或属性；

示例如下：

```
id|name|lang|price|ISBN
1|lop|java|328|ISBN978-7-107-18618-5
2|ripple|java|199|ISBN978-7-100-13678-5
```

CSV 是分隔符为逗号`,`的 TEXT 文件，当列值本身包含逗号时，该列值需要用双引号包起来，如：

```
marko,29,Beijing
"li,nary",26,"Wu,han"
```

JSON 文件要求每一行都是一个 JSON 串，且每行的格式需保持一致。

```json
{"source_name": "marko", "target_name": "vadas", "date": "20160110", "weight": 0.5}
{"source_name": "marko", "target_name": "josh", "date": "20130220", "weight": 1.0}
```

###### 3.2.1.2 HDFS 文件或目录

用户也可以指定 HDFS 文件或目录作为数据源，上面关于`本地磁盘文件或目录`的要求全部适用于这里。除此之外，鉴于 HDFS 上通常存储的都是压缩文件，loader 也提供了对压缩文件的支持，并且`本地磁盘文件或目录`同样支持压缩文件。

目前支持的压缩文件类型包括：GZIP、BZ2、XZ、LZMA、SNAPPY_RAW、SNAPPY_FRAMED、Z、DEFLATE、LZ4_BLOCK 和 LZ4_FRAMED。

###### 3.2.1.3 主流关系型数据库

loader 还支持以部分关系型数据库作为数据源，目前支持 MySQL、PostgreSQL、Oracle 和 SQL Server。

但目前对表结构要求较为严格，如果导入过程中需要做**关联查询**，这样的表结构是不允许的。关联查询的意思是：在读到表的某行后，发现某列的值不能直接使用（比如外键），需要再去做一次查询才能确定该列的真实值。

举个例子：假设有三张表，person、software 和 created

```
// person 表结构
id | name | age | city 
```

```
// software 表结构
id | name | lang | price
```

```
// created 表结构
id | p_id | s_id | date
```

如果在建模（schema）时指定 person 或 software 的 id 策略是 PRIMARY_KEY，选择以 name 作为 primary keys（注意：这是 hugegraph 中 vertexlabel 的概念），在导入边数据时，由于需要拼接出源顶点和目标顶点的 id，必须拿着 p_id/s_id 去 person/software 表中查到对应的 name，这种需要做额外查询的表结构的情况，loader 暂时是不支持的。这时可以采用以下两种方式替代：

1. 仍然指定 person 和 software 的 id 策略为 PRIMARY_KEY，但是以 person 表和 software 表的 id 列作为顶点的主键属性，这样导入边时直接使用 p_id 和 s_id 和顶点的 label 拼接就能生成 id 了；
2. 指定 person 和 software 的 id 策略为 CUSTOMIZE，然后直接以 person 表和 software 表的 id 列作为顶点 id，这样导入边时直接使用 p_id 和 s_id 即可；

关键点就是要让边能直接使用 p_id 和 s_id，不要再去查一次。

##### 3.2.2 准备顶点和边数据

###### 3.2.2.1 顶点数据

顶点数据文件由一行一行的数据组成，一般每一行作为一个顶点，每一列会作为顶点属性。下面以 CSV 格式作为示例进行说明。

- person 顶点数据（数据本身不包含 header）

```csv
Tom,48,Beijing
Jerry,36,Shanghai
```

- software 顶点数据（数据本身包含 header）

```csv
name,price
Photoshop,999
Office,388
```

###### 3.2.2.2 边数据

边数据文件由一行一行的数据组成，一般每一行作为一条边，其中有部分列会作为源顶点和目标顶点的 id，其他列作为边属性。下面以 JSON 格式作为示例进行说明。

- knows 边数据

```json
{"source_name": "Tom", "target_name": "Jerry", "date": "2008-12-12"}
```

- created 边数据

```json
{"source_name": "Tom", "target_name": "Photoshop"}
{"source_name": "Tom", "target_name": "Office"}
{"source_name": "Jerry", "target_name": "Office"}
```

#### 3.3 编写数据源映射文件

输入源的映射文件是`JSON`格式的，由多个**顶点映射**和**边映射**块组成，顶点映射和边映射分别对应某类顶点/边的输入源映射。每个顶点映射和边映射块内部会包含一个**输入源**的块，这个输入源块就对应上面介绍的`本地磁盘文件或目录`、`HDFS 文件或目录`和`关系型数据库`，负责描述数据源的基本信息。

先给出上面图模型和数据文件的输入源的映射文件 mapping.json：

```json
{
  "vertices": [
    {
      "label": "person",
      "input": {
        "type": "file",
        "path": "vertex_person.csv",
        "format": "CSV",
        "header": ["name", "age", "city"],
        "charset": "UTF-8"
      }
    },
    {
      "label": "software",
      "input": {
        "type": "file",
        "path": "vertex_software.csv",
        "format": "CSV"
      }
    }
  ],
  "edges": [
    {
      "label": "knows",
      "source": ["source_name"],
      "target": ["target_name"],
      "input": {
        "type": "file",
        "path": "edge_knows.json",
        "format": "JSON"
      },
      "field_mapping": {
        "source_name": "name",
        "target_name": "name"
      }
    },
    {
      "label": "created",
      "source": ["source_name"],
      "target": ["target_name"],
      "input": {
        "type": "file",
        "path": "edge_created.json",
        "format": "JSON"
      },
      "field_mapping": {
        "source_name": "name",
        "target_name": "name"
      }
    }
  ]
}
```

##### 3.3.1 顶点和边映射

顶点和边映射的节点（JSON 文件中的一个 key）有很多相同的部分，下面先介绍相同部分，再分别介绍`顶点映射`和`边映射`的特有节点。

**相同部分的节点**

- label: 待导入的顶点/边数据所属的`label`，必填；                                                                                   
- input: 顶点/边输入源的信息，是一个复合结构，必填；    
- field_mapping: 将输入源列的列名映射为顶点/边的属性名，选填；
- value_mapping: 将输入源的数据值映射为顶点/边的属性值，选填；
- selected: 选择某些列插入，其他未选中的不插入，不能与`ignored`同时存在，选填；                                                                           
- ignored: 忽略某些列，使其不参与插入，不能与`selected`同时存在，选填；
- null_values: 可以指定一些字符串代表空值，比如"NULL"，如果该列对应的顶点/边属性又是一个可空属性，那在构造顶点/边时不会设置该属性的值，选填；                                                                                
- update_strategies: 如果数据需要按特定方式批量**更新**时可以对每个属性指定具体的更新策略 (具体见下)，选填；

**更新策略**支持8种 :  (需要全大写)

1. 数值累加 : `SUM`
2. 两个数字/日期取更大的: `BIGGER`
3. 两个数字/日期取更小: `SMALLER`
4. **Set**属性取并集: `UNION`
5. **Set**属性取交集: `INTERSECTION`
6. **List**属性追加元素: `APPEND`
7. **List/Set**属性删除元素: `ELIMINATE`
8. 覆盖已有属性: `OVERRIDE`

**注意:** 如果新导入的属性值为空, 会采用已有的旧数据而不会采用空值, 效果可以参考如下示例

```javascript
// JSON文件中以如下方式指定更新策略
{
  "vertices": [
    {
      "label": "person",
      "update_strategies": {
        "age": "SMALLER",
        "set": "UNION"
      },
      "input": {
        "type": "file",
        "path": "vertex_person.txt",
        "format": "TEXT",
        "header": ["name", "age", "set"]
      }
    }
  ]
}

// 1.写入一行带OVERRIDE更新策略的数据 (这里null代表空)
'a b null null'

// 2.再写一行
'null null c d'

// 3.最后可以得到
'a b c d'   

// 如果没有更新策略, 则会得到
'null null c d'
```

> **注意** : 采用了批量更新的策略后, 磁盘读请求数会大幅上升, 导入速度相比纯写覆盖会慢数倍 (此时HDD磁盘[IOPS](https://en.wikipedia.org/wiki/IOPS)会成为瓶颈, 建议采用SSD以保证速度)

**顶点映射的特有节点**

- id: 指定某一列作为顶点的 id 列，当顶点 id 策略为`CUSTOMIZE`时，必填；当 id 策略为`PRIMARY_KEY`时，必须为空；

**边映射的特有节点**
                                                                                                                                                         
- source: 选择输入源某几列作为**源顶点**的 id 列，当源顶点的 id 策略为 `CUSTOMIZE`时，必须指定某一列作为顶点的 id 列；当源顶点的 id 策略为 `PRIMARY_KEY`时，必须指定一列或多列用于拼接生成顶点的 id，也就是说，不管是哪种 id 策略，此项必填； 
- target: 指定某几列作为**目标顶点**的 id 列，与 source 类似，不再赘述；                                                                                                                           

##### 3.3.2 输入源映射

输入源目前分为三类：FILE、HDFS、JDBC，由`type`节点区分，我们称为本地文件输入源、HDFS 输入源和 JDBC 输入源，下面分别介绍。

###### 3.3.2.1 本地文件输入源

- type: 输入源类型，必须填 file 或 FILE； 
- path: 本地文件或目录的路径，绝对路径或相对于映射文件的相对路径，建议使用绝对路径，必填；
- file_filter: 从`path`中筛选复合条件的文件，复合结构，目前只支持配置扩展名，用子节点`extensions`表示，默认为"*"，表示保留所有文件；
- format: 本地文件的格式，可选值为 CSV、TEXT 及 JSON，必须大写，必填；               
- header: 文件各列的列名，如不指定则会以数据文件第一行作为 header；当文件本身有标题且又指定了 header，文件的第一行会被当作普通的数据行；JSON 文件不需要指定 header，选填；    
- delimiter: 文件行的列分隔符，默认以逗号`","`作为分隔符，`JSON`文件不需要指定，选填；     
- charset: 文件的编码字符集，默认`UTF-8`，选填；    
- date_format: 自定义的日期格式，默认值为 yyyy-MM-dd HH:mm:ss，选填； 
- skipped_line: 想跳过的行，复合结构，目前只能配置要跳过的行的正则表达式，用子节点`regex`描述，默认不跳过任何行，选填；
- compression: 文件的压缩格式，可选值为 NONE、GZIP、BZ2、XZ、LZMA、SNAPPY_RAW、SNAPPY_FRAMED、Z、DEFLATE、LZ4_BLOCK 和 LZ4_FRAMED，默认为 NONE，表示非压缩文件，选填；

###### 3.3.2.2 HDFS 输入源

上述`本地文件输入源`的节点及含义这里基本都适用，下面仅列出 HDFS 输入源不一样的和特有的节点。

- type: 输入源类型，必须填 hdfs 或 HDFS，必填； 
- path: HDFS 文件或目录的路径，必须是 HDFS 的绝对路径，必填； 
- fs_default_fs: HDFS 集群的 fs.defaultFS 值（namenode 节点信息），默认使用 fs.defaultFS 的默认值，选填；

###### 3.3.2.3 JDBC 输入源

前面说到过支持多种关系型数据库，但由于它们的映射结构非常相似，故统称为 JDBC 输入源，然后用`vendor`节点区分不同的数据库。

- type: 输入源类型，必须填 jdbc 或 JDBC，必填；
- vendor: 数据库类型，可选项为 [MySQL、PostgreSQL、Oracle、SQLServer]，不区分大小写，必填；
- driver: jdbc 使用的 driver 类型，必填；
- url: jdbc 要连接的数据库的 url，必填；
- database: 要连接的数据库名，必填；
- schema: 要连接的 schema 名，不同的数据库要求不一样，下面详细说明；
- table: 要连接的表名，必填；
- username: 连接数据库的用户名，必填；
- password: 连接数据库的密码，必填；
- batch_size: 按页获取表数据时的一页的大小，默认为 500，选填；

**MYSQL**

| 节点 | 固定值或常见值 |
| --- | --- | 
| vendor | MYSQL |
| driver | com.mysql.cj.jdbc.Driver |
| url | jdbc:mysql://127.0.0.1:3306 |

schema: 可空，若填写必须与database的值一样

**POSTGRESQL**

| 节点 | 固定值或常见值 |
| --- | --- | 
| vendor | POSTGRESQL |
| driver | org.postgresql.Driver |
| url | jdbc:postgresql://127.0.0.1:5432 |

schema: 可空，默认值为“public”

**ORACLE**

| 节点 | 固定值或常见值 |
| --- | --- | 
| vendor | ORACLE |
| driver | oracle.jdbc.driver.OracleDriver |
| url | jdbc:oracle:thin:@127.0.0.1:1521 |

schema: 可空，默认值与用户名相同

**SQLSERVER**

| 节点 | 固定值或常见值 |
| --- | --- | 
| vendor | SQLSERVER |
| driver | com.microsoft.sqlserver.jdbc.SQLServerDriver |
| url | jdbc:sqlserver://127.0.0.1:1433 |

schema: 必填

#### 3.4 执行命令导入

准备好图模型、数据文件以及输入源映射关系文件后，接下来就可以将数据文件导入到图数据库中。

导入过程由用户提交的命令控制，用户可以通过不同的参数控制执行的具体流程。

##### 3.4.1 参数说明

参数                 | 默认值        | 是否必传 | 描述信息
------------------- | ------------ | ------- | -----------------------
-f 或 --file    |              |    Y    | 配置脚本的路径
-g 或 --graph   |              |    Y    | 图数据库空间
-s 或 --schema  |              |    Y    | schema文件路径
-h 或 --host    | localhost    |         | HugeGraphServer 的地址
-p 或 --port    | 8080         |         | HugeGraphServer 的端口号
--token             | null         |         | 当 HugeGraphServer 开启了权限认证时，当前图的 token 
--incremental-mode  | false        |         | 是否使用断点续导模式，仅输入源为 FILE 和 HDFS 支持该模式，启用该模式能从上一次导入停止的地方开始导
--reload-failure    | false        |         | 是否导入以前导入失败的那些记录，仅在断点续导（或增量导入）模式下才能开启
--num-threads       | CPUs         |         | 导入过程中线程池大小 (CPUs是当前OS可用**逻辑核**个数) 
--max-conn          | 4 * CPUs     |         | HugeClient 与 HugeGraphServer 的最大 HTTP 连接数，**调整线程**的时候建议同时调整此项 
--max-conn-per-route| 2 * CPUs     |         | HugeClient 与 HugeGraphServer 每个路由的最大 HTTP 连接数，**调整线程**的时候建议同时调整此项 
--batch-size        | 500          |         | 导入数据时每个批次包含的数据条数
--max-parse-errors  | 1            |         | 最多允许多少行数据解析错误，达到该值则程序退出
--max-insert-errors | 500          |         | 最多允许多少行数据插入错误，达到该值则程序退出
--timeout           | 60           |         | 插入结果返回的超时时间（秒）
--shutdown-timeout  | 10           |         | 多线程停止的等待时间（秒）
--retry-times       | 0            |         | 发生特定异常时的重试次数
--retry-interval    | 10           |         | 重试之前的间隔时间（秒）
--check-vertex      | false        |         | 插入边时是否检查边所连接的顶点是否存在
--dry-run           | false        |         | 打开该模式，只解析不导入，通常用于测试
--help              | false        |         | 打印帮助信息

##### 3.4.2 断点续导模式

通常情况下，Loader 任务都需要较长时间执行，如果因为某些原因导致导入中断进程退出，而下次希望能从中断的点继续导，这就是使用断点续导的场景。

用户设置命令行参数 --incremental-mode 为 true 即打开了断点续导模式。断点续导的关键在于进度文件，导入进程退出的时候，会把退出时刻的导入进度
记录到进度文件中，进度文件位于 `${struct}` 目录下，文件名形如 `load-progress ${date}` ，${struct} 为映射文件的前缀，${date} 为导入开始
的时刻。比如：在 `2019-10-10 12:30:30` 开始的一次导入任务，使用的映射文件为 `struct-example.json`，则进度文件的路径为与 struct-example.json 
同级的 `struct-example/load-progress 2019-10-10 12:30:30`。

> 注意：进度文件的生成与 --incremental-mode 是否打开无关，每次导入结束都会生成一个进度文件。

如果数据文件格式都是合法的，是用户自己停止（CTRL + C 或 kill，kill -9 不支持）的导入任务，也就是说没有错误记录的情况下，下一次导入只需要设置
为断点续导即可。

但如果是因为太多数据不合法或者网络异常，达到了 --max-parse-errors 或 --max-insert-errors 的限制，Loader 会把这些插入失败的原始行记录到
失败文件中，用户对失败文件中的数据行修改后，设置 --reload-failure 为 true 即可把这些"失败文件"也当作输入源进行导入（不影响正常的文件的导入），
当然如果修改后的数据行仍然有问题，则会被再次记录到失败文件中（不用担心会有重复行）。

每个顶点映射或边映射有数据插入失败时都会产生自己的失败文件，失败文件又分为解析失败文件（后缀 .parse-error）和插入失败文件（后缀 .insert-error），
它们被保存在 `${struct}/current` 目录下。比如映射文件中有一个顶点映射 person 和边映射 knows，它们各有一些错误行，当 Loader 退出后，在 
`${struct}/current` 目录下会看到如下文件：

- person-b4cd32ab.parse-error: 顶点映射 person 解析错误的数据
- person-b4cd32ab.insert-error: 顶点映射 person 插入错误的数据
- knows-eb6b2bac.parse-error: 边映射 knows 解析错误的数据
- knows-eb6b2bac.insert-error: 边映射 knows 插入错误的数据

> .parse-error 和 .insert-error 并不总是一起存在的，只有存在解析出错的行才会有 .parse-error 文件，只有存在插入出错的行才会有 .insert-error 文件。

##### 3.4.3 logs 目录文件说明

程序执行过程中各日志及错误数据会写入 hugegraph-loader.log 文件中。

##### 3.4.4 执行命令

运行 bin/hugeloader 并传入参数

```bash
bin/hugegraph-loader -g {GRAPH_NAME} -f ${INPUT_DESC_FILE} -s ${SCHEMA_FILE} -h {HOST} -p {PORT}
```

### 4 完整示例

下面给出的是 hugegraph-loader 包中 example 目录下的例子。

#### 4.1 准备数据

顶点文件：`example/file/vertex_person.csv`

```csv
marko,29,Beijing
vadas,27,Hongkong
josh,32,Beijing
peter,35,Shanghai
"li,nary",26,"Wu,han"
```

顶点文件：`example/file/vertex_software.txt`

```text
name|lang|price
lop|java|328
ripple|java|199
```

边文件：`example/file/edge_knows.json`

```
{"source_name": "marko", "target_name": "vadas", "date": "20160110", "weight": 0.5}
{"source_name": "marko", "target_name": "josh", "date": "20130220", "weight": 1.0}
```

边文件：`example/file/edge_created.json`

```
{"aname": "marko", "bname": "lop", "date": "20171210", "weight": 0.4}
{"aname": "josh", "bname": "lop", "date": "20091111", "weight": 0.4}
{"aname": "josh", "bname": "ripple", "date": "20171210", "weight": 1.0}
{"aname": "peter", "bname": "lop", "date": "20170324", "weight": 0.2}
```

#### 4.2 编写schema
schema文件：`example/file/schema.groovy`

```groovy
schema.propertyKey("name").asText().ifNotExist().create();
schema.propertyKey("age").asInt().ifNotExist().create();
schema.propertyKey("city").asText().ifNotExist().create();
schema.propertyKey("weight").asDouble().ifNotExist().create();
schema.propertyKey("lang").asText().ifNotExist().create();
schema.propertyKey("date").asText().ifNotExist().create();
schema.propertyKey("price").asDouble().ifNotExist().create();

schema.vertexLabel("person").properties("name", "age", "city").primaryKeys("name").ifNotExist().create();
schema.vertexLabel("software").properties("name", "lang", "price").primaryKeys("name").ifNotExist().create();

schema.indexLabel("personByName").onV("person").by("name").secondary().ifNotExist().create();
schema.indexLabel("personByAge").onV("person").by("age").range().ifNotExist().create();
schema.indexLabel("personByCity").onV("person").by("city").secondary().ifNotExist().create();
schema.indexLabel("personByAgeAndCity").onV("person").by("age", "city").secondary().ifNotExist().create();
schema.indexLabel("softwareByPrice").onV("software").by("price").range().ifNotExist().create();

schema.edgeLabel("knows").sourceLabel("person").targetLabel("person").properties("date", "weight").ifNotExist().create();
schema.edgeLabel("created").sourceLabel("person").targetLabel("software").properties("date", "weight").ifNotExist().create();

schema.indexLabel("createdByDate").onE("created").by("date").secondary().ifNotExist().create();
schema.indexLabel("createdByWeight").onE("created").by("weight").range().ifNotExist().create();
schema.indexLabel("knowsByWeight").onE("knows").by("weight").range().ifNotExist().create();
```

#### 4.3 编写输入源映射文件`example/file/struct.json`

```json
{
  "vertices": [
    {
      "label": "person",
      "input": {
        "type": "file",
        "path": "example/vertex_person.csv",
        "format": "CSV",
        "header": ["name", "age", "city"],
        "charset": "UTF-8"
      },
      "mapping": {
        "name": "name",
        "age": "age",
        "city": "city"
      }
    },
    {
      "label": "software",
      "input": {
        "type": "file",
        "path": "example/vertex_software.text",
        "format": "TEXT",
        "delimiter": "|",
        "charset": "GBK"
      }
    }
  ],
  "edges": [
    {
      "label": "knows",
      "source": ["source_name"],
      "target": ["target_name"],
      "input": {
        "type": "file",
        "path": "example/edge_knows.json",
        "format": "JSON"
      },
      "mapping": {
        "source_name": "name",
        "target_name": "name"
      }
    },
    {
      "label": "created",
      "source": ["aname"],
      "target": ["bname"],
      "input": {
        "type": "file",
        "path": "example/edge_created.json",
        "format": "JSON"
      },
      "mapping": {
        "aname": "name",
        "bname": "name"
      }
    }
  ]
}
```

#### 4.4 执行命令导入

```bash
sh bin/hugegraph-loader.sh -g hugegraph -f example/file/struct.json -s example/file/schema.groovy
```

导入结束后，会出现类似如下统计信息：

```
vertices has been loaded           : 8
edges has been loaded           : 6
--------------------------------------------------
total vertex metrics
parse:
    parse success           : 8
    parse failure           : 0
    parse time              : 0.043s
    parse rate              : 186(vertices/s)
load:
    load success            : 8
    load failure            : 0
    load time               : 0.131s
    load rate               : 61(vertices/s)
--------------------------------------------------
total edge metrics
parse:
    parse success           : 6
    parse failure           : 0
    parse time              : 0.026s
    parse rate              : 230(edges/s)
load:
    load success            : 6
    load failure            : 0
    load time               : 0.071s
    load rate               : 84(edges/s)
```
