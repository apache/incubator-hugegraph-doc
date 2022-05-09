---
title: "Task API"
linkTitle: "Task"
weight: 13
---

### 7.1 Task

#### 7.1.1 list all asynTasks in graph

##### Params

- status: the status of asynTasks
- limit：the max number of tasks to return

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/tasks?status=success
```

##### Response Status

```json
200
```

##### Response Body

```json
{
	"tasks": [{
		"task_name": "hugegraph.traversal().V()",
		"task_progress": 0,
		"task_create": 1532943976585,
		"task_status": "success",
		"task_update": 1532943976736,
		"task_result": "0",
		"task_retries": 0,
		"id": 2,
		"task_type": "gremlin",
		"task_callable": "com.baidu.hugegraph.api.job.GremlinAPI$GremlinJob",
		"task_input": "{\"gremlin\":\"hugegraph.traversal().V()\",\"bindings\":{},\"language\":\"gremlin-groovy\",\"aliases\":{\"hugegraph\":\"graph\"}}"
	}]
}
```

#### 7.1.2 view the details of an asyncTask

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/tasks/2
```

##### Response Status

```json
200
```

##### Response Body

```json
{
	"task_name": "hugegraph.traversal().V()",
	"task_progress": 0,
	"task_create": 1532943976585,
	"task_status": "success",
	"task_update": 1532943976736,
	"task_result": "0",
	"task_retries": 0,
	"id": 2,
	"task_type": "gremlin",
	"task_callable": "com.baidu.hugegraph.api.job.GremlinAPI$GremlinJob",
	"task_input": "{\"gremlin\":\"hugegraph.traversal().V()\",\"bindings\":{},\"language\":\"gremlin-groovy\",\"aliases\":{\"hugegraph\":\"graph\"}}"
}
```

#### 7.1.3 delete task infomation of an asyncTask，**won't delete the task itself**

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/tasks/2
```

##### Response Status

```json
204
```

#### 7.1.4 取消某个异步任务，**该异步任务必须具有处理中断的能力**

if you already created an asyncTask via [Gremlin API](../gremlin) as follows：

```groovy
"for (int i = 0; i < 10; i++) {" +
    "hugegraph.addVertex(T.label, 'man');" +
    "hugegraph.tx().commit();" +
    "try {" +
        "sleep(1000);" +
    "} catch (InterruptedException e) {" +
        "break;" +
    "}" +
"}"
```

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/tasks/2?action=cancel
```
> cancel it in 10s. if more than 10s，the task may already finished,then can't be cancelled.

##### Response Status

```json
202
```

##### Response Body

```json
{
    "cancelled": true
}
```

query the number of vertex which label is man ，it must less than 10。
