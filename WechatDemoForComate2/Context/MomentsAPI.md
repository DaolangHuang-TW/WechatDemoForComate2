# 朋友圈动态接口

## 接口说明
获取用户朋友圈的动态列表，包含文字内容、图片、发布者信息以及评论等。

## 接口定义

### 基本信息
- 请求路径：`/moments`
- 请求方法：`GET`
- 接口版本：`v1`

### 请求参数

#### 请求头
| 参数名 | 必选 | 类型 | 说明 |
|--------|------|------|------|
| Authorization | 是 | string | Bearer认证token |

#### 查询参数
| 参数名 | 必选 | 类型 | 说明 |
|--------|------|------|------|
| page | 否 | integer | 页码，默认为1 |
| size | 否 | integer | 每页条数，默认为10 |

### 响应参数

#### 成功响应
- 状态码：200
- 响应示例：
```json
[
    {
        "content": "沙发！",
        "images": [
            {
                "url": "https://xianmobilelab.gitlab.io/moments-data/images/tweets/001.jpeg"
            },
            {
                "url": "https://xianmobilelab.gitlab.io/moments-data/images/tweets/002.jpeg"
            },
            {
                "url": "https://xianmobilelab.gitlab.io/moments-data/images/tweets/003.jpeg"
            }
        ],
        "sender": {
            "username": "cyao",
            "nick": "Cheng Yao",
            "avatar": "https://xianmobilelab.gitlab.io/moments-data/images/user/avatar/001.jpeg"
        },
        "comments": [
            {
                "content": "Good.",
                "sender": {
                    "username": "leihuang",
                    "nick": "Lei Huang",
                    "avatar": "https://xianmobilelab.gitlab.io/moments-data/images/user/avatar/002.jpeg"
                }
            },
            {
                "content": "Like it too",
                "sender": {
                    "username": "weidong",
                    "nick": "WeiDong Gu",
                    "avatar": "https://xianmobilelab.gitlab.io/moments-data/images/user/avatar/003.jpeg"
                }
            }
        ]
    },
    // 更多动态数据...
]
```

#### 字段说明

##### 动态对象
| 字段名 | 类型 | 说明 |
|--------|------|------|
| content | string | 动态内容文本，可选 |
| images | array | 动态图片列表，可选 |
| sender | object | 发布者信息 |
| comments | array | 评论列表，可选 |

##### 图片对象
| 字段名 | 类型 | 说明 |
|--------|------|------|
| url | string | 图片URL地址 |

##### 用户对象
| 字段名 | 类型 | 说明 |
|--------|------|------|
| username | string | 用户账号名 |
| nick | string | 用户昵称 |
| avatar | string | 用户头像URL |

##### 评论对象
| 字段名 | 类型 | 说明 |
|--------|------|------|
| content | string | 评论内容 |
| sender | object | 评论发布者信息 |

#### 错误响应
- 状态码：500
- 响应示例：
```json
[
    {
        "unknown error": "STARCRAFT2"
    }
]
```

## cURL命令示例
```bash
curl -X GET 'https://apifoxmock.com/m1/5946593-5634569-default/moments?apifoxToken=JapJysb5u-n8yGO7__FEB' \
     -H 'Authorization: Bearer YOUR_TOKEN_HERE' \
     -H 'Content-Type: application/json'
```

## 分页请求示例
```bash
curl -X GET 'https://apifoxmock.com/m1/5946593-5634569-default/moments?apifoxToken=JapJysb5u-n8yGO7__FEB&page=2&size=5' \
     -H 'Authorization: Bearer YOUR_TOKEN_HERE' \
     -H 'Content-Type: application/json'
```