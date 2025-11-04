---
title: "Rebuild API"
linkTitle: "Rebuild"
weight: 6
---

### 1.6 Rebuild

> **重要提示**：在使用以下 API 之前，需要先创建图空间（graphspace）。请参考 [Graphspace API](../graphspace) 创建名为 `gs1` 的图空间。文档中的示例均假设已存在名为 `gs1` 的图空间。

#### 1.6.1 重建IndexLabel

##### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/jobs/rebuild/indexlabels/personByCity
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

> 可以通过`GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/tasks/1`（其中"1"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](../task)

#### 1.6.2 VertexLabel对应的全部索引重建

##### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/jobs/rebuild/vertexlabels/person
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

> 可以通过`GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/tasks/2`（其中"2"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](../task)

#### 1.6.3 EdgeLabel对应的全部索引重建

##### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/jobs/rebuild/edgelabels/created
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

> 可以通过`GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/tasks/3`（其中"3"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](../task)