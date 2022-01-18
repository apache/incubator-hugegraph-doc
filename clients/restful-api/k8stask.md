### 7.2 图计算任务

#### 7.2.1 创建图计算任务

##### Params

- algorithm: 算法名称，可以为 page-rank， degree-centrality， wcc， triangle-count， rings， rings-with-filter， betweenness-centrality， closeness-centrality， lpa， links， kcore， louvain， clustering-coefficient 
- worker: worker数量，数量限制[1, 100]
- params:参数，见请求体示例

##### Request Body

示例1: page-rank

```json
{
  "algorithm": "page-rank",
  "worker": 5,
  "params": {
    "pagerank.alpha": "0.15",
    "pagerank.l1DiffThreshold": "0.00001",
    "bsp.max_super_step": "10"
  }
}
```
| 参数                     | 是否必选 | 说明                   | 类型   | 取值范围        | 默认值  |
| :----------------------- | :------- | :--------------------- | :----- | :-------------- | :------ |
| pagerank.alpha           | 否       | 权重系数(又称阻尼系数) | Double | 0~1，不包括0和1 | 0.15    |
| pagerank.l1DiffThreshold | 否       | 收敛精度               | Double | 0~1，不包括0和1 | 0.00001 |
| bsp.max_super_step       | 否       | 最大迭代次数           | Int    | 1~2000          | 10      |

示例2: degree-centrality

```json
{
  "algorithm": "degree-centrality",
  "worker": 5,
  "params": {
    "degree_centrality.weight_property": ""
  }
}
```
| 参数                              | 是否必选 | 说明       | 类型   | 取值范围 | 默认值             |
| :-------------------------------- | :------- | :--------- | :----- | :------- | :----------------- |
| degree_centrality.weight_property | 否       | 权重属性名 | String |          | "",为空时边权重为1 |

示例3: rings

```json
{
"algorithm": "rings",
"worker": 5,
"params": {
"bsp.max_super_step": "10"
}
}
```
| 参数               | 是否必选 | 说明         | 类型 | 取值范围 | 默认值 |
| :----------------- | :------- | :----------- | :--- | :------- | :----- |
| bsp.max_super_step | 否       | 最大迭代次数 | Int  | 1~2000   | 10     |

示例4: rings-with-filter

```json
{
  "algorithm": "rings-with-filter",
  "worker": 5,
  "params": {
    "bsp.max_super_step": "10",
    "rings.property_filter": "{}"
  }
}
```
| 参数                  | 是否必选 | 说明             | 类型   | 取值范围 | 默认值 |
| :-------------------- | :------- | :--------------- | :----- | :------- | :----- |
| bsp.max_super_step    | 否       | 最大迭代次数     | Int    | 1~2000   | 10     |
| rings.property_filter | 否       | 点边属性过滤条件 | String |          | {}     |

示例5: closeness-centrality

```json
{
  "algorithm": "closeness-centrality",
  "worker": 5,
  "params": {
    "closeness_centrality.weight_property": "",
    "closeness_centrality.sample_rate": "1.0"
  }
}
```
| 参数                                 | 是否必选 | 说明       | 类型   | 取值范围 | 默认值              |
| :----------------------------------- | :------- | :--------- | :----- | :------- | :------------------ |
| closeness_centrality.weight_property | 否       | 权重属性名 | String |          | ""，为空时边权重为1 |
| closeness_centrality.sample_rate     | 否       | 边的采样率 | Double | (0, 1.0] | 1.0  

示例6: betweeness-centrality

```json
{
  "algorithm": "betweeness-centrality",
  "worker": 5,
  "params": {
    "betweenness_centrality.sample_rate": "1.0"
  }
}
```
| 参数                                 | 是否必选 | 说明       | 类型   | 取值范围 | 默认值              |
| :----------------------------------- | :------- | :--------- | :----- | :------- | :------------------ |
| closeness_centrality.sample_rate     | 否       | 边的采样率 | Double | (0, 1.0] | 1.0  

示例7: links

```json
{
  "algorithm": "links",
  "worker": 5,
  "params": {
    "bsp.max_super_step": "10",
    "links.analyze_config": ""
  }
}
```
| 参数                 | 是否必选 | 说明             | 类型   | 取值范围 | 默认值 |
| :------------------- | :------- | :--------------- | :----- | :------- | :----- |
| bsp.max_super_step   | 否       | 最大迭代次数     | Int    | 1~2000   | 10     |
| links.analyze_config | 是       | 链路传播条件配置 | String |          | {}     |

*其他算法，参数可以为空*

##### Hdfs 输出参数

| 参数                         | 是否必选 | 说明                         | 默认值                                                   |
| ---------------------------- | -------- | ---------------------------- | -------------------------------------------------------- |
| output.output_class          | 是       | 输出类                       | com.baidu.hugegraph.computer.core.output.hdfs.HdfsOutput |
| output.hdfs_url              | 是       | Hdfs地址                     | hdfs://127.0.0.1:9000                                    |
| output.hdfs_user             | 是       | Hdfs用户                     | hadoop                                                   |
| output.hdfs_path_prefix      | 否       | Hdfs结果文件夹前缀           | /hugegraph-computer/results                              |
| output.hdfs_delimiter        | 否       | Hdfs结果文件分割符           | char27                                                   |
| output.hdfs_merge_partitions | 否       | 是否将输出结果合并成一个文件 | true                                                     |

以 triangle-count 为例
```json
{
  "algorithm": "triangle-count",
  "worker": 5,
  "params": {
    "output.output_class": "com.baidu.hugegraph.computer.core.output.hdfs.HdfsOutput",
    "output.hdfs_url": "hdfs://127.0.0.1:9000",
    "output.hdfs_user": "hadoop"
  }
}
```

##### Method & Url

```
POST http://localhost:8080/graphs/{hugegraph}/jobs/computerdis
```

##### Response Status

```json
201
```

##### Response Body

```json
{
  "task_id": "7"
}
```

#### 7.2.2 删除图计算任务

##### Method & Url

```
DELETE http://localhost:8080/graphs/{hugegraph}/jobs/computerdis/{task_id}
```

##### Response Status

```json
200
```

##### Response Body

```json
{
  "task_id": "7",
  "message": "success"
}
```

#### 7.2.3 取消图计算任务

##### Method & Url

```
PUT http://localhost:8080/graphs/{hugegraph}/jobs/computerdis/{task_id}
```

##### Response Status

```json
202
```

##### Response Body

```json
{
  "task_id": "8"
}
```

#### 7.2.4 查看图计算任务

##### Method & Url

```
GET http://localhost:8080/graphs/{hugegraph}/jobs/computerdis/{task_id}
```

##### Response Status

```json
200
```

##### Response Body

```json
{
  "task_name": "computer-dis:page-rank",
  "task_progress": 0,
  "task_create": 1635229950651,
  "task_status": "running",
  "task_update": 1635229950652,
  "task_retries": 0,
  "id": 9,
  "task_type": "computer-dis",
  "task_callable": "com.baidu.hugegraph.job.ComputerDisJob",
  "task_input": "{\"graph\":\"hugegraph\",\"algorithm\":\"page-rank\",\"params\":{},\"worker\":5,\"token\":\"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX25hbWUiOiJhZG1pbiIsInVzZXJfaWQiOiItNjM6YWRtaW4iLCJleHAiOjE2MzUyMzAwMzd9.3vEP5HeUfCWdEzVoX6vDhVGne8P6_m-PbgpAfhfVjg4\",\"inner.job.id\":\"page-rank-wlpzjdlal8\",\"inner.status\":\"RUNNING\"}",
  "task_server": "server-1"
}
```

#### 7.2.5 查看图计算任务列表

##### Params

- limit: 100

##### Method & Url

```
GET http://localhost:8080/graphs/{hugegraph}/jobs/computerdis?limit=100
```

##### Response Status

```json
200
```

##### Response Body

```json
{
  "tasks": [
    {
      "task_name": "computer-dis:page-rank",
      "task_progress": 0,
      "task_create": 1635229748132,
      "task_status": "success",
      "task_update": 1635229762492,
      "task_retries": 0,
      "id": 7,
      "task_type": "computer-dis",
      "task_server": "server-1"
    },
    {
      "task_name": "computer-dis:page-rank",
      "task_progress": 0,
      "task_create": 1635229950651,
      "task_status": "success",
      "task_update": 1635229964862,
      "task_retries": 0,
      "id": 9,
      "task_type": "computer-dis",
      "task_server": "server-1"
    }
  ]
}
```
