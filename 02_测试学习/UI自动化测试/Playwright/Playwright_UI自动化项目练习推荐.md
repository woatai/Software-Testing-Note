# Playwright UI自动化项目练习推荐

学习目标：围绕 `Python + pytest + Playwright + Allure + POM` 学会 Web UI 自动化测试，从基础操作、用例组织、页面封装，到形成一个可运行的小型自动化练习项目。

## 学习阶段定位

现在先按“测试学习”来推进，不急着包装成面试项目。

学习顺序：

1. 先学会 Playwright 基础操作。
2. 再学会 pytest 组织 UI 自动化用例。
3. 再学会 POM 页面对象封装。
4. 再补 Allure、截图、trace、配置管理。
5. 最后用一个小项目串起来。

## 为什么选择 Playwright

- Playwright 自带自动等待机制，更容易写出稳定脚本。
- 支持 Chromium、Firefox、WebKit，适合练跨浏览器测试。
- 支持截图、视频、trace，方便失败定位。
- Python 版本可以直接配合 pytest，你已有 pytest 和 Allure 基础，学习迁移成本低。
- 适合练 Web 登录、表单、后台查询、订单/支付前校验等常见测试场景。

## 第一优先级项目

### 1. GitHub：mofanx/pwtest

地址：https://github.com/mofanx/pwtest

定位：Playwright + pytest + Allure 脚手架。

适合原因：

- 技术栈和学习目标一致：Playwright、pytest、Allure。
- 包含 POM、状态管理、多浏览器、日志、视频录制、截图、并行测试等概念。
- 适合参考目录和 fixture 设计，然后复刻一个自己的小框架。

重点看：

- `config/`：环境、浏览器、账号等配置。
- `pages/`：页面对象。
- `tests/`：测试用例。
- `conftest.py`：pytest fixture。
- `pytest.ini`：mark、用例发现、执行参数。

练习任务：

- 跑通项目。
- 看懂目录结构。
- 复刻一个最小项目。
- 写登录、表单提交、后台查询 3 条用例。
- 加 Allure feature、story、step。
- 加失败截图。

### 2. GitHub：microsoft/playwright-pytest

地址：https://github.com/microsoft/playwright-pytest

定位：官方 pytest 插件。

适合原因：

- 这是 Playwright 配合 pytest 的官方插件，适合学习标准用法。
- 它提供 `page`、`browser`、`context` 等 pytest fixture。
- 先学官方插件，再做自己的封装，会更稳。

重点看：

- `page` fixture 怎么直接进入测试函数。
- `--browser chromium/firefox/webkit` 怎么做多浏览器。
- `--headed` 和 headless 模式怎么切换。
- 失败时怎么结合截图、trace、Allure 做定位。

### 3. Gitee：Bug_Mao/MyAutoProject

地址：https://gitee.com/Bug_Mao/MyAutoProject

定位：Gitee 上的 Python + Playwright + pytest UI 自动化框架。

适合原因：

- 国内 Gitee 项目，中文环境更容易看。
- 技术标签是 Python、Playwright、pytest、UI 自动化框架。
- 项目不算特别大，适合快速参考目录和运行方式。

练习重点：

- 跑通项目。
- 看目录分层。
- 看 pytest 怎么组织 Playwright 用例。
- 对比 GitHub 项目，整理自己的项目结构。

## 第二优先级项目

### 4. GitHub：cmoir/playwright_pytest_bdd_example

地址：https://github.com/cmoir/playwright_pytest_bdd_example

定位：Playwright + pytest-bdd 示例。

适合原因：

- 包含普通 pytest 写法和 BDD 写法。
- README 明确提到 Page Object 示例。
- 适合了解 BDD，但不建议作为主项目。

怎么用：

- 只看 Page Object 和 pytest 组织方式。
- BDD 先了解即可，不作为当前学习主线。

### 5. GitHub：Yudanova/autotests-ui

地址：https://github.com/Yudanova/autotests-ui

定位：Playwright Python + pytest + POM + Allure。

适合原因：

- GitHub topic 中明确描述：UI automation with Playwright Python and Pytest，包含 POM、fixture、Allure reporting。
- 适合补“框架完整度”。

怎么用：

- 参考目录设计。
- 参考 fixture 和 Allure 组织方式。
- 不需要完全照搬。

### 6. Gitee：Playwright topic 下的项目

地址：https://gitee.com/explore/topic/playwright

可关注：

- `Bug_Mao/MyAutoProject`：Python + Playwright + pytest。
- `liruyi/autotest_framework`：Selenium / Playwright / API 都有，但内容会更杂。
- `laker/EasyAutoTest`：Java + Playwright，除非后续要转 Java，否则只看设计思路。

## 暂时不建议主练

- Java + Playwright + TestNG 项目：技术栈偏离当前 Python 路线。
- Appium 项目：先把 Web UI 自动化学稳，APP 自动化后面再补。
- Selenium 项目：可以了解历史和差异，但当前主线固定为 Playwright。
- 太大的自动化平台项目：容易迷路，短期学习收益不高。

## 自己的练习项目结构

项目名建议：`playwright_ui_auto_practice`

目录建议：

```text
playwright_ui_auto_practice/
  config/
    settings.py
  pages/
    base_page.py
    login_page.py
    contact_page.py
    dashboard_page.py
    pricing_page.py
  tests/
    test_login.py
    test_contact_form.py
    test_dashboard_search.py
    test_pricing_checkout.py
  utils/
    data_loader.py
    screenshot.py
    logger.py
  testdata/
    users.yaml
    contact_form.yaml
  reports/
  screenshots/
  conftest.py
  pytest.ini
  requirements.txt
  README.md
```

必须实现的能力：

- pytest 管理用例。
- Playwright 控制浏览器。
- POM 封装页面。
- fixture 管理 browser、context、page。
- pytest mark 区分 smoke、regression。
- Allure 报告展示 feature、story、step。
- 失败截图。
- 配置文件管理 base_url、账号、浏览器、headless。

## 建议练习场景

### 场景 1：登录

覆盖点：

- 正确账号登录。
- 错误密码登录。
- 用户名为空。
- 密码为空。
- 登录成功后进入首页或 dashboard。

### 场景 2：Contact Us 表单

覆盖点：

- 必填项为空。
- 邮箱格式错误。
- 正常提交。
- 提交后提示文案。

### 场景 3：后台查询

覆盖点：

- 登录后台。
- 搜索客户、商品或订单。
- 按状态筛选。
- 校验列表结果。

### 场景 4：套餐页和支付前校验

覆盖点：

- 套餐价格展示。
- 月付/年付切换。
- 点击订阅进入 checkout。
- 支付页金额、币种、套餐名展示正确。

注意：真实支付不自动扣款，只做到沙箱环境或支付前校验。

## 学习成果标准

学完这一阶段，至少要能做到：

- 能解释 Playwright 是什么，和 Selenium 有什么区别。
- 能用 Playwright 打开页面、点击、输入、断言。
- 能用 pytest 运行 UI 自动化用例。
- 能写一个简单 Page Object。
- 能生成 Allure 报告。
- 能在失败时保留截图或 trace。
- 能搭出一个最小可运行的 UI 自动化测试项目。
