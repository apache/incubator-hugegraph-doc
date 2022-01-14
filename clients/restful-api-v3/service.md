### 11.1 Service

在 HugeGraph 中，在线计算（OLTP）、离线计算（OLAP）和存储都是作为服务（service）存在的。目前仅支持在线计算服务的动态创建。

#### 11.1.1 创建一个服务

##### Method & Url

```
POST http://localhost:8080/graphspaces/gs1/services
```

##### Request Body

```json
{
  "name": "sv1",
  "type": "OLTP",
  "description": "test oltp service",
  "count": 1,
  "cpu_limit": 2,
  "memory_limit": 4,
  "storage_limit": 10,
  "route_type": "NodePort",
  "deployment_type": "K8S"
}
```

其中：
- type 指服务类型，可选值包括：OLTP、OLAP 和 STORAGE，目前仅支持 OLTP
- deployment_type 指部署类型，可选值包括：K8S 和 MANUAL。
    - K8S，指通过K8S集群启动服务
    - MANUAL，指通过手动部署的方式启动服务
- route_type 指服务的路由类型，可选值包括：ClusterIP、NodePort 和 LoadBalancer.
    - ClusterIP，指服务使用 K8S 内部 IP
    - NodePort，指服务使用 K8S 节点的 IP
    - LoadBalancer，指服务使用外部 LoadBalancer 提供的 IP

##### Response Status

```json
201
```

##### Response Body

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
    "storage_limit": 10,
    "route_type": "NodePort",
    "port": 8080,
    "urls": [
        "10.254.222.85:32357"
    ]
}

```

#### 11.1.2 列出某个图空间的所有服务

##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/services
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "services":["sv1"]
}
```

#### 11.1.3 查看某个服务

##### Method & Url

```
GET http://127.0.0.1:8080/graphspaces/gs1/services/sv1
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "name": "sv2",
    "type": "OLTP",
    "deployment_type": "K8S",
    "description": "test oltp service",
    "count": 1,
    "running": 0,
    "cpu_limit": 2,
    "memory_limit": 4,
    "storage_limit": 10,
    "route_type": "NodePort",
    "port": 8080,
    "urls": [
        "10.254.222.85:32357"
    ]
}

```

#### 11.1.4 删除某个服务

##### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/services/sv1?confirm_message=I%27m+sure+to+delete+the+service
```

> 注意：删除图空间，会导致图空间的全部资源被释放。

##### Response Status

```json
204
```
