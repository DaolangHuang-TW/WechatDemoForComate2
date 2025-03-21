# 用户信息接口

## 接口说明
获取当前用户的个人资料信息，包括头像、昵称等基本信息。

## 接口定义

### 基本信息
- 请求路径：`/profile`
- 请求方法：`GET`
- 接口版本：`v1`

### 请求参数

#### 请求头
| 参数名 | 必选 | 类型 | 说明 |
|--------|------|------|------|
| Authorization | 是 | string | Bearer认证token |

### 响应参数

#### 成功响应
- 状态码：200
- 响应示例：
```json
{
  "profile-image": "https://xianmobilelab.gitlab.io/moments-data/images/user/profile-image.jpeg",
  "avatar": "https://xianmobilelab.gitlab.io/moments-data/images/user/avatar.png",
  "nick": "super",
  "username": "SuperUser"
}
```

#### 字段说明
| 字段名 | 类型 | 说明 |
|--------|------|------|
| profile-image | string | 用户主页背景图片URL |
| avatar | string | 用户头像URL |
| nick | string | 用户昵称 |
| username | string | 用户账号名 |

#### 错误响应
- 状态码：404
- 响应示例：
```json
{
  "error": "User not found."
}
```

## cURL命令示例
```bash
curl -X GET 'https://apifoxmock.com/m1/5946593-5634569-default/profile?apifoxToken=JapJysb5u-n8yGO7__FEB' \
     -H 'Authorization: Bearer YOUR_TOKEN_HERE' \
     -H 'Content-Type: application/json'
```