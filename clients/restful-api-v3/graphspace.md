## 4.1.图空间

在 HugeGraph 中，多租户是通过图空间（graph space）来实现的，资源的分配和隔离可以通过图空间进行。

#### 4.1.1.创建一个图空间

##### 功能介绍

创建一个图空间

##### URI

```
POST /graphspaces
```

##### URI参数

无

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| name  | 是 | String  |   | 小写字母、数字和下划线组成，首字符必须是小写字母，长度不超过48  |  图空间的名字 |
| description  | 是 | String  |   |   |  图空间的描述信息 |
| cpu_limit  | 是 | Int  |   | > 0  |  CPU 核数 |
| memory_limit  | 是 | Int  |   | > 0  |  内存大小，单位 GB |
| storage_limit  | 是 | Int  |   | > 0  |  图空间的数据占据的磁盘空间上限 |
| oltp_namespace  | 是 | String  |   |   |  OLTP 的k8s命名空间 |
| olap_namespace  | 是 | String  |   |   |  OLAP 的k8s命名空间 |
| storage_namespace  | 是 | String  |   |   |  存储 的k8s命名空间 |
| max_graph_number | 是 | Int | | > 0 | 图空间的图数目的上限 |
| max_role_number | 是 | Int | | > 0 | 图空间的角色数目的上限 |
| auth | 否 | Boolean | false | true, false | 图空间是否支持权限认证 |
| configs | 否 | Map |  |  | 其他配置信息 |

##### Response

|  名称   | 类型  | 说明  |
| ------ | ---- | ----- |
| name  | String |  图空间的名字 |
| description  | String |  图空间的描述信息 |
| cpu_limit  | Int |  CPU 核数上限 |
| memory_limit  | Int |  内存大小上限，单位 GB |
| storage_limit  | Int |  图空间的数据占据的磁盘空间上限 |
| oltp_namespace  | String |  OLTP 的k8s命名空间 |
| olap_namespace  | String |  OLAP 的k8s命名空间 |
| storage_namespace  | String |  存储的k8s命名空间 |
| max_graph_number | Int | 图空间的图数目的上限 |
| max_role_number | Int | 图空间的角色数目的上限 |
| cpu_used  | Int |  已使用的 CPU 核数 |
| memory_used  | Int |  已使用的内存大小，单位 GB |
| storage_used  | Int |  图空间的数据已占据的磁盘空间 |
| graph_number_used | Int | 图空间的图数目 |
| role_number_used | Int | 图空间的角色数目 |
| auth | Boolean | 图空间是否支持权限认证 |

##### 使用示例

###### Method & Url

```
POST http://localhost:8080/graphspaces
```

###### Request Body

```json
{
  "name": "gs1",
  "description": "1st graph space",
  "cpu_limit": 1000,
  "memory_limit": 1024,
  "storage_limit": 1000,
  "oltp_namespace": "hugegraph-server",
  "olap_namespace": "hugegraph-server",
  "storage_namespace": "hugegraph-server",
  "max_graph_number": 100,
  "max_role_number": 10,
  "auth": false,
  "configs": {}
}
```

###### Response Status

```json
201
```

###### Response Body

```json
{
  "name": "gs1",
  "description": "1st graph space",
  "cpu_limit": 1000,
  "memory_limit": 1024,
  "storage_limit": 1000,
  "oltp_namespace": "hugegraph-server",
  "olap_namespace": "hugegraph-server",
  "storage_namespace": "hugegraph-server",
  "max_graph_number": 100,
  "max_role_number": 10,
  "cpu_used": 0,
  "memory_used": 0,
  "storage_used": 0,
  "graph_number_used": 0,
  "role_number_used": 0,
  "auth": true
}
```

#### 4.1.2.列出系统所有图空间

##### 功能介绍

列出系统所有图空间

##### URI

```
GET /graphspaces
```


##### URI参数

无

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| graphspaces  |Array| 图空间的名字列表 |

##### 使用示例

###### Method & Url

```
GET http://localhost:8080/graphspaces
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
    "graphSpaces":[
        "gs1",
        "DEFAULT"
    ]
}
```

#### 4.1.3.查看某个图空间

##### 功能介绍

查看某个图空间

##### URI

```
GET /graphspaces/${graphspace}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |

##### Body参数

无

##### Response

|  名称   | 类型  | 说明  |
| ------ | ---- | ----- |
| name  | String |  图空间的名字 |
| description  | String |  图空间的描述信息 |
| cpu_limit  | Int |  CPU 核数上限 |
| memory_limit  | Int |  内存大小上限，单位 GB |
| storage_limit  | Int |  图空间的数据占据的磁盘空间上限 |
| oltp_namespace  | String |  OLTP 的k8s命名空间 |
| olap_namespace  | String |  OLAP 的k8s命名空间 |
| storage_namespace  | String |  存储的k8s命名空间 |
| max_graph_number | Int | 图空间的图数目的上限 |
| max_role_number | Int | 图空间的角色数目的上限 |
| cpu_used  | Int |  已使用的 CPU 核数 |
| memory_used  | Int |  已使用的内存大小，单位 GB |
| storage_used  | Int |  图空间的数据已占据的磁盘空间 |
| graph_number_used | Int | 图空间的图数目 |
| role_number_used | Int | 图空间的角色数目 |
| auth | Boolean | 图空间是否支持权限认证 |

##### 使用示例

###### Method & Url

```
GET http://127.0.0.1:8080/graphspaces/gs1
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
  "name": "gs1",
  "description": "1st graph space",
  "cpu_limit": 1000,
  "memory_limit": 1024,
  "storage_limit": 1000,
  "oltp_namespace": "hugegraph-server",
  "olap_namespace": "hugegraph-server",
  "storage_namespace": "hugegraph-server",
  "max_graph_number": 100,
  "max_role_number": 10,
  "cpu_used": 0,
  "memory_used": 0,
  "storage_used": 0,
  "graph_number_used": 0,
  "role_number_used": 0,
  "auth": true
}
```

#### 4.1.4.更新某个图空间

注意：auth鉴权配置，在创建图空间的过程一旦确定下来，不允许更新

##### 功能介绍

更新某个图空间

##### URI

```
PUT /graphspaces/${graphspace}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| description  | 是 | String  |   |   |  图空间的描述信息 |
| cpu_limit  | 是 | Int  |   | > 0  |  OLTP HugeGraphServer 的 CPU 核数 |
| memory_limit  | 是 | Int  |   | > 0  |  OLTP HugeGraphServer 的内存大小，单位 GB |
| storage_limit  | 是 | Int  |   | > 0  |  图空间的数据占据的磁盘空间上限 |
| oltp_namespace  | 是 | String  |   |   |  OLTP 的k8s命名空间 |
| olap_namespace  | 是 | String  |   |   |  OLAP 的k8s命名空间 |
| storage_namespace  | 是 | String  |   |   |  存储的k8s命名空间 |
| max_graph_number | 是 | Int | | > 0 | 图空间的图数目的上限 |
| max_role_number | 是 | Int | | > 0 | 图空间的角色数目的上限 |

##### Response

|  名称   | 类型  | 说明  |
| ------ | ---- | ----- |
| name  | String |  图空间的名字 |
| description  | String |  图空间的描述信息 |
| cpu_limit  | Int |  CPU 核数上限 |
| memory_limit  | Int |  内存大小上限，单位 GB |
| storage_limit  | Int |  图空间的数据占据的磁盘空间上限 |
| oltp_namespace  | String |  OLTP 的k8s命名空间 |
| olap_namespace  | String |  OLAP 的k8s命名空间 |
| storage_namespace  | String |  存储的k8s命名空间 |
| max_graph_number | Int | 图空间的图数目的上限 |
| max_role_number | Int | 图空间的角色数目的上限 |
| cpu_used  | Int |  已使用的 CPU 核数 |
| memory_used  | Int |  已使用的内存大小，单位 GB |
| storage_used  | Int |  图空间的数据已占据的磁盘空间 |
| graph_number_used | Int | 图空间的图数目 |
| role_number_used | Int | 图空间的角色数目 |
| auth | Boolean | 图空间是否支持权限认证 |

##### 使用示例

###### Method & Url

```
PUT http://127.0.0.1:8080/graphspaces/gs1
```

###### Request Body

```json
{
    "description": "1st graph space",
    "cpu_limit": 2000,
    "memory_limit": 40960,
    "storage_limit": 2048,
    "oltp_namespace": "hugegraph-server",
    "olap_namespace": "hugegraph-server",
    "max_graph_number": 1000,
    "max_role_number": 100
}
```

###### Response Status

```json
200
```

###### Response Body

```json
{
  "name": "gs1",
  "description": "1st graph space",
  "cpu_limit": 1000,
  "memory_limit": 1024,
  "storage_limit": 1000,
  "oltp_namespace": "hugegraph-server",
  "olap_namespace": "hugegraph-server",
  "storage_namespace": "hugegraph-server",
  "max_graph_number": 100,
  "max_role_number": 10,
  "cpu_used": 0,
  "memory_used": 0,
  "storage_used": 0,
  "graph_number_used": 0,
  "role_number_used": 0,
  "auth": true
}
```

#### 4.1.5 删除某个图空间

##### 功能介绍

删除某个图空间

##### URI

```
DELETE /graphspaces/${graphspace}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |

##### Body参数

无

##### Response

无

##### 使用示例

###### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1
```

###### Request Body

无

###### Response Status

```json
204
```

> 注意：删除图空间，会导致图空间的全部资源被释放。
