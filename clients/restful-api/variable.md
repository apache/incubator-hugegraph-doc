### 4.1 Variables

Variables可以用来存储有关整个图的数据，数据按照键值对的方式存取

#### 4.1.1 创建或者更新某个键值对

##### Method

```
PUT
```

##### Url

```
http://localhost:8080/graphs/hugegraph/variables/name
```

##### Request Body

```json
{
  "data":"tom"
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

#### 4.1.2 列出全部键值对

##### Method 

```
GET
```

##### Url

```
http://localhost:8080/graphs/hugegraph/variables
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

#### 4.1.3 列出某个键值对

##### 方法

```
GET
```

##### Url

```
http://localhost:8080/graphs/hugegraph/variables/name
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

#### 4.1.4 删除某个键值对

##### Method

```
DELETE
```

##### Url

```
http://localhost:8080/graphs/hugegraph/variables/name
```

##### Response Status

```json
204
```