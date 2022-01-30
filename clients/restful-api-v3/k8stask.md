## 4.6.图计算任务

#### 4.6.1.创建图计算任务

##### 功能介绍

根据算法名称创建不同算法任务

##### URI

```
POST /graphspaces/${graphspace}/graphs/${graph}/jobs/computerdis
```

##### URI参数
 
|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| graph  | 是 | String  |   |   | 图名称  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| algorithm  | 是 | String  |   | page-rank， degree-centrality， wcc， triangle-count， rings， rings-with-filter， betweenness-centrality， closeness-centrality， lpa， links， kcore， louvain， clustering-coefficient  | 算法类型  |
| worker  | 是 | Int  |   | [1, 100]  | 并行运行数量  |
| params  | 是 | String  |   |   | 每种算法具体的参数，见请求体示例  |


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
| 名称                     | 是否必填 | 说明                   | 类型   | 取值范围        | 默认值  |
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
| 名称                              | 是否必填 | 说明       | 类型   | 取值范围 | 默认值             |
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
| 名称               | 是否必填 | 说明         | 类型 | 取值范围 | 默认值 |
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
| 名称                  | 是否必填 | 说明             | 类型   | 取值范围 | 默认值 |
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
| 名称                                 | 是否必填 | 说明       | 类型   | 取值范围 | 默认值              |
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
| 名称                                 | 是否必填 | 说明       | 类型   | 取值范围 | 默认值              |
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
| 名称                 | 是否必填 | 说明             | 类型   | 取值范围 | 默认值 |
| :------------------- | :------- | :--------------- | :----- | :------- | :----- |
| bsp.max_super_step   | 否       | 最大迭代次数     | Int    | 1~2000   | 10     |
| links.analyze_config | 是       | 链路传播条件配置 | String |          | {}     |

*其他算法，参数可以为空*

##### Hdfs 输出参数

| 名称                         | 是否必填 | 说明                         | 默认值                                                   |
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

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| task_id  | String | 返回创建的任务id  |

##### 使用示例 
 
###### Method & Url
 
```
POST http://localhost:8080/graphspaces/${graphspace}/graphs/${graph}/jobs/computerdis
``` 
 
###### Request Body 
 
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
 
###### Response Status

```json
201
```
###### Response Body 

```json
{
  "task_id": "7"
}
```

#### 4.6.2.删除图计算任务

##### URI

```
DELETE /graphspaces/${graphspace}/graphs/${graph}/jobs/computerdis/${task_id}
```
##### URI参数
 
|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| graph  | 是 | String  |   |   | 图名称  |
| task_id  | 是 | String  |   |   | 创建图计算任务中返回的task_id  |

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| task_id  | String | 删除的任务id  |
| message  | String | 执行状态  |
 

##### 使用示例 
 
###### Method & Url
 
```
DELETE http://localhost:8080/graphspaces/${graphspace}/graphs/${graph}/jobs/computerdis/${task_id}
```
 
###### Response Status

```json
200
``` 

###### Response Body
```json
{
  "task_id": "7",
  "message": "success"
}
```

#### 4.6.3.取消图计算任务

##### URI

```
PUT /graphspaces/${graphspace}/graphs/${graph}/jobs/computerdis/${task_id}
```
##### URI参数说明
 
|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| graph  | 是 | String  |   |   | 图名称  |
| task_id  | 是 | String  |   |   | 创建图计算任务中返回的task_id  |

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| task_id  | String | 取消的任务id  |
 
##### 使用示例
 
 
###### Method & Url
 
```
PUT http://localhost:8080/graphspaces/${graphspace}/graphs/${graph}/jobs/computerdis/${task_id}
```
 
###### Response Status

```json
202
```

###### Response Body
```json
{
  "task_id": "8"
}
```

#### 4.6.4.查看图计算任务

##### URI

```
GET /graphspaces/${graphspace}/graphs/${graph}/jobs/computerdis/${task_id}
```
##### URI参数
 
|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| graph  | 是 | String  |   |   | 图名称  |
| task_id  | 是 | String  |   |   | 创建图计算任务中返回的task_id  |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| task_name  |String| 任务名 |
| task_progress  |Int| 任务执行进度 |
| task_create  |Long| 任务创建时间戳 |
| task_status  |String| 任务状态 |
| task_update  |Long| 任务状态更新时间戳 |
| task_retries  |Int| 任务重试次数 |
| id  |Int| 任务id |
| task_type  |String| 任务类型 |
| task_callable  |String| 任务回调函数 |
| task_input  |String| 任务输入参数 |
| task_server  |String| 任务执行server |

 
##### 使用示例
 
 
###### Method & Url
 
```
GET http://localhost:8080/graphspaces/${graphspace}/graphs/${graph}/jobs/computerdis/${task_id}
```

###### Response Status

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

#### 4.6.5.查看图计算任务列表

##### URI

```
GET /graphspaces/${graphspace}/graphs/${graph}/jobs/computerdis?limit=${limit}
```
##### URI参数
 
|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| graph  | 是 | String  |   |   | 图名称  |
| limit  | 否 | Int  |   |   | 返回结果最大条数  |

##### body参数
 无

##### Response
|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| task_name  |String| 任务名 |
| task_progress  |Int| 任务执行进度 |
| task_create  |Long| 任务创建时间戳 |
| task_status  |String| 任务状态 |
| task_update  |Long| 任务状态更新时间戳 |
| task_retries  |Int| 任务重试次数 |
| id  |Int| 任务id |
| task_type  |String| 任务类型 |
| task_server  |String| 任务执行server |
 
##### 使用示例
 
 
###### Method & Url
 
```
GET http://localhost:8080/graphspaces/${graphspace}/graphs/${graph}/jobs/computerdis?limit=100
```

###### Response Status

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
