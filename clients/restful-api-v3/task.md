### 7.1 Task

#### 7.1.1 列出某个图中全部的异步任务

##### Params

- status: 异步任务的状态，状态可以为 UNKNOWN、NEW、SCHEDULING、SCHEDULED、QUEUED、PENDING、RESTORING、RUNNING、SUCCESS、CANCELLING、CANCELLED、FAILED
- limit：返回异步任务数目上限

##### Method & Url

```
GET http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/tasks?status=SUCCESS
```

##### URI参数
 
|  名称 	  | 是否必填  | 类型     | 默认值  |  取值范围 | 说明       |
|  --------   | -------- | ----     |  ----  | ---- | ----      |
| graphspace  | 是       | String   |        |   | 图空间名称  |
| hugegraph   | 是       | String   |        |  | 图名称     |
| status       | 是       | String   |       |  | 异步任务状态  |

 
##### Body参数
 
无

##### Response
| 名称                 | 类型            | 说明                   |
| ------------------  | ------------    | ---------------------- |
| task_name           | String          | 异步任务名字                       |
| task_progress       | Int             | 异步任务当前进度                   |
| task_create         | Long            | 异步任务创建时间点  |
| task_status         | String          | 异步任务状态 |
| task_update         | Long            | 异步任务最近更新时间节点 |
| task_result         | String          | 异步任务运行结果 |
| task_retries        | Int             | 异步任务累计重试次数 |
| id                  | Long            | 异步任务id   |
| task_type           | String          | 异步任务类型 |
| task_callable       | String          | 异步任务的调度函数 |
| task_input          | String          | 异步任务的输入值 |

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

#### 7.1.2 查看某个异步任务的信息

##### Method & Url

```
GET http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/tasks/{id}
```
##### URI参数说明
 
|  名称 	  | 是否必填  | 类型     | 默认值  |  取值范围 |说明       |
|  --------   | -------- | ----     |  ----  | ---- |----      |
| graphspace  | 是       | String   |        |  | 图空间名称  |
| hugegraph   | 是       | String   |        |  | 图名称     |
| id       | 是       | String   |       |      | 异步任务Id  |

##### Body参数
无

##### Response
| 名称                 | 类型            | 说明                   |
| ------------------  | ------------    | ---------------------- |
| task_name           | String          | 异步任务名字                       |
| task_progress       | Int             | 异步任务当前进度                   |
| task_create         | Long            | 异步任务创建时间点  |
| task_status         | String          | 异步任务状态 |
| task_update         | Long            | 异步任务最近更新时间节点 |
| task_result         | String          | 异步任务运行结果 |
| task_retries        | Int             | 异步任务累计重试次数 |
| id                  | Long            | 异步任务Id   |
| task_type           | String          | 异步任务类型 |
| task_callable       | String          | 异步任务的调度函数 |
| task_input          | String          | 异步任务的输入值 |
 

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

#### 7.1.3 删除某个异步任务信息，**不删除异步任务本身**

##### Params

- force: 是否强制删除，默认为 false。当设置为 true 时，不论异步任务处于何种状态，都将删除异步任务信息

##### Method & Url

```
DELETE http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/tasks/{id}
```
或者：
```
DELETE http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/tasks/{id}?force=true
```
##### URI参数
 
|  名称 	  | 是否必填  | 类型     | 默认值  | 取值范围 | 说明        |
|  --------   | -------- | ----     |  ----  | ---- | ----        |
| graphspace  | 是       | String   |        |    | 图空间名称   |
| hugegraph   | 是       | String   |        |    | 图名称      |
| id          | 是       | String   |       |     | 异步任务Id     |
| force       | 否       | Boolean  | false  |     |是否强制删除 |

##### Body参数
无

##### Response
| 名称                 | 类型            | 说明                   |
| ------------------  | ------------    | ---------------------- |
| task_name           | String          | 异步任务名字                       |
| task_progress       | Int             | 异步任务当前进度                   |
| task_create         | Long            | 异步任务创建时间点  |
| task_status         | String          | 异步任务状态 |
| task_update         | Long            | 异步任务最近更新时间节点 |
| task_result         | String          | 异步任务运行结果 |
| task_retries        | Int             | 异步任务累计重试次数 |
| id                  | Long            | 异步任务id   |
| task_type           | String          | 异步任务类型 |
| task_callable       | String          | 异步任务的调度函数 |
| task_input          | String          | 异步任务的输入值 |
##### Response Status

```json
204
```

#### 7.1.4 取消某个异步任务，**该异步任务必须具有处理中断的能力**

假设已经通过[Gremlin API](gremlin.md)创建了一个异步任务如下：

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
PUT http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/tasks/{id}?action=cancel
```
##### URI参数说明
 
|  名称 	  | 是否必填  | 类型     | 默认值  | 取值范围 | 说明       |
|  --------   | -------- | ----     |  ----  | ---- | ----      |
| graphspace  | 是       | String   |        | 图空间名称  |
| hugegraph   | 是       | String   |        | 图名称     |
| id       | 是       | String   |       | 异步任务Id |

##### Body参数
无

##### Response
| 名称                 | 类型            | 说明                   |
| ------------------  | ------------    | ---------------------- |
| cancelled           | Boolean         | 是否取消成功


> 请保证在10秒内发送该请求，如果超过10秒发送，任务可能已经执行完成，无法取消。

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

此时查询 label 为 man 的顶点数目，一定是小于 10 的。
