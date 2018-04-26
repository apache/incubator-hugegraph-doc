### 6.1 Other

#### 6.1.1 查看HugeGraph的版本信息

##### Method

```
GET
```

##### Url

```
http://localhost:8080/versions
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "versions": {
        "version": "v1",
        "core": "0.4.5.1",
        "gremlin": "3.2.5",
        "api": "0.13.2.0"
    }
}
```