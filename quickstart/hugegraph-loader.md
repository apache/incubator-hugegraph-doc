## HugeGraph-Loader Quick Start

### 1 概述

HugeGraph-Loader 是 Hugegragh 的数据导入组件，负责将普通文本数据转化为图形的顶点和边并批量导入到图形数据库中。

> 注意：使用 HugeGraph-Loader 需要依赖 HugeGraph Server 服务，下载和启动 Server 详见：[HugeGraph-Server Quick Start](/quickstart/hugegraph-server.html)

### 2 获取 HugeGraph-Loader

有两种方式可以获取 HugeGraph-Loader：

- 下载二进制tar包
- 下载源码编译安装

#### 2.1 下载二进制tar包

下载最新版本的 HugeGraph-Loader bin包：

```bash
wget https://github.com/hugegraph/hugegraph-loader/releases/download/v${version}/hugegraph-loader-${version}.tar.gz
tar zxvf hugegraph-loader-${version}-bin.tar.gz
```

#### 2.2 下载源码编译安装

下载最新版本的 HugeGraph-Loader 源码包：

```bash
$ git clone https://github.com/hugegraph/hugegraph-loader.git
```

编译生成tar包:

```bash
cd hugegraph-loader
mvn package -DskipTests
```

### 3 使用流程

使用 HugeGraph-Loader 的基本流程分为以下几步：

- 编写图模型（schema）
- 准备数据文件
- 编写输入源映射（source）
- 执行导入过程

#### 3.1 编写图模型（schema）

这一步是一个建模的过程，用户需要对自己已有的数据和想要创建的图模型有一个清晰的构想，然后编写schema建立图模型。

比如想创建一个拥有两类顶点及两类边的图，顶点是"人"和"软件"，边是"人认识人"和"人创造软件"，并且这些顶点和边都带有一些属性，比如顶点"人"有："姓名"、"年龄"等属性，
"软件"有："名字"、"售卖价格"等属性；边"认识"有："日期"属性等。

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

// 创建 person 顶点标签，其拥有三个属性：name, age, city，主键是 name
schema.vertexLabel("person").properties("name", "age", "city").primaryKeys("name").ifNotExist().create();
// 创建 software 顶点标签，其拥有两个属性：name, price，主键是 name
schema.vertexLabel("software").properties("name", "price").primaryKeys("name").ifNotExist().create();

// 创建 knows 边标签，这类边是从 person 指向 person 的
schema.edgeLabel("knows").sourceLabel("person").targetLabel("person").ifNotExist().create();
// 创建 created 边标签，这类边是从 person 指向 software 的
schema.edgeLabel("created").sourceLabel("person").targetLabel("software").ifNotExist().create();
```

> 关于 schema 的详细说明请参考 [hugegraph-client](/clients/hugegraph-client.md) 中对应部分。

#### 3.2 准备数据文件

目前 HugeGraph-Loader 仅支持本地文件作为数据源，支持的文件格式包括 CSV、TEXT 和 JSON，数据每行的结构需保持一致。

HugeGraph-Loader 对数据文件有一定的格式要求，且对顶点数据文件和边数据文件的要求略有不同，下面将说明如何准备顶点数据和准备边数据。

##### 3.2.1 准备顶点数据

顶点数据文件由一行一行的数据组成，一般每一行作为一个顶点，每一列会作为顶点属性。下面以 CSV 格式作为示例进行说明。

- person 顶点数据

```csv
Tom,48,Beijing
Jerry,36,Shanghai
```

- software 顶点数据

```csv
name,price
Photoshop,999
office,388
```

##### 3.2.2 准备边数据

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

#### 3.3 编写输入源映射文件

输入源映射文件是`Json`格式，其内容是由多个`VertexSource`和`EdgeSource`块组成，`VertexSource`和`EdgeSource`分别对应某类顶点/边的输入源映射。

上面图模型和数据文件的输入源映射文件如下：

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
      "mapping": {
        "source_name": "name",
        "target_name": "name"
      }
    },
    {
      "label": "created",
      "source": ["source_name"],
      "target": ["source_name"],
      "input": {
        "type": "file",
        "path": "edge_created.json",
        "format": "JSON"
      },
      "mapping": {
        "source_name": "name",
        "target_name": "name"
      }
    }
  ]
}
```

`VertexSource`的节点包括：

映射文件节点名 | 说明                    | 是否必填                                                                                
------- | --------------------- | ------------------------------------------------------------------------------------
label   | 待导入的顶点数据的`label`       | 是                                                                                   
input   | 顶点数据源的信息，当前版本就是源文件的信息 | 是                                                                                    
id      | 指定文件中的某一列作为顶点的 Id 列   | 当 Id 策略为`CUSTOMIZE`时，必填；当 Id 策略为`PRIMARY_KEY`时，必须为空 
mapping | 将文件列的列名映射为顶点的属性名      | 否                                                                                    

`EdgeSource`的节点包括：

映射文件节点名 | 说明                    | 是否必填                                                                                                                                                       
------- | --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- 
label   | 待导入的边数据的`label`        | 是                                                                                                                                                           
input   | 顶点数据源的信息，当前版本就是源文件的信息 | 是                                                                                                                                                           
source  | 指定文件中的某几列作为顶点的 id 列   | 当源/目标顶点的 Id 策略为 `CUSTOMIZE`时，必须指定文件中的某一列作为顶点的 id 列；当源/目标顶点的 Id 策略为 `PRIMARY_KEY`时，必须指定文件的一列或多列用于拼接生成顶点的 id，也就是说，不管是哪种 Id 策略，此项必填 
target  | 选择边的目标顶点的 id 列        | 与 source 类似，不再赘述                                                                                                                                            
mapping | 将文件列的列名映射为顶点的属性名      | 否                                                                                                                                                           

> 注意：`VertexSource`的 id 和`EdgeSource`的 source 和 target 填写的都是文件的中原列名，不是 mapping 后的属性名。

当前 HugeGraph-Loader 仅支持本地文件的导入，所以 `input` 只能是 `file` 这一种类型，此时的 `InputSource` 其实就是 `FileSource`。

`FileSource`的节点包括：

映射文件节点名   | 说明        | 是否必填 | 默认值或可选值                                       | 补充
--------- | --------- | ---- | --------------------------------------------- | -----------------------------------------------------------------------
type      | 输入源类型     | 是    | 必须填 file 或 FILE                               |
path      | 本地文件的绝对路径 | 是    |                                               | 绝对路径
format    | 本地文件的格式   | 是    | 可选值为 CSV、TEXT 及 JSON                          | 必须大写
header    | 文件各列的列名   | 否    |                                               | 如不指定则会以数据文件第一行作为 header；当文件本身有标题且又指定了 header，文件的第一行会被当作普通的数据行；JSON 文件不需要指定 header
delimiter | 文件行的列分隔符  | 否    | `TEXT`文件默认以`\t`作为分隔符，`CSV`文件不需要指定，默认以`,`作为分隔符 | `JSON`文件不需要指定
charset   | 文件的编码字符集  | 否    | 默认`UTF-8`                                     |

#### 3.4 执行导入

准备好图模型、数据文件以及输入源映射关系文件后，接下来就可以将数据文件导入到图数据库中。

导入过程由用户提交的命令控制，用户可以通过不同的参数控制执行的具体流程。

##### 3.4.1 参数说明

必要 | 参数                | 默认值                      | 描述信息
---- | ------------------- | --------------------------- | -----------------------
Y    | -f &#124; --file    | NONE                        | 配置脚本的路径
Y    | -g &#124; --graph   | NONE                        | 图形数据库空间
Y    | -s &#124; --schema  | NONE                        | schema文件路径
N    | -h &#124; --host    | localhost                   | HugeGraphServer 的地址
N    | -p &#124; --port    | 8080                        | HugeGraphServer 的端口号
N    | --num-threads       | availableProcessors() *2 -1 | 导入过程中线程池大小
N    | --batch-size        | 500                         | 导入数据时每个批次包含的数据条数
N    | --max-parse-errors  | 1                           | 最多允许多少行数据解析错误，达到该值则程序退出
N    | --max-insert-errors | BATCH_SIZE                  | 最多允许多少行数据插入错误，达到该值则程序退出
N    | --timeout           | 100                         | 插入结果返回的超时时间（秒）
N    | --shutdown-timeout  | 10                          | 多线程停止的等待时间（秒）
N    | --retry-times       | 10                          | 发生特定异常时的重试次数
N    | --retry-interval    | 10                          | 重试之前的间隔时间（秒）
N    | --check-vertex      | false                       | 插入边时是否检查边链接的顶点是否存在

##### 3.4.2 logs 目录文件说明

程序执行过程中各日志及错误数据会写入 logs 相关文件中。

- hugegraph-loader.log 程序运行过程中的 log 和 error 信息 (追加写)
- parse_error.data 解析错误的数据（每次启动覆盖写）
- insert_error.data 插入错误的数据（每次启动覆盖写）
 
##### 3.4.3 执行命令

运行 bin/hugeloader 并传入参数

```bash
bin/hugegraph-loader -g {GRAPH_NAME} -f ${INPUT_DESC_FILE} -s ${SCHEMA_FILE} -h {HOST} -p {PORT}
```

### 4 完整示例

下面给出的是 hugegraph-loader 包中 example 目录下的例子。

#### 4.1 准备数据

顶点文件：`vertex_person.csv`

```csv
marko,29,Beijing
vadas,27,Hongkong
josh,32,Beijing
peter,35,Shanghai
"li,nary",26,"Wu,han"
```

顶点文件：`vertex_software.text`

```text
name|lang|price
lop|java|328
ripple|java|199
```

边文件：`edge_knows.json`

```
{"source_name": "marko", "target_name": "vadas", "date": "20160110", "weight": 0.5}
{"source_name": "marko", "target_name": "josh", "date": "20130220", "weight": 1.0}
```

边文件：`edge_created.json`

```
{"aname": "marko", "bname": "lop", "date": "20171210", "weight": 0.4}
{"aname": "josh", "bname": "lop", "date": "20091111", "weight": 0.4}
{"aname": "josh", "bname": "ripple", "date": "20171210", "weight": 1.0}
{"aname": "peter", "bname": "lop", "date": "20170324", "weight": 0.2}
```

#### 4.2 编写schema

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

#### 4.3 编写输入源映射文件

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

#### 4.4 执行命令

```bash
bin/hugegraph-loader -g hugegraph -f example/struct.json -s example/schema.groovy
```