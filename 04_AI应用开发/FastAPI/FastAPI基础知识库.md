# FastAPI 基础知识库

## 一句话理解

FastAPI 是一个 Python 后端框架，用来把 Python 函数包装成 HTTP 接口。

在 AI 应用开发里，FastAPI 常用来做后端服务：

```text
前端页面
↓
调用 FastAPI 接口
↓
FastAPI 调用大模型、数据库、知识库或业务逻辑
↓
返回 JSON 给前端
```

在当前项目“跨境电商 AI 客服助手”里，FastAPI 的作用是：

```text
接收用户问题
↓
调用大模型
↓
返回 AI 客服回复
```

对应项目文件：

```text
E:\ai-customer-service\backend\main.py
```

## FastAPI 适合 AI 应用的原因

- 写接口快，适合快速做 AI 应用原型。
- 自动生成接口文档，方便调试和测试。
- 支持 Pydantic 数据校验，适合处理 JSON 请求。
- 可以把大模型调用、RAG、订单查询等 Python 逻辑封装成接口。
- 和 Streamlit、前端页面、Apifox、Postman 配合很方便。

## 最小应用结构

一个最小 FastAPI 应用通常长这样：

```python
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def health_check():
    return {"status": "ok"}
```

启动命令：

```powershell
uvicorn backend.main:app --reload
```

含义：

- `backend.main`：导入 `backend/main.py`
- `app`：文件里的 FastAPI 实例
- `--reload`：开发时自动重启服务

## 本地运行 FastAPI 项目

**为什么要创建虚拟环境？**

+ 隔离项目运行环境
+ 避免不同项目之间依赖冲突
+ 保持全局 Python 环境干净、稳定

**运行 FastAPI 项目**

```powershell
uvicorn backend.main:app --reload
```

+ `backend.main`：表示后端入口文件
+ `app`：表示 FastAPI 实例对象
+ `--reload`：修改代码后自动重启服务器，适合开发阶段使用

**uvicorn 的作用**

+ 监听本地端口，默认地址是 `http://127.0.0.1:8000`
+ 接收浏览器、前端页面、Apifox、Postman 发来的 HTTP 请求
+ 把请求转交给 FastAPI，让 FastAPI 去匹配路由和执行函数
+ 把 FastAPI 返回的结果，再作为 HTTP 响应返回给客户端
+ 配合 `--reload`，开发时修改代码后可以自动重启服务

流程理解：

```text
浏览器 / 前端 / Apifox
↓
uvicorn 接收请求
↓
FastAPI 匹配路由
↓
Python 函数处理业务
↓
uvicorn 返回响应
```

**访问交互式接口文档**

```text
http://127.0.0.1:8000/docs
```

+ FastAPI 会自动生成接口文档
+ 可以在浏览器里直接查看接口、参数、返回结构
+ 也可以直接测试 `/chat` 接口

**在 AI 客服项目里的作用**

+ 启动后端服务
+ 打开 `/docs` 查看 `/chat` 接口
+ 检查请求体是否有 `message`
+ 检查返回结果是否有 `reply`

## 路由

路由就是 URL 地址和处理函数之间的映射关系。

例如：

```python
@app.get("/")
def health_check():
    return {"status": "ok"}
```

**关键代码含义**

+ `@app.get("/")`：装饰器，用来声明一个 GET 接口
+ `app`：FastAPI 实例对象
+ `get`：请求方法
+ `"/"`：请求路径
+ `health_check()`：处理函数，请求进来后执行它
+ `return {"status": "ok"}`：响应结果，FastAPI 会自动转成 JSON

表示：

```text
GET /
```

访问后返回：

```json
{
  "status": "ok"
}
```

流程理解：

```text
用户访问 URL
↓
FastAPI 根据请求方法和路径匹配路由
↓
执行对应的 Python 函数
↓
返回响应结果
```

在 AI 客服项目里，核心路由是：

```python
@app.post("/chat")
def chat(request: ChatRequest) -> ChatResponse:
    ...
```

表示：

```text
POST /chat
```

+ `GET /`：用来检查服务是否正常
+ `POST /chat`：用来接收客户问题，并返回 AI 回复

## GET 和 POST

常见理解：

```text
GET：获取数据
POST：提交数据
```

在当前 AI 客服项目里：

```text
GET /       用来检查服务是否正常
POST /chat  用来提交客户问题，并获取 AI 回复
```

用户问题属于提交数据，所以用 `POST`。

## 请求参数

FastAPI 常见参数有三类：

```text
路径参数：/items/{item_id}
查询参数：/items?keyword=phone
请求体参数：JSON body
```

当前项目最重要的是“请求体参数”。

前端发送给后端的 JSON：

```json
{
  "message": "我的订单什么时候发货？"
}
```

这里的 `message` 就是请求体里的字段。

## Pydantic 请求模型

Pydantic 用来描述和校验请求数据。

当前项目中：

```python
class ChatRequest(BaseModel):
    message: str = Field(..., min_length=1)
```

含义：

```text
请求体必须有 message
message 必须是字符串
message 最少 1 个字符
```

这样可以避免接口收到空数据或格式错误的数据。

## Pydantic 响应模型

响应模型用来描述接口返回的数据结构。

当前项目中：

```python
class ChatResponse(BaseModel):
    reply: str
```

表示 `/chat` 接口返回：

```json
{
  "reply": "您好，请提供订单号，我可以帮您进一步确认发货状态。"
}
```

好处：

- 返回结构清晰。
- 前端知道应该读取 `reply` 字段。
- 后续接口文档会更规范。

## JSON 响应

FastAPI 可以直接返回字典，自动变成 JSON。

例如：

```python
return {"status": "ok"}
```

浏览器或接口测试工具看到的是：

```json
{
  "status": "ok"
}
```

当前项目 `/chat` 返回的是：

```python
return ChatResponse(reply=reply)
```

最终也是 JSON：

```json
{
  "reply": "AI 客服回复内容"
}
```

## 状态码

状态码用来表示接口请求结果。

常见状态码：

```text
200：成功
400：请求参数错误
422：FastAPI 自动参数校验失败
500：服务内部错误
502：调用外部服务失败
```

当前项目中：

```python
if not message:
    raise HTTPException(status_code=400, detail="message 不能为空")
```

表示：用户没有输入问题时，返回 400。

## 异常处理

异常处理是为了让错误信息更清楚，而不是直接让程序崩掉。

当前项目中：

```python
except RuntimeError as exc:
    raise HTTPException(status_code=500, detail=str(exc)) from exc
```

例如 `.env` 没有配置真实 API Key 时，后端会返回：

```json
{
  "detail": "请先在 .env 中配置真实的 DEEPSEEK_API_KEY"
}
```

这比直接报一大段 Python 错误更适合调试。

## 当前项目的 /chat 接口流程

```text
用户在 Streamlit 页面输入问题
↓
frontend/app.py 用 requests.post 调用 http://127.0.0.1:8000/chat
↓
FastAPI 接收 JSON：{"message": "..."}
↓
ChatRequest 校验 message
↓
调用 get_customer_service_reply(message)
↓
大模型返回客服回复
↓
FastAPI 返回 JSON：{"reply": "..."}
↓
Streamlit 页面展示 reply
```

## /chat 接口示例

请求：

```http
POST /chat
Content-Type: application/json
```

请求体：

```json
{
  "message": "我的订单什么时候发货？"
}
```

返回：

```json
{
  "reply": "您好，请提供订单号，我可以帮您进一步确认发货状态。"
}
```

PowerShell 测试命令：

```powershell
Invoke-RestMethod -Method Post `
  -Uri http://127.0.0.1:8000/chat `
  -ContentType "application/json" `
  -Body '{"message":"我的订单什么时候发货？"}'
```

## 和 Streamlit 的关系

Streamlit 是前端页面，FastAPI 是后端接口。

在当前项目里：

```text
frontend/app.py：负责页面输入和展示
backend/main.py：负责接收请求和返回 JSON
backend/llm_client.py：负责调用大模型
backend/prompts.py：负责客服提示词
```

Streamlit 调用 FastAPI 的核心代码逻辑是：

```python
requests.post(
    "http://127.0.0.1:8000/chat",
    json={"message": message}
)
```

## 学 FastAPI 今天要掌握什么

当前阶段只需要掌握够用内容：

- 知道 FastAPI 是后端接口框架。
- 会看懂 `app = FastAPI()`。
- 会看懂 `@app.get("/")` 和 `@app.post("/chat")`。
- 知道请求 JSON 里有 `message`。
- 知道返回 JSON 里有 `reply`。
- 知道 Pydantic 模型用于参数校验。
- 知道 `HTTPException` 用于返回错误信息。
- 会用 `uvicorn backend.main:app --reload` 启动后端。
- 会用 PowerShell、Apifox 或 Postman 测试接口。

## 你需要会解释的话

可以这样解释 FastAPI 在项目里的作用：

```text
FastAPI 负责提供后端接口。用户在 Streamlit 页面输入问题后，前端会把问题作为 JSON 发给 FastAPI 的 /chat 接口。FastAPI 校验 message 字段后，调用大模型生成客服回复，再把 reply 以 JSON 形式返回给页面。
```

可以这样解释 `/chat` 接口：

```text
/chat 是一个 POST 接口，请求体里需要传 message，表示客户的问题。接口返回 reply，表示 AI 客服生成的回复。
```

## 今日验收清单

- 能启动后端服务。
- 浏览器访问 `http://127.0.0.1:8000/` 能看到服务状态。
- 能用接口测试工具请求 `POST /chat`。
- 知道 `message` 和 `reply` 分别是什么。
- 能看懂 `backend/main.py` 的主要结构。
- 能解释为什么信息不足时不能编造订单、物流、退款状态。

## 后续再学

等 AI 客服项目继续推进时，再学这些内容：

- 中间件：统一处理请求、日志、跨域等。
- 依赖注入：管理数据库连接、用户身份、公共参数。
- ORM 和数据库：订单查询、会话记录需要用。
- 登录认证和 Token：后台管理或用户系统需要用。
- Redis 缓存：高频数据或会话缓存时再学。
- 项目结构拆分：接口变多后再做模块化。
