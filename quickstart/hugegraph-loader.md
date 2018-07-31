## HugeGraph-Loader Quick Start

### 1 概述

HugeGraph-Loader 是 Hugegragh 的数据导入模块，负责将普通文本数据转化为图形的顶点和边并插入图形数据库中。

> 注意：使用 HugeGraph-Loader 需要依赖 Hugegraph Server 服务，下载和启动 Server 详见：[HugeGraph-Server Quick Start](/quickstart/hugegraph-server.html)

### 2 获取 HugeGraph-Loader

有两种方式可以获取 HugeGraph-Loader：

- 下载二进制tar包
- 下载源码编译安装

#### 2.1 下载二进制tar包

下载最新版本的 HugeGraph-Loader bin包：

```bash
wget https://hugegraph.github.io/hugegraph-doc/downloads/hugeloader/hugegraph-loader-${version}-bin.tar.gz
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

- 编写配置脚本
- 准备文本数据
- 执行导入过程

#### 3.1 编写配置脚本

配置脚本采用 groovy 语言编写，脚本定义数据文件的路径，文件的类型，以及顶点和边的 label 和 keys。

##### 3.1.1 获取数据文件路径

用户定义数据文件的路径

```groovy
//示例
inputPath = '/home/work/data'
inputfileV = inputPath + '/vertices/'
inputfileE = inputPath + '/edges/'
```

##### 3.1.2 定义文件的类型

不同的文件类型，读取文件时的语法不同，所以请按照规范配置文件的类型。

**常用文件格式示例:**

- JSON

  ```groovy
    // 示例
    personInput = File.json(inputfiledir + "vertex_person.json")
    softwareInput = File.json(inputfiledir + "vertex_software.json")
    knowsInput = File.json(inputfiledir + "edge_knows.json")
    createdInput = File.json(inputfiledir + "edge_created.json")
  ```

- CSV

  ```groovy
    // 示例
    personInput = File.csv(inputfiledir + "vertex_person.csv")
    softwareInput = File.csv(inputfiledir + "vertex_software.csv")
    knowsInput = File.csv(inputfiledir + "edge_knows.csv")
    createdInput = File.csv(inputfiledir + "edge_created.csv")
  ```

- TEXT

  ```groovy
    // 示例
    personInput = File.text(inputfiledir + "vertex_person.text").delimiter('|')
    softwareInput = File.text(inputfiledir + "vertex_software.text").delimiter('|')
    knowsInput = File.text(inputfiledir + "edge_knows.text").delimiter('|')
    createdInput = File.text(inputfiledir + "edge_created.text").delimiter('|')
  ```

> 用户可自行制定 TEXT 文件的列分隔符，默认为制表符。

**文件的header**

文件的 header 用于表示文件每一列内容的名称，也即默认生成图后的 properties。

- JSON 格式的文件 key 为 header，value 为数据内容。
- CSV 和 TEXT 格式的文件默认第一行为 header，如果文件没有 header，则需要用户指定 header

```groovy
// CSV 指定 header
personInput = File.csv(inputfiledir + "vertex_person.csv").header("name", "age", "city")
softwareInput = File.csv(inputfiledir + "vertex_software.csv").header("name", "lang", "price")
knowsInput = File.csv(inputfiledir + "edge_knows.csv").header("aname", "bname", "date", "weight")
createdInput = File.csv(inputfiledir + "edge_created.csv").header("aname", "bname", "date", "weight")

// TEXT 指定 header
personInput = File.csv(inputfiledir + "vertex_person.csv").delimiter('|').header("name", "age", "city")
softwareInput = File.csv(inputfiledir + "vertex_software.csv").delimiter('|').header("name", "lang", "price")
knowsInput = File.csv(inputfiledir + "edge_knows.csv").delimiter('|').header("aname", "bname", "date", "weight")
createdInput = File.csv(inputfiledir + "edge_created.csv").delimiter('|').header("aname", "bname", "date", "weight")
```

**压缩文件的读取**

HugeGraph-Loader 支持压缩文件的处理和导入，目前仅支持.gzip 文件（后续将支持更多压缩格式）

```groovy
// 示例：
personInput = File.csv(inputfiledir + "vertex_person.csv").gzip()
softwareInput = File.csv(inputfiledir + "vertex_software.csv").gzip()
knowsInput = File.csv(inputfiledir + "edge_knows.csv").gzip()
createdInput = File.csv(inputfiledir + "edge_created.csv").gzip()
```

**非UTF-8编码文件的读取**

默认情况下，HugeGraph-Loader 认为数据源文件是UTF-8编码的，如果文件不是UTF-8的而直接导入，可能会产生乱码，解决办法有两种：

- 全局指定编码字符集，通过命令行选项`-charset`设置

```bash
# 示例
bin/hugeloader -f example/json/example.groovy -g hugegraph -charset GBK
```

- 为每个文件单独指定编码字符集，通过方法`charset(String)`设置

```groovy
// 示例
personInput = File.json(inputfiledir + "vertex_person.json").charset("GBK")
softwareInput = File.json(inputfiledir + "vertex_software.json").charset("UTF-16")
knowsInput = File.json(inputfiledir + "edge_knows.json").charset("UTF-8")
createdInput = File.json(inputfiledir + "edge_created.json").charset("GBK")
```

注意：如果同时通过两种方式设置了编码方式，后者（为文件单独指定）会覆盖前者（全局指定）。

##### 3.1.3 定义 label 和 keys

配置脚本中仅需要为顶点和边定义 label 和 keys，properties 可以从数据文件的列名中获取。

> 以下配置实际是 groovy 调用 java 相应的方法，请严格按照示例格式配置。

配置顶点的 label 和 keys

```groovy
// 示例
load(personInput).asVertices {
    label "person"          // label 为顶点的名称
    keys "name"             // keys 可以定义多个，相当于联合主键
    enableLabelIndex false  // 是否创建label索引，默认为true
}

load(softwareInput).asVertices {
    label "software"
    keys "name"
}
```

配置边的 label 和 keys

```groovy
load(knowsInput).asEdges {
    label "knows"           // label 为边的名称
    // 定义边的起始顶点
    outV {
        label "person"
        keys "aname"        // 起始顶点的 keys，必须与数据文件中一致，且与 inV 中 keys 相区分
    }
    // 定义边的终止顶点
    inV {
        label "person"
        keys "bname"        // 终止顶点的 keys，必须与数据文件中一致，且与 outV 中 keys 相区分
    }
    enableLabelIndex false  // 是否创建label索引，默认为true
}

load(createdInput).asEdges {
    label "created"
    outV {
        label "person"
        keys "aname"
    }
    inV {
        label "software"
        keys "bname"
    }
}
```

特殊配置

- mapping: 将文件中 header 的名称进行替换，也即对数据入库进行重命名
- ignores: 忽略文件中的某些列，也即不解析这些列

```groovy
// 示例
load(personInput).asVertices {
    label "person"          
    keys "name"             
    enableLabelIndex false  
    mapping "name","mappingName" // 第一个参数为源名称，第二个参数为映射名称
    ignores "age","city"         // 可以跟多个参数
}
```

##### 3.1.3 编写自定义的 schema

由于 HugeGraph 的图形数据是需要 schema 的，HugeGraph-Loader 支持不创建 schema、自动创建 schema 以及手动创建 schema 三种操作模式，由`-autoCreateSchema`和`-schema` 两个选项设置。

- `-autoCreateSchema`表示是否自动创建 schema，默认为`false`；
- `-schema`指定手动创建 schema 文件的路径。

如果通过`-schema ${file}`选项指定了 schema 文件的路径，HugeGraph-Loader 会先执行文件中的语句（groovy）创建schema。不允许在传入了`-schema`选项的同时将`-autoCreateSchema`设置为`true`。

如果设置`-autoCreateSchema`选项为`true`，HugeGraph-Loader 会自动创建 schema，自动创建的 schema 将所有顶点和边的属性都作为`text`看待；如果设置`-autoCreateSchema`选项为`false`，HugeGraph-Loader 不会创建 schema，此时用户必须保证数据库中已经存在了 schema，这种情况下 HugeGraph-Loader 也会把属性都当作`text`看待。
 
#### 3.2 准备文本数据

目前支持 JSON、CSV、TEXT 的文件格式，数据每行的结构需要完全一致。

##### 3.2.1 准备顶点数据

> 顶点数据中的列都将作为顶点的属性存在 顶点数据中的列必须包含配置脚本中的 key 字段

- JSON

```json
// 示例
// vertex_person.json
{"name": "marko", "age": 29, "city": "Beijing"}
{"name": "vadas", "age": 27, "city": "Hongkong"}
{"name": "josh", "age": 32, "city": "Beijing"}
{"name": "peter", "age": 35, "city": "Shanghai"}

// vertex_software.json
{"name": "lop", "lang": "java", "price": 328}
{"name": "ripple", "lang": "java", "price": 199}
```

- CSV

```csv
// 示例
// vertex_person.csv
name,age,city
marko,29,Beijing
vadas,27,Hongkong
josh,32,Beijing
peter,35,Shanghai

// vertex_software.csv
name,lang,price
lop,java,328
ripple,java,199
```

- TEXT

```csv
// 示例
// vertex_person.text
name|age|city
marko|29|Beijing
vadas|27|Hongkong
josh|32|Beijing
peter|35|Shanghai

// vertex_software.text
name|lang|price
lop|java|328
ripple|java|199
``` 

##### 3.2.2 准备边数据

> 边数据必须包含配置脚本中 inV 的 keys 以及 outV 的 keys 边数据中的其它列将作为边的属性

- JSON

```json
// 示例
// edge_knows.json
{"aname": "marko", "bname": "vadas", "date": "20160110", "weight": 0.5}
{"aname": "marko", "bname": "josh", "date": "20130220", "weight": 1.0}

// edge_created.json
{"aname": "marko", "bname": "lop", "date": "20171210", "weight": 0.4}
{"aname": "josh", "bname": "lop", "date": "20091111", "weight": 0.4}
{"aname": "josh", "bname": "ripple", "date": "20171210", "weight": 1.0}
{"aname": "peter", "bname": "lop", "date": "20170324", "weight": 0.2}
```

- CSV

```csv
// 示例
// edge_knows.csv
aname,bname,date,weight
marko,vadas,20160110,0.5
marko,josh,20130220,1.0

// edge_created.csv
aname,bname,date,weight
marko,lop,20171210,0.4
josh,lop,20091111,0.4
josh,ripple,20171210,1.0
peter,lop,20170324,0.2
```

- TEXT

```
// 示例
// edge_knows.text
aname|bname|date|weight
marko|vadas|20160110|0.5
marko|josh|20130220|1.0

// edge_created.text
aname|bname|date|weight
marko|lop|20171210|0.4
josh|lop|20091111|0.4
josh|ripple|20171210|1.0
peter|lop|20170324|0.2
```

#### 3.3 执行导入过程

导入过程由用户提交的命令控制，用户可以通过不同的参数控制执行的具体流程。

##### 3.3.1 参数说明

必要参数   | 参数                | 默认值                           | 描述信息
--------- | ------------------ | ------------------------------- | -----------------------------------------------
Y         | -f                 | NONE                            | 配置脚本的路径
Y         | -g                 | NONE                            | 图形数据库空间
N         | -h                 | localhost                       | HugeGraphServer 的地址
N         | -p                 | 8080                            | HugeGraphServer 的端口号
N         | -schema            | -                               | schema的创建脚本文件路径
N         | -autoCreateSchema  | true                            | 是否允许程序自动创建和更新图形 schema
N         | -dryRun            | false                           | 为 true时，仅生成 schema 而不执行数据导入过程
N         | -schemaOutputFile  | schema.groovy                   | 生成 schema 文件的名称
N         | -numThreads        | availableProcessors() *2 -1     | 导入过程中线程池大小
N         | -batchSize         | 500                             | 导入数据时每个批次包含的数据条数
N         | -numFutures        | 100                             | 最多允许多少个任务同时提交
N         | -terminateTimeout  | 10                              | 多线程停止的等待时间（秒）
N         | -maxParseErrors    | 1                               | 最多允许多少行数据解析错误，达到该值则程序退出
N         | -maxInsertErrors   | BATCH_SIZE                      | 最多允许多少行数据插入错误，达到该值则程序退出
N         | -timeout           | 100                             | 插入结果返回的超时时间（秒）
N         | -retryExceptions   | java.net.SocketTimeoutException | 需要重试的异常（多个异常时用','分隔）
N         | -retryTimes        | 10                              | 发生特定异常时的重试次数
N         | -retryIntervalTime | 10                              | 重试之前的间隔时间（秒）
N         | -loadNew           | flase                           | 插入边时是否检查边链接的顶点是否存在
N         | -idStrategy        | primary_key                     | 顶点id生成策略(primary_key/customize_string)
N         | -invalidKeyRegex   | null                            | 过滤掉用户配置的正则表达式匹配到的key，默认过滤掉keys 全为 null 或 '' 的数据
N         | -charset           | UTF-8                           | 数据源文件的编码字符集

关于idStrategy

- 顶点的id生成策略默认为primary_key，即利用groovy脚本中配置的keys生成id
- 如果顶点数据中已有id，可以采用自定义策略customize_string
- 当使用策略customize_string时，必须保证顶点数据中有一列的header为id（或mapping为id）,且不需要在groovy脚本中配置keys

> -help 可以打印参数及其描述信息。

##### 3.3.2 logs 目录文件说明

程序执行过程中各日志及错误数据会写入 logs 相关文件中。

- hugegraph-loader.log 程序运行过程中的 log 和 error 信息 (追加写)
- parseError.data 解析错误的数据（覆盖写）
- insertError.data 插入错误的数据（覆盖写）
- schema.groovy 生成的图形schema 信息（覆盖写）

> 用户可通过schemaOutputFile参数修改schema.groovy文件名称

##### 3.3.3 执行命令

运行 bin/hugeloader 并传入参数

```text
使用: bin/hugeloader [[-option value]...]
            (通过各个参数运行程序解析数据并将数据导入指定的图形数据空间中)
     bin/hugeloader -help
            (打印帮助信息和所有可用参数的说明信息)
示例: bin/hugeloader -g hugegraph -f example/example.groovy
```

### 4 强制性约束

目前为项目持续开发期，功能尚不完备，仅支持在以下约束条件下使用

- 各项数据的类型均为 String
- 中小数据量的导入

### 5 完整例子

本例中顶点类型为 author 和 book, 边为 authored 将 author 和 book 的关系建立起来。

#### 5.1 编写配置脚本

```groovy
inputfiledir = "example/json/"
personInput = File.json(inputfiledir + "vertex_person.json")
softwareInput = File.json(inputfiledir + "vertex_software.json")
knowsInput = File.json(inputfiledir + "edge_knows.json")
createdInput = File.json(inputfiledir + "edge_created.json")

//Specifies what data source to load using which mapper (as defined inline)

load(personInput).asVertices {
    label "person"
    keys "name"
    enableLabelIndex false
}

load(softwareInput).asVertices {
    label "software"
    keys "name"
}

load(knowsInput).asEdges {
    label "knows"
    outV {
        label "person"
        keys "aname"
    }
    inV {
        label "person"
        keys "bname"
    }
    mapping "aname", "name"
    mapping "bname", "name"
}

load(createdInput).asEdges {
    label "created"
    outV {
        label "person"
        keys "aname"
    }
    inV {
        label "software"
        keys "bname"
    }
    enableLabelIndex false
    mapping "aname", "name"
    mapping "bname", "name"
}
```

#### 5.2 准备文本数据

##### 5.2.1 顶点数据

`vertex_person.json`

```
{"name": "marko", "age": 29, "city": "Beijing"}
{"name": "vadas", "age": 27, "city": "Hongkong"}
{"name": "josh", "age": 32, "city": "Beijing"}
{"name": "peter", "age": 35, "city": "Shanghai"}
```

`vertex_software.json`

```
{"name": "lop", "lang": "java", "price": 328}
{"name": "ripple", "lang": "java", "price": 199}
```

##### 5.2.2 边数据

` edge_knows.json`

```
{"aname": "marko", "bname": "vadas", "date": "20160110", "weight": 0.5}
{"aname": "marko", "bname": "josh", "date": "20130220", "weight": 1.0}
```

`edge_created.json`

```
{"aname": "marko", "bname": "lop", "date": "20171210", "weight": 0.4}
{"aname": "josh", "bname": "lop", "date": "20091111", "weight": 0.4}
{"aname": "josh", "bname": "ripple", "date": "20171210", "weight": 1.0}
{"aname": "peter", "bname": "lop", "date": "20170324", "weight": 0.2}
```

#### 5.3 执行命令

运行 `bin/hugeloader` 并传入参数

```bash
# 示例
bin/hugeloader -f example/json/example.groovy -schema example/json/schema.groovy -g hugegraph
```

`schema.groovy`脚本内容：

```
// Define schema
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

### 6 日志文件

HugeGraph-Loader在导入图数据时，会记录导入的过程信息以及错误信息

- `schema.groovy`，采用自动生成schema时，该文件中会记录生成的schema信息
- `hugegraph-loader.log`，数据导入过程中的全部日志信息
- `parse_error.data`，解析数据文件时发生的错误信息
- `vertex_insert_error.data`，顶点导入时，请求发送到HugeGraphServer后，由于无法完成插入由HugeGraphServer返回的错误信息
- `edge_insert_error.data`，边导入时，请求发送到HugeGraphServer后，由于无法完成插入由HugeGraphServer返回的错误信息

