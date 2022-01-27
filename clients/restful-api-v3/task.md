### 7.1 Task
Task的描述字段详细说明

| 字段             | 说明                    |
| ---------------- | -------------------    |
| task_name        | 异步任务名字             |
| task_progress    | 异步任务当前进度         |
| task_create      | 异步任务创建时间点        |
| task_status      | 异步任务状态             |
| task_update      | 异步任务最近更新时间节点  |
| task_result      | 异步任务运行结果          |
| task_retries     | 异步任务累计重试次数      |
| id               | 异步任务id               |
| task_type        | 异步任务类型             |
| task_callable    | 异步任务的调度函数        |
| task_input       | 异步任务的输入值         |

task_status字段的可选值:
 - UNKNOWN: 未知状态，用于标注异常情况
 - NEW: 刚刚创建的异步任务，尚未进行任何的调度管理
 - SCHEDULING: 开始进行调度
 - SCHEDULED: 已经完成调度分配，但是尚未被执行器确认接收
 - QUEUED: 执行器已将此任务排队
 - PENDING: 异步任务挂起，暂不执行
 - RESTORING: 被挂起或者因为其他原因中断的任务开始恢复
 - RUNNING: 异步任务开始执行，此时无法中断或取消
 - SUCCESS: 异步任务执行成功
 - CANCELLING: 正在尝试取消
 - CANCELLED: 异步任务已经取消成功
 - FAILED: 异步任务执行失败

#### 7.1.1 列出某个图中全部的异步任务

##### URI

```
GET graphspaces/{graphspace}/graphs/{hugegraph}/tasks?status={status}&limit={limit}
```

##### URI参数
 
|  名称 	  | 是否必填  | 类型     | 默认值  |  取值范围 | 说明       |
|  --------   | -------- | ----     |  ----  | ---- | ----      |
| graphspace  | 是       | String   |        |   | 图空间名称  |
| hugegraph   | 是       | String   |        |  | 图名称     |
| status      | 是       | String   |        |  | 异步任务状态  |
| limit       | 否       | Int      |        |  | 返回异步任务数目上限 |

 
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

##### 使用示例

列出所有状态为SUCCESS的异步任务

##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/huegraph/tasks?status=SUCCESS
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

#### 7.1.2 查看某个异步任务的信息

##### URI

```
GET /graphspaces/{graphspace}/graphs/{hugegraph}/tasks/{id}
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
 

##### 使用示例

查看id为2的任务的状态
##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/tasks/2
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

#### 7.1.3 删除某个异步任务信息，**不删除异步任务本身**


##### URI

```
DELETE /graphspaces/{graphspace}/graphs/{hugegraph}/tasks/{id}?force={force}
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

##### 使用示例

强制删除id为2的任务的信息
##### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/graphs/hugegraph/tasks/2?force=true
```
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

##### URI

```
PUT /graphspaces/{graphspace}/graphs/{hugegraph}/tasks/{id}?action=cancel
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

##### 使用示例

取消id为2的异步任务
##### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/tasks/2?action=cancel
```
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
