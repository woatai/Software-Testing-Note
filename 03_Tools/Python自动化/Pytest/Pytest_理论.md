# Pytest 理论基础

## 一、测试框架

测试框架: 抽象出来的工具集合，提供大量组件、工具、功能

+ 用例发现
+ 用例管理
+ 环境管理
+ 用例执行
+ 测试报告

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

   





















