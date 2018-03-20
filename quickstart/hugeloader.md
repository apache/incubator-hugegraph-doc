# HugeLoader Quick Start

## 1. 概述
HugeLoader 是 Hugegragh 的一个模块，负责将普通文本数据转化为图形的顶点和边并插入图形数据库中。

## 2. 项目依赖
使用 HugeLoader 需要依赖 Hugegraph Server，下载和启动 Server 详见：[HugeServer Quick Start](http://hugegraph.baidu.com/quickstart/hugeserver.html)

## 3. 获取 HugeLoader
有两种方式可以获取 HugeLoader：

- 下载二进制tar包
- 下载源码编译安装

### 3.1 下载二进制tar包
- 下载最新版本的HugeLoader bin包：

```shell
wget http://api.xdata.baidu.com/hdfs/yqns02/hugegraph/hugeloader/hugegraph-loader-latest-bin.tar.gz
tar zxvf hugegraph-loader-latest-bin.tar.gz
```

### 3.2 下载源码编译安装
- 下载最新版本的HugeLoader 源码包：

```shell
git clone ssh://username@icode.baidu.com:8235/baidu/xbu-data/hugegraph-loader
```

- 编译生成tar包:

```shell
cd hugegraph-loader
mvn package -DskipTests
```

## 4. 使用流程
使用 HugeLoader 的基本流程分为以下几步：
- 编写配置脚本
- 准备文本数据
- 执行导入过程

### 4.1 编写配置脚本
配置脚本采用 groovy 语言编写，脚本定义数据文件的路径，文件的类型，以及顶点和边的 label 和 keys。

#### 4.1.1 获取数据文件路径
- 用户定义数据文件的路径
```groovy
//示例
inputPath = '/home/work/data'
inputfileV = inputPath + '/vertices/'
inputfileE = inputPath + '/edges/'
```

#### 4.1.2 定义文件的类型
不同的文件类型，读取文件时的语法不同，所以请按照规范配置文件的类型。

1. 常用文件格式示例:

- JSON
```groovy
//示例
authorInput = File.json(inputfileV + 'author.json')
bookInput = File.json(inputfileV + 'book.json')
authorBookInput = File.json(inputfileE + 'authorBook.json')
```

- CSV
```groovy
//示例
authorInput = File.csv(inputfileV + "author.csv")
bookInput = File.csv(inputfileV + "book.csv")
authorBookInput = File.csv(inputfileE + "authorBook.csv")
```

- TEXT
```groovy
//示例
authorInput = File.text(inputfileV + "author.txt").delimiter('|')
bookInput = File.text(inputfileV + "book.txt").delimiter('|')
authorBookInput = File.text(inputfileE + "authorBook.txt").delimiter('|')
```

> 用户可自行制定 TEXT 文件的列分隔符，默认为制表符。

2. 文件的header

文件的 header 用于表示文件每一列内容的名称，也即默认生成图后的 properties。
- JSON 格式的文件 key 为 header，value 为数据内容。
- CSV 和 TEXT 格式的文件默认第一行为 header，如果文件没有 header，则需要用户指定 header

```
// CSV 指定 header
authorInput = File.csv(inputfileV + "author.csv").header("name", "gender")
bookInput = File.csv(inputfileV + "book.csv").header("name", "year", "ISBN")
authorBookInput = File.csv(inputfileE + "authorBook.csv").header("auther_name", "book_name")

// TEXT 指定 header
authorInput = File.text(inputfileV + "author.txt").delimiter('|').header("name", "gender")
bookInput = File.text(inputfileV + "book.txt").delimiter('|').header("name", "year", "ISBN")
authorBookInput = File.text(inputfileE + "authorBook.txt").delimiter('|').header("auther_name", "book_name")
```

3. 压缩文件的读取
HugeLoader 支持压缩文件的处理和导入，目前仅支持.gzip 文件（后续将支持更多压缩格式）

```groovy
// 示例：
authorInput = File.csv(inputfileV + "author.csv").gzip()
bookInput = File.csv(inputfileV + "book.csv").gzip()
authorBookInput = File.csv(inputfileE + "authorBook.csv").gzip()
```

#### 4.1.3 定义 label 和 keys
配置脚本中仅需要为顶点和边定义 label 和 keys，properties 可以从数据文件的列名中获取。

> 以下配置实际是 groovy 调用 java 相应的方法，请严格按照示例格式配置。

- 配置顶点的 label 和 keys

```groovy
//示例
load(authorInput).asVertices {
    label "author" // label 为顶点的名称
    keys "name"    // keys 可以定义多个，相当于联合主键
}

load(bookInput).asVertices {
    label "book"
    keys "name"
}
```

- 配置边的 label 和 keys


```grvvoy
load(authorBookInput).asEdges {
    label "authored" // label 为边的名称
    //定义边的起始顶点
    outV { 
        label "author"
        keys "aname" //起始顶点的 keys，必须与数据文件中一致，且与 inV 中 keys 相区分
    }
    //定义边的终止顶点
    inV { 
        label "book"
        keys "bname" //终止顶点的 keys，必须与数据文件中一致，且与 outV 中 keys 相区分
    }
}
```

- 特殊配置
    1. mapping : 将文件中 header 的名称进行替换，也即对数据入库进行重命名
    2. ignores : 忽略文件中的某些列，也即不解析这些列

```groovy
//示例
load(authorInput).asVertices {
    label "author" 
    keys "name"   
    mapping "name","mappingName" // 第一个参数为源名称，第二个参数为映射名称
    ignores "gender","age" // 可以跟多个参数
}
```



### 4.2 准备文本数据
目前支持 JSON、CSV、TEXT 的文件格式，数据每行的结构需要完全一致。

#### 4.2.1 准备顶点数据
> 顶点数据中的列都将作为顶点的属性存在
> 顶点数据中的列必须包含配置脚本中的 key 字段

- JSON

```json
//示例
//author.json
{"name":"Julia Child","gender":"F"}
{"name":"Simone Beck","gender":"F"}
{"name":"Louisette Bertholie","gender":"F"}

//book.json
{"name":"The Art of French Cooking, Vol. 1","year":"1961","ISBN":"none"}
{"name":"Simca's Cuisine: 100 Classic French Recipes for Every Occasion","year":"1972","ISBN":"0-394-40152-2"}
{"name":"The French Chef Cookbook","year":"1968","ISBN":"0-394-40135-2"}
```

- CSV

```csv
//示例
//author.csv
name|gender
Julia Child|F
Simone Beck|F
Louisette Bertholie|F

//book.csv
name|year|ISBN
The Art of French Cooking, Vol. 1|1961|none
Simca's Cuisine: 100 Classic French Recipes for Every Occasion|1972|0-394-40152-2
The French Chef Cookbook|1968|0-394-40135-2
```

#### 4.2.2 准备边数据
> 边数据必须包含配置脚本中 inV 的 keys 以及 outV 的 keys
> 边数据中的其它列将作为边的属性

- JSON

```json
//示例
//authorBook.json
{"bname":"The Art of French Cooking, Vol. 1","aname":"Julia Child","test":"test"}
{"bname":"The Art of French Cooking, Vol. 1","aname":"Simone Beck","test":"test"}
{"bname":"The Art of French Cooking, Vol. 1","aname":"Louisette Bertholie","test":"test"}
```
- CSV

```csv
//示例
//authorBook.csv
bname|aname
The Art of French Cooking, Vol. 1|Julia Child
The Art of French Cooking, Vol. 1|Simone Beck
The Art of French Cooking, Vol. 1|Louisette Bertholie
```

### 4.3 执行导入过程
导入过程由用户提交的命令控制，用户可以通过不同的参数控制执行的具体流程。

#### 4.3.1 参数说明

必要参数(Y/N) | 参数 | 默认值 | 描述信息
 --- | --- | --- | --- 
Y | -f | NONE | 配置脚本的路径
Y | -g | NONE | 图形数据库空间
N | -h | localhost | HugeServer 的地址
N | -p | 8080 |  Hugeserver 的端口号
N | -createSchema | true | 是否允许程序自动创建和更新图形 schema
N | -dryRun | false | 为 true时，仅生成 schema 而不执行数据导入过程
N | -schemaOutputFile | schema.groovy | 生成 schema 文件的名称
N | -numThreads | availableProcessors() *2 -1| 导入过程中线程池大小
N | -batchSize | 500 | 导入数据时每个批次包含的数据条数
N | -numFutures | 100 | 最多允许多少个任务同时提交
N | -terminateTimeout | 10 | 多线程停止的等待时间（秒）
N | -maxParseErrors | 1 | 最多允许多少行数据解析错误，达到该值则程序退出
N | -maxInsertErrors | BATCH_SIZE | 最多允许多少行数据插入错误，达到该值则程序退出
N | -timeout | 100 | 插入结果返回的超时时间（秒）
N | -retryExceptions | java.net.SocketTimeoutException | 需要重试的异常（多个异常时用','分隔）
N | -retryTimes | 10 | 发生特定异常时的重试次数
N | -retryIntervalTime | 10 | 重试之前的间隔时间（秒）
N | -loadNew         | flase | 插入边时是否检查边链接的顶点是否存在
N | -idStrategy      | primary_key | 顶点id生成策略(primary_key/customize_string)
N | -invalidKeyRegex | null | 过滤掉用户配置的正则表达式匹配到的key，默认过滤掉keys 全为 null 或 '' 的数据


关于idStrategy

- 顶点的id生成策略默认为primary_key，即利用groovy脚本中配置的keys生成id
- 如果顶点数据中已有id，可以采用自定义策略customize_string
- 当使用策略customize_string时，必须保证顶点数据中有一列的header为id（或mapping为id）,且不需要在groovy脚本中配置keys

> -help 可以打印参数及其描述信息。

#### 4.3.2 logs 目录文件说明
程序执行过程中各日志及错误数据会写入 logs 相关文件中。

- hugegraph-loader.log 程序运行过程中的 log 和 error 信息 (追加写)
- parseError.data 解析错误的数据（覆盖写）
- insertError.data 插入错误的数据（覆盖写）
- schema.groovy 生成的图形schema 信息（覆盖写）

> 用户可通过schemaOutputFile参数修改schema.groovy文件名称

#### 4.3.3 执行命令
运行 bin/hugeloader 并传入参数
```text
使用: bin/hugeloader [[-option value]...]
            (通过各个参数运行程序解析数据并将数据导入指定的图形数据空间中)
      bin/hugeloader -help
            (打印帮助信息和所有可用参数的说明信息)
示例: bin/hugeloader -g hugegraph -f example/example.groovy
```
## 5. 强制性约束
目前为项目持续开发期，功能尚不完备，仅支持在以下约束条件下使用
- 各项数据的类型均为 String
- 中小数据量的导入

## 6.完整例子
本例中顶点类型为 author 和 book, 边为 authored 将 author 和 book 的关系建立起来。

### 6.1 编写配置脚本
```groovy
inputPath = '/home/work/data'
inputfileV = inputPath + '/vertices/'
inputfileE = inputPath + '/edges/'

authorInput = File.json(inputfileV + 'author.json')
bookInput = File.json(inputfileV + 'book.json')
authorBookInput = File.json(inputfileE + 'authorBook.json')

load(authorInput).asVertices {
    label "author"
    keys "name"
}

load(bookInput).asVertices {
    label "book"
    keys "name"
}

load(authorBookInput).asEdges {
    label "authored"
    outV {
        label "author"
        key "aname"
    }
    inV {
        label "book"
        key "bname"
    }
}
```

### 6.2 准备文本数据
#### 6.2.1 顶点数据

author.json

```json
{"name":"Julia Child","gender":"F"}
{"name":"Simone Beck","gender":"F"}
{"name":"Louisette Bertholie","gender":"F"}
{"name":"Patricia Simon","gender":"F"}
{"name":"Alice Waters","gender":"F"}
{"name":"Patricia Curtan","gender":"F"}
{"name":"Kelsie Kerr","gender":"F"}
{"name":"Fritz Streiff","gender":"M"}
{"name":"Emeril Lagasse","gender":"M"}
{"name":"James Beard","gender":"M"}
```
book.json

```json
{"name":"The Art of French Cooking, Vol. 1","year":"1961","ISBN":"none"}
{"name":"Simca's Cuisine: 100 Classic French Recipes for Every Occasion","year":"1972","ISBN":"0-394-40152-2"}
{"name":"The French Chef Cookbook","year":"1968","ISBN":"0-394-40135-2"}
{"name":"The Art of Simple Food: Notes, Lessons, and Recipes from a Delicious Revolution","year":"2007","ISBN":"0-307-33679-4"}
```
#### 6.2.2 边数据
authorBook.json

```json
{"bname":"The Art of French Cooking, Vol. 1","aname":"Julia Child","test":"test"}
{"bname":"The Art of French Cooking, Vol. 1","aname":"Simone Beck","test":"test"}
{"bname":"The Art of French Cooking, Vol. 1","aname":"Louisette Bertholie","test":"test"}
{"bname":"Simca's Cuisine: 100 Classic French Recipes for Every Occasion","aname":"Simone Beck","test":"test"}
{"bname":"Simca's Cuisine: 100 Classic French Recipes for Every Occasion","aname":"Patricia Simon","test":"test"}
{"bname":"The French Chef Cookbook","aname":"Julia Child","test":"test"}
{"bname":"The Art of Simple Food: Notes, Lessons, and Recipes from a Delicious Revolution","aname":"Alice Waters","test":"test"}
{"bname":"The Art of Simple Food: Notes, Lessons, and Recipes from a Delicious Revolution","aname":"Patricia Curtan","test":"test"}
{"bname":"The Art of Simple Food: Notes, Lessons, and Recipes from a Delicious Revolution","aname":"Kelsie Kerr","test":"test"}
{"bname":"The Art of Simple Food: Notes, Lessons, and Recipes from a Delicious Revolution","aname":"Fritz Streiff","test":"test"}
```

#### 6.3 执行命令
运行 bin/hugeloader 并传入参数

```shell
# 示例
bin/hugeloader -f /home/work/data/authorBookMap_JSON.groovy -g hugegraph 
```