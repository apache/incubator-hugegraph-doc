## 4.2.服务

在 HugeGraph 中，在线计算（OLTP）、离线计算（OLAP）和存储都是作为服务（service）存在的。目前仅支持在线计算服务的动态创建。

#### 4.2.1.创建一个服务

##### 功能介绍

创建一个服务

##### URI

```
POST /graphspaces/${graphspace}/services
```


##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |

##### Body参数

|  名称            | 是否必填  | 类型    | 默认值  | 取值范围                                                   | 说明            |
|  ----            | ----     | ----    | ----   | ----                                                      | ----            |
| name             | 是       | String  |        | 小写字母、数字和下划线组成，首字符必须是小写字母，长度不超过48  |  service 的名字 |
| type             | 是       | String  |        | OLTP, OLAP, STORAGE                                       | 服务类型         |
| description      | 是       | String  |        |                                                           |  service 的描述信息 |
| count            | 否       | Int     |  1     | > 0                                                       |  HugeGraphServer 的数目 |
| cpu_limit        | 否       | Int     |  1     | > 0                                                       |  HugeGraphServer 的 CPU 核数 |
| memory_limit     | 否       | Int     |  4     | > 0                                                       |  HugeGraphServer 的内存大小，单位 GB |
| storage_limit    | 否       | Int     |  100   | > 0                                                       |  HStore的磁盘大小，单位GB |
| route_type       | 否       | String  |        | ClusterIP, LoadBalancer, NodePort                         | 当deployment_type为K8S时必须填写，反之不可填写 |
| port             | 否       | Int     |        | > 0                                                       | 当deployment_type为MANUAL时必须填写，反之不可填写 |
| urls             | 否       | [String]|        | 字符串数组                                                 | 当deployment_type为MANUAL时必须填写，反之不可填写 |
| deployment_type  | 是       | String  |        | K8S、MANUAL                                               |  service 的部署类型，K8S 指通过K8S集群启动服务，MANUAL 指通过手动部署的方式启动服务 |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| name  | String | service 的名字 |
| type  | String | 服务类型         |
| description  | String |  service 的描述信息 |
| count  | Int |  HugeGraphServer 的总数目 |
| running | Int | 运行的 HugeGraphServer 的数目
| cpu_limit  | Int  |  HugeGraphServer 的 CPU 核数 |
| memory_limit  | Int  |  HugeGraphServer 的内存大小，单位 GB |
| storage_limit | Int  |  HStore的磁盘大小，单位GB |
| route_type    | String  | 路由类型 |
| port          | Int | 服务端口 |
| deployment_type  | String  |  service 的部署类型 |
| urls | Array | service 地址列表 |
| pd_service_id | String | 该服务在pd注册的id信息 |

##### 使用示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/gs1/services
```

###### Request Body

```json
{
  "name": "sv1",
  "type": "OLTP",
  "description": "test oltp service",
  "count": 1,
  "cpu_limit": 2,
  "memory_limit": 4,
  "storage_limit": 16,
  "deployment_type": "K8S",
  "route_type": "LoadBalancer",
  "urls": []
}
```

###### Response Status

```json
201
```

###### Response Body

```json
{
    "name": "sv1",
    "type": "OLTP",
    "deployment_type": "K8S",
    "description": "test oltp service",
    "count": 1,
    "running": 0,
    "cpu_limit": 2,
    "memory_limit": 4,
    "storage_limit": 16,
    "route_type": "LoadBalancer",
    "port": 0,
    "urls": [
        "10.254.222.85:32357"
    ],
    "pd_service_id": "73e32e8a274b9ab8940e068c6242e0fb"
}
```

#### 4.2.2.列出某个图空间的所有服务

##### 功能介绍

列出某个图空间的所有服务

##### URI

```
GET /graphspaces/${graphspace}/services
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| services  |Array| service 的名字列表 |

##### 使用示例


###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/services
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
    "services":["sv1"]
}
```

#### 4.2.3.查看某个服务

##### 功能介绍

查看某个服务

##### URI

```
GET /graphspaces/${graphspace}/services/${service}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| service  | 是 | String  |   |   | 服务名称  |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| name  | String | service 的名字 |
| type  | String | 服务类型         |
| description  | String |  service 的描述信息 |
| count  | Int |  HugeGraphServer 的总数目 |
| running | Int | 运行的 HugeGraphServer 的数目
| cpu_limit  | Int  |  HugeGraphServer 的 CPU 核数 |
| memory_limit  | Int  |  HugeGraphServer 的内存大小，单位 GB |
| storage_limit | Int  |  HStore的磁盘大小，单位GB |
| route_type    | String  | 路由类型 |
| port          | Int | 服务端口 |
| deployment_type  | String  |  service 的部署类型 |
| urls | Array | service 地址列表 |
| pd_service_id | String | 该服务在pd注册的id信息 |

##### 使用示例

###### Method & Url

```
GET http://127.0.0.1:8080/graphspaces/gs1/services/sv1
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
    "name": "sv1",
    "type": "OLTP",
    "deployment_type": "K8S",
    "description": "test oltp service",
    "count": 1,
    "running": 0,
    "cpu_limit": 2,
    "memory_limit": 4,
    "storage_limit": 16,
    "route_type": "LoadBalancer",
    "port": 0,
    "urls": [
        "10.254.222.85:32357"
    ],
    "pd_service_id": "73e32e8a274b9ab8940e068c6242e0fb"
}
```

#### 4.2.4.删除某个服务

##### 功能介绍

删除某个服务

##### URI

```
DELETE /graphspaces/${graphspace}/services/${service}
```


##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |   | 图空间名称  |
| service  | 是 | String  |   |   | 服务名称  |

##### Body参数

无

##### Response

无

##### 使用示例

###### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/services/sv1
```


###### Request Body

无

###### Response Status

```json
204
```

> 注意：删除图空间，会导致图空间的全部资源被释放。
