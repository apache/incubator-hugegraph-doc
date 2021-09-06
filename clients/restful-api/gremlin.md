### 8.1 Gremlin

#### 8.1.1 向HugeGraphServer发送gremlin语句（GET），同步执行

##### Params

- gremlin: 要发送给`HugeGraphServer`执行的`gremlin`语句
- bindings: 用来绑定参数，key是字符串，value是绑定的值（只能是字符串或者数字），功能类似于MySQL的 Prepared Statement，用于加速语句执行
- language: 发送语句的语言类型，默认为`gremlin-groovy`
- aliases: 为存在于图空间的已有变量添加别名

**查询顶点**

##### Method & Url

```
GET http://127.0.0.1:8080/gremlin?gremlin=hugegraph.traversal().V('1:marko')
```

##### Response Status

```json
200
```

##### Response Body

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

#### 8.1.2 向HugeGraphServer发送gremlin语句（POST），同步执行

##### Method & Url

```
POST http://localhost:8080/gremlin
```

**查询顶点**

##### Request Body

```json
{
	"gremlin": "hugegraph.traversal().V('1:marko')",
	"bindings": {},
	"language": "gremlin-groovy",
	"aliases": {}
}
```

##### Response Status

```json
200
```

##### Response Body

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
不能直接写成`graph.traversal().V()`或`g.V()`，可以通过`"aliases": {"graph": "hugegraph", "g": "__g_hugegraph"}`
为图和遍历器添加别名后使用别名操作。其中，`hugegraph`是原生存在的变量，`__g_hugegraph`是`HugeGraphServer`额外添加的变量，
每个图都会存在一个对应的这样格式（__g_${graph}）的遍历器对象。

> 响应体的结构与其他 Vertex 或 Edge 的 RESTful API的结构有区别，用户可能需要自行解析。

**查询边**

##### Request Body

```json
{
	"gremlin": "g.E('S1:marko>2>>S2:lop')",
	"bindings": {},
	"language": "gremlin-groovy",
	"aliases": {
		"graph": "hugegraph", 
		"g": "__g_hugegraph"
	}
}
```

##### Response Status

```json
200
```

##### Response Body

```json
{
	"requestId": "3f117cd4-eedc-4e08-a106-ee01d7bb8249",
	"status": {
		"message": "",
		"code": 200,
		"attributes": {}
	},
	"result": {
		"data": [{
			"id": "S1:marko>2>>S2:lop",
			"label": "created",
			"type": "edge",
			"inVLabel": "software",
			"outVLabel": "person",
			"inV": "2:lop",
			"outV": "1:marko",
			"properties": {
				"weight": 0.4,
				"date": "20171210"
			}
		}],
		"meta": {}
	}
}
```

#### 8.1.3 向HugeGraphServer发送gremlin语句（POST），异步执行

##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/jobs/gremlin
```

**查询顶点**

##### Request Body

```json
{
	"gremlin": "g.V('1:marko')",
	"bindings": {},
	"language": "gremlin-groovy",
	"aliases": {}
}
```

注意：

> 异步执行Gremlin语句暂不支持aliases，可以使用 `graph` 代表要操作的图，也可以直接使用图的名字， 例如 `hugegraph`;
另外`g`代表 traversal，等价于 `graph.traversal()` 或者 `hugegraph.traversal()`

##### Response Status

```json
201
```

##### Response Body

```json
{
	"task_id": 1
}
```

注：

> 可以通过`GET http://localhost:8080/graphs/hugegraph/tasks/1`（其中"1"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)

**查询边**

##### Request Body

```json
{
	"gremlin": "g.E('S1:marko>2>>S2:lop')",
	"bindings": {},
	"language": "gremlin-groovy",
	"aliases": {}
}
```

##### Response Status

```json
200
```

##### Response Body

```json
{
	"task_id": 2
}
```

注：

> 可以通过`GET http://localhost:8080/graphs/hugegraph/tasks/2`（其中"2"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)