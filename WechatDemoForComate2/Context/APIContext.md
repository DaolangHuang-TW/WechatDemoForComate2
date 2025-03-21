# API接口规范文档

## 基础信息

### 服务地址
- 开发环境：`https://apifoxmock.com/m1/5946593-5634569-default`
- API版本：`v1`

### 通用规范

#### 请求规范
1. **请求方法**
   - GET：查询资源
   - POST：创建资源
   - PUT：更新资源（全量更新）
   - PATCH：更新资源（部分更新）
   - DELETE：删除资源

2. **请求头**
```http
Content-Type: application/json
Authorization: Bearer {token}
Accept: application/json
```

3. **分页参数**
   - page：页码，从1开始
   - size：每页条数，默认10条

#### 响应规范

1. **成功响应**
   - 状态码：200/201/204
   - 响应格式：
     - 单个资源：返回对象
     - 资源列表：返回数组
     - 创建成功：返回新创建的资源
     - 删除成功：无响应体

2. **错误响应**
   - 状态码：4xx/5xx
   - 响应格式：
```json
{
    "error": "错误描述信息"
}
```

3. **状态码说明**
   - 200：请求成功
   - 201：创建成功
   - 204：删除成功
   - 400：请求参数错误
   - 401：未授权
   - 403：禁止访问
   - 404：资源不存在
   - 500：服务器错误

### 数据格式规范

1. **命名规范**
   - 使用小写字母和连字符(kebab-case)
   - 避免使用下划线和大写字母
   - 字段名应具有描述性

2. **日期时间格式**
   - 使用ISO 8601标准
   - 示例：`2024-01-18T08:30:00Z`

3. **图片URL规范**
   - 使用HTTPS协议
   - 提供完整的URL路径
   - 支持的格式：JPEG/PNG/GIF

4. **字符编码**
   - 统一使用UTF-8编码

### 安全规范

1. **认证方式**
   - 使用Bearer Token认证
   - Token在请求头中携带
   - 示例：`Authorization: Bearer {token}`

2. **接口限流**
   - 单IP每分钟最多100次请求
   - 超出限制返回429状态码
   - 响应头包含限流信息：
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 98
X-RateLimit-Reset: 1623238800
```

## 接口文档

### 用户相关接口
- [用户信息接口](./ProfileAPI.md)
- [朋友圈动态接口](./MomentsAPI.md)

## 错误处理

### 错误响应格式
```json
{
    "error": "错误描述",
    "error_code": "ERROR_CODE",
    "details": {
        "field": "错误字段",
        "message": "具体错误信息"
    }
}
```

### 通用错误码
| 错误码 | 描述 | HTTP状态码 |
|--------|------|------------|
| INVALID_TOKEN | 无效的Token | 401 |
| TOKEN_EXPIRED | Token已过期 | 401 |
| PERMISSION_DENIED | 权限不足 | 403 |
| RESOURCE_NOT_FOUND | 资源不存在 | 404 |
| INVALID_PARAMETER | 参数错误 | 400 |
| SERVER_ERROR | 服务器错误 | 500 |

## 最佳实践

1. **版本控制**
   - 在URL中使用版本号
   - 示例：`/v1/profile`

2. **请求参数验证**
   - 必填参数校验
   - 参数类型校验
   - 参数范围校验

3. **响应数据处理**
   - 统一的响应格式
   - 合适的状态码
   - 清晰的错误信息

4. **性能优化**
   - 合理使用缓存
   - 支持分页查询
   - 避免返回过多数据