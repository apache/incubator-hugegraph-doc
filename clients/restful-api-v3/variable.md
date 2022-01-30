## 4.11.变量

Variables可以用来存储有关整个图的数据，数据按照键值对的方式存取

#### 4.11.1.创建或者更新某个键值对

##### 功能介绍

创建键值对或者更新键值对

##### URI

```
PUT /graphspaces/${graphspace}/graphs/${hugegraph}/variables/${key}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| hugegraph  | 是 | String  |   |   | 图名称  |
| key  | 是 | String  |   |   | 键值对key  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| data  | 是 | String  |   |   |   |

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| key  | String | 返回键值对  |

##### 使用示例

###### Method & Url

```json
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/variables/name
```

###### Request Body

```json
{
    "data": "tom"
}
```

###### Response Status

```json
200
```

###### Response Body

```json
{
  "name": "tom"
}
```

#### 4.11.2.列出全部键值对

##### 功能介绍

列出图空间中具体图的全部键值对

##### URI

```
GET /graphspaces/${graphspace}/graphs/${graph}/variables
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| graph  | 是 | String  |   |   | 图名称  |

##### Body参数

无

##### Response

成功响应参数如下表所示：

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| key  | String | 返回键值对  |

##### 使用示例

###### Method & Url

```json
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/variables
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
  "name": "tom"
}
```

#### 4.11.3.列出某个键值对

##### 功能介绍

查询具体的键值对

##### URI

```
GET /graphspaces/${graphspace}/graphs/${graph}/variables/${key}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| graph  | 是 | String  |   |   | 图名称  |
| key  | 是 | String  |   |   | 键值对key  |

##### Body参数

无

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| key  | String | 返回键值对  |

##### 使用示例

###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/variables/name
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
    "name": "tom"
}
```

#### 4.11.4.删除某个键值对

##### 功能介绍

根据key值删除键值对

##### URI

```
DELETE /graphspaces/${graphspace}/graphs/${graph}/variables/${key}

```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| graph  | 是 | String  |   |   | 图名称  |
| key  | 是 | String  |   |   | 键值对key  |

##### Body参数

无

##### Response

无

##### 使用示例

###### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/graphs/hugegraph/variables/name
```

###### Request Body

无

###### Response Status

```json
204
```

###### Response Body

无
