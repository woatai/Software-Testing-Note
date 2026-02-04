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

夹具：在用例**执行之前、执行之后**，自动运行代码

场景:

+ 之前:加密参数 /之后:解密结果 
+ 之前:启动浏览器 /之后:关闭浏览器   
+ 之前:注册、登录账号/之后:删除账号

### 8.1 创建夹具

```python
# 创建夹具
@pytest.fixture
def f():
    # 前置参数
    print(datetime.now(),"用例执行前")
    yield
    # 后置参数
    print(datetime.now(), "用例执行后")
```

**步骤**

1. 创建函数

2. 添加装饰器

3. 添加yield 生成器

### 8.2 使用夹具

1.  通过参数的形式进行夹具的使用

   ```python
   # 夹具传参
   def test_1( 夹具的函数名 ):
       pass
   ```
   
2.  给**用例**加上`usefixtures`标记
   
   ```python
   @pytest.mark.usefixtures("f")
   def test_2():
       pass
   ```



### 8.3 高级用法

1. 自动使用

```python
@pytest.fixture(autouse=True) # 加参数配置自动执行
def f():
    # 前置参数
    print(datetime.now(),"用例执行前")
    yield
    # 后置参数
    print(datetime.now(), "用例执行后")
```

2. 依赖使用

```python
@pytest.fixture()
def ff():
    print("我也是fixtrue ,依赖使用")
@pytest.fixture(autouse=True)
def f(ff): # 以·参数的形式去依赖 fixture
    # 前置参数
    print(datetime.now(),"用例执行前")
    yield
    # 后置参数
    print(datetime.now(), "用例执行后")
```

```shell
tests/test_jiaju.py::test_2 我也是fixtrue ,依赖使用
2026-01-27 23:00:41.878100 用例执行前
PASSED2026-01-27 23:00:41.878100 用例执行后
```

3. 返回内容： 接口关联、接口自动化封装

   ```python
   @pytest.fixture(autouse=True)
   def f(ff):
       # 前置参数
       print(datetime.now(),"用例执行前")
       yield  123 # 传递到用例使用
       # 后置参数
       print(datetime.now(), "用例执行后")
   # 夹具传参
   def test_1(f):
       print("收到 fixture",f)
       pass
   ```

4. 范围共享：  场景：多个用例之间 开关浏览器 容易造成资源浪费

   + **默认**范围：function （一个用例）
   + 全局范围：session   
     + 使用`conftest.py` 实现 跨文件的全局范围  
       + 在根目录 新建 `conftest.py` 文件
     + 》 命名空间 怎么跨空间 使用第三方空间

   ```python
   @pytest.fixture(scope='session')
   def ff():
       print("我也是fixtrue ,依赖使用")
   @pytest.fixture(autouse=True,scope='session')
   def f(ff):
       # 前置参数
       print(datetime.now(),"用例执行前")
       yield  123 # 传递到用例使用
       # 后置参数
       print(datetime.now(), "用例执行后")
   ```

   ```shell
   tests/test_jiaju.py::test_1 我也是fixtrue ,依赖使用
   2026-01-27 23:20:29.608055 用例执行前
   收到 fixture 123
   PASSED
   tests/test_jiaju.py::test_2 PASSED2026-01-27 23:20:29.609069 用例执行后
   ```


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

```



### 13.3 封装框架

1. 请求
2. 断言响应
3. 提取变量















