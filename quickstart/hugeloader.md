# HugeLoader Quick Start

# 一、HugeLoader概述
HugeLoader 是 Hugegragh 的一个模块，负责将普通文本数据转化为图形的顶点和边并插入图形数据库中。

# 二、项目依赖
使用 HugeLoader 需要依赖 Hugegraph Server，下载和启动 Server 详见：[HugeServer Quick Start](http://hugegraph.baidu.com/quickstart/hugeserver.html)

# 三、获取 HugeLoader
有两种方式可以获取 HugeLoader：

- 下载二进制tar包
- 下载源码编译安装

## 3.1 下载二进制tar包
- 下载最新版本的HugeLoader bin包：

```shell
wget http://api.xdata.baidu.com/hdfs/yqns01/hugegraph/latest/hugegraph-loader-latest-bin.tar.gz
tar zxvf hugegraph-loader-latest-bin.tar.gz
```

## 3.2 下载源码编译安装
- 下载最新版本的HugeLoader 源码包：

```shell
git clone ssh://username@icode.baidu.com:8235/baidu/xbu-data/hugegraph-loader
```

- 编译生成tar包:

```shell
cd hugegraph-loader
mvn package -DskipTests
```

# 四、使用流程
使用 HugeLoader 的基本流程分为以下几步：
- 编写配置脚本
- 准备文本数据
- 执行导入过程

## 4.1 编写配置脚本
配置脚本采用 groovy 语言编写，脚本定义数据文件的路径，文件的类型，以及顶点和边的 label 和 keys。

### 4.1.1 获取数据文件路径
- 根据 inputpath 进行拼接
```groovy
//示例
inputfileV = inputPath + '/vertices/'
inputfileE = inputPath + '/edges/'
```

> inputPath 的获取：
> 1. 如果用户执行导入时输入 -p，inputPath 为用户输入的路径
> 2. 如果用户没有输入，inputPath 取 path，而 path 首先来自用户环境变量 LOADER_HOME，若无此环境变量则取当前工作目录

- 用户使用绝对路径
```groovy
//示例
inputfileV = '/Users/lizhigang/mycode/hugegraph-loader/data/JSON/data/vertices/'
inputfileE = '/Users/lizhigang/mycode/hugegraph-loader/data/JSON/data/edges/'
```

### 4.1.2 定义文件的类型
不同的文件类型，读取文件时的语法不同，所以请按照规范配置文件的类型。

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
authorInput = File.csv(inputfileV + "author.csv").delimiter('|')
bookInput = File.csv(inputfileV + "book.csv").delimiter('|')
authorBookInput = File.csv(inputfileE + "authorBook.csv").delimiter('|')
```

> 用户可自行制定 CSV 文件的列分隔符，默认为逗号。

### 4.1.3 定义 label 和 keys
配置脚本中仅需要为顶点和边定义 label 和 keys，properties 可以从数据文件的列名中获取,目前仅支持单 key。

> 以下配置实际是 groovy 调用 java 相应的方法，请严格按照示例格式配置。

- 配置顶点的 label 和 keys

```groovy
//示例
load(authorInput).asVertices {
    label "author"
    keys "name"
}

load(bookInput).asVertices {
    label "book"
    keys "name"
}
```
- 配置边的 label 和 keys

```grvvoy
load(authorBookInput).asEdges {
    label "authored"
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

## 4.2 准备文本数据
目前支持 JSON、CSV 等数据格式，数据每行的结构需要完全一致。

### 4.2.1 准备顶点数据
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

### 4.2.2 准备边数据
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

## 4.3 执行导入过程
导入过程由用户提交的命令控制，用户可以通过不同的参数控制执行的具体流程。

### 4.3.1 参数说明
短命令|长命令|是否有参|参数说明
 --- | --- | --- | ---
h | help | false | 打印帮助信息和所有可用命令信息
f | file | true | 配置脚本的路径
g | gragh | true | 图形数据库空间
d | address | true | 图形数据库服务端的 ip:port
p | inputpath | true | 输入数据路径，默认为当前 classpath
dryrun | NULL | false | 只生成 schema 而不写数据库,默认 False
createSchema | NULL | false | 创建或更新 schema，默认 False
schemaOutputFile | NULL | true |保存 schema 的文件，默认 proposed_schemas.groovy
loadNew | NULL | false | 不检查数据库已有数据，直接插入数据，默认 False

### 4.3.2 参数使用
#### 必填参数:
- **-f**: 指定配置脚本（建议绝对路径）
- **-d**: 指定Hugegragh Server 的 ip:port
- **-g**: 指定图形数据空空间，也即图的名称

#### 可选参数：
- **-p:** 数据文件的路径名，默认为 path，而 path 默认为环境变量 LOADER_HOME 或者System.getProperty("user.dir")
- **-dryrun:** 只生成 schema 存储到文件，不执行在数据库中创建 schema 和插入数据的操作。
- **-schemaOutputFile:** 配合 dryrun 使用，指定 schema 存储的文件名，若不指定则默认为 proposed_schemas.groovy
- **-createSchema:** 插入数据前先检查和更新 schema。若不指定该参数，当数据 schema 与数据库 schema 不一致时报错。
- **-loadNew:** 插入边时检查边链接的两个顶点是否存在，若不指定则直接插入数据，当顶点不存在时报错。

### 4.3.3 执行命令
运行 bin/hugeloader 并传入参数
```shell
# 示例
bin/hugeloader -f /Users/lizhigang/mycode/hugegraph-loader/data/JSON/authorBookMap_JSON.groovy -dlocalhost:8080 -g hugegraph -p /Users/lizhigang/mycode/hugegraph-loader/data/JSON/data -createSchema -schemaOutputFile schema.groovy
```
# 五、强制性约束
目前为项目一期，功能尚不完备，仅支持在以下约束条件下使用
- 各项数据的类型均为 String

# 六、完整例子
本例中顶点类型为 author 和 book, 边为 authored 将 author 和 book 的关系建立起来。

## 6.1 编写配置脚本
```groovy

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

## 6.2 准备文本数据
### 顶点数据
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
### 边数据
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

### 6.3 执行命令
运行 bin/hugeloader 并传入参数
```shell
# 示例
bin/hugeloader -f /Users/lizhigang/mycode/hugegraph-loader/data/JSON/authorBookMap_JSON.groovy -d localhost:8080 -g hugegraph -p /Users/lizhigang/mycode/hugegraph-loader/data/JSON/data -createSchema -schemaOutputFile schema.groovy
```