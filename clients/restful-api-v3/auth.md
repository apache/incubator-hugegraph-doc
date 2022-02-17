## 4.12.用户&权限

> 开启权限及相关配置请先参考 [权限配置](../../config/config-authentication-v3.md) 文档

### 4.12.1.用户认证与权限控制概述：
HugeGraph支持多用户认证、以及细粒度的权限访问控制，采用基于“用户-用户组-操作-资源”的4层设计，灵活控制用户角色与权限。 
资源描述了图数据库中的数据，比如符合某一类条件的顶点，每一个资源包括type、label、properties三个要素，共有18种type、
任意label、任意properties的组合形成的资源，一个资源的内部条件是且关系，多个资源之间的条件是或关系。用户可以属于一个或多个用户组，
每个用户组可以拥有对任意个资源的操作权限，操作类型包括：读、写、删除、执行等种类。 HugeGraph支持动态创建用户、用户组、资源，
支持动态分配或取消权限。初始化数据库时超级管理员用户被创建，后续可通过超级管理员创建各类角色用户，新创建的用户如果被分配足够权限后，可以由其创建或管理更多的用户。

##### 举例说明：
user(name=tester) -belong-> group(name=all) -access(read)-> target(graphspace=gs1, graph=graph1, resource={label: person,
city: Beijing})  
描述：用户'tester'拥有对'gs1'图空间中graph1'图中北京人的读权限。

##### 接口说明：
用户认证与权限控制接口包括5类：UserAPI、GroupAPI、TargetAPI、BelongAPI、AccessAPI。

### 4.12.2.用户（User）API
用户接口包括：创建用户（需要超级管理员admin权限），删除用户（需要超级管理员admin权限），修改用户（需要超级管理员admin权限或用户自己），和查询用户相关信息接口。

#### 4.12.2.1.创建用户

##### 功能介绍

创建用户

##### URI

```
POST /auth/users
```

##### URI参数

无

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| user_name  | 是 | String  |   | 长度5-16个字符，可以为字母（区分大小写）、数字、下划线 | 用户名称  |
| user_password  | 是 | String  |   | 长度5-16个字符，可以为字母、数字和特殊符号，其中特殊符号：~!@#$%^&*()_+<>,.?/:;'`"\[\]{}\\  | 用户密码  |
| user_phone  | 否 | String  |   |   | 用户手机  |
| user_email  | 否 | String  |   |   |  用户邮箱 |

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| id  | String | 用户ID  |
| user_name  | String | 用户名称  |
| user_password  | String | 用户密码（密文）  |
| user_phone  | String | 用户手机（脱敏后）  |
| user_email  | String | 用户邮箱  |
| user_creator  | String | 创建者  |
| user_create  | String | 创建时间  |
| user_update  | String | 更新时间  |

##### 使用示例

###### Method & Url

```
POST http://localhost:8080/auth/users
```

###### Request Body

```json
{
  "user_name": "tester",
  "user_password": "password1",
  "user_phone": "182****9088",
  "user_email": "123@xx.com"
}
```

###### Response Status

```json
201
```

###### Response Body

```json
{
  "user_password": "$2a$04$GlhAj4yVVrvXunC5eVVBfOOG1dtHTKu4K5q.AFBQ0mZpg5mZIwTC.",
  "user_email": "123@xx.com",
  "user_update": "2021-12-06 18:47:45",
  "user_name": "tester",
  "user_creator": "admin",
  "user_phone": "182****9088",
  "id": "tester",
  "user_create": "2021-12-06 18:47:45"
}
```

#### 4.12.2.2.删除用户

##### 功能介绍

删除用户

##### URI

```
DELETE /auth/users/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| id  | 是 | String  |   |  | 用户ID  |

##### Body参数

无

##### Response

无


##### 使用示例

###### Method & Url

```
DELETE http://localhost:8080/auth/users/tester
```

###### Request Body

无

###### Response Status

```json
204
```

###### Response Body

无

#### 4.12.2.3.修改用户

##### 功能介绍

修改用户

##### URI

```
PUT /auth/users/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| id  | 是 | String  |   |  | 用户ID  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| user_name  | 是 | String  |   |  | 用户名称，不可修改  |
| user_password  | 是 | String  |   | 长度5-16个字符，可以为字母、数字和特殊符号，其中特殊符号：~!@#$%^&*()_+<>,.?/:;'`"\[\]{}\\  | 用户密码  |
| user_phone  | 否 | String  |   |   | 用户手机  |
| user_email  | 否 | String  |   |   |  用户邮箱 |

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| id  | String | 用户ID  |
| user_name  | String | 用户名称  |
| user_password  | String | 用户密码（密文）  |
| user_phone  | String | 用户手机（脱敏后）  |
| user_email  | String | 用户邮箱  |
| user_creator  | String | 创建者  |
| user_create  | String | 创建时间  |
| user_update  | String | 更新时间  |

##### 使用示例

###### Method & Url

```
PUT http://localhost:8080/auth/users/tester
```

###### Request Body

```json
{
  "user_name": "tester",
  "user_password": "password2",
  "user_phone": "183****9266"
}
```

###### Response Status

```json
200
```

###### Response Body

```json
{
  "user_password": "$2a$04$FrFCRuHZUcPMR8qqxmKHdOlmEcHKkPgQVDdOI1rP8NhbK4pRAwvXG",
  "user_email": "123@xx.com",
  "user_update": "2021-12-06 18:48:45",
  "user_name": "tester",
  "user_creator": "admin",
  "user_phone": "183****9266",
  "id": "tester",
  "user_create": "2021-12-06 18:47:45"
}
```

#### 4.12.2.4.查询用户列表

##### 功能介绍

查询用户

##### URI

```
GET /auth/users?limit=100
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| limit  | 否 | Long  |   |  | 限制返回结果数量  |

##### Body参数

无

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| users  | Array |   |

表1 users对象

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| id  | String | 用户ID  |
| user_name  | String | 用户名称  |
| user_password  | String | 用户密码（密文）  |
| user_phone  | String | 用户手机（脱敏后）  |
| user_email  | String | 用户邮箱  |
| user_creator  | String | 创建者  |
| user_create  | String | 创建时间  |
| user_update  | String | 更新时间  |

失败响应状态以及参数具体见实际返回内容

##### 使用示例

###### Method & Url

```
GET http://localhost:8080/auth/users?limit=100
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
  "users": [
    {
      "user_avatar": "user/as/image.png",
      "user_password": "$2a$04$3gKUvlO51o4o/YfuUkknNOINaLlZqd454ZjU4sQ4r.y1FqT7HyUu6",
      "user_email": "admin@baidu.com",
      "user_update": "2021-10-25 19:50:50",
      "user_name": "admin",
      "user_creator": "system",
      "user_phone": "23423525",
      "id": "admin",
      "user_create": "2021-10-25 19:50:50"
    },
    {
      "user_password": "$2a$04$FrFCRuHZUcPMR8qqxmKHdOlmEcHKkPgQVDdOI1rP8NhbK4pRAwvXG",
      "user_email": "123@xx.com",
      "user_update": "2021-12-06 18:48:45",
      "user_name": "tester",
      "user_creator": "admin",
      "user_phone": "183****9266",
      "id": "tester",
      "user_create": "2021-12-06 18:47:45"
    }
  ]
}
```

#### 4.12.2.5.查询某个用户

##### 功能介绍

查询具体用户

##### URI

```
GET /auth/users/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| id  | 是 | String  |   |  | 用户ID  |

##### Body参数

无

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| id  | String | 用户ID  |
| user_name  | String | 用户名称  |
| user_password  | String | 用户密码（密文）  |
| user_phone  | String | 用户手机（脱敏后）  |
| user_email  | String | 用户邮箱  |
| user_creator  | String | 创建者  |
| user_create  | String | 创建时间  |
| user_update  | String | 更新时间  |

##### 使用示例

###### Method & Url

```
GET http://localhost:8080/auth/users/tester
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
  "user_password": "$2a$04$FrFCRuHZUcPMR8qqxmKHdOlmEcHKkPgQVDdOI1rP8NhbK4pRAwvXG",
  "user_email": "123@xx.com",
  "user_update": "2021-12-06 18:48:45",
  "user_name": "tester",
  "user_creator": "admin",
  "user_phone": "183****9266",
  "id": "tester",
  "user_create": "2021-12-06 18:47:45"
}
```

#### 4.12.2.6.查询某个用户的角色

##### 功能介绍

查询具体角色信息

##### URI

```
GET /auth/users/${id}/role
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| id  | 是 | String  |   |  | 用户ID  |

##### Body参数

无

##### Response

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| roles  | Object |   |

表1 roles对象

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| graphspace  | Object |   |

表2 graphspace对象

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| graph  | Object |   |

表3 graph对象

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| permission  | Array |   |

表4 permission对象

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| type  | String |   |
| label  | String |   |
| properties  | Array |   |

表5 properties对象

|  名称   | 类型  |  说明  |
|  ----  | ----  | ----  |
| key  | String |   |

##### 使用示例

###### Method & Url

```
GET http://localhost:8080/auth/users/tester/role
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
  "roles": {
    "gs1": {
      "hugegraph": {
        "READ": [
          {
            "type": "ALL",
            "label": "*",
            "properties": null
          }
        ]
      }
    }
  }
}
```

### 4.12.3.用户组（Group）API
用户组会赋予相应的资源权限，用户会被分配不同的用户组，即可拥有不同的资源权限。  
用户组接口包括：创建用户组，删除用户组，修改用户组，和查询用户组相关信息接口。

注意：需要图空间管理员或者超级管理员权限

#### 4.12.3.1.创建用户组

##### 功能介绍

在指定图空间下创建用户组

##### URI

```
POST /graphspaces/${graphspace}/auth/groups
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| graphspace  | 是 | String  |   |   | 图空间名称  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| group_name | 是 | String  |   |   | 用户组名称  |
| group_description | 否 | String  |   |   | 用户组描述  |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| id  |String| 用户组ID |
| group_name |String| 用户组名称 |
| graphspace |String| 图空间 |
| group_creator |String| 创建者 |
| group_create |String| 创建时间 |
| group_update |String| 更新时间 |
| group_description |String| 描述 |

##### 使用示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/gs1/auth/groups
```

###### Request Body

```json
{
    "group_name": "all",
    "group_description": "group can do anything"
}
```

###### Response Status

```json
201 
```

###### Response Body

```json
{
  "group_creator": "admin",
  "group_name": "all",
  "group_create": "2021-12-06 18:56:32",
  "graphspace": "gs1",
  "group_update": "2021-12-06 18:56:32",
  "id": "all",
  "group_description": "group can do anything"
}
```

#### 4.12.3.2.删除用户组

##### 功能介绍

删除指定图空间下用户组

##### URI

```
DELETE /graphspaces/${graphspace}/auth/groups/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   | 图空间  |
|  id | 是 | String  |   |   | 用户组ID  |

##### Body参数

无

##### Response

无

##### 使用示例

###### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/auth/groups/all
```

###### Request Body

无

###### Response Status

```json
204
```

###### Response Body

无


#### 4.12.3.3.修改用户组

##### 功能介绍

修改指定图空间下用户组

##### URI

```
PUT /graphspaces/{graphspace}/auth/groups/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   | 图空间  |
|  id | 是 | String  |   |   | 用户组ID  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| group_name | 是 | String  |   |   | 用户组名称  |
| group_description | 否 | String  |   |   | 用户组描述  |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| id  |String| 用户组ID |
| group_name |String| 用户组名称 |
| graphspace |String| 图空间 |
| group_creator |String| 创建者 |
| group_create |String| 创建时间 |
| group_update |String| 更新时间 |
| group_description |String| 描述 |


##### 使用示例

###### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/auth/groups/all
```

###### Request Body

```json
{
  "group_name": "all",
  "group_description": "modify description"
}
```

###### Response Status

```json
200
```

###### Response Body

```json
{
  "group_creator": "admin",
  "group_name": "all",
  "group_create": "2021-12-06 18:58:36",
  "graphspace": "gs1",
  "group_update": "2021-12-06 18:59:12",
  "id": "all",
  "group_description": "modify description"
}
```

#### 4.12.3.4.查询用户组列表

##### 功能介绍

查询指定图空间所有用户组列表信息

##### URI

```
GET /graphspaces/${graphspace}/auth/groups?limit=100
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   | 图空间  |
|  limit | 否 | Long  |   |   | 返回结果数量限制  |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
|  groups | Array | 用户组列表 |

表1 groups对象

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| id  |String| 用户组ID |
| group_name |String| 用户组名称 |
| graphspace |String| 图空间 |
| group_creator |String| 创建者 |
| group_create |String| 创建时间 |
| group_update |String| 更新时间 |
| group_description |String| 描述 |


##### 使用示例

###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/auth/groups
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
  "groups": [
    {
      "group_creator": "admin",
      "group_name": "all",
      "group_create": "2021-12-06 18:58:36",
      "graphspace": "gs1",
      "group_update": "2021-12-06 18:59:12",
      "id": "all",
      "group_description": "modify description"
    }
  ]
}
```

#### 4.12.3.5.查询某个用户组

##### 功能介绍

查询指定图空间下特定用户组信息

##### URI

```
GET /graphspaces/${graphspace}/auth/groups/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   | 图空间  |
|  id | 是 | String  |   |   | 用户组ID  |


##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| id  |String| 用户组ID |
| group_name |String| 用户组名称 |
| graphspace |String| 图空间 |
| group_creator |String| 创建者 |
| group_create |String| 创建时间 |
| group_update |String| 更新时间 |
| group_description |String| 描述 |


##### 使用示例

###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/auth/groups/all
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
  "group_creator": "admin",
  "group_name": "all",
  "group_create": "2021-12-06 18:58:36",
  "graphspace": "gs1",
  "group_update": "2021-12-06 18:59:12",
  "id": "all",
  "group_description": "modify description"
}
```

### 4.12.4.资源（Target）API
资源描述了图数据库中的数据，比如符合某一类条件的顶点，每一个资源包括type、label、properties三个要素，共有18种type、
任意label、任意properties的组合形成的资源，一个资源的内部条件是且关系，多个资源之间的条件是或关系。   
资源接口包括：资源的创建、删除、修改和查询。

注意：需要图空间管理员或者超级管理员权限

#### 4.12.4.1.创建资源

##### 功能介绍

在指定图空间下创建资源

##### URI

```
POST /graphspaces/${graphspace}/auth/targets
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| graphspace | 是 | String  |   |   | 图空间  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  target_name | 是 | String  |   |   |  资源名称 |
|  target_graph | 是 | String  |   |   |  资源图 |
|  target_resources | 是 | Array  |   |   |  资源定义(列表) |

表1 target_resource对象

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  type | 否 | String  |   | VERTEX, EDGE等, 可填ALL，则表示可以是顶点或边  |  类型 |
|  label | 否 | String  |   |   |  ⼀个顶点或边类型的名称，可填*，则表示任意类型 |
|  properties | 否 | Map  |   |   |  可包含多个属性的键值对，必须匹配所有属性值，属性值⽀持填条件范围（age:P.gte(18)），properties如果为null表示任意属性均可，如果属性名和属性值均为‘*ʼ也表示任意属性均可 |

如精细资源："target_resources": [{"type":"VERTEX","label":"person","properties":{"city":"Beijing","age":"P.gte(20)"}}]**  
资源定义含义：类型是'person'的顶点，且城市属性是'Beijing'，年龄属性大于等于20。

type取值范围如下：
```
enum ResourceType { NONE STATUS, VERTEX, EDGE, VERTEX_AGGR, EDGE_AGGR, VAR, GREMLIN, TASK, PROPERTY_KEY, VERTEX_LABEL, EDGE_LABEL, INDEX_LABEL, SCHEMA, META, ALL, GRANT, USER_GROUP, PROJECT, TARGET, METRICS, ROOT }
```

这些类型按照影响的范围是基本有序的，范围从小到大。比如：NONE 是最低级别，表示没有资源；ALL 属于比较高的级别，表示所有的图数据（顶点和边）和元数据（schema）；ROOT是最高级别，表示根资源。另外有一些“综合性“的类型，比如：
- SCHEMA，表示全部元数据，即PROPERTY_KEY、VERTEX_LABEL、EDGELABEL 和 INDEXLABEL
- ALL，表示全部图数据和元数据，即VERTEX、EDGE 和 SCHEMA等
- ROOT，表示根，包括ALL相关的资源

注：根据访问资源的依赖属性，选择合适的类型值。 例如：

在查询一个 VERTEX 的时候，这个过程中，任何涉及到的 VertexLabel、INDEXLABEL 和 PROPERTY_KEY，都必须有读权限。 在比如查询USER的时候，应该对 VERTEX、VertexLabel、INDEXLABEL 和 PROPERTY_KEY 都有读权限才行。

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| id  |String| 资源ID |
| target_name  |String| 资源名称 |
| graphspace  |String| 图空间 |
| target_graph  |String| 图 |
| target_creator  |String| 创建者 |
| target_create  |String| 创建时间 |
| target_update  |String| 更新时间 |
| target_resources  |Array| 资源 |

表1 target_resource对象

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| type  |String| 资源ID |
| label  |String| label标签 |
| properties  |Map| 资源属性键对值 |

##### 使用示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/gs1/auth/targets
```

###### Request Body

```json
{
  "target_name":"all_targets",
  "target_graph": "hugegraph",
  "target_url": "127.0.0.1:8080",
  "target_resources": [
    {
      "type": "ALL"
    }
  ]
}
```

###### Response Status

```json
201 
```

###### Response Body

```json
{
  "target_creator": "admin",
  "target_name": "all_targets",
  "graphspace": "gs1",
  "target_graph": "hugegraph",
  "target_create": "2021-12-06 19:45:28",
  "target_resources": [
    {
      "type": "ALL",
      "label": "*",
      "properties": null
    }
  ],
  "id": "all_targets",
  "target_update": "2021-12-06 19:45:28"
}
```

#### 4.12.4.2.删除资源

##### 功能介绍

删除指定图空间下资源

##### URI

```
DELETE /graphspaces/${graphspace}/auth/targets/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| graphspace  | 是 | String  |   |   | 图空间  |
| id  | 是 | String  |   |   | 资源ID  |

##### Body参数

无

##### Response

无


##### 使用示例

###### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/auth/targets/all_targets
```

###### Request Body

无

###### Response Status

```json
204
```

###### Response Body

无

#### 4.12.4.3.修改资源

##### 功能介绍

修改指定图空间下资源信息

##### URI

```
PUT /graphspaces/${graphspace}/auth/targets/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| graphspace  | 是 | String  |   |   | 图空间  |
| id  | 是 | String  |   |   | 资源ID  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  target_name | 是 | String  |   |   |  资源名称 |
|  target_graph | 是 | String  |   |   |  资源图 |
|  target_resources | 是 | Array  |   |   |  资源定义(列表) |

表1 target_resource对象

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  type | 否 | String  |   | VERTEX, EDGE等, 可填ALL，则表示可以是顶点或边  |  类型 |
|  label | 否 | String  |   |   |  ⼀个顶点或边类型的名称，可填*，则表示任意类型 |
|  properties | 否 | Map  |   |   |  可包含多个属性的键值对，必须匹配所有属性值，属性值⽀持填条件范围（age:P.gte(18)），properties如果为null表示任意属性均可，如果属性名和属性值均为‘*ʼ也表示任意属性均可 |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| id  |String| 资源ID |
| target_name  |String| 资源名称 |
| graphspace  |String| 图空间 |
| target_graph  |String| 图 |
| target_creator  |String| 创建者 |
| target_create  |String| 创建时间 |
| target_update  |String| 更新时间 |
| target_resources  |Array| 资源 |

表1 target_resource对象

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| type  |String| 资源ID |
| label  |String| label标签 |
| properties  |Map| 资源属性键对值 |


##### 使用示例

###### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/auth/targets/all_targets
```

###### Request Body

```json
{
  "target_name":"all_targets",
  "target_graph": "hugegraph",
  "target_resources": [
    {
      "type": "NONE"
    }
  ]
}
```

###### Response Status

```json
200
```

###### Response Body

```json
{
  "target_creator": "admin",
  "target_name": "all_targets",
  "graphspace": "gs1",
  "target_graph": "hugegraph",
  "target_create": "2021-12-06 19:45:28",
  "target_resources": [
    {
      "type": "NONE",
      "label": "*",
      "properties": null
    }
  ],
  "id": "all_targets",
  "target_update": "2021-12-06 19:47:03"
}
```

#### 4.12.4.4.查询资源列表

##### 功能介绍

查询指定图空间下资源列表

##### URI

```
GET /graphspaces/${graphspace}/auth/targets?limit=100
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   |  图空间 |
|  limit | 否 | Long  |   |   |  返回结果数量限制 |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
|  targets |Array| 资源列表 |

表1 target对象

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| id  |String| 资源ID |
| target_name  |String| 资源名称 |
| graphspace  |String| 图空间 |
| target_graph  |String| 图 |
| target_creator  |String| 创建者 |
| target_create  |String| 创建时间 |
| target_update  |String| 更新时间 |
| target_resources  |Array| 资源 |

表2 target_resource对象

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| type  |String| 资源ID |
| label  |String| label标签 |
| properties  |Map| 资源属性键对值 |

##### 使用示例

###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/auth/targets
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
  "targets": [
    {
      "target_creator": "admin",
      "target_name": "all_targets",
      "graphspace": "gs1",
      "target_graph": "hugegraph",
      "target_create": "2021-12-06 19:45:28",
      "target_resources": [
        {
          "type": "NONE",
          "label": "*",
          "properties": null
        }
      ],
      "id": "all_targets",
      "target_update": "2021-12-06 19:47:03"
    }
  ]
}
```

#### 4.12.4.5.查询某个资源

##### 功能介绍

查询指定图空间下特定资源信息

##### URI

```
GET /graphspaces/${graphspace}/auth/targets/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| graphspace  | 是 | String  |   |   |  图空间 |
| id  | 是 | String  |   |   |  资源ID |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| id  |String| 资源ID |
| target_name  |String| 资源名称 |
| graphspace  |String| 图空间 |
| target_graph  |String| 图 |
| target_creator  |String| 创建者 |
| target_create  |String| 创建时间 |
| target_update  |String| 更新时间 |
| target_resources  |Array| 资源 |

表2 target_resource对象

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| type  |String| 资源ID |
| label  |String| label标签 |
| properties  |Map| 资源属性键对值 |


##### 使用示例

###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/auth/targets/all_targets
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
  "target_creator": "admin",
  "target_name": "all_targets",
  "graphspace": "gs1",
  "target_graph": "hugegraph",
  "target_create": "2021-12-06 19:45:28",
  "target_resources": [
    {
      "type": "NONE",
      "label": "*",
      "properties": null
    }
  ],
  "id": "all_targets",
  "target_update": "2021-12-06 19:47:03"
}
```

### 4.12.5.关联角色（Belong）API
关联用户和用户组的关系，一个用户可以关联一个或者多个用户组。用户组拥有相关资源的权限，不同用户组的资源权限可以理解为不同的角色。即给用户关联角色。  
关联角色接口包括：用户关联角色的创建、删除、修改和查询。

注意：需要图空间管理员或者超级管理员权限

#### 4.12.5.1.创建用户的关联角色

##### 功能介绍

创建用户关联角色

##### URI

```
POST /graphspaces/${graphspace}/auth/belongs
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| graphspace  | 是 | String  |   |   |  图空间 |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| user  | 是 | String  |   |   |  用户ID |
| group  | 是 | String  |   |   |  用户组ID |
| belong_description  | 是 | String  |   |   |  描述 |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
|  id |String| 关联角色ID |
|  graphspace |String| 图空间 |
|  user |String| 用户 |
|  group |String| 用户组 |
|  belong_creator |String| 创建者 |
|  belong_create |String| 创建时间 |
|  belong_update |String| 更新时间 |
|  belong_description |String| 描述 |

##### 使用示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/gs1/auth/belongs
```

###### Request Body

```json
{
  "user": "tester",
  "group": "all",
  "belong_description": "none description"
}
```

###### Response Status

```json
201 
```

###### Response Body

```json
{
  "belong_description": "none description",
  "belong_create": "2021-12-06 19:51:14",
  "belong_creator": "admin",
  "graphspace": "gs1",
  "belong_update": "2021-12-06 19:51:14",
  "id": "tester->all",
  "user": "tester",
  "group": "all"
}
```

#### 4.12.5.2.删除关联角色

##### 功能介绍

删除指定图空间下的关联角色

##### URI

```
DELETE /graphspaces/${graphspace}/auth/belongs/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| graphspace  | 是 | String  |   |   |  图空间 |
| id  | 是 | String  |   |   |  关联角色ID |

##### Body参数

无

##### Response

无


##### 使用示例

###### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/auth/belongs/tester->all
```

###### Request Body

无

###### Response Status

```json
204
```

###### Response Body

无

#### 4.12.5.3.修改关联角色

##### 功能介绍

修改指定图空间下关联角色，关联角色只能修改描述，不能修改 user 和 group 属性，如果需要修改关联角色，需要删除原来关联关系，新增关联角色。

##### URI

```
PUT /graphspaces/${graphspace}/auth/belongs/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   | 图空间  |
|  id | 是 | String  |   |   | 关联角色ID  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| belong_description  | 是 | String  |   |   |  描述 |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
|  id |String| 关联角色ID |
|  graphspace |String| 图空间 |
|  user |String| 用户 |
|  group |String| 用户组 |
|  belong_creator |String| 创建者 |
|  belong_create |String| 创建时间 |
|  belong_update |String| 更新时间 |
|  belong_description |String| 描述 |

##### 使用示例

###### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/auth/belongs/tester->all
```

###### Request Body

```json
{
  "belong_description": "modify description"
}
```

###### Response Status

```json
200
```

###### Response Body

```json
{
  "belong_description": "modify description",
  "belong_create": "2021-12-06 19:51:14",
  "belong_creator": "admin",
  "graphspace": "gs1",
  "belong_update": "2021-12-07 09:58:56",
  "id": "tester->all",
  "user": "tester",
  "group": "all"
}
```

#### 4.12.5.4.查询关联角色列表

##### 功能介绍

查询指定图空间下关联角色列表

##### URI

```
GET /graphspaces/${graphspace}/auth/belongs?limit=100
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   | 图空间  |
|  limit | 否 | Long  |   |   | 返回结果数量限制  |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| belongs  |Array| 关联角色列表 |

表1 belong对象

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
|  id |String| 关联角色ID |
|  graphspace |String| 图空间 |
|  user |String| 用户 |
|  group |String| 用户组 |
|  belong_creator |String| 创建者 |
|  belong_create |String| 创建时间 |
|  belong_update |String| 更新时间 |
|  belong_description |String| 描述 |

##### 使用示例

###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/auth/belongs
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
  "belongs": [
    {
      "belong_description": "modify description",
      "belong_create": "2021-12-06 19:51:14",
      "belong_creator": "admin",
      "graphspace": "gs1",
      "belong_update": "2021-12-07 09:58:56",
      "id": "tester->all",
      "user": "tester",
      "group": "all"
    }
  ]
}
```

#### 4.12.5.5.查看某个关联角色

##### 功能介绍

查看指定图空间下某个关联角色信息

##### URI

```
GET /graphspaces/${graphspace}/auth/belongs/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   |  图空间 |
|  id | 是 | String  |   |   |  关联角色ID |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
|  id |String| 关联角色ID |
|  graphspace |String| 图空间 |
|  user |String| 用户 |
|  group |String| 用户组 |
|  belong_creator |String| 创建者 |
|  belong_create |String| 创建时间 |
|  belong_update |String| 更新时间 |
|  belong_description |String| 描述 |


##### 使用示例

###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/auth/belongs/tester->all
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
  "belong_description": "modify description",
  "belong_create": "2021-12-06 19:51:14",
  "belong_creator": "admin",
  "graphspace": "gs1",
  "belong_update": "2021-12-07 09:58:56",
  "id": "tester->all",
  "user": "tester",
  "group": "all"
}
```

### 4.12.6.赋权（Access）API
给用户组赋予资源的权限，主要包含：读操作(READ)、写操作(WRITE)、删除操作(DELETE)、执行操作(EXECUTE)、图空间管理(SPACE)、运维管理(OP)等。  
赋权接口包括：赋权的创建、删除、修改和查询。

注意：需要图空间管理员或者超级管理员权限

#### 4.12.6.1.创建赋权(用户组赋予资源的权限)

##### 功能介绍

在指定图空间下创建赋权

##### URI

```
POST /graphspaces/${graphspace}/auth/accesses
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| graphspace  | 是 | String  |   |   |  图空间 |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  group | 是 | String  |   |   | 用户组ID  |
|  target | 是 | String  |   |   | 资源ID  |
|  access_permission | 是 | String  |   |   | 权限许可  |
|  access_description | 是 | String  |   |   | 赋权描述  |

access_permission：
- READ：读操作，所有的查询，包括查询Schema、查顶点/边，查询顶点和边的数量VERTEX_AGGR/EDGE_AGGR，也包括读图的状态STATUS、变量VAR、任务TASK等；
- WRITE：写操作，所有的创建、更新操作，包括给Schema增加property key，给顶点增加或更新属性等；
- DELETE：删除操作，包括删除元数据、删除顶点/边；
- EXECUTE：执⾏操作，包括执⾏Gremlin语句、执⾏Task、执⾏metadata函数；
- SPACE：图空间权限，包括动态管理图（增删改查）、图空间权限管理等；
- OP：运维管理权限，可以设置图空间运维管理员和全局运维管理员；

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| id  |String| 赋权ID |
|  graphspace |String| 图空间 |
|  group |String| 用户组 |
|  target |String| 资源 |
|  access_permission |String| 权限 |
|  access_creator |String| 创建者 |
|  access_create |String| 创建时间 |
|  access_update |String| 更新时间 |

##### 使用示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/gs1/auth/accesses
```

###### Request Body

```json
{
  "group": "all",
  "target": "all_targets",
  "access_permission": "READ"
}
```

###### Response Status

```json
201 
```

###### Response Body

```json
{
  "access_permission": "READ",
  "graphspace": "gs1",
  "access_create": "2021-12-07 10:08:44",
  "id": "all->1->all_targets",
  "access_update": "2021-12-07 10:08:44",
  "access_creator": "admin",
  "group": "all",
  "target": "all_targets"
}
```

#### 4.12.6.2.删除赋权

##### 功能介绍

删除指定图空间下赋权

##### URI

```
DELETE /graphspaces/${graphspace}/auth/accesses/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| graphspace  | 是 | String  |   |   |  图空间 |
| id  | 是 | String  |   |   |  赋权ID |

##### Body参数

无

##### Response

无


##### 使用示例

###### Method & Url

```
DELETE http://localhost:8080/graphspaces/gs1/auth/accesses/all->1->all_targets
```

###### Request Body

无

###### Response Status

```json
204
```

###### Response Body

无

#### 4.12.6.3.修改赋权

##### 功能介绍

修改指定图空间下赋权信息，赋权只能修改描述，不能修改用户组、资源和权限许可，如果需要修改赋权的关系，可以删除原来的赋权关系，新增赋权。

##### URI

```
PUT /graphspaces/${graphspace}/auth/accesses/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   |  图空间 |
|  id | 是 | String  |   |   |  赋权ID |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  access_description | 是 | String  |   |   | 描述  |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| id  |String| 赋权ID |
|  graphspace |String| 图空间 |
|  group |String| 用户组 |
|  target |String| 资源 |
|  access_permission |String| 权限 |
|  access_creator |String| 创建者 |
|  access_create |String| 创建时间 |
|  access_update |String| 更新时间 |

##### 使用示例

###### Method & Url

```
PUT http://localhost:8080/graphspaces/gs1/auth/accesses/all->1->all_targets
```

###### Request Body

```json
{
  "access_description": "update"
}
```

###### Response Status

```json
200
```

###### Response Body

```json
{
  "access_description": "update",
  "access_permission": "READ",
  "graphspace": "DEFAULT",
  "access_create": "2021-12-07 10:08:44",
  "id": "all->1->all_targets",
  "access_update": "2021-12-07 10:10:48",
  "access_creator": "admin",
  "group": "all",
  "target": "all_targets"
}
```

#### 4.12.6.4.查询赋权列表

##### 功能介绍

查询指定图空间下赋权列表

##### URI

```
GET /graphspaces/${graphspace}/auth/accesses?limit=100
```

##### URI参数

无

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| graphspace  | 是 | String  |   |   | 图空间  |
| limit  | 否 | Long  |   |   | 返回结果限制数量  |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
|  accesses |Array| 赋权列表 |

表1 access对象

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| id  |String| 赋权ID |
|  graphspace |String| 图空间 |
|  group |String| 用户组 |
|  target |String| 资源 |
|  access_permission |String| 权限 |
|  access_creator |String| 创建者 |
|  access_create |String| 创建时间 |
|  access_update |String| 更新时间 |

##### 使用示例

###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/auth/accesses
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
  "accesses": [
    {
      "access_description": "update",
      "access_permission": "READ",
      "graphspace": "gs1",
      "access_create": "2021-12-07 10:08:44",
      "id": "all->1->all_targets",
      "access_update": "2021-12-07 10:10:48",
      "access_creator": "admin",
      "group": "all",
      "target": "all_targets"
    }
  ]
}
```

#### 4.12.6.5.查询某个赋权

##### 功能介绍

查询指定图空间下某个赋权信息

##### URI

```
GET /graphspaces/${graphspace}/auth/accesses/${id}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| graphspace  | 是 | String  |   |   | 图空间  |
| id  | 是 | String  |   |   | 赋权ID  |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| id  |String| 赋权ID |
|  graphspace |String| 图空间 |
|  group |String| 用户组 |
|  target |String| 资源 |
|  access_permission |String| 权限 |
|  access_creator |String| 创建者 |
|  access_create |String| 创建时间 |
|  access_update |String| 更新时间 |

##### 使用示例

###### Method & Url

```
GET http://localhost:8080/graphspaces/gs1/auth/accesses/all->1->all_targets
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
  "access_description": "update",
  "access_permission": "READ",
  "graphspace": "DEFAULT",
  "access_create": "2021-12-07 10:08:44",
  "id": "all->1->all_targets",
  "access_update": "2021-12-07 10:10:48",
  "access_creator": "admin",
  "group": "all",
  "target": "all_targets"
}
```

### 4.12.7.Manager API
管理超级管理员、图空间管理员，主要包含：创建、删除、查看。

#### 4.12.7.1.创建 manager

##### 功能介绍

创建超级管理员或者图空间管理员

##### URI

```
POST /auth/managers
```

##### URI参数

无

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| user  | 是 | String  |   |   | 用户名称  |
| type  | 是 | String  |   | ADMIN、SPACE  | ADMIN、SPACE，分别代表超级管理员、图空间管理员  |
| graphspace  | 否 | String  |   |   | 如果type选择SPACE，那么graphspace是必填项；如果type选择ADMIN，那么graphspace忽略|

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| user  |String| 用户名称 |
| type  |String| 管理员类型 |
| graphspace  |String| 图空间名称 |

##### 使用示例

###### Method & Url

```
POST http://localhost:8080/auth/managers
```

###### Request Body


```json
{
  "user": "boss",
  "type": "SPACE",
  "graphspace": "graphspace1"
}
```

###### Response Status

```json
201
```

###### Response Body

```json
{
  "user": "boss",
  "type": "SPACE",
  "graphspace": "graphspace1"
}
```

#### 4.12.7.2.删除 manager

##### 功能介绍

删除超级管理员或者图空间管理员

##### URI

```
DELETE /auth/managers?user=${user}&type=${type}&graphspace=${graphspace}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| user  | 是 | String  |   |   | 用户名称  |
| type  | 是 | String  |   | ADMIN、SPACE  | ADMIN、SPACE，分别代表超级管理员、图空间管理员  |
| graphspace  | 否 | String  |   |   | 如果type选择SPACE，那么graphspace是必填项；如果type选择ADMIN，那么graphspace忽略|


##### Body参数

无

##### Response

无

##### 使用示例

###### Method & Url

```
DELETE http://localhost:8080/auth/managers?user=boss&type=SPACE&graphspace=graphspace1
```

###### Request Body

无

###### Response Status

```json
204
```

###### Response Body

无

#### 4.12.7.3.查看 manager 列表

##### 功能介绍

查看超级管理员或者图空间管理员立标

##### URI

```
GET /auth/managers?type=${type}&graphspace=${graphspace}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| type  | 是 | String  |   | ADMIN、SPACE  | ADMIN、SPACE，分别代表超级管理员、图空间管理员  |
| graphspace  | 否 | String  |   |   | 如果type选择SPACE，那么graphspace是必填项；如果type选择ADMIN，那么graphspace忽略|


##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| admins |List[String]| 管理员列表|

##### 使用示例

###### Method & Url

```
GET http://localhost:8080/auth/managers?type=SPACE&graphspace=graphspace1
```

###### Request Body

无

###### Response Status

```json
200
```

###### Response Body

```
{
  "admins": ["boss"]
}
```

## 4.13.Token API
获取用户Token，主要包含：登录(login)、验证Token(verify)。

#### 4.13.1.登录(login)

##### 功能介绍

获取用户Token

##### URI

```
POST /auth/login
```

##### URI参数

无

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| user_name  | 是 | String  |   |   | 用户名称  |
| user_password  | 是 | String  |   | | 用户密码  |
| token_expire  | 否 | Long  |   |   | Token自系统创建后有效期，单位秒，例如：10800：3小时、86400：1天、604800：1周、2592000：1月（注意：实际使用过程Token有效期可能存在有一分钟左右的误差） |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| token  |String| 系统生成的用户Token |

##### 使用示例

###### Method & Url

```
POST http://localhost:8080/auth/login
```

###### Request Body

```json
{
  "user_name": "admin",
  "user_password": "admin",
  "token_expire": 10800
}
```

###### Response Status

```json
200
```

###### Response Body

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX25hbWUiOiJhZG1pbiIsInVzZXJfaWQiOiJhZG1pbiIsImV4cCI6MTYzODg1NDA0M30.2zOSTC98Z-UMo-QblTdPVTGsnFMN4G5dZeTV0-PCuD8"
}
```

#### 4.13.2.验证Token(verify)

##### 功能介绍

验证Token

##### URI

```
GET /auth/verify
```

##### URI参数

无

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
| user_name  |String| 用户名称 |
| user_id  |String| 用户ID |


##### 使用示例

###### Method & Url

```
GET http://localhost:8080/auth/verify
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
  "user_name": "admin",
  "user_id": "admin"
}
```
