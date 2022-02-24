# 3.Tools使用说明

## 3.1.概述

HugeGraph-Tools 是 HugeGragh 管理和备份/还原组件。

解压后，进入 hugegraph-tools 目录，可以使用`bin/hugegraph`或者`bin/hugegraph help`来查看 usage 信息。主要分为：

- 图管理类，graph-mode-set、graph-mode-get、graph-create、graph-list、graph-get、graph-clear 和 graph-drop
- 异步任务管理类，task-list、task-get、task-delete、task-cancel 和 task-clear
- Gremlin类，gremlin-execute 和 gremlin-schedule
- 备份/恢复类，backup、restore、migrate、schedule-backup 和 dump

```bash
Usage: hugegraph [options] [command] [command options]
```

## 3.2.[options]-全局变量

`options`是 HugeGraph-Tools 的全局变量，可以在 hugegraph-tools/bin/hugegraph 中配置,包括：

- --space，HugeGraph-Tools 操作的图空间的名字，默认值是 DEFAULT
- --graph，HugeGraph-Tools 操作的图的名字，默认值是 hugegraph
- --url，HugeGraph-Server 的服务地址，默认是 http://127.0.0.1:8080
- --user，当 HugeGraph-Server 开启认证时，传递用户名
- --password，当 HugeGraph-Server 开启认证时，传递用户的密码
- --timeout，连接 HugeGraph-Server 时的超时时间，默认是 30s
- --trust-store-file，证书文件的路径，当 --url 使用 https 时，HugeGraph-Client 使用的 truststore 文件，默认为空，代表使用 hugegraph-tools 内置的 truststore 文件 conf/hugegraph.truststore
- --trust-store-password，证书文件的密码，当 --url 使用 https 时，HugeGraph-Client 使用的 truststore 的密码，默认为空，代表使用 hugegraph-tools 内置的 truststore 文件的密码

上述全局变量，也可以通过环境变量来设置。一种方式是在命令行使用 export 设置临时环境变量，在该命令行关闭之前均有效


全局变量      | 环境变量                | 示例
------------ | --------------------- | ------------------------------------------
--url        | HUGEGRAPH_URL         | export HUGEGRAPH_URL=http://127.0.0.1:8080
--space      | HUGEGRAPH_GRAPHSPACE  | export HUGEGRAPH_GRAPHSPACE=DEFAULT
--graph      | HUGEGRAPH_GRAPH       | export HUGEGRAPH_GRAPH=hugegraph
--user       | HUGEGRAPH_USERNAME    | export HUGEGRAPH_USERNAME=admin
--password   | HUGEGRAPH_PASSWORD    | export HUGEGRAPH_PASSWORD=test
--timeout    | HUGEGRAPH_TIMEOUT     | export HUGEGRAPH_TIMEOUT=30
--trust-store-file | HUGEGRAPH_TRUST_STORE_FILE | export HUGEGRAPH_TRUST_STORE_FILE=/tmp/trust-store
--trust-store-password | HUGEGRAPH_TRUST_STORE_PASSWORD | export HUGEGRAPH_TRUST_STORE_PASSWORD=xxxx

另一种方式是在 bin/hugegraph 脚本中设置环境变量：

```
#!/bin/bash

# Set environment here if needed
#export HUGEGRAPH_URL=
#export HUGEGRAPH_GRAPHSPACE=
#export HUGEGRAPH_GRAPH=
#export HUGEGRAPH_USERNAME=
#export HUGEGRAPH_PASSWORD=
#export HUGEGRAPH_TIMEOUT=
#export HUGEGRAPH_TRUST_STORE_FILE=
#export HUGEGRAPH_TRUST_STORE_PASSWORD=
```

## 3.3.图管理类

图管理类包括graph-mode-set、graph-mode-get、graph-list、graph-get和graph-clear。具体描述如下：

- graph-mode-set，设置图的 restore mode
  - --graph-mode 或者 -m，必填项，指定将要设置的模式，合法值包括 [NONE, RESTORING, MERGING, LOADING]
- graph-mode-get，获取图的 restore mode
- graph-create，创建一个新图
  - --name 或者 -n，选填项，指定要创建的图的名字，默认为"g"
  - --file 或者 -f，必填项，指定要创建的图的配置文件
- graph-list，列出某个 HugeGraph-Server 中全部的图
- graph-get，获取某个图及其存储后端类型
- graph-clear，清除某个图的全部 schema 和 data
- graph-drop，删除一个图

> 当需要把备份的图原样恢复到一个新的图中的时候，需要先将图模式设置为 RESTORING 模式；当需要将备份的图合并到已存在的图中时，需要先将图模式设置为 MERGING 模式。

## 3.4.异步任务管理类

异步任务管理类task-list、task-get和task-delete。具体描述如下：

- task-list，列出某个图中的异步任务，可以根据任务的状态过滤
  - --status，选填项，指定要查看的任务的状态，即按状态过滤任务
  - --limit，选填项，指定要获取的任务的数目，默认为 -1，意思为获取全部符合条件的任务
- task-get，获取某个异步任务的详细信息
  - --task-id，必填项，指定异步任务的 ID
- task-delete，删除某个异步任务的信息
  - --task-id，必填项，指定异步任务的 ID
  - --force, 选填项，是否强制删除异步任务，默认为 false。设置为 true 时，表示不论异步任务处于何种状态，都删除该异步任务信息
- task-cancel，取消某个异步任务的执行
  - --task-id，要取消的异步任务的 ID
- task-clear，清理完成的异步任务
  - --force，选填项，设置时，表示清理全部异步任务，未执行完成的先取消，然后清除所有异步任务。默认只清理已完成的异步任务

## 3.5.Gremlin类

Gremlin类包括gremlin-execute和gremlin-schedule。具体描述如下：

- gremlin-execute，发送 Gremlin 语句到 HugeGraph-Server 来执行查询或修改操作，同步执行，结束后返回结果
  - --file 或者 -f，指定要执行的脚本文件，UTF-8编码，与 --script 互斥
  - --script 或者 -s，指定要执行的脚本字符串，与 --file 互斥
  - --aliases 或者 -a，Gremlin 别名设置，格式为：key1=value1,key2=value2,...
  - --bindings 或者 -b，Gremlin 绑定设置，格式为：key1=value1,key2=value2,...
  - --language 或者 -l，Gremlin 脚本的语言，默认为 gremlin-groovy
  > --file 和 --script 二者互斥，必须设置其中之一
- gremlin-schedule，发送 Gremlin 语句到 HugeGraph-Server 来执行查询或修改操作，异步执行，任务提交后立刻返回异步任务id
  - --file 或者 -f，指定要执行的脚本文件，UTF-8编码，与 --script 互斥
  - --script 或者 -s，指定要执行的脚本字符串，与 --file 互斥
  - --bindings 或者 -b，Gremlin 绑定设置，格式为：key1=value1,key2=value2,...
  - --language 或者 -l，Gremlin 脚本的语言，默认为 gremlin-groovy
  > --file 和 --script 二者互斥，必须设置其中之一

## 3.6.备份/恢复类

- backup，将某张图中的 schema 或者 data 备份到 HugeGraph 系统之外，以 JSON 形式存在本地磁盘或者 HDFS
  - --format，备份的格式，可选值包括 [json, text]，默认为 json
  - --all-properties，是否备份顶点/边全部的属性，仅在 --format 为 text 是有效，默认 false
  - --label，要备份的顶点/边的类型，仅在 --format 为 text 是有效，只有备份顶点或者边的时候有效
  - --properties，要备份的顶点/边的属性，逗号分隔，仅在 --format 为 text 是有效，只有备份顶点或者边的时候有效
  - --compress，备份时是否压缩数据，默认为 true
  - --directory 或者 -d，存储 schema 或者 data 的目录，本地目录时，默认为'./{graphName}'，HDFS 时，默认为 '{fs.default.name}/{graphName}'
  - --huge-types 或者 -t，要备份的数据类型，逗号分隔，可选值为 'all' 或者 一个或多个 [vertex,edge,vertex_label,edge_label,property_key,index_label] 的组合，'all' 代表全部6种类型，即顶点、边和所有schema
  - --log 或者 -l，指定日志目录，默认为当前目录
  - --retry，指定失败重试次数，默认为 3
  - --split-size 或者 -s，指定在备份时对顶点或者边分块的大小，默认为 1048576
  - -D，用 -Dkey=value 的模式指定动态参数，用来备份数据到 HDFS 时，指定 HDFS 的配置项，例如：-Dfs.default.name=hdfs://localhost:9000
- restore，将 JSON 格式存储的 schema 或者 data 恢复到一个新图中（RESTORING 模式）或者合并到已存在的图中（MERGING 模式）
  - --directory 或者 -d，存储 schema 或者 data 的目录，本地目录时，默认为'./{graphName}'，HDFS 时，默认为 '{fs.default.name}/{graphName}'
  - --clean，是否在恢复图完成后删除 --directory 指定的目录，默认为 false
  - --huge-types 或者 -t，要恢复的数据类型，逗号分隔，可选值为 'all' 或者 一个或多个 [vertex,edge,vertex_label,edge_label,property_key,index_label] 的组合，'all' 代表全部6种类型，即顶点、边和所有schema
  - --log 或者 -l，指定日志目录，默认为当前目录
  - --retry，指定失败重试次数，默认为 3
  - -D，用 -Dkey=value 的模式指定动态参数，用来从 HDFS 恢复图时，指定 HDFS 的配置项，例如：-Dfs.default.name=hdfs://localhost:9000
  > 只有当 --format 为 json 执行 backup 时，才可以使用 restore 命令恢复
- migrate, 将当前连接的图迁移至另一个 HugeGraphServer 中
  - --target-graph，目标图的名字，默认为 hugegraph
  - --target-url，目标图所在的 HugeGraphServer，默认为 http://127.0.0.1:8081
  - --target-user，访问目标图的用户名
  - --target-password，访问目标图的密码
  - --target-timeout，访问目标图的超时时间
  - --target-trust-store-file，访问目标图使用的 truststore 文件
  - --target-trust-store-password，访问目标图使用的 truststore 的密码
  - --directory 或者 -d，迁移过程中，存储源图的 schema 或者 data 的目录，本地目录时，默认为'./{graphName}'，HDFS 时，默认为 '{fs.default.name}/{graphName}'
  - --huge-types 或者 -t，要迁移的数据类型，逗号分隔，可选值为 'all' 或者 一个或多个 [vertex,edge,vertex_label,edge_label,property_key,index_label] 的组合，'all' 代表全部6种类型，即顶点、边和所有schema
  - --log 或者 -l，指定日志目录，默认为当前目录
  - --retry，指定失败重试次数，默认为 3
  - --split-size 或者 -s，指定迁移过程中对源图进行备份时顶点或者边分块的大小，默认为 1048576
  - -D，用 -Dkey=value 的模式指定动态参数，用来在迁移图过程中需要备份数据到 HDFS 时，指定 HDFS 的配置项，例如：-Dfs.default.name=hdfs://localhost:9000
  - --graph-mode 或者 -m，将源图恢复到目标图时将目标图设置的模式，合法值包括 [RESTORING, MERGING]
  - --keep-local-data，是否保留在迁移图的过程中产生的源图的备份，默认为 false，即默认迁移图结束后不保留产生的源图备份
- schedule-backup，周期性对图执行备份操作，并保留一定数目的最新备份（目前仅支持本地文件系统）
  - --directory 或者 -d，必填项，指定备份数据的目录
  - --backup-num，选填项，指定保存的最新的备份的数目，默认为 3
  - --interval，选填项，指定进行备份的周期，格式同 Linux crontab 格式
- dump，把整张图的顶点和边全部导出，默认以`vertex vertex-edge1 vertex-edge2...`JSON格式存储。
  用户也可以自定义存储格式，只需要在`hugegraph-tools/src/main/java/com/baidu/hugegraph/formatter`
  目录下实现一个继承自`Formatter`的类，例如`CustomFormatter`，使用时指定该类为formatter即可，例如
  `bin/hugegraph dump -f CustomFormatter`
  - --formatter 或者 -f，指定使用的 formatter，默认为 JsonFormatter
  - --directory 或者 -d，存储 schema 或者 data 的目录，默认为当前目录
  - --log 或者 -l，指定日志目录，默认为当前目录
  - --retry，指定失败重试次数，默认为 3
  - --split-size 或者 -s，指定在备份时对顶点或者边分块的大小，默认为 1048576
  - -D，用 -Dkey=value 的模式指定动态参数，用来备份数据到 HDFS 时，指定 HDFS 的配置项，例如：-Dfs.default.name=hdfs://localhost:9000

> deploy命令中有可选参数 -u，提供时会使用指定的下载地址替代默认下载地址下载 tar 包，并且将地址写入`~/hugegraph-download-url-prefix`文件中；之后如果不指定地址时，会优先从`~/hugegraph-download-url-prefix`指定的地址下载 tar 包；如果 -u 和`~/hugegraph-download-url-prefix`都没有时，会从默认下载地址进行下载

## 3.7.具体命令参数

各子命令的具体参数如下：

```bash
Usage: hugegraph [options] [command] [command options]
  Options:
    --space
      Name of graph space
      Default: DEFAULT
    --graph
      Name of graph
      Default: hugegraph
    --password
      Password of user
    --throw-mode
      Whether the hugegraph-tools work to throw an exception
      Default: false
    --timeout
      Connection timeout
      Default: 30
    --trust-store-file
      The path of client truststore file used when https protocol is enabled
    --trust-store-password
      The password of the client truststore file used when the https protocol 
      is enabled
    --url
      The URL of HugeGraph-Server
      Default: http://127.0.0.1:8080
    --user
      Name of user
  Commands:
    graph-create      Create graph with config
      Usage: graph-create [options]
        Options:
          --file, -f
            Creating graph config file
          --name, -n
            The name of new created graph, default is g
            Default: g

    graph-list      List all graphs
      Usage: graph-list

    graph-get      Get graph info
      Usage: graph-get

    graph-clear      Clear graph schema and data
      Usage: graph-clear [options]
        Options:
        * --confirm-message, -c
            Confirm message of graph clear is "I'm sure to delete all data". 
            (Note: include "")

    graph-drop      Drop graph
      Usage: graph-drop [options]
        Options:
        * --confirm-message, -c
            Confirm message of graph clear is "I'm sure to drop the graph". 
            (Note: include "")

    graph-mode-set      Set graph mode
      Usage: graph-mode-set [options]
        Options:
        * --graph-mode, -m
            Graph mode, include: [NONE, RESTORING, MERGING]
            Possible Values: [NONE, RESTORING, MERGING, LOADING]

    graph-mode-get      Get graph mode
      Usage: graph-mode-get

    task-list      List tasks
      Usage: task-list [options]
        Options:
          --limit
            Limit number, no limit if not provided
            Default: -1
          --status
            Status of task

    task-get      Get task info
      Usage: task-get [options]
        Options:
        * --task-id
            Task id
            Default: 0

    task-delete      Delete task
      Usage: task-delete [options]
        Options:
          --force
            Force to delete task
            Default: false
        * --task-id
            Task id
            Default: 0

    task-cancel      Cancel task
      Usage: task-cancel [options]
        Options:
        * --task-id
            Task id
            Default: 0

    task-clear      Clear completed tasks
      Usage: task-clear [options]
        Options:
          --force
            Force to clear all tasks, cancel all uncompleted tasks firstly, 
            and delete all completed tasks
            Default: false

    gremlin-execute      Execute Gremlin statements
      Usage: gremlin-execute [options]
        Options:
          --aliases, -a
            Gremlin aliases, valid format is: 'key1=value1,key2=value2...'
            Default: {}
          --bindings, -b
            Gremlin bindings, valid format is: 'key1=value1,key2=value2...'
            Default: {}
          --file, -f
            Gremlin Script file to be executed, UTF-8 encoded, exclusive to 
            --script 
          --language, -l
            Gremlin script language
            Default: gremlin-groovy
          --script, -s
            Gremlin script to be executed, exclusive to --file

    gremlin-schedule      Execute Gremlin statements as asynchronous job
      Usage: gremlin-schedule [options]
        Options:
          --bindings, -b
            Gremlin bindings, valid format is: 'key1=value1,key2=value2...'
            Default: {}
          --file, -f
            Gremlin Script file to be executed, UTF-8 encoded, exclusive to 
            --script 
          --language, -l
            Gremlin script language
            Default: gremlin-groovy
          --script, -s
            Gremlin script to be executed, exclusive to --file

    backup      Backup graph schema/data. If directory is on HDFS, use -D to 
            set HDFS params. For example: 
            -Dfs.default.name=hdfs://localhost:9000 
      Usage: backup [options]
        Options:
          --all-properties
            All properties to be backup flag
            Default: false
          --compress
            compress flag
            Default: true
          --directory, -d
            Directory of graph schema/data, default is './{graphname}' in 
            local file system or '{fs.default.name}/{graphname}' in HDFS
          --format
            File format, valid is [json, text]
            Default: json
          --huge-types, -t
            Type of schema/data. Concat with ',' if more than one. Other types 
            include 'all' and 'schema'. 'all' means all vertices, edges and 
            schema. In other words, 'all' equals with 'vertex, edge, 
            vertex_label, edge_label, property_key, index_label'. 'schema' 
            equals with 'vertex_label, edge_label, property_key, index_label'.
            Default: [PROPERTY_KEY, VERTEX_LABEL, EDGE_LABEL, INDEX_LABEL, VERTEX, EDGE]
          --label
            Vertex label or edge label, only valid when type is vertex or edge
          --log, -l
            Directory of log
            Default: ./logs
          --properties
            Vertex or edge properties to backup, only valid when type is 
            vertex or edge
            Default: []
          --retry
            Retry times, default is 3
            Default: 3
          --split-size, -s
            Split size of shard
            Default: 1048576
          --thread-num, -T
            Threads number to use, default is Math.min(10, Math.max(4, CPUs / 
            2)) 
            Default: 0
          -D
            HDFS config parameters
            Syntax: -Dkey=value
            Default: {}

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
            Default: "0 0 * * *"

    dump      Dump graph to files
      Usage: dump [options]
        Options:
          --directory, -d
            Directory of graph schema/data, default is './{graphname}' in 
            local file system or '{fs.default.name}/{graphname}' in HDFS
          --formatter, -f
            Formatter to customize format of vertex/edge
            Default: JsonFormatter
          --log, -l
            Directory of log
            Default: ./logs
          --retry
            Retry times, default is 3
            Default: 3
          --split-size, -s
            Split size of shard
            Default: 1048576
          --thread-num, -T
            Threads number to use, default is Math.min(10, Math.max(4, CPUs / 
            2)) 
            Default: 0
          -D
            HDFS config parameters
            Syntax: -Dkey=value
            Default: {}

    restore      Restore graph schema/data. If directory is on HDFS, use -D to 
            set HDFS params if needed. For 
            example:-Dfs.default.name=hdfs://localhost:9000 
      Usage: restore [options]
        Options:
          --clean
            Whether to remove the directory of graph data after restored
            Default: false
          --directory, -d
            Directory of graph schema/data, default is './{graphname}' in 
            local file system or '{fs.default.name}/{graphname}' in HDFS
          --huge-types, -t
            Type of schema/data. Concat with ',' if more than one. Other types 
            include 'all' and 'schema'. 'all' means all vertices, edges and 
            schema. In other words, 'all' equals with 'vertex, edge, 
            vertex_label, edge_label, property_key, index_label'. 'schema' 
            equals with 'vertex_label, edge_label, property_key, index_label'.
            Default: [PROPERTY_KEY, VERTEX_LABEL, EDGE_LABEL, INDEX_LABEL, VERTEX, EDGE]
          --log, -l
            Directory of log
            Default: ./logs
          --retry
            Retry times, default is 3
            Default: 3
          --thread-num, -T
            Threads number to use, default is Math.min(10, Math.max(4, CPUs / 
            2)) 
            Default: 0
          -D
            HDFS config parameters
            Syntax: -Dkey=value
            Default: {}

    migrate      Migrate graph
      Usage: migrate [options]
        Options:
          --directory, -d
            Directory of graph schema/data, default is './{graphname}' in 
            local file system or '{fs.default.name}/{graphname}' in HDFS
          --graph-mode, -m
            Mode used when migrating to target graph, include: [RESTORING, 
            MERGING] 
            Default: RESTORING
            Possible Values: [NONE, RESTORING, MERGING, LOADING]
          --huge-types, -t
            Type of schema/data. Concat with ',' if more than one. Other types 
            include 'all' and 'schema'. 'all' means all vertices, edges and 
            schema. In other words, 'all' equals with 'vertex, edge, 
            vertex_label, edge_label, property_key, index_label'. 'schema' 
            equals with 'vertex_label, edge_label, property_key, index_label'.
            Default: [PROPERTY_KEY, VERTEX_LABEL, EDGE_LABEL, INDEX_LABEL, VERTEX, EDGE]
          --keep-local-data
            Whether to keep the local directory of graph data after restored
            Default: false
          --log, -l
            Directory of log
            Default: ./logs
          --retry
            Retry times, default is 3
            Default: 3
          --split-size, -s
            Split size of shard
            Default: 1048576
          --target-graph
            The name of target graph to migrate
            Default: hugegraph
          --target-password
            The password of target graph to migrate
          --target-timeout
            The timeout to connect target graph to migrate
            Default: 0
          --target-trust-store-file
            The trust store file of target graph to migrate
          --target-trust-store-password
            The trust store password of target graph to migrate
          --target-url
            The url of target graph to migrate
            Default: http://127.0.0.1:8081
          --target-user
            The username of target graph to migrate
          --thread-num, -T
            Threads number to use, default is Math.min(10, Math.max(4, CPUs / 
            2)) 
            Default: 0
          -D
            HDFS config parameters
            Syntax: -Dkey=value
            Default: {}

    auth-backup      null
      Usage: auth-backup [options]
        Options:
          --directory
            Directory of auth information, default is 
            './{auth-backup-restore}' in local file system or 
            '{fs.default.name}/{auth-backup-restore}' in HDFS
          --retry
            Retry times, default is 3
            Default: 3
          --types, -t
            Type of auth data to restore and backup, concat with ',' if more 
            than one. 'all' means all auth information. In other words, 'all' 
            equals with 'user, group, target, belong, access'. In addition, 
            'belong' or 'access' can not backup or restore alone, if type 
            contains 'belong' then should contains 'user' and 'group'. If type 
            contains 'access' then should contains 'group' and 'target'.
            Default: [TARGET, GROUP, USER, ACCESS, BELONG]
          -D
            HDFS config parameters
            Syntax: -Dkey=value
            Default: {}

    auth-restore      null
      Usage: auth-restore [options]
        Options:
          --directory
            Directory of auth information, default is 
            './{auth-backup-restore}' in local file system or 
            '{fs.default.name}/{auth-backup-restore}' in HDFS
          --init-password
            Init user password, if restore type include 'user', please specify 
            the init-password of users.
            Default: <empty string>
          --retry
            Retry times, default is 3
            Default: 3
          --strategy
            The strategy needs to be chosen in the event of a conflict when 
            restoring. Valid strategies include 'stop' and 'ignore', default 
            is 'stop'. 'stop' means if there a conflict, stop restore. 
            'ignore' means if there a conflict, ignore and continue to 
            restore. 
            Default: STOP
            Possible Values: [STOP, IGNORE]
          --types, -t
            Type of auth data to restore and backup, concat with ',' if more 
            than one. 'all' means all auth information. In other words, 'all' 
            equals with 'user, group, target, belong, access'. In addition, 
            'belong' or 'access' can not backup or restore alone, if type 
            contains 'belong' then should contains 'user' and 'group'. If type 
            contains 'access' then should contains 'group' and 'target'.
            Default: [TARGET, GROUP, USER, ACCESS, BELONG]
          -D
            HDFS config parameters
            Syntax: -Dkey=value
            Default: {}

    help      Print usage
      Usage: help

```

## 3.8.具体命令示例

### 3.8.1.gremlin语句

```bash
# 同步执行gremlin
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph gremlin-execute --script 'g.V().count()'

# 异步执行gremlin
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph gremlin-schedule --script 'g.V().count()'
```

### 3.8.2.查看task情况

```bash
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph task-list

./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph task-list --limit 5

./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph task-list --status success
```

### 3.8.3.图模式查看和设置

```bash
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph graph-mode-set -m RESTORING MERGING NONE

./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph graph-mode-set -m RESTORING

./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph graph-mode-get

./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph graph-list
```

### 3.8.4.创建图

```bash
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 graph-create -n hugegraph2 -f ./hugegraph2.properties
```

### 3.8.5.清空图

```bash
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph graph-clear
```

### 3.8.6.删除图

```bash
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph graph-drop
```

### 3.8.7.图备份

```bash
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph backup -t all --directory ./backup-test
```

### 3.8.8.周期性的备份

```bash
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph --interval */2 * * * * schedule-backup -d ./backup-0.10.2
```

### 3.8.9.图恢复

```bash
# 设置图模式
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph graph-mode-set -m RESTORING

# 恢复图
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph restore -t all --directory ./backup-test

# 恢复图模式
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph graph-mode-set -m NONE
```

### 3.8.10.图迁移

```bash
./bin/hugegraph --url http://127.0.0.1:8080 --user admin --password admin --space gs1 --graph hugegraph migrate --target-url http://127.0.0.1:8090 --target-space DEFAULT --target-graph hugegraph
```
