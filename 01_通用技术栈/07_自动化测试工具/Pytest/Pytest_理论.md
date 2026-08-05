# Pytest 理论基础

## 一、测试框架

测试框架: 抽象出来的工具集合，提供大量组件、工具、功能

+ 环境管理  fixture
+ 用例发现  命令
+ 用例执行  命令行和代码 参数化
+ 用例管理  mark allure 
+ 测试报告  allure

背景：
     大部分编程语言，都有测试框架:
    java: junit，testng
    **python:. unittest, pytest**

|            | unittest         | pytest              |
| ---------- | ---------------- | ------------------- |
| 安装、卸载 | 无需安装         | 手动安装            |
| 升级、降级 | 无法改变版本     | 可以指定版本        |
| 代码风格   | Java语言         | Python语言          |
| 插件生态   | 只有几个插件     | 1400+插件涵盖各方面 |
| 备注       | 由python官方维护 | 完全兼容unittest    |

## 二、快速上手

**安装**

```sh
pip install pytest  # 安装
pip install pytest -u # 升级到最新版
```

**pytest 启动的三种方法**:

+ 命令行 

  + ```shell
    pytest
    ```

+ 代码 

  + ```python
    import pytest
    pytest.main()
    ```

+ 鼠标【不推荐】


**断言**

pytest 在简单的基础上，对断言进行高级封装（AST），对python数据结构断言，非常友好

1. pytest遵循了python简单的方式
2. pytest实现了很多高级特性

## 三、看懂结果

```shell
============================ test session starts =============================
collecting ... collected 2 items

test_base.py::test_ok FAILED                                             [ 50%]
test_base.py:3 (test_ok)
1 != 2

Expected :2
Actual   :1
<Click to see difference>

def test_ok():
        # open("main.py")
>       assert 1 == 2
E       assert 1 == 2

test_base.py:6: AssertionError

test_base.py::test_fail FAILED                                           [100%]
test_base.py:7 (test_fail)
def test_fail():
>       assert False
E       assert False

test_base.py:9: AssertionError


============================== 2 failed in 0.19s ==============================
```

> 1. 执行的用例数
> 2. 执行过程：文件名称、用例结果、执行进度
> 3. 失败详情：用例内容、断言提示
> 4. 整体摘要：结果情况、结果数量、花费时间

**用例结果缩写**

| 缩写 | 单词    | 含义                     |
| ---- | ------- | ------------------------ |
| .    | passed  | 通过                     |
| F    | failed  | 失败(用例执行时报错)     |
| E    | error   | 出错(fixture执行报错)    |
| S    | Skipped | 跳过                     |
| X    | xpassed | 预期外通过（不符合预期） |
| x    | xfailed | 预期内失败（符合预期）   |

## 四、用例规则

### 4.1 用例发现规则

> 测试框架在识别、加载用例的过程，称之为 ：用例发现

pytest的用例发现步骤:

1. 遍历所有的目录，例外:`venv`, 以`.`开头的目录会隐藏
2. 打开python文件，`test_`开头的文件 或者 `_test`结尾
3. 遍历所有的`Test`开头类  （类不是用例 方法才是 ）
4. 收集所有的`test_`开头的**函数或者方法**

### 4.2 用例内容规则

> pytest 8.4 增加了一个强制要求

pytest 对用例的要求：

1. 可调用的（函数、方法、对象、类）
2. 名字`test_`开头
3. 没有参数(参数有另外含义)
4. 没有返回值(默认为`None`)

### 4.3 练习

> 有函数 add 接收两个参数，并返回它们相加的结果 
>
> 请为此编写测试用例

```python
import pytest
def add(a,b):
    return a + b
# 正例
class TestAdd:
    def test_int(self):
        assert add(1, 2) == 3

    def test_str(self):
        assert add("1", "3") == '13'

    def test_list(self):
        assert  add([1],[2,3,4]) ==[1,2,3,4]

if __name__ == "__main__":
    pytest.main()
```

备注：

> 当函数重复的时候，用类 去封装 起到分组的作用

## 五、配置框架

配置 可以改变pytest 默认的规则

**查看所有的配置**

```shell
pytest -h
```

+ 查看有哪些配置
+ 分别有哪些方式
  + `-` 开头 ：参数
  + 小写字母开头： ini配置
  + 大写字母开头：环境遍历 （用的比较少）

+ 创建的配置文件 命令`pytest.ini`

**常用参数**

+ `-v` ：增加详细程度

+ `-s` ：在用例中正常的使用**输入输出**  

  + ```
    test_add.py::test_print 123
    ```

+ `-x`：快速退出，当遇到失败的用例停止执行  应用场景： 冒烟测试
+ `-m`：用例筛选

## 六、标记mark

标记 可以让用例与众不同，进而可以让用被区别对待

### 6.1 用户自定义标记

用户自定义标记 只能实现 用例筛选

步骤：

1. 先注册

   在`pytest.ini`文件去注册

   ```ini
   [pytest]
   markers =
       api = 接口测试
       web:UI测试
       ut:单元测试
       login:登录相关
       pay:支付相关
   ```

   ```shell
   (.venv) D:\python-objects\pytest01>pytest --markers
   @pytest.mark.api: 接口测试:
   
   @pytest.mark.web:UI测试
   
   @pytest.mark.ut:单元测试
   
   @pytest.mark.login:登录相关
   
   @pytest.mark.pay:支付相关
   ```

2. 再标记 通过装饰器进行装饰

   ```python
       @pytest.mark.api
       def test_int(self):
           assert add(1, 2) == 3
   
       @pytest.mark.web
       def test_str(self):
           assert add("1", "3") == '13'
   
       @pytest.mark.ut
       def test_list(self):
           assert  add([1],[2,3,4]) ==[1,2,3,4]
   ```

3. 后筛选

   ```shell
   python -v -m [对应的配置名 例如 api]
   ```

### 6.2 框架内置标记   

用户自定义标记为用例增加特殊执行效果

和自定义标记区别：

1. 系统内已配置 通过`pytest --marks`查看
2. 不仅可以筛选，还可以增加特殊效果
3. 不同的标记，增加不同的特殊效果
   + **skip：无条件跳过**
   + **skipif：有条件跳过**
   + **xfail：预期失败**
   + **parametrize：参数化**
   +  **Usefixtures：使用fixtures**

## 七、数据驱动测试参数

> 通过数据文件去决定测试用例的数量

1. 创建数据文件

   ```
   a,b,c
   1,2,3
   ...
   ```

   

2. 读取csv文件

   ```python
   def read_csv(path):
       with open(path, newline='', encoding='utf-8') as f:
           reader = csv.reader(f)
           next(reader)  # 跳过表头
   
           return [
               tuple(map(int, row))
               for row in reader
           ]
   ```

3. 驱动测试

   ```python
       @pytest.mark.parametrize(
           "a,b,c",
           read_csv("data.csv")
       )
       @pytest.mark.ddt
       def test_int_(self,a,b,c):
           assert add(a, b) == c
   ```

## 八、夹具fixture

fixture：由 pytest 管理的依赖提供机制。

它不只是“测试前执行、测试后清理”，还可以为测试提供数据、浏览器页面、配置对象、业务函数和当前测试的信息。

pytest 会根据测试函数的参数名称查找 fixture，递归准备它依赖的其他 fixture，按照作用域缓存结果，再把结果传给测试函数。

常见场景：

+ 提供测试数据，例如配置、YAML 数据和用户信息。
+ 创建并清理资源，例如浏览器页面、数据库连接和临时文件。
+ 组合多个 fixture，构建当前测试需要的数据包。
+ 读取当前测试模块、测试名称等运行信息。
+ 返回一个函数，让测试在合适的业务时机主动调用。

### 8.1 创建夹具

使用 `@pytest.fixture` 把普通 Python 函数注册为 fixture：

```python
@pytest.fixture
def settings():
    return checkout_settings
```

fixture 的基本创建过程：

1. 创建一个 Python 函数。
2. 添加 `@pytest.fixture` 装饰器。
3. 只需要提供数据时使用 `return`。
4. 测试结束后还需要清理资源时使用 `yield`。

**使用 `return` 提供数据**

项目中的 `settings`、`test_data` 和 `test_info` fixture 都会返回数据：

```python
@pytest.fixture(scope="session")
def test_data():
    return YamlReader.load(DATA_DIR / "test_data.yaml")
```

执行过程：

```text
pytest 发现测试需要 test_data
→ pytest 调用 test_data fixture
→ fixture 读取 YAML
→ return 把数据交给测试
→ fixture 函数结束
```

`return` 后不能再执行清理代码，因此它适合不需要释放的数据对象。

**使用 `yield` 提供资源并清理**

当前项目的 `page` fixture：

```python
@pytest.fixture
def page(context):
    page = context.new_page()
    page.set_default_timeout(PLAYWRIGHT_DEFAULT_TIMEOUT_MS)
    page.set_default_navigation_timeout(
        PLAYWRIGHT_DEFAULT_NAVIGATION_TIMEOUT_MS
    )
    yield page
    page.close()
```

可以把这个过程理解成“把浏览器页面借给测试，用完以后再收回来”：

1. `context.new_page()`：fixture 先创建一个浏览器页面。
2. `yield page`：把已经打开的页面交给测试使用，fixture 暂时不往下执行。
3. pytest 转去执行需要 `page` 的测试。
4. 测试结束后，pytest 回到 fixture 的 `yield` 后面。
5. `page.close()`：关闭测试使用完的浏览器页面。

对应三句话：

+ “把 `page` 对象提供给测试”：把已经打开的浏览器页面交给测试使用。
+ “暂停 fixture，等待测试执行”：fixture 先不往下执行，pytest 转去运行测试。
+ “测试结束后执行清理代码”：测试用完页面后，再回来执行 `page.close()`。

一句话记忆：

> `yield page`：把 `page` 借出去，等测试用完，再继续执行下面的清理代码。

`return` 和 fixture 中的 `yield` 对比：

| 写法 | 把什么交出去 | 测试结束后能否继续执行 fixture |
| --- | --- | --- |
| `return value` | 数据或对象 | 不能，fixture 已经结束 |
| `yield value` | 数据或资源 | 能，会从 `yield` 后继续执行清理代码 |

测试断言失败时，pytest 通常仍会执行 `yield` 后面的清理代码。如果 fixture 在到达 `yield` 之前就报错，测试不会开始，`yield` 后面的代码也不会执行。

**不要混淆两种 `yield`**

项目的报告 hook 中也有 `yield`：

```python
@pytest.hookimpl(hookwrapper=True)
def pytest_runtest_makereport(item, call):
    outcome = yield
    report = outcome.get_result()
```

它不是 fixture：

| 位置 | `yield` 的作用 | 谁接收结果 |
| --- | --- | --- |
| `page` fixture | 把 `page` 交给测试，测试结束后再清理 | 测试函数收到 `page` |
| `hookwrapper` | 暂停 hook，让 pytest 先生成测试报告 | hook 恢复后收到 `outcome` |

### 8.2 使用夹具

**通过测试函数参数使用**

测试函数不需要手动调用 fixture，只需要声明同名参数：

```python
def test_adyen_card(
    page,
    settings,
    checkout_data,
    ensure_payment_method,
    screenshot_context,
):
    checkout_url = settings.build_checkout_url(checkout_data)
    page.goto(checkout_url)
```

pytest 是这个测试函数的调用者。执行过程：

1. pytest 收集到 `test_adyen_card`。
2. pytest 读取测试函数的参数名称。
3. pytest 从测试模块、`conftest.py` 和插件中查找同名 fixture。
4. pytest 递归准备这些 fixture 的依赖。
5. pytest 把每个 fixture 的结果传给对应参数。
6. pytest 调用测试函数。

类型注解可以帮助阅读和编辑器提示，但 pytest 查找 fixture 时主要依据参数名称。

**使用 `usefixtures`**

不需要读取 fixture 返回值，只需要触发它的准备或清理行为时，可以使用：

```python
@pytest.mark.usefixtures("prepare_environment")
def test_submit_order():
    pass
```

两种使用方式的区别：

| 使用方式 | 是否执行 fixture | 测试能否取得 fixture 的返回值 |
| --- | --- | --- |
| 测试函数参数 | 是 | 能 |
| `@pytest.mark.usefixtures()` | 是 | 不能 |

项目的大部分 fixture 都会向测试提供数据或对象，因此使用测试函数参数更合适。

**fixture 可以依赖其他 fixture**

fixture 函数的参数也会由 pytest 注入：

```python
@pytest.fixture
def checkout_data(payment, test_data, test_info):
    return CheckoutDataBuilder.build(payment, test_data, test_info)
```

这里不是 `checkout_data()` 手动调用其他函数。pytest 会先准备 `payment`、`test_data` 和 `test_info`，再调用 `checkout_data`。

当前 UI 测试的主要依赖关系：

```text
test_adyen_card
├── page
│   └── context（pytest-playwright 插件提供）
├── settings
├── checkout_data
│   ├── payment
│   │   └── request（pytest 内置）
│   ├── test_data
│   └── test_info
├── ensure_payment_method
│   ├── payment_method
│   │   └── checkout_data
│   └── checkout_data
└── screenshot_context
    ├── request
    ├── payment_method
    └── checkout_data
```

pytest 会先创建依赖，再创建使用它们的 fixture；清理时顺序相反。

同一个测试中，`checkout_data` 虽然被多个 fixture 依赖，但在默认的 `function` 作用域内只会执行一次，其他地方取得的是这一次执行的缓存结果。

**参数出现在测试签名中就会触发 fixture**

项目测试体没有直接读取 `screenshot_context`，但它仍然写在测试函数参数中：

```python
def test_adyen_card(..., screenshot_context):
    ...
```

因此 pytest 会执行 `screenshot_context` fixture，并把结果保存到当前测试的 `item.funcargs`。测试失败后，报告 hook 再从 `item.funcargs` 取出它，用来生成失败截图名称。

### 8.3 高级用法

**作用域和缓存**

`scope` 决定一个 fixture 实例可以存活和复用多久：

| scope | 创建频率 | 常见用途 |
| --- | --- | --- |
| `function` | 每个测试函数创建一次，默认值 | 页面、当前用例数据 |
| `class` | 每个测试类创建一次 | 测试类共享资源 |
| `module` | 每个测试模块创建一次 | 单个测试文件共享数据 |
| `package` | 每个测试包创建一次 | 测试目录共享资源 |
| `session` | 整次 pytest 运行创建一次 | 只需加载一次的配置和 YAML |

当前项目中的例子：

+ `page`、`checkout_data`、`payment` 默认是 `function` 作用域。
+ `settings`、`test_data`、`test_info` 是 `session` 作用域。
+ `test_info` 中生成的邮箱会在同一次 pytest 运行中复用。

作用域越宽，数据共享时间越长。不要随意修改 `session` fixture 返回的可变字典，否则后面的测试可能读取到被污染的数据。

项目的支付失败用例使用 `deepcopy()` 创建副本后再替换卡数据：

```python
@pytest.fixture
def failed_checkout_data(checkout_data, jpay_failure_case):
    failure_data = deepcopy(checkout_data)
    failure_data["payment"]["card"] = deepcopy(jpay_failure_case["card"])
    return failure_data
```

较宽作用域的 fixture 不能依赖较窄作用域的 fixture。例如 `session` fixture 不能依赖默认的 `function` fixture，否则 pytest 会报告 `ScopeMismatch`。

注意：

> `scope` 决定生命周期，fixture 定义的位置决定可见范围，这两个概念不同。

**fixture 的可见范围**

| 定义位置 | 可被哪些测试发现 |
| --- | --- |
| 测试模块中的 fixture | 当前测试模块 |
| 某个目录的 `conftest.py` | 该目录及其子目录 |
| 项目根目录的 `conftest.py` | 项目测试目录中的测试 |
| pytest 插件提供的 fixture | 启用该插件的测试 |

pytest 会自动发现适用范围内的 `conftest.py`，测试文件不需要导入它。

根目录 `conftest.py` 中的 fixture 并不自动等于 `session` 作用域。例如项目的 `page` 定义在根目录 `conftest.py`，但没有声明 `scope`，所以仍然是每个测试创建一次。

当前项目重新定义了名为 `page` 的 fixture，因此它覆盖 pytest-playwright 插件提供的同名 fixture；同时继续依赖插件提供的 `context`：

```python
@pytest.fixture
def page(context):
    page = context.new_page()
    yield page
    page.close()
```

这样可以在项目内统一设置页面操作超时和导航超时。

**使用内置 `request` 读取当前测试信息**

`request` 是 pytest 提供的内置 fixture。项目的 `payment` fixture 通过它读取当前测试模块声明的 `PAYMENT_KEY`：

```python
@pytest.fixture
def payment(request):
    payment_key = getattr(request.module, "PAYMENT_KEY", None)
    if payment_key is None:
        raise KeyError("Payment test modules must define PAYMENT_KEY.")
    return payment_key
```

执行过程：

```text
测试模块声明 PAYMENT_KEY = "adyen_card"
→ pytest 执行 payment(request)
→ request.module 指向当前测试模块
→ payment 读取 PAYMENT_KEY
→ return "adyen_card"
```

`screenshot_context` 使用 `request.node.name` 读取当前测试名称。`request` 不是业务数据，而是 pytest 提供的当前执行上下文。

**fixture 可以返回一个函数**

fixture 不一定只返回静态数据。项目的 `ensure_payment_method` 返回内部函数 `_ensure`，简化后如下：

```python
@pytest.fixture
def ensure_payment_method(payment_method, checkout_data):
    def _ensure(checkout_page):
        payment_method_item = checkout_page.payment_method_item(
            payment_method
        )
        payment_method_item.wait_for(state="visible")

    return _ensure
```

测试接收到的是函数对象：

```python
ensure_payment_method(checkout_page)
```

执行过程：

```text
pytest 执行 ensure_payment_method fixture
→ fixture 创建并返回 _ensure 函数
→ 测试收到这个函数
→ 测试打开 checkout 页面
→ 测试在需要检查支付方式时主动调用 _ensure
```

这种写法常称为 factory fixture。它让 fixture 先保存公共依赖，再由测试决定业务动作的执行时机。

项目中的 `_ensure` 还会根据支付方式策略调用 `pytest.fail()` 或 `pytest.skip()`。因为 `_ensure` 是在测试体中调用的，所以结果发生在测试的 call 阶段，不属于 fixture setup 阶段报错。

**测试模块中的局部 fixture**

fixture 不一定都放在 `conftest.py`。只服务单个测试模块时，可以直接写在对应测试文件中。项目代码简化后如下：

```python
@pytest.fixture
def jpay_failure_case(test_data):
    return test_data["jpay_card"]["failure_cases"]["payment_failed"]
```

这个 fixture 只需要被 JPay Card 失败用例使用，因此放在对应测试模块中，不扩大共享范围。

**自动使用 `autouse`**

```python
@pytest.fixture(autouse=True)
def prepare_environment():
    ...
```

`autouse=True` 表示适用范围内的测试即使没有声明参数，也会自动执行这个 fixture。

它适合所有测试都必须执行的统一准备或清理，但会隐藏依赖关系，应谨慎使用。当前项目没有自定义 `autouse` fixture，主要使用明确的测试参数注入。

**参数化值和 fixture 的边界**

项目使用 `pytest_generate_tests()` 为 `checkout_currency` 生成多币种参数：

```python
def pytest_generate_tests(metafunc):
    if "checkout_currency" not in metafunc.fixturenames:
        return
    currencies = currency_config["cases"]
    metafunc.parametrize("checkout_currency", currencies, ids=currencies)
```

`pytest_generate_tests()` 是收集阶段运行的 hook，不是 fixture。`checkout_currency` 虽然也通过测试函数参数接收，但它的值来自参数化，不是来自 `@pytest.fixture` 函数。

```text
收集测试
→ hook 读取币种配置
→ 为 checkout_currency 生成多个参数值
→ pytest 为每个值生成独立测试实例
→ 执行每个测试实例需要的 fixture
```

**fixture 报错与测试失败**

| 发生位置 | pytest 通常显示 | 测试体是否执行 |
| --- | --- | --- |
| fixture 在 `return` 或 `yield` 前报错 | `ERROR`，setup 出错 | 否 |
| 测试断言不成立 | `FAILED` | 已执行 |
| `yield` 后的清理代码报错 | teardown 出错 | 测试体已经执行 |
| 测试中调用 `pytest.skip()` | `SKIPPED` | 执行到跳过位置 |

一句话记忆：

> pytest 看见测试参数名后，自动找到 fixture，先准备依赖，按 scope 缓存结果，把结果交给测试，最后按相反顺序清理资源。

## 九、常用的插件

### 9.1 pytest-html

用途：生成html测试报告

**安装**：

```shell
pip install  pytest-html
```

输入pytest 可以查询看到对应的 `plugins: html-4.2.0`

**使用**

在配置文件 `pytest.ini` 文件上去添加 

```ini
addopts = --html=report.html --self-contained-html
```

命令去输入 `pytest ` 后 根目录会有html的文件

### 9.2 pytest-xdist

用途：分布式进行

**安装：**

```shell
pip install pytest-xdist
```

**使用**

```shell
pytest -n N(表示数字)
```

**使用注意**

+ 只有在任务本身耗时较长，超出调用成本很多的时候，才有意义
+ 分布式执行，有并发问题:资源竞争、乱序  `不能使用`

### 9.3 pytest-rererunfailures

**安装**

```
pip install pytest-rererunfailures
```

**使用**

```shell
pytest -m rr --reruns 5 --reruns-delay 1 
```

### 9.4 pytest-result-log

用途：把用例的执行结果记录到日志文件中

**安装：**

```shell
pip install pytest-result-log
```

**使用**： 在日志文件进行配置

```ini
# ========== 文件日志（完整） ==========
log_file = ./logs/pytest.log
log_file_level = INFO
log_file_format = %(asctime)s [%(levelname)s] %(name)s | %(filename)s:%(lineno)s | %(message)s
log_file_date_format = %Y-%m-%d %H:%M:%S

# ========== 控制台日志（精简） ==========
log_cli = true
log_cli_level = WARNING
log_cli_format = [%(levelname)s] %(message)s

# ========== pytest-result-log ==========
result_log_enable = 1
result_log_separator = 1

# 分割线用 INFO，不污染 warning
result_log_level_separator = info

# 失败信息详细，但不刷屏
result_log_level_verbose = warning
```

## 十、插件管理

[Pytest Plugin List ](https://docs.pytest.org/en/stable/reference/plugin_list.html)

pytest 插件生态是pytest特别的优势之处

**插件分两类**：

+ 框架内置的：不需要安装
+ 第三方插件： 需要安装

**插件的启用管理**

+ 启用:`-p abc`
+ 禁用:`-p no:abc `

**插件使用方式:**

1. 参数
2. 配置文件
3. fixture
4. mark

## 十一、企业级测试报告

allure 是一个测试报告框架

### 11.1 基本使用

**安装**

```
pip install allure-pytest
```

**配置**

```ini
--alluredir=temps --clean-alluredir
```

**生成报告**

```shell
allure generate  -o report -c temps 
```

用代码去实现

```python
import os
pytest.main()
# 生成测试报告 -c 清除temps目录
os.system("allure generate  -o report -c temps ")
```

### 11.2 allure 敏捷开发

allure 支持对用例进行**分组和关联**

```tex
@allure.epic('电商系统')  表示项目
@allure.feature('下单')  表示模块
@allure.story('选择商品') 表示功能
@allure.title('选择规格为一的物料')   表示用例
```

```python

@allure.epic('电商系统')
@allure.feature('下单')
@allure.story('选择商品')
@allure.title('选择规格为一的物料')
@pytest.mark.ut
def test_a():
    pass

@allure.epic('电商系统')
@allure.feature('下单')
@allure.story('确认订单')
@allure.title('确认订单')
@pytest.mark.ut
def test_b():
    pass
```

## 十二、web自动化测试实战

pytest仅进行用例管理 ，**不会控制浏览器**，需要借助新的工具 **selenium**

练习：用selenium打开一个浏览器

```python
@pytest.mark.web
def test_web(selenium):
    selenium.get('https://www.baidu.com')
    print(selenium.title)
    time.sleep(1)
```

**尝试自己写插件**

## 十三、封装接口测试框架

接口自动化封装

+ 使用 yaml 作为用例，降低自动化门槛
+ 自动请求接口、断言接口
+ 自动在日志记录HTTP报文
+ 自动生成allure测试报告

### 13.1 yaml文件格式

**YAML完全兼容JSON格式，并且支持Python相似写法**

> 1.YAML完全兼容ISON
>
> 2.是数据格式，不是变成语言
>
> 3.像Python一样容易编辑和阅读

#### 13.1.1 安装yaml

```shell
pip install pyyaml
```

#### 13.1.2 使用yaml

1. `#` 作为注释符号
2. 缩进：使用2个空格
3. 成员表示
   + `-`表示列表成员
   + `:`表示字典成员
4. 兜底: 完全兼容JSON

```yaml
# 这是我的yaml文件
number:
  - -1
  - 1
  - 1.1

str:
  - "ada"
  - "12345"
  - "aa11233"

空值: null # json写法

字典: { "a": 1, "b": 2 } # json写法
```

#### 13.1.3 加载yaml文件

```python
# 封装yaml函数
def load_yaml(path):
    with open(path,encoding="utf-8") as f: # 用open方法读取系统文件
     s = f.read()
    data = yaml.safe_load(s)  # 调用yaml加载方法
    return data
print(load_yaml('test_case.yaml'))
```

### 13.2 接口测试用例

#### 13.2.1 设计用例内容

1. 名字: 请求首页数据接口

2. 标记[可选]

3. 步骤

   1. 请求接口:GET https://www.baidu.com

   2. 响应断言:status_code== 200

   3. 提取变量:json()['code']

#### 13.2.2 YAML表示用例

```yaml
# 登陆成功的用例

```



### 13.3 封装框架

#### 13.3.1 请求接口

外部工具 `requests`

```shell
pip install requests
```

从http协议抓包角度，请求由三部分组成

请求行：方法 加 地址

```python
import requests

# 地址
url = 'https://petstore.swagger.io/v2/pet/findByStatus?status=sold'

# get 方法
requests.get(url)
# post 方法
requests.post(url)

# 任意方法
requests.request('MOVE',url)
```

请求头 + 请求体（post）

```python
resq = requests.request(
    method,
    url,
    headers={"accept": "application/json", "Content-Type": "application/json"},  # 字典
    json={
        "id": 0,
        "category": {"id": 0, "name": "string"},
        "name": "doggie",
        "photoUrls": ["string"],
        "tags": [{"id": 0, "name": "string"}],
        "status": "available",
    },
)
print(resq.text)
```

#### 13.3.2 断言响应

响应：

响应头：状态码

响应行：键值对

响应体：响应正文

**获取响应**

```python
print(resq.status_code) # 响应码
print(resq.headers) # 头
print(resq.json()) # 响应正文 转成正文
```

**断言单个响应结果**

```python
# 断言单个内容是否正确
assert resq.status_code == 200
assert 'string' in resq.text
assert resq.json()['tags'][0]['name'] == 'striSng'
```

**断言所有内容**

```shell
pip install response_valiator
```

```python
# 接口断言 断言全部
validator(
  resq, # 写请求
  status_code=200,
  text='*string*',
  json = {
    'category': {
      'id':0
    }
  }
)
```

#### 13.3.3 提取变量

基本原则：

+ JSON：JSONPATH
+ HTML：XPATH
+ 字符串：RE

**RE是兜底的 因为其他本质上也是字符串**

json返回的是列表

```python
import jsonpath

data = {
  "hisdata": [{"time":1711199902,"kw":"maven生命周期","fq":2},
  {"time":1714492823,"kw":"全国软件水平考试"},
  {"time":1714528756,"kw":"苹果更新为什么说我无法连接到网络"},
  {"time":1714528831,"kw":"苹果更新需要充电吗"}]
}

# res = jsonpath.jsonpath(data,'$.hisdata')[0][0]['time']
print(res)
```

**封装提取json函数**

```python
def extract(resp,attr_name,exp):
  try:
    resp.json = resp.json()
  except Exception:
    resp.json = {}
   
  attr = getattr(resp,attr_name) # 反射 等价于 attr = resp.json
  res = jsonpath.jsonpath(attr,exp)
  return res[0]
```

**调用**

```python
from extract_util import extract
res = extract(resp,'json','$.tags[0].id')
print(res)
```

### 13.4 落地封装





