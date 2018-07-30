### 6.2 Rebuild

#### 6.2.1 重建IndexLabel

##### Method

```
PUT
```

##### Url

```
http://localhost:8080/graphs/hugegraph/jobs/rebuild/indexlabels/personByCity
```

##### Response Status

```json
202
```

##### Response Body

```json
{
    "task_id": 1
}
```

注：

> 可以通过`GET http://localhost:8080/graphs/hugegraph/tasks/1`（其中"1"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)

#### 6.2.2 重建VertexLabel索引

##### Method

```
PUT
```

##### Url

```
http://localhost:8080/graphs/hugegraph/jobs/rebuild/vertexlabels/person
```

##### Response Status

```json
202
```

##### Response Body

```json
{
    "task_id": 2
}
```

注：

> 可以通过`GET http://localhost:8080/graphs/hugegraph/tasks/2`（其中"2"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)

#### 6.2.3 重建EdgeLabel索引

##### Method

```
PUT
```

##### Url

```
http://localhost:8080/graphs/hugegraph/jobs/rebuild/edgelabels/softwareByPrice
```

##### Response Status

```json
202
```

##### Response Body

```json
{
    "task_id": 3
}
```

注：

> 可以通过`GET http://localhost:8080/graphs/hugegraph/tasks/3`（其中"3"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)