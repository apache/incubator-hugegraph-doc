### 9.1 Auth

##### 权限管理：包括UserAPI、AccessAPI、BelongAPI、GroupAPI、TargetAPI

#### 9.1.1 创建target

##### request body

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
POST http://localhost:8080/graphs/hugegraph/auth/targets
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


#### 9.1.2 创建group

##### request body

```json
{
    "group_name": "all",
    "group_description": "group can do anything"
}
```


##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/auth/groups
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


#### 9.1.3 创建access（group到target的连接）

##### request body

```json
{
    "group": "-69:all",
    "target": "-77:all",
    "access_permission": "READ"
}
```


##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/auth/accesses
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

#### 9.1.4 创建User

##### request body

```json
{
    "user_name": "boss",
    "user_password": "pb"
}
```


##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/auth/users
```

##### Response Status

```json
201 
```

##### Response Body

```json
{
    "user_password": "$2a$04$z057xA7F/0wxUuwLaJHUE.FVL8i.NBImz/y8n8grwYuwlYpekDyE6",
    "user_update": "2020-11-11 16:13:34.836",
    "user_name": "boss",
    "user_creator": "admin",
    "id": "-63:boss",
    "user_create": "2020-11-11 16:13:34.836"
}
```

#### 9.1.5 创建User的belong授权

##### request body

```json
{
    "user": "-63:boss",
    "group": "-69:all"
}
```


##### Method & Url

```
POST http://localhost:8080/graphs/hugegraph/auth/belongs
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
    "id": "S-63:boss>-82>>S-69:all",
    "user": "-63:boss",
    "group": "-69:all"
}
```


注意：
> 上方9.1.*为创建权限流程，其中target、group、user为基础。access和belong为关联，access关联 target和group。belong是为user 添加 group。


#### 9.2.1 删除target

##### Params

- id:需要删除的target id


##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/auth/targets/-77:gremlin
```

##### Response Status

```json
204
```

##### Response Body

```json
1
```

#### 9.2.2 删除group

##### Params

- id:需要删除的group id


##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/auth/groups/-69:grant
```

##### Response Status

```json
204
```

##### Response Body

```json
1
```

#### 9.2.3 删除accesses

##### Params

- id:需要删除的accesses id


##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/auth/accesses/S-69:all>-88>12>S-77:all
```

##### Response Status

```json
204
```

##### Response Body

```json
1
```

#### 9.2.4 删除user

##### Params

- id:需要删除的user id


##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/auth/users/-63:test
```

##### Response Status

```json
204
```

##### Response Body

```json
1
```


#### 9.2.5 删除belongs

##### Params

- id:需要删除的belongs id


##### Method & Url

```
DELETE http://localhost:8080/graphs/hugegraph/auth/belongs/S-63:boss>-82>>S-69:grant
```

##### Response Status

```json
204
```

##### Response Body

```json
1
```



#### 9.3.1 修改target

##### Params

- id:需要修改的target id


##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/auth/targets/-77:gremlin
```

##### request body
修改了type
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
返回结果会将修改过的全部内容都返回
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

#### 9.3.2 修改group

##### Params

- id:需要修改的group id

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/auth/groups/-69:grant
```

##### request body
修改了group_description
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
返回结果会将修改过的全部内容都返回
```json
{
    "group_creator": "admin",
    "group_name": "grant",
    "group_create": "2020-11-12 09:50:58.458",
    "group_update": "2020-11-12 09:57:59.155",
    "id": "-69:grant",
    "group_description": "grant"
}
```


#### 9.3.3 修改accesses

##### Params

- id:需要修改的accesses id

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/auth/accesses/S-69:all>-88>12>S-77:all
```

##### request body
修改了access_description
```json
{
    "group": "-69:all",
    "target": "-77:all",
    "access_permission": "WRITE",
    "access_description": "test"
}
```

##### Response Status

```json
200
```

##### Response Body
返回结果会将修改过的全部内容都返回
```json
{
    "access_description": "test",
    "access_permission": "WRITE",
    "access_create": "2020-11-12 10:12:03.074",
    "id": "S-69:all>-88>12>S-77:all",
    "access_update": "2020-11-12 10:16:19.637",
    "access_creator": "admin",
    "group": "-69:all",
    "target": "-77:all"
}
```

#### 9.3.4 修改user

##### Params

- id:需要修改的user id

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/auth/users/-63:test
```

##### request body
修改了user_password 和 user_phone
```json
{
    "user_name": "test",
    "user_password": "pw",
    "user_phone": "123456"
}
```

##### Response Status

```json
200
```

##### Response Body
返回结果会将修改过的全部内容都返回
```json
{
    "user_password": "$2a$04$Homdfl6Ib2g7AtCE8SuZ5uerdIfePtiLJzO30dyF/peUH.HSXq8w2",
    "user_update": "2020-11-12 10:29:30.455",
    "user_name": "test",
    "user_creator": "admin",
    "user_phone": "123456",
    "id": "-63:test",
    "user_create": "2020-11-12 10:27:13.601"
}
```


#### 9.3.5 修改Belongs

##### Params

- id:需要修改的Belongs id

##### Method & Url

```
PUT http://localhost:8080/graphs/hugegraph/auth/belongs/S-63:boss>-82>>S-69:grant
```

##### request body
修改了belong_description
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
返回结果会将修改过的全部内容都返回
```json
{
    "belong_description": "update test",
    "belong_create": "2020-11-12 10:40:21.720",
    "belong_creator": "admin",
    "belong_update": "2020-11-12 10:42:47.265",
    "id": "S-63:boss>-82>>S-69:grant",
    "user": "-63:boss",
    "group": "-69:grant"
}
```



#### 9.4.1 查询target list

##### Params

- limit:返回结果条数的上限

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/auth/targets
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

#### 9.4.2 查询某个target

##### Params

- id: 需要查询的target id

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/auth/targets/-77:grant
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

#### 9.4.3 查询group list

##### Params

- limit:返回结果条数的上限

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/auth/groups
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

#### 9.4.4 查询某个group

##### Params

- id: 需要查询的group id

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/auth/groups/-69:all
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

#### 9.4.5 查询accesses list

##### Params

- limit:返回结果条数的上限

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/auth/accesses
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

#### 9.4.6 查询某个accesses

##### Params

- id: 需要查询的accesses id

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/auth/accesses/S-69:all>-88>11>S-77:all
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




#### 9.4.7 查询user list

##### Params

- limit:返回结果条数的上限


##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/auth/users
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
            "user_password": "$2a$04$1tl1IKTncjcmMojLdt2qO.EAJ1w0TGunAZ5IJXWwBgPLvTPk366Ly",
            "user_update": "2020-11-11 11:41:12.254",
            "user_name": "admin",
            "user_creator": "system",
            "id": "-63:admin",
            "user_create": "2020-11-11 11:41:12.254"
        }
    ]
}
```

#### 9.4.8 查询某个user

##### Params

- id: 需要查询的user id

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/auth/users/-63:admin
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
            "user_password": "$2a$04$1tl1IKTncjcmMojLdt2qO.EAJ1w0TGunAZ5IJXWwBgPLvTPk366Ly",
            "user_update": "2020-11-11 11:41:12.254",
            "user_name": "admin",
            "user_creator": "system",
            "id": "-63:admin",
            "user_create": "2020-11-11 11:41:12.254"
        }
    ]
}
```

#### 9.4.9 查询某个用户的role

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/auth/users/-63:boss/role
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


#### 9.4.10 查询belongs list

##### Params

- limit:返回结果条数的上限


##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/auth/belongs
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
            "id": "S-63:boss>-82>>S-69:all",
            "user": "-63:boss",
            "group": "-69:all"
        }
    ]
}
```

#### 9.4.11 查看某个belongs

##### Params

- id: 需要查询的belongs id

##### Method & Url

```
GET http://localhost:8080/graphs/hugegraph/auth/belongs/S-63:boss>-82>>S-69:all
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
    "id": "S-63:boss>-82>>S-69:all",
    "user": "-63:boss",
    "group": "-69:all"
}
```




