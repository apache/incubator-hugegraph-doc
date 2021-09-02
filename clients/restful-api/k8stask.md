### 6.3 图计算任务

#### 6.3.1 创建图计算任务

##### Params

- worker_instances: worker数量
- internal_algorithm: 算法名称
- params_class: 参数类

##### Request Body

```json
{
  "worker_instances": "2",
  "internal_algorithm": "[pagerank]",
  "params_class": "com.baidu.hugegraph.computer.algorithm.rank.pagerank.PageRankParams"
}
```

##### Method & Url

```
POST http://localhost:8080/graphs/{hugegraph}/jobs/computerdis/{algorithm}
```

##### Response Status

```json
201
```

##### Response Body

```json
{
  "task_id": "xx",
  "message": "success"
}
```

#### 6.3.2 删除图计算任务

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
  "task_id": "xx",
  "message": "success"
}
```

#### 6.3.3 取消图计算任务

##### Method & Url

```
PUT http://localhost:8080/graphs/{hugegraph}/jobs/computerdis/{task_id}
```

##### Response Status

```json
204
```

##### Response Body

```json
{
    "task_id": "xx",
    "message": "success"
}
```

#### 6.3.4 查看图计算任务列表

##### Params

- limit: 100

##### Method & Url

```
GET http://localhost:8080/graphs/{hugegraph}/jobs/computerdis?limit=100
```

##### Response Status

```json
201
```

##### Response Body

```json
{
  "tasks": [
    {
      "task_name": "computer-proxy:pagerank",
      "task_progress": 0,
      "task_create": 1630574093172,
      "task_status": "success",
      "task_update": 1630574102519,
      "task_retries": 0,
      "id": 2,
      "task_type": "computer-proxy",
      "task_server": "server-2"
    },
    {
      "task_name": "computer-proxy:pagerank",
      "task_progress": 0,
      "task_create": 1630574152472,
      "task_status": "success",
      "task_update": 1630574165237,
      "task_retries": 0,
      "id": 3,
      "task_type": "computer-proxy",
      "task_server": "server-2"
    },
    {
      "task_name": "computer-proxy:pagerank",
      "task_progress": 0,
      "task_create": 1630574926226,
      "task_status": "failed",
      "task_update": 1630574935039,
      "task_retries": 0,
      "id": 4,
      "task_type": "computer-proxy",
      "task_server": "server-2"
    }
  ]
}
```

#### 6.3.5 更新图计算任务状态

##### Params

- status: RUNNING

##### Request Body

```json
{
  "status": "RUNNING"
}
```

##### Method & Url

```
GET http://localhost:8080/graphs/{hugegraph}/jobs/computerdis/update/{jobId}
```

##### Response Status

```json
200
```