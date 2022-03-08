## 4.15.其它类

#### 4.15.1.查看HugeGraph的版本信息
 
##### 功能介绍

查看HugeGraph的版本信息

##### URI

```
GET /versions
```

##### URI参数

无

##### Body参数（没有就写无）

无

##### Response（没有就写无）

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| version  |String| API 大类别 |
| core  |String| hugegraph-core 版本号 |
| gremlin  |String| gremlin 版本号 |
| api  |String| API 小类别，具体版本号 |

##### 使用示例

###### Method & Url

```
GET  http://localhost:8080/versions
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
    "versions": {
        "version": "v3",
        "core": "3.0.0",
        "gremlin": "3.4.3",
        "api": "0.68"
    }
}
```
