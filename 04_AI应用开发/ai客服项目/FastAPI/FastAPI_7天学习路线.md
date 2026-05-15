# FastAPI 7 天学习路线

## 学习目标

这 7 天不是为了学完整个 FastAPI，而是为了支撑当前项目“跨境电商 AI 客服助手”的第一阶段最小闭环。

第一阶段目标：

```text
用户在 Streamlit 页面输入问题
↓
Streamlit 调用 FastAPI /chat 接口
↓
FastAPI 调用大模型
↓
返回客服回复
↓
页面展示回复
```

学完 7 天后，你要能说清楚：

```text
FastAPI 负责提供后端接口。/chat 接口接收 message，调用大模型后返回 reply。
```

## 视频来源

B 站 FastAPI 视频：

```text
https://www.bilibili.com/video/BV1zV2QBtE39?p=3
```

原始链接：

```text
https://www.bilibili.com/video/BV1zV2QBtE39?spm_id_from=333.788.videopod.episodes&vd_source=c21175e9eb2a26a85e2c6ba32dcba2d1&p=3
```

## 视频结构总览

根据截图整理，课程大致分为这些阶段。

### 01-04：FastAPI 入门

```text
01 FastAPI 从入门到实战导学课程
02 FastAPI 基础入门 - FastAPI 框架简介
03 FastAPI 基础入门 - 第一个 FastAPI 应用
04 FastAPI 基础入门 - 路由
```

学习重点：

- FastAPI 是什么。
- 怎么创建 `app = FastAPI()`。
- 怎么写第一个接口。
- 路由和函数的关系。

### 05-09：参数和请求体

```text
05 FastAPI 基础入门 - 参数简介和路径参数
06 FastAPI 基础入门 - 路径参数 Path
07 FastAPI 基础入门 - 查询参数 Query
08 FastAPI 基础入门 - 请求体参数
09 FastAPI 基础入门 - 请求体参数 Field
```

学习重点：

- 路径参数是什么。
- 查询参数是什么。
- 请求体 JSON 是什么。
- Pydantic 和 Field 怎么做参数校验。

当前项目最重要的是：

```json
{
  "message": "我的订单什么时候发货？"
}
```

### 10-14：响应和异常

```text
10 FastAPI 基础入门 - 响应类型 JSON
11 FastAPI 基础入门 - 响应类型 HTML
12 FastAPI 基础入门 - 响应类型 文件
13 FastAPI 基础入门 - 自定义响应数据
14 FastAPI 基础入门 - 异常响应处理
```

学习重点：

- 接口怎么返回 JSON。
- 状态码是什么。
- 参数错误和服务错误怎么返回。
- 当前阶段重点看 JSON 和异常处理，HTML/文件响应先了解即可。

### 15-16：进阶基础

```text
15 FastAPI 进阶 - 中间件
16 FastAPI 进阶 - 依赖注入
```

学习重点：

- 中间件可以统一处理请求。
- 依赖注入可以管理公共逻辑。
- 当前项目第一阶段不是必须，后面项目变复杂再深入。

### 17-21：ORM 和数据库

```text
17 FastAPI 进阶 - ORM 简介及安装
18 FastAPI 进阶 - ORM 建表
19 FastAPI 进阶 - ORM 在路由中使用
20 FastAPI 进阶 - ORM 操作数据 - 查询
21 FastAPI 进阶 - ORM 操作数据 - 条件查询
```

学习重点：

- 这些和数据库相关。
- 当前最小闭环暂时不学。
- 等项目做订单查询、会话记录时再回来学。

### 31-68：头条项目实战

截图中后半部分是一个完整头条项目，包括：

```text
项目结构
模块化路由
数据库和 ORM 配置
新闻分类
用户注册
生成 Token
登录
获取用户信息
修改用户信息
收藏
浏览历史
Redis 缓存
AI 问答功能
缓存和调用模型总结
```

学习建议：

- 当前阶段先不跟做完整头条项目。
- 等你的 AI 客服项目需要用户系统、数据库、缓存时，再选对应章节看。
- 不要因为视频后面有 AI 问答功能，就提前跳过去学；先把自己的 `/chat` 跑稳。

## 当前阶段暂时跳过

这些内容先记录，不深入：

- ORM 和数据库
- 用户注册
- Token
- 登录认证
- Redis 缓存
- 完整头条项目
- 视频里的 AI 问答功能

原因：

```text
当前目标是 AI 客服最小闭环，不是完整后端系统。
```

## Day 1：认识 FastAPI，跑通第一个接口

看视频：

```text
01 导学
02 FastAPI 框架简介
03 第一个 FastAPI 应用
```

看项目文件：

```text
E:\ai-customer-service\backend\main.py
```

今天学什么：

- FastAPI 是什么。
- `app = FastAPI()` 是什么。
- `@app.get("/")` 是什么。
- 为什么后端要提供接口。

动手练习：

- 启动后端：

```powershell
uvicorn backend.main:app --reload
```

- 浏览器打开：

```text
http://127.0.0.1:8000/
```

验收清单：

- 能启动后端。
- 能看到 `{"status":"ok"}`。
- 能说出 `GET /` 是健康检查接口。

学完后要能说清楚：

```text
FastAPI 可以把 Python 函数变成浏览器或前端能访问的 HTTP 接口。
```

## Day 2：路由和接口

看视频：

```text
04 路由
```

看项目文件：

```text
E:\ai-customer-service\backend\main.py
```

今天学什么：

- 路由是什么。
- `GET` 和 `POST` 的区别。
- `/` 和 `/chat` 分别负责什么。

动手练习：

- 在 `backend/main.py` 中阅读这两个接口：

```python
@app.get("/")
def health_check():
    ...

@app.post("/chat")
def chat(request: ChatRequest):
    ...
```

验收清单：

- 能指出 `/chat` 是客服对话接口。
- 能说出为什么用户问题要用 `POST` 提交。
- 能说出路由和函数之间的对应关系。

学完后要能说清楚：

```text
路由就是 URL 和 Python 函数之间的对应关系。/chat 对应 chat 函数。
```

## Day 3：参数类型

看视频：

```text
05 参数简介和路径参数
06 路径参数 Path
07 查询参数 Query
08 请求体参数
```

看项目文件：

```text
E:\ai-customer-service\backend\main.py
```

今天学什么：

- 路径参数。
- 查询参数。
- 请求体参数。
- 当前项目为什么主要用请求体。

动手练习：

- 理解 `/chat` 请求体：

```json
{
  "message": "我的订单什么时候发货？"
}
```

验收清单：

- 能区分 path、query、body。
- 能说出 `message` 来自请求体 JSON。
- 能用接口测试工具发送 JSON 请求。

学完后要能说清楚：

```text
/chat 接口接收的是请求体参数，前端把用户问题放在 JSON 的 message 字段里。
```

## Day 4：请求体和 Pydantic

看视频：

```text
08 请求体参数
09 请求体参数 Field
```

看项目文件：

```text
E:\ai-customer-service\backend\main.py
```

今天学什么：

- Pydantic 的作用。
- `BaseModel` 是什么。
- `Field(..., min_length=1)` 是什么。
- 请求模型和响应模型为什么重要。

项目示例：

```python
class ChatRequest(BaseModel):
    message: str = Field(..., min_length=1)


class ChatResponse(BaseModel):
    reply: str
```

验收清单：

- 能解释 `ChatRequest`。
- 能解释 `ChatResponse`。
- 知道空字符串、缺字段、类型错误都属于需要校验的内容。

学完后要能说清楚：

```text
Pydantic 用来规定接口输入和输出的数据结构，ChatRequest 要求请求里必须有 message。
```

## Day 5：JSON 响应和错误处理

看视频：

```text
10 响应类型 JSON
14 异常响应处理
```

看项目文件：

```text
E:\ai-customer-service\backend\main.py
```

今天学什么：

- FastAPI 怎么返回 JSON。
- 状态码是什么。
- `HTTPException` 是什么。
- 调大模型失败时为什么要返回清楚的错误。

项目示例：

```python
raise HTTPException(status_code=400, detail="message 不能为空")
```

验收清单：

- 能说出成功返回 `reply`。
- 能说出错误返回 `detail`。
- 能理解 400、500、502 的大概区别。

学完后要能说清楚：

```text
FastAPI 可以返回标准 JSON。成功时返回 reply，失败时通过 HTTPException 返回 detail。
```

## Day 6：结合项目理解 /chat 最小闭环

看项目文件：

```text
E:\ai-customer-service\backend\main.py
E:\ai-customer-service\backend\llm_client.py
E:\ai-customer-service\frontend\app.py
```

今天学什么：

- 前端怎么请求后端。
- 后端怎么调用大模型。
- 后端怎么把回复返回给页面。

完整流程：

```text
Streamlit 输入 message
↓
requests.post 调用 /chat
↓
FastAPI 接收 ChatRequest
↓
调用 get_customer_service_reply
↓
返回 ChatResponse
↓
Streamlit 展示 reply
```

验收清单：

- 能把 `/chat` 的流程从前端讲到后端。
- 能说出 `main.py`、`llm_client.py`、`app.py` 各自负责什么。
- 能说出 API Key 没配好时为什么不能拿到真实 AI 回复。

学完后要能说清楚：

```text
FastAPI 在这个项目里是中间层，负责接住前端问题，调用大模型，再把回复返回给前端。
```

## Day 7：接口测试和复盘

使用工具：

```text
PowerShell
Apifox
Postman
```

测试接口：

```text
GET  http://127.0.0.1:8000/
POST http://127.0.0.1:8000/chat
```

PowerShell 示例：

```powershell
Invoke-RestMethod -Method Post `
  -Uri http://127.0.0.1:8000/chat `
  -ContentType "application/json" `
  -Body '{"message":"我的订单什么时候发货？"}'
```

今天学什么：

- 怎么验证接口是否能用。
- 怎么检查请求 JSON。
- 怎么检查响应 JSON。
- 怎么记录接口测试结果。

验收清单：

- 能启动后端服务。
- 能请求 `GET /`。
- 能请求 `POST /chat`。
- 能看懂成功响应。
- 能看懂错误响应。
- 能用自己的话解释 `/chat` 最小闭环。

学完后要能说清楚：

```text
接口测试就是验证请求、响应和错误处理是否符合预期。AI 应用也要像普通系统一样测试接口。
```

## 7 天结束后的总复盘

你应该能回答这些问题：

- FastAPI 是什么？
- 为什么 AI 客服项目需要 FastAPI？
- `/chat` 为什么用 POST？
- 请求体里的 `message` 是什么？
- 响应里的 `reply` 是什么？
- Pydantic 在接口里做什么？
- `HTTPException` 用来做什么？
- 前端 Streamlit 如何调用后端接口？
- API Key 没配好时为什么会报错？

## 后续学习安排

等当前 AI 客服项目进入对应阶段，再回来看这些视频内容：

```text
订单查询、会话记录阶段：17-21 ORM 和数据库
后台用户系统阶段：用户注册、Token、登录
性能和缓存阶段：Redis 缓存
项目变大阶段：项目结构、模块化路由、依赖注入
AI 能力扩展阶段：视频里的 AI 问答功能
```

现在先记住一句话：

```text
先跑通 /chat，不急着学完整个后端系统。
```
