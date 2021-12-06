### 9.1 用户认证与权限控制

> 开启权限及相关配置请先参考 [权限配置](../../config/config-authentication.md) 文档

##### 用户认证与权限控制概述：
HugeGraph支持多用户认证、以及细粒度的权限访问控制，采用基于“用户-用户组-操作-资源”的4层设计，灵活控制用户角色与权限。 
资源描述了图数据库中的数据，比如符合某一类条件的顶点，每一个资源包括type、label、properties三个要素，共有18种type、
任意label、任意properties的组合形成的资源，一个资源的内部条件是且关系，多个资源之间的条件是或关系。用户可以属于一个或多个用户组，
每个用户组可以拥有对任意个资源的操作权限，操作类型包括：读、写、删除、执行等种类。 HugeGraph支持动态创建用户、用户组、资源，
支持动态分配或取消权限。初始化数据库时超级管理员用户被创建，后续可通过超级管理员创建各类角色用户，新创建的用户如果被分配足够权限后，可以由其创建或管理更多的用户。

##### 举例说明：
user(name=tester) -belong-> group(name=all) -access(read)-> target(graph=graph1, resource={label: person,
city: Beijing})  
描述：用户'tester'拥有对'graph1'图中北京人的读权限。

##### 接口说明：
用户认证与权限控制接口包括5类：UserAPI、GroupAPI、TargetAPI、BelongAPI、AccessAPI。

### 9.2 用户（User）API
用户接口包括：创建用户（需要超级管理员admin权限），删除用户（需要超级管理员admin权限），修改用户（需要超级管理员admin权限或用户自己），和查询用户相关信息接口。

#### 9.2.1 创建用户

##### Params

- user_name: 用户名称，长度5-16个字符，可以为字母（区分大小写）、数字、下划线。
- user_password: 用户密码，长度5-16个字符，可以为字母、数字和特殊符号，其中特殊符号：~!@#$%^&*()_+|<>,.?/:;'`"\[\]{}\\。
- user_phone: 用户手机号
- user_email: 用户邮箱  

其中 user_name 和 user_password 为必填。

##### Request Body

```json
{
    "user_name": "tester",
    "user_password": "******",
    "user_phone": "182****9088",
    "user_email": "123@xx.com"
}
```


##### Method & Url

```
# 旧版
POST http://localhost:8080/graphs/auth/users
```
```
# 新版
POST http://localhost:8080/auth/users
```
##### Response Status

```json
201 
```

##### Response Body
返回报文中，密码为加密后的密文
```json
{
    "user_password": "******",
    "user_email": "123@xx.com",
    "user_update": "2020-11-17 14:31:07.833",
    "user_name": "tester",
    "user_creator": "admin",
    "user_phone": "182****9088",
    "id": "-63:tester",
    "user_create": "2020-11-17 14:31:07.833"
}
```

#### 9.2.2 删除用户

##### Params

- id: 需要删除的用户 Id


##### Method & Url

```
# 旧版
DELETE http://localhost:8080/graphs/auth/users/-63:tester
```
```
# 新版
DELETE http://localhost:8080/auth/users/tester
```
##### Response Status

```json
204
```

##### Response Body

```json
1
```

#### 9.2.3 修改用户

##### Params

- id: 需要修改的用户 Id

##### Method & Url

```
# 旧版
PUT http://localhost:8080/graphs/auth/users/-63:tester
```
```
# 新版
PUT http://localhost:8080/auth/users/tester
```
##### Request Body
修改user_name、user_password和user_phone
```json
{
    "user_name": "tester",
    "user_password": "******",
    "user_phone": "183****9266"
}
```

##### Response Status

```json
200
```

##### Response Body
返回结果是包含修改过的内容在内的整个用户组对象
```json
{
    "user_password": "******",
    "user_update": "2020-11-12 10:29:30.455",
    "user_name": "tester",
    "user_creator": "admin",
    "user_phone": "183****9266",
    "id": "-63:tester",
    "user_create": "2020-11-12 10:27:13.601"
}
```

#### 9.2.4 查询用户列表

##### Params

- limit: 返回结果条数的上限


##### Method & Url

```
# 旧版
GET http://localhost:8080/graphs/auth/users
```
```
# 新版
GET http://localhost:8080/auth/users
```
##### Response Status

```json
200
```

##### Response Body

```json
{
    "users": [
        {
            "user_password": "******",
            "user_update": "2020-11-11 11:41:12.254",
            "user_name": "admin",
            "user_creator": "system",
            "id": "-63:admin",
            "user_create": "2020-11-11 11:41:12.254"
        }
    ]
}
```

#### 9.2.5 查询某个用户

##### Params

- id: 需要查询的用户 Id

##### Method & Url

```
# 旧版
GET http://localhost:8080/graphs/auth/users/-63:admin
```
```
# 新版
GET http://localhost:8080/auth/users/admin
```
##### Response Status

```json
200
```

##### Response Body

```json
{
    "users": [
        {
            "user_password": "******",
            "user_update": "2020-11-11 11:41:12.254",
            "user_name": "admin",
            "user_creator": "system",
            "id": "-63:admin",
            "user_create": "2020-11-11 11:41:12.254"
        }
    ]
}
```

#### 9.2.6 查询某个用户的角色

##### Method & Url

```
# 旧版
GET http://localhost:8080/graphs/auth/users/-63:tester/role
```
```
# 新版
GET http://localhost:8080/auth/users/tester/role
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "roles": {
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
```

### 9.3 用户组（Group）API
用户组会赋予相应的资源权限，用户会被分配不同的用户组，即可拥有不同的资源权限。  
用户组接口包括：创建用户组，删除用户组，修改用户组，和查询用户组相关信息接口。

注意：需要图空间管理员或者超级管理员权限

#### 9.3.1 创建用户组

##### Params

- group_name: 用户组名称
- group_description: 用户组描述

##### Request Body

```json
{
    "group_name": "all",
    "group_description": "group can do anything"
}
```


##### Method & Url

```
# 旧版
POST http://localhost:8080/graphs/auth/groups
```
```
# 新版
POST http://localhost:8080/graphspaces/{graphspace}/auth/groups
```

##### Response Status

```json
201 
```

##### Response Body

```json
{
    "group_creator": "admin",
    "group_name": "all",
    "group_create": "2020-11-11 15:46:08.791",
    "group_update": "2020-11-11 15:46:08.791",
    "id": "-69:all",
    "group_description": "group can do anything"
}
```

#### 9.3.2 删除用户组

##### Params

- id: 需要删除的用户组 Id


##### Method & Url

```
# 旧版
DELETE http://localhost:8080/graphs/auth/groups/-69:grant
```
```
# 新版
DELETE http://localhost:8080/graphspaces/{graphspace}/auth/groups/grant
```
##### Response Status

```json
204
```

##### Response Body

```json
1
```

#### 9.3.3 修改用户组

##### Params

- id: 需要修改的用户组 Id

##### Method & Url

```
# 旧版
PUT http://localhost:8080/graphs/auth/groups/-69:grant
```
```
# 新版
PUT http://localhost:8080/graphspaces/{graphspace}/auth/groups/grant
```

##### Request Body
修改group_description
```json
{
    "group_name": "grant",
    "group_description": "grant"
}
```

##### Response Status

```json
200
```

##### Response Body
返回结果是包含修改过的内容在内的整个用户组对象
```json
{
    "group_creator": "admin",
    "group_name": "grant",
    "group_create": "2020-11-12 09:50:58.458",
    "group_update": "2020-11-12 09:57:58.155",
    "id": "-69:grant",
    "group_description": "grant"
}
```

#### 9.3.4 查询用户组列表

##### Params

- limit: 返回结果条数的上限

##### Method & Url

```
# 旧版
GET http://localhost:8080/graphs/auth/groups
```
```
# 新版
GET http://localhost:8080/graphspaces/{graphspace}/auth/groups
```
##### Response Status

```json
200
```

##### Response Body

```json
{
    "groups": [
        {
            "group_creator": "admin",
            "group_name": "all",
            "group_create": "2020-11-11 15:46:08.791",
            "group_update": "2020-11-11 15:46:08.791",
            "id": "-69:all",
            "group_description": "group can do anything"
        }
    ]
}
```

#### 9.3.5 查询某个用户组

##### Params

- id: 需要查询的用户组 Id

##### Method & Url

```
# 旧版
GET http://localhost:8080/graphs/auth/groups/-69:all
```
```
# 新版
GET http://localhost:8080/graphspaces/{graphspace}/auth/groups/all
```
##### Response Status

```json
200
```

##### Response Body

```json
{
    "group_creator": "admin",
    "group_name": "all",
    "group_create": "2020-11-11 15:46:08.791",
    "group_update": "2020-11-11 15:46:08.791",
    "id": "-69:all",
    "group_description": "group can do anything"
}
```

### 9.4 资源（Target）API
资源描述了图数据库中的数据，比如符合某一类条件的顶点，每一个资源包括type、label、properties三个要素，共有18种type、
任意label、任意properties的组合形成的资源，一个资源的内部条件是且关系，多个资源之间的条件是或关系。   
资源接口包括：资源的创建、删除、修改和查询。

注意：需要图空间管理员或者超级管理员权限

#### 9.4.1 创建资源

##### Params
- target_name: 资源名称
- target_graph: 资源图
- target_url: 资源地址
- target_resources: 资源定义(列表)

target_resources可以包括多个target_resource，以列表的形式存储。  
每个target_resource包含：
- type：可选值 VERTEX, EDGE等, 可填ALL，则表示可以是顶点或边；
- label：可选值，⼀个顶点或边类型的名称，可填*，则表示任意类型；
- properties：map类型，可包含多个属性的键值对，必须匹配所有属性值，属性值⽀持填条件范围（age:
  P.gte(18)），properties如果为null表示任意属性均可，如果属性名和属性值均为‘*ʼ也表示任意属性均可。

如精细资源："target_resources": [{"type":"VERTEX","label":"person","properties":{"city":"Beijing","age":"P.gte(20)"}}]**  
资源定义含义：类型是'person'的顶点，且城市属性是'Beijing'，年龄属性大于等于20。

type取值范围如下：
```
enum ResourceType { NONE STATUS, VERTEX, EDGE, VERTEX_AGGR, EDGE_AGGR, VAR, GREMLIN, TASK, PROPERTY_KEY, VERTEX_LABEL, EDGE_LABEL, INDEX_LABEL, SCHEMA, META, ALL, GRANT, USER_GROUP, PROJECT, TARGET, METRICS, ROOT }
```

这些类型按照影响的范围是基本有序的，范围从小到大。比如：NONE 是最低级别，表示没有资源；ALL 属于比较高的级别，表示所有的图数据（顶点和边）和元数据（schema）；ROOT是最高级别，表示根资源。另外有一些“综合性“的类型，比如：
- SCHEMA，表示全部元数据，即PROPERTY_KEY、VERTEX_LABEL、EDGELABEL 和 INDEXLABEL
- ALL，表示全部图数据和元数据，即VERTEX、EDGE 和 SCHEMA等 
- ROOT，表示根，包括 ALL 和权限相关的资源

注：根据访问资源的依赖属性，选择合适的类型值。 例如：

在查询一个 VERTEX 的时候，这个过程中，任何涉及到的 VertexLabel、INDEXLABEL 和 PROPERTY_KEY，都必须有读权限。 在比如查询USER的时候，应该对 VERTEX、VertexLabel、INDEXLABEL 和 PROPERTY_KEY 都有读权限才行。

##### Request Body

```json
{
    "target_name": "all",
    "target_graph": "hugegraph",
    "target_url": "127.0.0.1:8080",
    "target_resources": [
        {
            "type": "ALL"
        }
    ]
}
```

##### Method & Url

```
# 旧版
POST http://localhost:8080/graphs/auth/targets
```
```
# 新版
POST http://localhost:8080/graphspaces/{graphspace}/auth/targets
```

##### Response Status

```json
201 
```

##### Response Body

```json
{
    "target_creator": "admin",
    "target_name": "all",
    "target_url": "127.0.0.1:8080",
    "target_graph": "hugegraph",
    "target_create": "2020-11-11 15:32:01.192",
    "target_resources": [
        {
            "type": "ALL",
            "label": "*",
            "properties": null
        }
    ],
    "id": "-77:all",
    "target_update": "2020-11-11 15:32:01.192"
}
```

#### 9.4.2 删除资源

##### Params

- id: 需要删除的资源 Id


##### Method & Url

```
# 旧版
DELETE http://localhost:8080/graphs/auth/targets/-77:gremlin
```
```
# 新版
DELETE http://localhost:8080/graphspaces/{graphspace}/auth/targets/gremlin
```
##### Response Status

```json
204
```

##### Response Body

```json
1
```

#### 9.4.3 修改资源

##### Params

- id: 需要修改的资源 Id


##### Method & Url

```
# 旧版
PUT http://localhost:8080/graphs/auth/targets/-77:gremlin
```
```
# 新版
PUT http://localhost:8080/graphspaces/{graphspace}/auth/targets/gremlin
```

##### Request Body
修改资源定义中的type
```json
{
    "target_name": "gremlin",
    "target_graph": "hugegraph",
    "target_url": "127.0.0.1:8080",
    "target_resources": [
        {
            "type": "NONE"
        }
    ]
}
```

##### Response Status

```json
200
```

##### Response Body
返回结果是包含修改过的内容在内的整个用户组对象
```json
{
    "target_creator": "admin",
    "target_name": "gremlin",
    "target_url": "127.0.0.1:8080",
    "target_graph": "hugegraph",
    "target_create": "2020-11-12 09:34:13.848",
    "target_resources": [
        {
            "type": "NONE",
            "label": "*",
            "properties": null
        }
    ],
    "id": "-77:gremlin",
    "target_update": "2020-11-12 09:37:12.780"
}
```

#### 9.4.4 查询资源列表

##### Params

- limit: 返回结果条数的上限

##### Method & Url

```
# 旧版
GET http://localhost:8080/graphs/auth/targets
```
```
# 新版
GET http://localhost:8080/graphspaces/{graphspace}/auth/targets
```
##### Response Status

```json
200
```

##### Response Body

```json
{
    "targets": [
        {
            "target_creator": "admin",
            "target_name": "all",
            "target_url": "127.0.0.1:8080",
            "target_graph": "hugegraph",
            "target_create": "2020-11-11 15:32:01.192",
            "target_resources": [
                {
                    "type": "ALL",
                    "label": "*",
                    "properties": null
                }
            ],
            "id": "-77:all",
            "target_update": "2020-11-11 15:32:01.192"
        },
        {
            "target_creator": "admin",
            "target_name": "grant",
            "target_url": "127.0.0.1:8080",
            "target_graph": "hugegraph",
            "target_create": "2020-11-11 15:43:24.841",
            "target_resources": [
                {
                    "type": "GRANT",
                    "label": "*",
                    "properties": null
                }
            ],
            "id": "-77:grant",
            "target_update": "2020-11-11 15:43:24.841"
        }
    ]
}
```

#### 9.4.5 查询某个资源

##### Params

- id: 需要查询的资源 Id

##### Method & Url

```
# 旧版
GET http://localhost:8080/graphs/auth/targets/-77:grant
```
```
# 新版
GET http://localhost:8080/graphspaces/{graphspace}/auth/targets/grant
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "target_creator": "admin",
    "target_name": "grant",
    "target_url": "127.0.0.1:8080",
    "target_graph": "hugegraph",
    "target_create": "2020-11-11 15:43:24.841",
    "target_resources": [
        {
            "type": "GRANT",
            "label": "*",
            "properties": null
        }
    ],
    "id": "-77:grant",
    "target_update": "2020-11-11 15:43:24.841"
}
```

### 9.5 关联角色（Belong）API
关联用户和用户组的关系，一个用户可以关联一个或者多个用户组。用户组拥有相关资源的权限，不同用户组的资源权限可以理解为不同的角色。即给用户关联角色。  
关联角色接口包括：用户关联角色的创建、删除、修改和查询。

注意：需要图空间管理员或者超级管理员权限

#### 9.5.1 创建用户的关联角色

##### Params

- user: 用户 Id
- group: 用户组 Id
- belong_description: 描述

##### Request Body

```json
{
    "user": "-63:tester",
    "group": "-69:all"
}
```


##### Method & Url

```
# 旧版
POST http://localhost:8080/graphs/auth/belongs
```
```
# 新版
POST http://localhost:8080/graphspaces/{graphspace}/auth/belongs
```
##### Response Status

```json
201 
```

##### Response Body

```json
{
    "belong_create": "2020-11-11 16:19:35.422",
    "belong_creator": "admin",
    "belong_update": "2020-11-11 16:19:35.422",
    "id": "S-63:tester>-82>>S-69:all",
    "user": "-63:tester",
    "group": "-69:all"
}
```

#### 9.5.2 删除关联角色

##### Params

- id: 需要删除的关联角色 Id

##### Method & Url

```
# 旧版
DELETE http://localhost:8080/graphs/auth/belongs/S-63:tester>-82>>S-69:grant
```
```
# 新版
DELETE http://localhost:8080/graphspaces/{graphspace}/auth/belongs/tester>8>grant
```
##### Response Status

```json
204
```

##### Response Body

```json
1
```

#### 9.5.3 修改关联角色
关联角色只能修改描述，不能修改 user 和 group 属性，如果需要修改关联角色，需要删除原来关联关系，新增关联角色。

##### Params

- id: 需要修改的关联角色 Id

##### Method & Url

```
# 旧版
PUT http://localhost:8080/graphs/auth/belongs/S-63:tester>-82>>S-69:grant
```
```
# 新版
PUT http://localhost:8080/graphspaces/{graphspace}/auth/belongs/tester>8>grant
```

##### Request Body
修改belong_description
```json
{
    "belong_description": "update test"
}
```

##### Response Status

```json
200
```

##### Response Body
返回结果是包含修改过的内容在内的整个用户组对象
```json
{
    "belong_description": "update test",
    "belong_create": "2020-11-12 10:40:21.720",
    "belong_creator": "admin",
    "belong_update": "2020-11-12 10:42:47.265",
    "id": "S-63:tester>-82>>S-69:grant",
    "user": "-63:tester",
    "group": "-69:grant"
}
```

#### 9.5.4 查询关联角色列表

##### Params

- limit: 返回结果条数的上限


##### Method & Url

```
# 旧版
GET http://localhost:8080/graphs/auth/belongs
```
```
# 新版
GET http://localhost:8080/graphspaces/{graphspace}/auth/belongs
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "belongs": [
        {
            "belong_create": "2020-11-11 16:19:35.422",
            "belong_creator": "admin",
            "belong_update": "2020-11-11 16:19:35.422",
            "id": "S-63:tester>-82>>S-69:all",
            "user": "-63:tester",
            "group": "-69:all"
        }
    ]
}
```

#### 9.5.5 查看某个关联角色

##### Params

- id: 需要查询的关联角色 Id

##### Method & Url

```
# 旧版
GET http://localhost:8080/graphs/auth/belongs/S-63:tester>-82>>S-69:all
```
```
# 新版
GET http://localhost:8080/graphspaces/{graphspace}/auth/belongs/tester>2>all
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "belong_create": "2020-11-11 16:19:35.422",
    "belong_creator": "admin",
    "belong_update": "2020-11-11 16:19:35.422",
    "id": "S-63:tester>-82>>S-69:all",
    "user": "-63:tester",
    "group": "-69:all"
}
```

### 9.6 赋权（Access）API
给用户组赋予资源的权限，主要包含：读操作(READ)、写操作(WRITE)、删除操作(DELETE)、执行操作(EXECUTE)等。  
赋权接口包括：赋权的创建、删除、修改和查询。

注意：需要图空间管理员或者超级管理员权限

#### 9.6.1 创建赋权(用户组赋予资源的权限)

##### Params

- group: 用户组 Id
- target: 资源 Id
- access_permission: 权限许可  
- access_description: 赋权描述

access_permission：
- READ：读操作，所有的查询，包括查询Schema、查顶点/边，查询顶点和边的数量VERTEX_AGGR/EDGE_AGGR，也包括读图的状态STATUS、变量VAR、任务TASK等；
- WRITE：写操作，所有的创建、更新操作，包括给Schema增加property key，给顶点增加或更新属性等；
- DELETE：删除操作，包括删除元数据、删除顶点/边；
- EXECUTE：执⾏操作，包括执⾏Gremlin语句、执⾏Task、执⾏metadata函数；
- SPACE：图空间权限，包括动态管理图（增删改查）、图空间权限管理等；
- OP：运维管理权限，可以设置图空间运维管理员和全局运维管理员；

##### Request Body

```json
{
    "group": "-69:all",
    "target": "-77:all",
    "access_permission": "READ"
}
```

##### Method & Url

```
# 旧版
POST http://localhost:8080/graphs/auth/accesses
```
```
# 新版
POST http://localhost:8080/graphspaces/{graphspace}/auth/accesses
```

##### Response Status

```json
201 
```

##### Response Body

```json
{
    "access_permission": "READ",
    "access_create": "2020-11-11 15:54:54.008",
    "id": "S-69:all>-88>11>S-77:all",
    "access_update": "2020-11-11 15:54:54.008",
    "access_creator": "admin",
    "group": "-69:all",
    "target": "-77:all"
}
```

#### 9.6.2 删除赋权

##### Params

- id: 需要删除的赋权 Id


##### Method & Url

```
# 旧版
DELETE http://localhost:8080/graphs/auth/accesses/S-69:all>-88>12>S-77:all
```
```
# 新版
DELETE http://localhost:8080/graphspaces/{graphspace}/auth/accesses/all>8>all
```

##### Response Status

```json
204
```

##### Response Body

```json
1
```

#### 9.6.3 修改赋权
赋权只能修改描述，不能修改用户组、资源和权限许可，如果需要修改赋权的关系，可以删除原来的赋权关系，新增赋权。

##### Params

- id: 需要修改的赋权 Id

##### Method & Url

```
# 旧版
PUT http://localhost:8080/graphs/auth/accesses/S-69:all>-88>12>S-77:all
```
```
# 新版
PUT http://localhost:8080/graphspaces/{graphspace}/auth/accesses/all>8>all
```

##### Request Body
修改access_description
```json
{
    "access_description": "test"
}
```

##### Response Status

```json
200
```

##### Response Body
返回结果是包含修改过的内容在内的整个用户组对象
```json
{
    "access_description": "test",
    "access_permission": "WRITE",
    "access_create": "2020-11-12 10:12:03.074",
    "id": "S-69:all>-88>12>S-77:all",
    "access_update": "2020-11-12 10:16:18.637",
    "access_creator": "admin",
    "group": "-69:all",
    "target": "-77:all"
}
```

#### 9.6.4 查询赋权列表

##### Params

- limit: 返回结果条数的上限

##### Method & Url

```
# 旧版
GET http://localhost:8080/graphs/auth/accesses
```
```
# 新版
GET http://localhost:8080/graphspaces/{graphspace}/auth/accesses
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "accesses": [
        {
            "access_permission": "READ",
            "access_create": "2020-11-11 15:54:54.008",
            "id": "S-69:all>-88>11>S-77:all",
            "access_update": "2020-11-11 15:54:54.008",
            "access_creator": "admin",
            "group": "-69:all",
            "target": "-77:all"
        }
    ]
}
```

#### 9.6.5 查询某个赋权

##### Params

- id: 需要查询的赋权 Id

##### Method & Url

```
# 旧版
GET http://localhost:8080/graphs/auth/accesses/S-69:all>-88>11>S-77:all
```
```
# 新版
GET http://localhost:8080/graphspaces/{graphspace}/auth/accesses/all>8>all
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "access_permission": "READ",
    "access_create": "2020-11-11 15:54:54.008",
    "id": "S-69:all>-88>11>S-77:all",
    "access_update": "2020-11-11 15:54:54.008",
    "access_creator": "admin",
    "group": "-69:all",
    "target": "-77:all"
}
```

### 9.7 Token API
获取用户Token，主要包含：登录(login)、验证Token(verify)。

#### 9.7.1 登录(login)

##### Params

- user_name： 用户名
- user_password：用户密码
- token_expire：Token自系统创建后有效期，单位秒，例如：10800：3小时、86400：1天、604800：1周、2592000：1月（注意：实际使用过程Token有效期可能存在有一分钟左右的误差）

##### Method & Url

```
# 旧版
POST http://localhost:8080/graphs/auth/login
```
```
# 新版
POST http://localhost:8080/auth/login
```

##### Request Body

```json
{
  "user_name": "admin",
  "user_password": "admin",
  "token_expire": 10800
}
```

##### Response Status

```json
200
```

##### Response Body

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX25hbWUiOiJneWcxMjM0IiwidXNlcl9pZCI6Ii02MzpneWcxMjM0IiwiZXhwIjoxNjMyNjUzOTE2fQ.T4psT797RIaPqvkqtgVug1qIZQ2djKBLI5yOxQRjuZU"
}
```

#### 9.7.2 验证Token(verify)

##### Method & Url

```
# 旧版
POST http://localhost:8080/graphs/auth/verify
```
```
# 新版
POST http://localhost:8080/auth/verify
```

##### Response Status

```json
200
```

##### Response Body

```json
{
    "user_name": "admin",
    "user_id": "-63:admin"
}
```