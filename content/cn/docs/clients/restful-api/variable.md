---
title: "Variable API"
linkTitle: "Variable"
weight: 11
---

### 5.1 Variables

> **重要提示**：在使用以下 API 之前，需要先创建图空间（graphspace）。请参考 [Graphspace API](../graphspace) 创建名为 `gs1` 的图空间。文档中的示例均假设已存在名为 `gs1` 的图空间。

Variables可以用来存储有关整个图的数据，数据按照键值对的方式存取

#### 5.1.1 创建或者更新某个键值对

##### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/variables/name
```

##### Request Body

```json
{
  "data": "tom"
}
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "name": "tom"
}
```

#### 5.1.2 列出全部键值对

##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/variables
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "name": "tom"
}
```

#### 5.1.3 列出某个键值对

##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/variables/name
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "name": "tom"
}
```

#### 5.1.4 删除某个键值对

##### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/graphs/hugegraph/variables/name
```

##### Response Status

```json
204
```