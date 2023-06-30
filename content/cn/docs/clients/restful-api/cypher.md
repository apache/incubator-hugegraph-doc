---
title: "Cypher API"
linkTitle: "Cypher"
weight: 15
---

### 9.1 Cypher

#### 9.1.1 向HugeGraphServer发送Cypher语句（GET），同步执行

##### Method & Url

```
GET /graphs/{graph}/cypher?cypher={cypher}
```

##### Params
- graph: 图名称
- cypher: cypher语句


##### 使用示例

```
GET http://localhost:8080/graphs/hugecypher1/cypher?cypher=match(n:person) return n.name as name order by n.name limit 1
```

##### Response Status

```json
200
```
##### Response Body

```json
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

```
POST /graphs/{graph}/cypher
```

##### Params
- graph: 图名称

##### Body
{cypher}
- cypher: cypher语句

注意：

> 不是JSON格式，是纯文本的Cypher语句

##### 使用示例

```
POST http://localhost:8080/graphs/hugecypher1/cypher
```

###### Request Body

```json
match(n:person) return n.name as name order by n.name limit 1
```
##### Response Status

```json
200
```
##### Response Body

```json
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