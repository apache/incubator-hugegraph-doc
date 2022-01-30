## 4.3.图操作
## 4.3.1.图数据
#### 4.3.1.1.创建图

#### 功能介绍

创建一个新图，该操作需要图空间管理员或者超级管理员权限

#### URI

```
POST /graphspaces/${graphspace}/graphs/${graph}
```

#### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |  | 图空间  |
| graph  | 是 | String  |   |  | 图  |

#### Body参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| backend  | 是 | String  |   |  | 存储类型，目前仅支持hstore  |
| serializer  | 是 | String  |   |  | 序列化类型，目前仅支持binary  |
| store  | 是 | String  |   |  | 与图名保持一致  |
| search.text_analyzer  | 否 | String  | jieba  | [word, ansj, hanlp, smartcn, jieba, jcseg, mmseg4j, ikanalyzer] |   |
| search.text_analyzer_mode  | 否 | String  | INDEX  |  |   |

```
search.text_analyzer_mode:

word: [MaximumMatching, ReverseMaximumMatching, MinimumMatching, ReverseMinimumMatching, BidirectionalMaximumMatching, BidirectionalMinimumMatching, BidirectionalMaximumMinimumMatching, FullSegmentation, MinimalWordCount, MaxNgramScore, PureEnglish]
ansj: [BaseAnalysis, IndexAnalysis, ToAnalysis, NlpAnalysis]
hanlp: [standard, nlp, index, nShort, shortest, speed]
smartcn: []
jieba: [SEARCH, INDEX]
jcseg: [Simple, Complex]
mmseg4j: [Simple, Complex, MaxWord]
ikanalyzer: [smart, max_word]
```

#### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| name  | String |  图名 |
| backend  | String |  存储类型 |
| description  | String |  描述 |

#### 使用示例

##### Method & Url

```
POST http://localhost:8080/graphspaces/gs1/graphs/hugegraph
```

##### Request Body

```json
{
  "backend": "hstore",
  "serializer": "binary",
  "store": "hugegraph",
  "search.text_analyzer": "jieba",
  "search.text_analyzer_mode": "INDEX"
}
```

##### Response Status

```json
201
```

##### Response Body

```json
{
  "name": "hugegraph",
  "backend": "hstore",
  "description": ""
}
```

#### 4.4.1.2.列出图空间中全部的图

#### 功能介绍

列出图空间下中全部的图

#### URI

```
GET /graphspaces/${graphspace}/graphs
```

#### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |  | 图空间  |

#### Body参数

无

#### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| graphs  | Array |  图列表 |

#### 使用示例

##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs
```

##### Request Body

无

##### Response Status

```json
200
```

##### Response Body

```json
{
    "graphs": [
        "hugegraph",
        "hg1"
    ]
}
```

#### 4.3.1.3.查看某个图的信息

#### 功能介绍

查看图空间下某个图的信息

#### URI

```
GET /graphspaces/${graphspace}/graphs/${graph}
```

#### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |  | 图空间  |
| graph  | 是 | String  |   |  | 图  |

#### Body参数

无

#### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| name  | String |  图名 |
| backend  | String |  存储类型 |
| description  | String |  描述 |

#### 使用示例

##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph
```

##### Request Body

无

##### Response Status

```json
200
```

##### Response Body

```json
{
  "name": "hugegraph",
  "backend": "hstore",
  "description": ""
}
```

#### 4.3.1.4.清空图数据，包括schema、vertex、edge和index等

#### 功能介绍

清空某个图的全部数据，包括schema、vertex、edge和index等，该操作需要图空间管理员或者超级管理员权限

#### URI

```
PUT /graphspaces/${graphspace}/graphs/${graph}
```

#### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |  | 图空间  |
| graph  | 是 | String  |   |  | 图  |

#### Body参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| action  | 是 | String  |   | clear | 动作  |
| clear_schema  | 是 | Boolean  |   |  | 其中 clear_schema 为 true 时，不仅删除图数据（顶点和边），同时删除元数据（schema）；clear_schema 为 false 时，只删除图数据（顶点和边），保留元数据（schema）|

#### Response

无

#### 使用示例

##### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph
```

##### Request Body

```json
{
  "action": "clear",
  "clear_schema": true
}
```

##### Response Status

```json
200
```

##### Response Body

无

#### 4.3.1.5.删除图

#### 功能介绍

删除某个图，该操作需要图空间管理员权限或者超级管理员权限

#### URI

```
DELETE /graphspaces/${graphspace}/graphs/${graph}
```

#### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |  | 图空间  |
| graph  | 是 | String  |   |  | 图  |

#### Body参数

无

#### Response

无

#### 使用示例

##### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/graphs/hugegraph
```

##### Request Body

无

##### Response Status

```json
204
```

##### Response Body

无

### 4.3.2 图配置

#### 4.3.2.1.查看图的配置

#### 功能介绍

查看某个图的配置，**该操作需要管理员权限**

#### URI

```
GET /graphspaces/${graphspace}/graphs/${graph}/conf
```

#### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |  | 图空间  |
| graph  | 是 | String  |   |  | 图  |

#### Body参数

无

#### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| search.text_analyzer  | String |   |
| search.text_analyzer_mode  | String |   |
| gremlin.graph  | String |   |
| serializer  | String |   |
| backend  | String | 后端存储  |
| store  | String | 图名  |
| pd.peers  | String | pd地址  |

#### 使用示例

##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/conf
```

##### Request Body

无

##### Response Status

```json
200
```

##### Response Body

```json
{
  "search.text_analyzer": "jieba",
  "gremlin.graph": "com.baidu.hugegraph.HugeFactory",
  "search.text_analyzer_mode": "INDEX",
  "serializer": "binary",
  "backend": "hstore",
  "store": "hugegraph1",
  "pd.peers": "127.0.0.1:8686"
}
```

### 4.3.3.图模式

合法的图模式包括：NONE，RESTORING，MERGING，LOADING
    
- None 模式（默认），元数据和图数据的写入属于正常状态。特别的：
    - 元数据（schema）创建时不允许指定 ID
    - 图数据（vertex）在 id strategy 为 Automatic 时，不允许指定 ID
- LOADING：批量导入数据时自动启用，特别的：
    - 添加顶点/边时，不会检查必填属性是否传入

Restore 时存在两种不同的模式： Restoring 和 Merging

- Restoring 模式，恢复到一个新图中，特别的：
    - 元数据（schema）创建时允许指定 ID
    - 图数据（vertex）在 id strategy 为 Automatic 时，允许指定 ID
- Merging 模式，合并到一个已存在元数据和图数据的图中，特别的：
    - 元数据（schema）创建时不允许指定 ID
    - 图数据（vertex）在 id strategy 为 Automatic 时，允许指定 ID

正常情况下，图模式为 None，当需要 Restore 图时，需要根据需要临时修改图模式为 Restoring 模式或者 Merging 模式，并在完成 Restore 时，恢复图模式为 None。


#### 4.3.3.1 查看图模式

#### 功能介绍

查看某个图的模式

#### URI

```
GET /graphspaces/${graphspace}/graphs/${graph}/mode
```

#### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |  | 图空间  |
| graph  | 是 | String  |   |  | 图  |

#### Body参数

无

#### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| mode  | String |  图模式 |

#### 使用示例

##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/mode
```

##### Request Body

无

##### Response Status

```json
200
```

##### Response Body

```json
{
    "mode": "NONE"
}
```

> 合法的图模式包括：NONE，RESTORING，MERGING


#### 4.3.3.2.设置图模式

#### 功能介绍

设置某个图的模式

#### URI

```
PUT /graphspaces/${graphspace}/graphs/${graph}/mode
```

#### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |  | 图空间  |
| graph  | 是 | String  |   |  | 图  |

#### Body参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| NONE 或者 RESTORING 或者 MERGING  | 是 | String  |   |  | 模式  |

#### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| mode  | String |  图模式 |

#### 使用示例

##### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/mode
```

##### Request Body

```
"RESTORING"
```

> 合法的图模式包括：NONE，RESTORING，MERGING

##### Response Status

```json
200
```

##### Response Body

```json
{
    "mode": "RESTORING"
}
```

### 4.3.4.图的读模式（Graph Read Mode）

合法的图的读模式包括：OLTP_ONLY, ALL
    
- OLTP 模式（默认），图的查询结果只包含OLTP类型的属性，不包含OLAP属性
- ALL 模式，图的查询结果既包含OLTP类型的属性，又包含OLAP属性（如果有）

#### 4.3.4.1.查看图的读模式

#### 功能介绍

查看图的读模式

#### URI

```
GET /graphspaces/${graphspace}/graphs/${graph}/graph_read_mode
```

#### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |  | 图空间  |
| graph  | 是 | String  |   |  | 图  |

#### Body参数

无

#### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| graph_read_mode  | String |  图模式 |

#### 使用示例

##### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/graphs/hugegraph/graph_read_mode
```

##### Request Body

无

##### Response Status

```json
200
```

##### Response Body

```json
{
    "graph_read_mode": "OLTP_ONLY"
}
```

#### 4.3.4.2.设置图的读模式

#### 功能介绍

设置某个图的读模式. **该操作需要管理员权限**

#### URI

```
PUT /graphspaces/${graphspace}/graphs/${graph}/graph_read_mode
```

#### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| graphspace  | 是 | String  |   |  | 图空间  |
| graph  | 是 | String  |   |  | 图  |

#### Body参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| ALL 或者 OLTP_ONLY  | 是 | String  |   |  | 合法的图模式包括：OLTP_ONLY，ALL  |

#### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| graph_read_mode  | String |  图模式 |

#### 使用示例

##### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/graphs/hugegraph/graph_read_mode
```

##### Request Body

```
"ALL"
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "graph_read_mode": "ALL"
}
```
