### 1.6 Rebuild

#### 1.6.1 重建IndexLabel

##### 功能介绍

重建 IndexLabel

##### URI

```
PUT /graphspaces/${graphspace}/graphs/${graph}/jobs/rebuild/indexlabels/${indexlabel}
```


##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| graph  | 是 | String  |   |   | 图名称  |
| indexlabel  | 是 | String  |   |   | indexlabel 的名字  |

##### Body参数

无

##### Response（没有就写无）

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| task_id  |Int| 重建索引的任务 id |

##### 使用示例


###### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/jobs/rebuild/indexlabels/personByCity
```


###### Request Body

无

###### Response Status

```json
202
```


###### Response Body

```json
{
    "task_id": 1
}
```

注：

> 可以通过`GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/tasks/1`（其中"1"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)

#### 1.6.2 VertexLabel对应的全部索引重建

##### 功能介绍

重建 VertexLabel 对应的全部索引

##### URI

```
PUT /graphspaces/${graphspace}/graphs/${graph}/jobs/rebuild/vertexlabels/${vertexlabel}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| graph  | 是 | String  |   |   | 图名称  |
| vertexlabel  | 是 | String  |   |   | vertexlabel 的名字  |

##### Body参数

无

##### Response（没有就写无）

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| task_id  |Int| 重建索引的任务 id |

##### 使用示例

###### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/jobs/rebuild/vertexlabel/person
```


###### Request Body

无

###### Response Status

```json
202
```


###### Response Body

```json
{
    "task_id": 2
}
```

注：

> 可以通过`GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/tasks/2`（其中"2"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)

#### 1.6.3 EdgeLabel对应的全部索引重建

##### 功能介绍

重建 EdgeLabel 对应的全部索引

##### URI

```
PUT /graphspaces/${graphspace}/graphs/${graph}/jobs/rebuild/edgelabels/${edgelabel}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| graph  | 是 | String  |   |   | 图名称  |
| edgelabel  | 是 | String  |   |   | edgelabel 的名字  |

##### Body参数

无

##### Response（没有就写无）

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| task_id  |Int| 重建索引的任务 id |

##### 使用示例

###### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/jobs/rebuild/edgelabels/created
```


###### Request Body

无

###### Response Status

```json
202
```


###### Response Body

```json
{
    "task_id": 3
}
```

注：

> 可以通过`GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/tasks/3`（其中"3"是task_id）来查询异步任务的执行状态，更多[异步任务RESTful API](task.md)
