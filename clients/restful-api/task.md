### 6.1 Task

#### 6.1.1 列出某个图中全部的异步任务



##### Params

- status: 异步任务的状态
- limit：返回异步任务数目上限

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

#### 6.1.2 查看某个异步任务的信息

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

#### 6.1.3 删除某个异步任务信息，**不删除异步任务本身**

##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/tasks/2
```

##### Response Status

```json
204
```
