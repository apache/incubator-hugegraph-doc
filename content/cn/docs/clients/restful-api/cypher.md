---
title: "Cypher API"
linkTitle: "Cypher"
weight: 15
---

### 9.1 Cypher

> **重要提示**：在使用以下 API 之前，需要先创建图空间（graphspace）。请参考 [Graphspace API](../graphspace) 创建名为 `gs1` 的图空间。文档中的示例均假设已存在名为 `gs1` 的图空间。

#### 9.1.1 向HugeGraphServer发送Cypher语句（GET），同步执行

##### Method & Url

```javascript
GET /graphspaces/{graphspace}/graphs/{graph}/cypher?cypher={cypher}
```

##### Params

**路径参数说明：**

- graphspace: 图空间名称
- graph: 图名称

**请求参数说明：**

- cypher: cypher语句


##### 使用示例

```javascript
GET http://localhost:8080/graphspaces/gs1/graphs/hugecypher1/cypher?cypher=match(n:person) return n.name as name order by n.name limit 1
```

##### Response Status

```javascript
200
```
##### Response Body

```javascript
{
    "requestId": "766b9f48-2f10-40d9-951a-3027d0748ab7",
    "status": {
        "message": "",
        "code": 200,
        "attributes": {
        }
    },
    "result": {
        "data": [
            {
                "name": "hello"
            }
        ],
        "meta": {
        }
    }
}
```

#### 9.1.2 向HugeGraphServer发送Cypher语句（POST），同步执行


##### Method & Url

```javascript
POST /graphspaces/{graphspace}/graphs/{graph}/cypher
```

##### Params

**路径参数说明：**

- graphspace: 图空间名称
- graph: 图名称

##### Body
{cypher}
- cypher: cypher语句

注意：

> 不是JSON格式，是纯文本的Cypher语句

##### 使用示例

```javascript
POST http://localhost:8080/graphspaces/gs1/graphs/hugecypher1/cypher
```

###### Request Body

```cypher
match(n:person) return n.name as name order by n.name limit 1
```
##### Response Status

```javascript
200
```
##### Response Body

```javascript
{
    "requestId": "f096bee0-e249-498f-b5a3-ea684fc84f57",
    "status": {
        "message": "",
        "code": 200,
        "attributes": {
        }
    },
    "result": {
        "data": [
            {
                "name": "hello"
            }
        ],
        "meta": {
        }
    }
}


```
