## 4.10.Gremlin

#### 4.10.1.向HugeGraphServer发送gremlin语句（GET），同步执行

##### 功能介绍

向HugeGraphServer发送gremlin语句（GET），同步执行

##### URI

```
GET /gremlin?gremlin=${gremlin}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| gremlin  | 是 | String  |   |  | 要发送给HugeGraphServer执行的gremlin语句  |
| bindings  | 否 | String  |   |  | 用来绑定参数，key是字符串，value是绑定的值（只能是字符串或者数字），功能类似于MySQL的 Prepared Statement，用于加速语句执行  |
| language  | 是 | String  |   |  | 发送语句的语言类型，默认为gremlin-groovy  |
| aliases  | 是 | String  |   |  | 为存在于图空间的已有变量添加别名  |

##### Body参数

无

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| requestId  | String |  请求ID |
| status  | Map |  返回状态 |
| result  | Object |  结果对象 |

表1 status对象

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| message  | String |  消息 |
| code  | Integer |  返回码 |
| attributes  | Map |  信息 |

表2 result对象

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| data  | Array |  数据列表 |

表3 data对象

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| data  | Json |  具体数据 |


##### 使用示例

###### Method & Url

```
GET http://localhost:8080/gremlin?gremlin=gs1-hugegraph.traversal().V()
```

###### Request Body

无

###### Response Status

```json
200
```

###### Response Body

```json
{
	"requestId": "c6ef47a8-b634-4b07-9d38-6b3b69a3a556",
	"status": {
		"message": "",
		"code": 200,
		"attributes": {}
	},
	"result": {
		"data": [{
			"id": "1:marko",
			"label": "person",
			"type": "vertex",
			"properties": {
				"city": [{
					"id": "1:marko>city",
					"value": "Beijing"
				}],
				"name": [{
					"id": "1:marko>name",
					"value": "marko"
				}],
				"age": [{
					"id": "1:marko>age",
					"value": 29
				}]
			}
		}],
		"meta": {}
	}
}
```

#### 4.10.2.向HugeGraphServer发送gremlin语句（POST），同步执行

##### 功能介绍

向HugeGraphServer发送gremlin语句（POST），同步执行

##### URI

```
POST /gremlin
```

##### URI参数

无

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| gremlin  | 是 | String  |   |  | 要发送给HugeGraphServer执行的gremlin语句  |
| bindings  | 否 | String  |   |  | 用来绑定参数，key是字符串，value是绑定的值（只能是字符串或者数字），功能类似于MySQL的 Prepared Statement，用于加速语句执行  |
| language  | 是 | String  |   |  | 发送语句的语言类型，默认为gremlin-groovy  |
| aliases  | 是 | String  |   |  | 为存在于图空间的已有变量添加别名  |

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| requestId  | String |  请求ID |
| status  | Map |  返回状态 |
| result  | Object |  结果对象 |

表1 status对象

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| message  | String |  消息 |
| code  | Integer |  返回码 |
| attributes  | Map |  信息 |

表2 result对象

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| data  | Array |  数据列表 |

表3 data对象

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| data  | Json |  具体数据 |


##### 使用示例

###### Method & Url

```
POST http://localhost:8080/gremlin
```

###### Request Body

```json
{
	"gremlin": "graph.traversal().V('1:marko')",
	"bindings": {},
	"language": "gremlin-groovy",
	"aliases": {"graph":"gs1-hugegraph", "g":"__g_gs1-hugegraph"}
}
```

###### Response Status

```json
200
```

###### Response Body

```json
{
	"requestId": "c6ef47a8-b634-4b07-9d38-6b3b69a3a556",
	"status": {
		"message": "",
		"code": 200,
		"attributes": {}
	},
	"result": {
		"data": [{
			"id": "1:marko",
			"label": "person",
			"type": "vertex",
			"properties": {
				"city": [{
					"id": "1:marko>city",
					"value": "Beijing"
				}],
				"name": [{
					"id": "1:marko>name",
					"value": "marko"
				}],
				"age": [{
					"id": "1:marko>age",
					"value": 29
				}]
			}
		}],
		"meta": {}
	}
}
```

注意：

> 这里是直接使用图对象（hugegraph），先获取其遍历器（traversal()），再获取顶点。
不能直接写成`graph.traversal().V()`或`g.V()`，可以通过`"aliases": {"graph": "gs1-hugegraph", "g": "__g_gs1-hugegraph"}`
为图和遍历器添加别名后使用别名操作。其中，`hugegraph`是原生存在的变量，`__g_gs1-hugegraph`是`HugeGraphServer`额外添加的变量，
每个图都会存在一个对应的这样格式（__g_${graphspace}-${graph}）的遍历器对象。

> 响应体的结构与其他 Vertex 或 Edge 的 RESTful API的结构有区别，用户可能需要自行解析。

#### 4.10.3.向HugeGraphServer发送gremlin语句（POST），异步执行

##### 功能介绍

向HugeGraphServer发送gremlin语句（POST），异步执行

##### URI

```
POST /graphspaces/${graphspace}/graphs/${graph}/jobs/gremlin
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |  | 图空间  |
| graph  | 是 | String  |   |  | 图  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| gremlin  | 是 | String  |   |  | 要发送给HugeGraphServer执行的gremlin语句  |
| bindings  | 否 | String  |   |  | 用来绑定参数，key是字符串，value是绑定的值（只能是字符串或者数字），功能类似于MySQL的 Prepared Statement，用于加速语句执行  |
| language  | 是 | String  |   |  | 发送语句的语言类型，默认为gremlin-groovy  |
| aliases  | 是 | String  |   |  | 为存在于图空间的已有变量添加别名  |

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| task_id  | Integer | 任务ID  |

##### 使用示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/gs1/graphs/hugegraph/jobs/gremlin
```

###### Request Body

```json
{
	"gremlin": "g.V('1:marko')",
	"bindings": {},
	"language": "gremlin-groovy",
	"aliases": {}
}
```

###### Response Status

```json
201
```

###### Response Body

```json
{
	"task_id": 1
}
```

注意：

> 异步执行Gremlin语句暂不支持aliases，可以使用 `graph` 代表要操作的图，也可以直接使用图的名字， 例如 `hugegraph`;
另外`g`代表 traversal，等价于 `graph.traversal()` 或者 `hugegraph.traversal()`

注：

> 可以通过`GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/tasks/1`（其中"1"是task_id） 来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)
