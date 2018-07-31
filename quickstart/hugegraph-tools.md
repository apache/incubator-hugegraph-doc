## HugeGraph-Tools Quick Start

### 1 概述

HugeGraph-Tools 是 HugeGragh 的自动化部署、管理和备份/还原组件。

### 2 获取 HugeGraph-Tools

有两种方式可以获取 HugeGraph-Tools：

- 下载二进制tar包
- 下载源码编译安装

#### 2.1 下载二进制tar包

下载最新版本的 HugeGraph-Tools 包：

```bash
wget https://hugegraph.github.io/hugegraph-doc/downloads/hugetools/hugegraph-tools-${version}.tar.gz
tar zxvf hugegraph-tools-${version}.tar.gz
```

#### 2.2 下载源码编译安装

下载最新版本的 HugeGraph-Tools 源码包：

```bash
$ git clone https://github.com/hugegraph/hugegraph-tools.git
```

编译生成tar包:

```bash
cd hugegraph-tools
mvn package -DskipTests
```

生成 tar 包 hugegraph-tools-${version}.tar.gz


### 3 使用

#### 3.1 功能概览

解压后，进入hugegraph-tools目录，可以使用`bin/hugegraph`来查看 usage 信息。主要分为：

- 安装部署类，deploy、clear、start-all和stop-all
- 备份/恢复类，backup、restore、schedule-backup、dump
- 图管理类，graph-mode-set、graph-mode-get、graph-list、graph-get和graph-clear
- 异步任务管理类，task-delete、task-get和task-delete
- Gremlin类，gremlin-execute和gremlin-schedule

```bash
Usage: hugegraph [options] [command] [command options]
```

##### 3.2 [options]-全局变量

`options`是 HugeGraph-Tools 的全局变量，可以在hugegraph-tools/bin/hugegraph中配置,包括：
- --graph，HugeGraph-Tools操作的图的名字，默认值是hugegraph
- --url，HugeGraph-Server 的服务地址，默认是http://127.0.0.1:8080
- --user，当 HugeGraph-Server 开启认证时，传递用户名
- --password，当 HugeGraph-Server 开启认证时，传递用户的密码

##### 3.3 安装部署类

- deploy，一键下载、安装和启动 HugeGraph-Server 和 HugeGraph-Studio
- clear，清理 HugeGraph-Server 和 HugeGraph-Studio 目录和tar包
- start-all，一键启动 HugeGraph-Server 和 HugeGraph-Studio，并启动监控，服务死掉时自动拉起服务
- stop-all，一键关闭 HugeGraph-Server 和 HugeGraph-Studio

> deploy命令中有可选参数 -u，提供时会使用指定的下载地址替代默认下载地址下载 tar 包，并且将地址写入`~/hugegraph-download-url-prefix`文件中；之后如果不指定地址时，会优先从`~/hugegraph-download-url-prefix`指定的地址下载 tar 包；如果 -u 和`~/hugegraph-download-url-prefix`都没有时，会从默认下载地址进行下载

##### 3.4 备份/恢复类

- backup，将某张图中的 schema 或者 data 备份到 HugeGraph 系统之外，以 JSON 形式存在本地磁盘
- restore，将 JSON 格式存储的 schema 或者 data 恢复到原系统或者创建新图
- schedule-backup，周期性对图执行备份操作，并保留一定数目的最新备份
- dump，把整张图的顶点和边全部导出，默认以`vertex vertex-edge1 vertex-edge2..
.`JSON格式存储。用户也可以自定义存储格式，只需要在`hugegraph-tools/src/main/java/com/baidu/hugegraph
/formatter`目录下实现一个继承自`Formatter`的类，例如`CustomFormatter`，使用时指定该类为formatter即可，例如
`bin/hugegraph dump -f CustomFormatter`

##### 3.5 图管理类，graph-mode-set、graph-mode-get、graph-list、graph-get和graph-clear

- graph-mode-set，设置图的 restore mode
- graph-mode-get，获取图的 restore mode
- graph-list，列出某个 HugeGraph-Server 中全部的图
- graph-get，获取某个图
- graph-clear，清除某个图的全部 schema 和 data

> 当图中含有 Automatic Id Strategy的 vertex label 时，restore 前需要将图 restoring 模式设置为 TRUE，restore 结束后恢复 restoring 模式为 FALSE

##### 3.6 异步任务管理类，task-list、task-get和task-delete

- task-list，列出某个图中的异步任务，可以根据任务的状态过滤
- task-get，获取某个异步任务的详细信息
- task-delete，删除某个异步任务的信息

##### 3.7 Gremlin类，gremlin-execute和gremlin-schedule

- gremlin-execute，发送 Gremlin 语句到 HugeGraph-Server 来执行查询或修改操作，同步执行，结束后返回结果
- gremlin-schedule，发送 Gremlin 语句到 HugeGraph-Server 来执行查询或修改操作，异步执行，任务提交后立刻返回异步任务id

##### 3.8 具体命令参数

各子命令的具体参数如下：

```bash
Usage: hugegraph [options] [command] [command options]
  Options:
    --graph
      Name of graph
      Default: hugegraph
    --password
      Password of user
    --url
      The URL of HugeGraph-Server url
      Default: http://127.0.0.1:8080
    --user
      User Name
  Commands:
    backup      Backup graph schema/data to files
      Usage: backup [options]
        Options:
          --directory, -d
            Directory to store graph schema/data
            Default: ./
        * --huge-types, -t
            Type of schema/data. Concat with ',' if more than one. 'all' means 
            'vertex,edge,vertex_label,edge_label,property_key,index_label' 
          --retry
            Retry times, default is 3
            Default: 3

    task-list      List tasks
      Usage: task-list [options]
        Options:
          --limit
            Limit number, no limit if not provided
            Default: -1
          --status
            Status of task

    schedule-backup      Schedule backup task
      Usage: schedule-backup [options]
        Options:
          --backup-num
            The number of latest backups to keep
            Default: 3
        * --directory, -d
            The directory of backups stored
          --interval
            The interval of backup, format is: "a b c d e". 'a' means minute 
            (0 - 59), 'b' means hour (0 - 23), 'c' means day of month (1 - 
            31), 'd' means month (1 - 12), 'e' means day of week (0 - 6) 
            (Sunday=0), "*" means all
            Default: 0,0,*,*,*

    restore      Restore graph schema/data from files
      Usage: restore [options]
        Options:
          --directory, -d
            Directory of graph schema/data
            Default: ./
        * --huge-types, -t
            Type of schema/data. Concat with ',' if more than one. 'all' means 
            'vertex,edge,vertex_label,edge_label,property_key,index_label' 
          --retry
            Retry times, default is 3
            Default: 3

    graph-mode-get      Get graph mode
      Usage: graph-mode-get [options]
        Options:
          --graph-name
            Name of graph
            Default: hugegraph

    clear      Clear HugeGraph-Server and HugeGraph-Studio
      Usage: clear [options]
        Options:
        * -p
            Install path of HugeGraph-Server and HugeGraph-Studio

    graph-list      List all graphs
      Usage: graph-list

    gremlin-schedule      Execute Gremlin statements as asynchronous job
      Usage: gremlin-schedule [options]
        Options:
          --bindings, -b
            Gremlin bindings, valid format is: 'key1=value1,key2=value2...'
            Default: {}
          --language, -l
            Gremlin script language
            Default: gremlin-groovy
        * --script, -s
            Script to be executed

    graph-get      Get graph info
      Usage: graph-get [options]
        Options:
          --graph-name
            Name of graph
            Default: hugegraph

    graph-clear      Clear graph schema and data
      Usage: graph-clear [options]
        Options:
        * --confirm-message, -c
            Confirm message of graph clear
          --graph-name
            Name of graph
            Default: hugegraph

    deploy      Install HugeGraph-Server and HugeGraph-Studio
      Usage: deploy [options]
        Options:
        * -p
            Install path of HugeGraph-Server and HugeGraph-Studio
          -u
            Download url prefix path of HugeGraph-Server and HugeGraph-Studio
        * -v
            Version of HugeGraph-Server and HugeGraph-Studio

    help      Print usage
      Usage: help

    stop-all      Stop HugeGraph-Server and HugeGraph-Studio
      Usage: stop-all

    task-get      Get task info
      Usage: task-get [options]
        Options:
        * --task-id
            Task id
            Default: 0

    start-all      Start HugeGraph-Server and HugeGraph-Studio
      Usage: start-all [options]
        Options:
        * -p
            Install path of HugeGraph-Server and HugeGraph-Studio
        * -v
            Version of HugeGraph-Server and HugeGraph-Studio

    gremlin-execute      Execute Gremlin statements
      Usage: gremlin-execute [options]
        Options:
          --aliases, -a
            Gremlin aliases, valid format is: 'key1=value1,key2=value2...'
            Default: {}
          --bindings, -b
            Gremlin bindings, valid format is: 'key1=value1,key2=value2...'
            Default: {}
          --language, -l
            Gremlin script language
            Default: gremlin-groovy
        * --script, -s
            Script to be executed

    graph-mode-set      Set graph mode
      Usage: graph-mode-set [options]
        Options:
          --graph-name
            Name of graph
            Default: hugegraph
        * --restore, -r
            Restore flag
            Default: false

    dump      Dump graph to files
      Usage: dump [options]
        Options:
          --directory, -d
            Directory to store graph data
            Default: ./
          --formatter, -f
            Formatter to customize format of vertex/edge
            Default: JsonFormatter
          --retry
            Retry times, default is 3
            Default: 3

    task-delete      Delete task
      Usage: task-delete [options]
        Options:
        * --task-id
            Task id
            Default: 0

```