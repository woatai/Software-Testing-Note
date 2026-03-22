# Python

## 基础

### 一、标识符

#### 1.1 含义：程序员定义的变量名、函数名

1. 只能有数字、字母、_(下划线)组成
2. 不能以数字开头
3. 严格区分大小写

### 二、数值类型

#### 2.1 int整型（常用）：任意大小的整数

可以检测数据类型的函数是 `type（）`

#### 2.2 float 浮点型：小数

#### 2.3 bool布尔型（重点）

有固定写法，一个为True，一个为False

```python
print(True + False)
# 输出1
```

布尔值可以当作整型对待，True相当于整数l，False相当于整数0

2.4 complex 复数型（了解）

固定写法：z=a + bj --a是实部，b是虚部，j是虚部单位

```python
ma = 1 + 1j
ma2 = 2 + 2j
print(ma + ma2)
```

### 三、字符串str

特点：需要加上引号，单双引号都可以，包含了多行内容的时候也可以使用三引号

```
str = 'hello'
str1 = "sss"
str2 = """sd 
sdsa 
"""
print(str2)
```

### 四、格式化输出

##### 4.1 占位符

生成一定格式的字符串

##### 4.2 % 

1. **%s 字符串（常用）**

```python
name =  "NingNing"
print("My name is %s" % name)
```

2. **%d 整数（常用）**

```python
age = 18
name = "NingNing"
print("My name is %s 年龄是 %d" % (name, age))
```

3. **%4d 整数**

不足四位，前面补足空白

```python
num = 123
print("%4d" % num)
```

```tex
 123
```

```python
print("%04d" % num)
# 用0补全
```

```
0123
```

4. **%f 浮点数**

```python
f = 1.2345678
print("%f" % f)
# 默认6位浮点数
print("%.3f" % f)
# 设置三位浮点数
```

5. **%% 输出百分号**

```python
print("我是%%的1的%%" % ())
```

```
我是%的1的%
```

#### 4.3 f格式化

格式：`f"{表达式}"`

```python
age = 18
name = "NingNing"
print(f"My name is {name} ,my age is {age}")
```

### 五、算术运算符

使用算术运算符/，商一定是浮点数,且除数不能为0

```python
print(1/0)
```

`//` 向下取整

```python
print(5/2)
```

```
2
```

`%` 取余数

```python
print(5 % 2)
```

```
1 
```

`**` 取幂

### 六、输入函数input（）

```python
name = input("请输入你的名字")
print(name)
```

### 七、转义字符

`\t` 制表符 通常表示空四个字符，也称缩进

`\n` 换行符 

`\r` 回车

`\\` 反斜杠符号

```python
r"" #默认不转义
```

### 八、运算符

**比较运算符**

== !=  > < >= <= 

== 比较的是两个变量的值是否相等，相等的话就返回为True(真)，不相等返回为False(假)

!= 比较的是两个变量的值是否相等，不相等的话就返回为True(真)，相等返回为False(假)

**逻辑运算符**

and（与） or（或）

```python
if a == "hh" or/and b == "ss":
    print("11")
```

 not（非） 表示相反的意思

```python
print(not 3 < 9)
```

```
false
```

**三目运算符**（三元表达式）

```python
a = 9
b = 6
print( "a > b") if a > b else print("a < b ")
```

#### if 运算符

**if elif**

```python
score = input("请输入你的成绩:")
if score == "100":
    print("你真棒")
elif score == "60":
    print(f"keep running {type(score)}")
else:
    print("可以了")
```

**if嵌套** 

```python
ticket = True
temp  = 36.3
# 判断是否有车票
if ticket == True:
    print("可以进站了，", end="")
    if 36.3 <= temp <= 37.2:
        print("体温正常，安心回家")
else:
    print("不能进站")

```

### 九、循环语句

#### 9. 循环语句



#### 9.2 while循环

模版

```python
i = 0
while i < 100:
    print("running")
    i += 1
```

> 从1加到100，计算他们之和

```python
a = 1
i = 1
while i < 100:
    a = a + i + 1
    i += 1
print(a)
```



#### 9.3 for循环

基本格式

>  for 临时变量 in 可迭代对象：
> 	循环体

```python
str = '1234' # 字符串是可迭代对象
for i in str:
    print(i)
```

> 练习
>
> 1 加到 100 for

```python
s = 0
for i in range(1,101): # range() 左闭右开 
    s += i
    print(i)
print(i)
```

`range（start,end,step）` 

左闭右开
range（5）：默认从零开始

#### 9.4 break和continue

**break**

结束循环

```python
i = 1
while i <= 5:
    print(f"吃到第{i}个苹果")
    if i == 3:
        print(f"第{i}个苹果有虫子")
        break
    i += 1
```

**continue**

跳出本次循环，下一次循环继续执行

```python
i = 1
while i <= 5:
    print(f"吃到第{i}个苹果")
    if i == 3:
        print(f"第{i}个苹果有虫子")
        i += 1 #需要修改计数器，不然会导致死循环
        continue 
    i += 1
```

for 循环下continue不需要加 i += 1

```python
for i in range(5):
    if i == 3:
        continue
    print(i)
```

### 十、字符串

#### 10.1 字符串编码与常用操作

本质上就是二进制数据与语言文字的一一对应关系

**Unicode**

所有字符都是2个字节  

好处:字符与数字之间转换速度更快一些

坏处:占用空间大

**UTF-8**

精准，对不同的字符用不同的长度表示

优点：节省空间

缺点：字符与数字的转换速度较慢，每次都需要计算字符要用多少个字节来表示。

**字节编码转换**

```python
# 字符串编码转换
a = 'hello'
print(a,type(a)) # str,字符串是以字符为单位进行处理
a1 = a.encode("utf-8") # 编码
print(type(a1)) # bytes,以字节为单位进行处理
a2 = a1.decode("utf-8") # 解码
print(a2,type(a2))
# 对于types，这是他跟字符串类型之间的相互转换
```

##### 10.1.1 字符串操作

```python
# 字符串操作
print ("a" + "a")
print("a","a",sep="") # 两个字符串取消空格拼接

```

##### 10.1.2 重复输出

```python
print("a\n" * 10 ) #输出十个a
```

##### 10.1.3 成员运算符

作用：检查字符串中是否包含了某个子字符串(某个字符或多个字符)

+ in :如果包含的话，返回True，不包含返回False

+ not in:如果不包含的话，返回True,包含返回False

```python
name = "bing"
print('s' in name)
print("b" in name)
print('s' not in name)
print("b" not in name)
```

##### 10.1.4 下标

python 下标从0开始

作用：通过下标可以快速找到对应的数据

格式:字符串名【下标值】

```python
name = "bing"
print(name[0])  #下标从0开始数
print(name[1])
print(name[-1])   #从右到左是从-1开始数
```

##### 10.1.5 切片

含义：指对操作的对象截取其中一部分的操作

语法：【开始位置：结束位置：步长】

包前不包后:即从起始位置开始，到结束位置的前一位结束(不包含结束位置本身)

```python
st = "asdfghjkl"
# 从左到右
print(st[0:2])
# 从右到左
print(st[:-1])  # asdfghjk
print(st[-1:]) # l

```

#### 10.2 字符串常见操作

###### 10.2.1 查找

find:检测某个子字符串是否包含在字符串中，如果在就返回这个子字符串开始位置的下标，否则就返回`-1`

find(子字符串,开始位置下标,结束位置下标)	

注意：开始和结束位置下标可以省略，表示在整个字符串中查找

```python
# 查找字符串
name = "ceshi"
print(name.find('i'))
# 4
print(name.find('i', 3,4))
# -1   包前不包后 
```

 返回某个字符出现次数

count():返回某个子字符串在整个字符串中出现的次数，没有就返回0

count(子字符串,开始位置下标,结束位置下标)

##### 10.2.2 判断

startswith():是否以某个子字符串开头，是的话就返回True,不是的话就返回False,如果设置开始和结束位量

则在指定范围内检查

startswith(子字符串,开始位置下标,结束位置下标)

```python
st = "zhangSan"
print(st.startswith("zh"))
```

是否以某个子字符串结尾，是的话就返回True,不是的话就返回False,如果设置开始和结束位置则在指定范围内检查

endswith(子字符串,开始位置下标,结束位置下标)

#### 10.3 修改元素

##### 10.3.1 replace

replace(旧内容，新内容，替换次数)

注意:替换次数可以省略，默认全部替换

```python
name = "aaasss66666"
print(name.replace('6','8',3))
```

##### 10.3.2 split()

指定分隔符来切字符串   --以列表的形式返回

```python
st = "hello test."
print(st.split(' '))  # ['hello', 'test.']
```

#### 10.4 列表 

**列表之间的数据类型各不相同**

**列表是可以迭代对象，可以用for循环遍历取值**

```python
li = [1,2,"a","s "]

for i in li:
    print(i,type(i))
    
print(li[0:3])  # [1, 2, 'a']  切片
```

##### 10.4.1 添加元素

append（）  extend（）  insert（）

```python
li = ['one','two','three']

li.append("four")   # append 整体添加
print(li) # ['one', 'two', 'three', 'four']

li.extend('four')   # 分散添加
print(li) # ['one', 'two', 'three', 'four', 'f', 'o', 'u', 'r']

li.insert(3,"6666")  # 指定索引 添加
print(li)  # ['one', 'two', 'three', '6666', 'four', 'f', 'o', 'u', 'r']
```

注意：

extend是分散添加，不是可迭代对象不能添加，比如 extend（4）是不允许的，

因为int类型不是可迭代对象

##### 10.4.2 修改元素

直接通过下标去修改

```python
li = ['one','two','three']
li[0] = 'body'
```

##### 10.4.3 查找元素

in： 判断指定元素是否在列表中，如果存在就返回true，如果不存在就返回false
not in：判断指定元素是否不在列表中，返回结果与in 取反

```python
while True:
    name = input("请输入你的昵称: \n")
    if(name in name_list):
        print(f"该昵称 {name} 已经存在")
    else:
        print(f"该昵称 {name} 可以使用")
        name_list.append(name)
        print(name_list)
        break
# 查找 列表中的文字，如果没有就添加
```

##### 10.4.4 删除元素

**del**

```python
# 删除元素
li = ['a','b','c','d']
# del li # 删除列表
del li [-1]  #根据下标删除元素
print(li)
输出 ['a', 'b', 'c']
```

**pop**

```python
li.pop(0)  # 根据下标删除元素
li.pop()  # 默认删除最后一个元素
print(li)
```

**remove**

```python
li.remove('b')  # 根据元素的值进行删除 (默认删除出现的第一个)
```



##### 10.4.5  排序元素

`sort`: 将列表按特定顺序重新排列，默认从小到大

`reverse`: 倒序，将列表倒置(反过来)

```python
# 5.5 排序
li = [1,3,2,545,34,22]
li.sort()
print(li)
li.reverse()
print(li)

# [1, 2, 3, 22, 34, 545]
# [545, 34, 22, 3, 2, 1]
```

#### 10.5 列表推导式

**格式一**：【表达式 for 变量 in 列表】

注意：in后面不仅可以放列表，还可以放range()、可选代对象

```python
# 输出1-6 
[print(i * 5) for i in range(1,7)]

```



**格式二**：【表达式 for 变量 in 列表 if 条件 】

 ```python
# 把奇数放进列表里面
# 在范围内， 把奇数放进列表里面
li = []
num = int(input("输入有限范围内的奇数，比如输入10，表示在0到10之间\n"))
[li.append(i) for i in range(1,num) if i % 2 == 1 ]
print(li)
 ```



### 十二、元组和字典

#### 12.1 元组

##### 12.1.1 tuple

>  基本格式:元组名=(元素1,元素2,元素3）
>
> 所有元素之间用 ，隔开，不同的元素可以是不用的数据类型

```python
tub= (1,2,"a",)
print(type(tub))
# <class 'tuple'>
```

`注意`

只有一个元素的时候，要加 “,”

```python
tub1 = (1,)
print(type(tub1))
# <class 'tuple'>
```

##### 12.1.2 元组与列表的区别

1. 元组只有一个元素末尾必须加 "," 列表不需要

   ```python
   1i =[1]
   print(type(li))
   ```

   

2.  元组只支持查询操作，不支持增删改操作

   ```python
   tub=(1,2,3)
   print(tub[2])
   ```

   

##### 12.1.3 元组的应用场景

+ 函数的函数和返回值

+ 格式化输出后面的()本质上就是一个元组

  ```python
  name = "james"
  age = 18
  
  info = (name,age)
  print(type(info))
  print("%s的年龄是%d" % info)
  
  # <class 'tuple'>
  # james的年龄是18
  ```

  

+ 数据不可以被修改，保护数据的安全



#### 12.2 字典

##### 12.2.1 字典的定义

以键值对的形式存在

```python
dic =  {'name':'james'}
print(type(dic))
# <class 'dict'>
```

键具有唯一性，值可以重复

```python
dic =  {'name':'james','name':"sss"}
print(dic)
# {'name': 'sss'}
```

> 重复的键会把前面的值覆盖

##### 12.2.2 查看元素

**get（）**

````python
dic =  {'name':'james','age':18}
print(dic.get('age'))
````

如果搜索的元素不存在的话，可以自定义提示 语

```python
dic =  {'name':'james','age':18}
print(dic.get('hh',"找不到"))
# 找不到
```

##### 12.2.3 修改元素

变量名[键名]=值

```python
dic['name'] = 'lebron'
print(dic.get('name'))
```

字典通过键名去修改

##### 12.2.4  增加元素

变量名[键名]=值

存在就修改，不存在就新增

````python
dic['name'] = 'lebron'
````

##### 12.2.5 删除元素

**del**

删除整个字典   del 字典名

删除指定键值对	

```python
del dic['name']
print(dic['name'])
```

如果是删除不存在的键会报错 `keyerror`

**clear**

清空整个字典的东西，但是保留了这个字典

```python
dic =  {'name':'james','age':18}
dic.clear()
print(dic)
```

**pop()**

删除键值对,键不存在就报错；

```python
dic =  {'name':'james','age':18}
# dic.clear()
dic.pop('name')
dic.pop('gfff') # 删除不存在的键位的时候， 会报KeyError: 'gfff'的错误	

dic.popitem()  #  3.7之前的版本是随机删除一个键值对， 3.7之后的版本默认删除最后一个键值对
print(dic)
```

##### 12.2.6 字典常见操作二

**len（）**

返回字典的长度

```python
print(len(dic))  # 1
```

**keys()** 

返回字典里的所有键名

```python
print(dic.keys())
dict_keys(['name'])

for i in dic.keys():
    print(i)
    print(type(i))
    
# name
# <class 'str'>
```

**values()**

返回字典的所有的值

```python
for i in dic.values():
    print(i)
    print(type(i))
# james
# <class 'str'>
```

**items()**

返回字典的里所有用的键值对

````python
for i in dic.items():
    print(i)
    print(type(i))
    
# ('name', 'james')
# <class 'tuple'>
# ('age', 18)
# <class 'tuple'>
````

> 字典的应用场景
>
> 使用键值对，存储描述一个场景的相关信息

#### 12.3 集合

##### 12.3.1 基本格式

集合名={元素1，元素2，元素3，，，，}

```python
set1 =  {1,2,3}
print(set1)
print(type(set1))

# 定义空字典
s1 = {}
print(type(s1)) 
# 定义空集合
s2 = set()
print(type(s2))
```

##### 12.3.2 集合具有无序性

```python
# 数字排序一样
s1 = {1,2,3,4,5,6,7,8,9}
print(s1)

# 字母排序每次结果不一样
s2 = {'a','b','c','d'}
print(s2)
```



+ 每次运行结果都不同，hash值不同，那么在hash表中的位置也不同，这就实现了集合的无序性
+ python中int整型的hash值就是它本身，在hash表中的位置不会发生改变，所以顺序也不会改变

```python
print(hash(1)) #1
print(hash(2)) #2

print(hash('1'))  # 550524749
print(hash('2'))  # -1145006599
```

> 利用无序性，集合能够实现唯一性，自动去重，不能修改

##### 12.3.3 集合的常见操作

add  添加元素

```python
s1 = {1,2,3,4}
s1.add(5)  # 
s1.add(4)  # 集合的唯一性，决定了如果需要添加的元素在原集合中已经存在，就不进行任何操作
s1.add((2,3)) # 一次只能添加一个元素
print(s1)
```

update()  离散添加 (对象是可迭代对象)

```python
l1 = ['1','2','3']
s1.update(l1)
```

remove  选择删除的元素，如果集合中有就删除，没有就会报错

```python
s1 = {1,2,3,4}
s1.remove(1)
print('删除后的',s1)
```

pop  对集合进行无序排列，然后将左边的第一个元素删除

```python
s1 = {1,2,'3','4'}
print('原集合：',s1)
s1.pop()
print('删除后的集合：',s1)

# 原集合： {1, 2, '4', '3'}
# 删除后的集合： {2, '4', '3'}
```

discard: 选择要删除的元素，有就会删除，没有则不会发生任何改变，即不会进行任何操作

```python
s1 = {1,2,'3','4'}
print('原集合：',s1)
s1.discard(2)
print('删除后的集合：',s1)
```



#### 12.4 交集和并集

& 交集  ；空就显示set() 

|  并集 ；重复的不算，集合的唯一性



###  十三、类型转换

**int()**

> 浮点型强转整型会去掉小数点及后面的数值，只保留整数部分

```python
a = 1.7
b = int(a)
print(b)
# b = 1 
```

> 字符串转整型 ，除了数字和+、-以外的字符串会报错

```python
c = '123'
d = int(c)
print(d , type(d))

# 123 <class 'int'>
```

```
如果字符串中有数字和正负号(+/-)以外的字符就会报错
print(int(10-’)) #报错
+/-不可以写在后面
```

**float()**

> 整型转换为浮点型，会自动添加一位小数
>
> 字符串转浮点型 ，除了数字和+、-以外的字符串会报错`

```python
print(float(11))
# 11.0
print(float('11'))
print(float('+11'))
```

**str（）**

> 任何类型都可以转换字符串类型，包括列表，字典

```python
print(type(str(1.66666)))
```

**eval（）**

> 可以实现list、dict、tuple和str之间的转换

```python
str = "['1',1,1]"
print(eval(str))
```

> 非常强大，但是不够安全，容易被恶意修改数据，不建议使用

**list()**

> 支持转换为list的类型，str，tuple，dict，set（可迭代对象）

```python
str = 'abcdef'
print(list(str))
# dict 
print(list({'name':"abc",'age':14})) # ['name', 'age']
# tuple  元组
```

### 十四、赋值、深浅拷贝、可变与不可变对象

#### 14.1 赋值

```python
li= [1,2,3,4]
print(li)
# 把li赋值给li2
li2 = li
print("赋值后的li2",li2)
print("li",li)
li.append(5)
print("li2:",li2)
print("li:",li)

# li2: [1, 2, 3, 4, 5]
# li: [1, 2, 3, 4, 5]
```

> 赋值：对象引用的绑定,a  和 b 都指向同一个内存图

#### 14.2 浅拷贝

> 会创建新的对象，拷贝第一层的数据，嵌套层会指向原来的内存地址

```python
# 定义一个嵌套列表
import copy
li= [1,2,3,4,[1,2,3]]
copyli  = copy.copy(li)
print("li的内存地址",id(li))
print("copyli的内存地址",id(copyli))

# li的内存地址 32951144
# copyli的内存地址 32985736

li[4].append(4)
print("li:",li)
print("copyli:",copyli)

# li: [1, 2, 3, 4, [1, 2, 3, 4]]
# copyli: [1, 2, 3, 4, [1, 2, 3, 4]]
```

`浅拷贝：外层地址不同，内层地址一样`

#### 14.3 深拷贝

deepcopy()

```python
import copy
li= [1,2,3,4,[1,2,3]]
copyli  = copy.deepcopy(li)  # 深层拷贝
print("li的内存地址",id(li))
print("copyli的内存地址",id(copyli))
# li.append(5)
print("li:",li)
print("copyli:",copyli)
li[4].append(4)
print("li:",li)
print("copyli:",copyli)
```

> 深拷贝数据变化只影响自己本身，跟原来的对象没有关联



#### 14.4 可变类型

含义：变量对应的值可以改变，但是内存地址不会改变

常见的可变类型：`list，dict，set`

```python
li = [1,2,3,4]
print("li的内存地址：",id(li))
li.append(5)
print("添加后li的内存地址：",id(li))

# li的内存地址： 17664488
# 添加后li的内存地址： 17664488

s = {1,2,3,4}
print(id(s))
```



#### 14.5 不可变类型

含义:存储空间保存的数据不允许被修改，这种数据就是不可变类型

> 数值类型：int，bool，float，complex
>
> 字符串：str
>
> 元组：tuple

```python
a = 1
print('a的内存地址：',id(a))
a = 2
print('a的内存地址：',id(a))

a的内存地址： 16121984
a的内存地址： 16122000
```

> 注意：前面所说的深浅拷贝只针对可变对象，不可变对象没有 拷贝 的说法

### 十五、函数

**函数**

含义:将独立的代码块组织成一个整体，使其具有特殊功能的代码集，在需要的时候再去调用。

`定义函数并调用`

```python
def hello():
    print("hello")
hello()
```

`返回值 return`

```python
def buy():
    return 'hello'
print(buy())
```

> 返回值：三种情况总结
>
> 1. 无返回值，返回none
> 2. 返回一个值，将值返回给调用者
> 3. 返回多个值，以元组的形式返回给调用

`print和return的区别`

return 是有返回值，print是打印结果

**参数**

定义格式：

> def 函数(形参a，形参b)：
> 	函数体
>
> 调用格式：
> 函数名（实参1，实参2）

```python
def add(a=0,b=0):
    return a+b
print(add())
```

**必备参数**

含义：传递和定义参数的顺序及个数必须一致

> 格式：
>
> ```python
> def func(name,age,sex):
>     print(name)
>     print(age)
>     print(sex)
> func('a',18,'man')
> ```

**默认参数**

含义: 为参数提供默认值，调用函数时可不传该默认参数的值

> 格式：
>
> ```python
> def func(a=8):
>     print(a)
> ```

**可变参数**

含义:传入的值的数量是可以改变的，可以传入多个，也可以不传

> 格式 :
>
> ​	def func(*args)
>
> *args将实参所有的位置参数接收，放置在一个元组中。
>
> ```python
> def var(*args):
>  print(args)
>  print(type(args))
> var('a',1,1.222)  以元组的形式接收
> 
> ('a', 1, 1.222)
> <class 'tuple'>
> ```

**关键字参数**

含义：传入键值对	

> 格式：def func（**kwargs）
>
> ```python
> def fund(**kwargs):
>     print(kwargs)
>     print(type(kwargs))
> fund()
> fund(name = 'james',sex = 'man')
> ```
>
> 作用：可以扩展函数的功能

#### 15.1函数嵌套

> ```python
> def buy():
>     print('buy someThing')
> def cooking():
>     buy()  # 调用
>     print('cook')
> cooking()
> ```

#### 15.2 函数嵌套定义

含义： 在一个函数中定义另外一个函数

> ```python
> def study():
>     print('11')
>     def run():
>         print('run')
>     run()
> study()
> ```

#### 15.3 作用域，匿名函数、内置函数与拆包

##### 15.3.1 作用域

含义: 指的是变量生效的范围，分为两种，分别是全局变量和局部变量

**全局变量**

> 函数外部定义的变量，在整个文件中都是有效的
>
> ```python
> a = 100
> def test1():
>     a = 80
>     print(a)
> test1()
> print('调用后的数字',a)
> ```
>
> a的值没有被覆盖是因为函数内部如果要使用变量，会先从函数内部找，有的话就直接使用。没有会到函数外面去找。

**局部变量**

> 函数内部定义的变量，从定义位置开始到函数定义结束的位置有效
>
> ```python
> def func():
>     a = 80
> ```

**声明全局变量**

> 在函数内部声明全局变量
>
> ```python
> a = 100
> def test1():
>     global a,b
>     a = 80
>     b = 70
>     print(a)
> test1()
> print('调用后的数字',a)
> ```

**nonlocal**

> 用来声明外层的局部变量，只能在`嵌套`函数中使用，在外部函数先进行声明，内部函数进行nonlocal声明
>
> ```python
> def test1():
>     a = 80
>     def study():
>         nonlocal a
>         a = 70
>         print('study的',a)
>     study()
>     print('test1的',a)
> test1()
> ```

##### 15.3.2 匿名函数

**基本语法**

> 函数名 = lambda 形参 ： 返回值（表达式）
>
> 调用：结果 = 函数名（实参）
>
> ```python
> # 普通函数
> def add(a,b):
>     return  a+b
> print(add(1,3))
> 
> # 匿名函数
> add  = lambda a,b:a+b
> print(add(1,3))
> ```
>
> `lambda不需要写return来返回值，表达式本身结果就是返回`

**多种参数**

> ```python
> # 一个参数
> funb = lambda name : name
> print(funb('我是谁'))
> 
> # 默认参数
> func  = lambda name,age = 8: (name,age)
> print(func('james',40))
> 
> # 关键字参数
> fund = lambda **kwargs :kwargs
> print(fund(name = 'james',age = 18))
> ```

**lambda结合if判断**

> ```python
> a = 5
> b = 6
> fune = lambda a,b : 'a>b' if a > b else 'a<b'
> print('结果',fune(a,b))
> ```

**内置函数**

> **abs()** 返回绝对值
>
> **sum()** 求和 sum函数里要放可迭代对象，字符串和整型是不可迭代对象
>
> **min()**
>
> **max (1,1,key = abs())**

##### 15.3.3 zip()

> 含义：将可迭代对象作为参数，将对象中对应的元素打包成一个个元组
>
> ```python
> li = [1,2,3]
> li2 = ['a','b']
> print(zip(li,li2))
> for i in zip(li,li2):
>     print(i)
>     print(type(i))
>     
>     
> (1, 'a')
> <class 'tuple'>
> (2, 'b')
> <class 'tuple'>
> ```
>
>  如果元素个数不一致，就按照长度最短的返回

##### 15.3.4 map()

> 可以对`可迭代对象`中的每一个元素进行`映射`，分别去执行
>
>  map(func,iter)   func: 自定义的函数，iter： 可迭代的对象
>
> ```python
> # map()
> li = [1,2,3,4]
> def func(x):
>     return x * 5
> mp = map(func,li)
> print(mp)
> # 1.for 循环打印
> for i in mp:
>     print(i)
> # 2. 转换为list函数
> print("list函数",list(mp))
> 
> [5, 10, 15, 20]
> [5, 10, 15, 20]
> ```

##### 15.3.5 reduce()

> 先把对象中的两个元素取出来，计算出一个值然后保存着，接下来把这个计算值跟第三个元素进行计算
>
> 使用前 需要导包
>
> ```python
> from functools import reduce
> li = [1,2,3,1]
> def add(x,y):
>     return x + y
> res = reduce(add,li)
> print(res)
> ```
>
> **reduce(function,sequence)** 
>
>   `function` 自定义函数： 必须是有两个参数的函数
>
>   `sequence` 序列： 必须是可迭代对象  

#### 15.4 拆包

> 含义： 对于函数中的多个返回数据，去掉元组，列表或者字典 直接获取里面数据的过程。
>
> `方法一`
>
> ```python
> tua = (1,2,3,4)
> a,b,c,d = tua
> print(a,b,c,d)
> ```
>
> ```
> 要求元组内的个数与接收的变量个数相同，对象内有多少个数据就需要定义多少个变量接收
> ```
>
> `方法二`
>
> ```python
> tua = (1,2,3,4)
> a,*b =tua
> print(a,*b)
> b,c,d = *b
> ```
>
> ```
> 先把单独的给它取完，其他剩下的全部都交给带*的变量
> ```
>
> ```python
> # 函数调用
> def func(a,b,*args):  
> ```

#### 15.5 异常模块与包

#### 15.5.1 raise 

>  抛出异常
>
> `需求:密码小于6时，抛出异常`
>
> ```python
> def login():
>     pwd = input('请输入密码:',)
>     if len(pwd) >= 6:
>        return '密码输入成功'
>     raise Exception('密码小于6位')
> try:
>     print(login())
> except Exception as e:
>     print(e)
> ```
>
> ```
> 逻辑 
> 1.这是在函数内部抛出异常，函数内部没有接住
> 2.函数调用的时候再去捕获异常
> ```

#### 15.6 导入

> 导入整个模块
>
> ```python
> # 导入模块  并且调用函数和变量名
> import pytest
> print(pytest.name)
> pytest.funa()
> ```
>
> 导入模块中的功能，调用就直接写功能就好了
>
> ```python
> from pytest import funa
> funa()
> 
> # 这个是pytest函数
> # 调用函数funa()
> ```
>
> `*`号代表 全部导入
>
> ```python
> from pytest import *
> ```

> 不建议过多使用from...import...声明，有时候命名冲突会造成一些错误
>
> 推荐使用import模块，用模块前缀的方进行调用，比如：match.funa()

#### 15.6.2 as起别名

> as给功能起别名
>
>  语法：
>
> ```python
> from pytest import funa as a,funb as b 
> ```

#### 15.7 内置全局变量

> 语法
>
> ```python
> # 内置变量  __name__
> if __name__ == '__main__':
> ```
>
> 作用
>
> ```
> 控制代码在被直接运行时才执行，而在被导入时不执行；
> 它通常放在你希望作为入口的文件中，
> 或者放在你希望可独立运行测试的模块中。
> ```
>

#### 15.8 包

> 含义：就是项目结构中的文件夹/目录
>
> 与普通文件夹的区别：包是含有`__init__.py`的文件夹
>
> 作用:将有联系的模块放到同一个文件夹下,有效避免模块名称冲突问题，让结构更清晰

##### 15.8.1 新建包

> 新建包的时候，会默认新建`__init__.py`的文件夹
>
> `__init__.py`
>
> ```python
> # 导入其他模块
> from pack_01 import register
> ```
>
> 导入包
>
> ```
> import pack_01
> ```

#### 15.8.2 `__all__`

> 本质上是一个列表，列表里面的元素就代表要导入的模块
>
> `init.py`
>
> ```python
> __all__ = ['register','log']
> ```
>
> `调用函数`
>
> ```python
> from pack_01 import *
> register.reg()
> log.log()
> ```

#### 15.8.3 递归函数

优点：代码简洁，

缺点：使用递归函数的时候，需要反复调用函数，耗内存，运行效率低



#### 15.8.4 闭包

##### 条件

+ 函数嵌套(函数里面再定义函数)
+ 内层函数使用外层函数的局部变量
+ 外层函数的返回值是内层函数的函数名

```python
def outer():
    a = 10
    def inner(c):
        b = 5
        print(a+b+c)
    return inner
```

```python
调用一、
outer()(6)
调用二、
ot = outer()
ot()
```

##### 每次开启内函数的时候都在使用同一份闭包变量

```python
def outer(m):
    print("outer is ",m)
    def inner(n):
        print("inner",n)
        return m + n
    return inner
ot = outer(10)
# 第一次调用
print(ot(15))  # 10+ 15
# 第二次调用
print(ot(20))  # 10+ 20
```

> 总结：使用闭包的过程中，一旦外部函数被调用了一次，返回了外函数的引用，每次开启内函数都是使用同一份闭包变量

#### 15.8.5 装饰器

>  场景：在原代码的场景中去添加新功能
>
> ```python
> def test(fn):
>     print("登录")
>     print("注册")
>     fn()
> def test01():
>     print("转账")
> test(test01)
> ```

> **装饰器**
>
> 装饰器本质上就是一个`闭包`函数，它的好处就是在不修改原有代码的基础上，增加额外的功能
>
> 需要满足以下两点:
>
> 1.不修改原程序或函数的代码
>
> 2.不改变函数或程序调用方法。
>
> 闭包三个条件：
>
> 1. 函数嵌套
> 2. 内函数要使用外部函数的局部变量
> 3. 外函数的返回值是内函数的内存地址

> ```python
> # 被装饰的函数
> def login():
>     print("登录中")
> 
> def outer(fn):
>     # 既有新功能又有旧功能
>     def inner():
>         fn()
>         print("登录成功")
>     return inner
> ot = outer(login)
> ot()
> ```
>
> 装饰器的原理
>
> 将一个函数作为参数传入另一个函数中，通过在返回的新函数中添加额外逻辑来动态地增强原函数功能

##### 语法糖

```python
def outer(fn):
    def inner():
        fn()
        print("登录成功")
    return inner
@outer  # 装饰这个函数 
def login():
    print("登录中")

login()
```

> 多个装饰器的装饰过程，离函数最近的装饰器先装饰，然后外面的装饰器再进行装饰。
>
> 由内到外的装饰过程
>
> ```python
> @deco2
> @deco1
> def test()
> 	···
> ```

## 语法进阶 

### 十六、类与对象

> ​	 类就是一系列具有相同属性和行为的事物的统称，不是真实存在的事物对象是类的具体实现，是类创建出来的真实存在的事物，面向对象思想的核心在开发中，先有类，再有对象

#### 16.1 类的三要素

类名  属性   方法

##### 1.1 定义类

> 基本格式 
>
> class 类名
> 		代码块
>
> ```python
> class Washier:
>     height = 80
> print(Washier.height)
> # 创建一个新的属性
> Washier.width = 60
> print(Washier.width)
> ```

##### 1.2 创建对象

创建对象的过程也叫实例化对象

>  基本格式：对象名 = 类名（）
>
> 实例化一个洗衣机对象
>
> ```python
> wa = Washier()
> print(wa)
> wa2 = Washier()
> print(wa2)
> ```

 ##### 1.3 实例方法和实例属性

实例方法

>  由对象调用，至少有一个self参数，执行实例方法的时候，自动将调用该方法的对象赋值给self
>
> self参数是类中的实例方法必备的
>
> ```python
> class Washier:
>     height = 80
>     def run(self):
>         print("run方法")
>         print("self",self)
> 
> wa = Washier()
> print(wa)
> wa.run()
> 
> # wa的内存地址是<__main__.Washier object at 0x020A1358>
> # run方法
> # self 的内存地址 <__main__.Washier object at 0x020A1358>
> ```

实例属性

> ```python
> class Person:
>     name = "james"
>     def run(self):
>         print(f"{Person.name} 的年龄是 {self.age}")
> 
> zhanSan  = Person()
> zhanSan.age = 18
> zhanSan.run()
> ```

**实例属性和类属性的区别**

> 类属性属于类，是公共的，大家都能访问到，实例属性属于对象的，是私有的

```python
class Person:
    name = "james"
    def run(self):
        print(f"{Person.name} 的年龄是 {self.age}")  # 实例属性

zhanSan  = Person()
print(zhanSan.name)
zhanSan.age = 18  # 实例属性
zhanSan.run()

lisi = Person()
lisi.name = "lisi"
lisi.sex = "man"
print(lisi.name)
print(lisi.sex)
```

##### 1.4 构造函数

```python
# 构造函数
class Person:
    # name = "james"
    def __init__(self,name,age,height):
        self.name = name
        self.age  = age
        self.height = height + "cm"
    def run(self):
        print(f"{self.name} 的年龄是 {self.age},身高是 {self.height}")  # 实例属性

p1  = Person('james',18,"173")
p1.run()
print(type(p1.age))
```

##### 1.5 析构函数

> `__del__`执行的时候，内存会立即被回收，会调用对象本身的`__del__()`方法
>
> `__del__()`方法 表示 这个程序已经结束

```python
class Person:
    name = "james"
    def __init__(self):
        print("__init__执行")
    def __del__(self):
        print("__del__执行")

p1 = Person()
del p1  # 删除对像，输出 __del__执行
print("最后一行代码")
```

#### 16.2 封装

面向对象的三大特性：`封装、多态、继承`

>  封装:指的是隐藏对象中一些**不希望被外部所访问**到的属性或者方法
>
> ```python
> class Person:
>     name = "james"  # 类属性
> ```
>
> 解释： `Person.name` 能被外面所有用户使用
>
> ```python
> class Person:
>     name = "james"  # 类属性
>     __age = 40  # 隐藏属性
>     def introduce(self):
>         print(f"{Person.name}'s age is {Person.__age}")
> p1 = Person()
> # 第一种访问方法
> print(p1.name)
> # print(p1._Person__age)
> # 第二种方法：通过方法去调用 推荐
> p1.introduce()
> ```

> + _xxx:单划线开头，声明私有属性/方法，如果定义在类中，外部可以使用，子类也可以继承。但是在另一个py文件中通过`from xxx import *`导入时，无法导入
> + __xxx:双划线开头，隐藏属性，如果定义在类中，无法在外部直接访问，子类不会继承，要访问只能通过间接的方式，另一个py文件中通过`from xxx import *`导入的时候，也无法导入
>
> 访问私有属性
>
> ```python
> class Person:
>     name = "james"  # 类属性
>     __age = 40  # 隐藏属性
>     _sex = "man" # 私有属性
> p1 = Person()
> print(p1._sex)   # 私有属性
> ```
>
> 隐藏方法的使用
>
> ```python
> class Person:
>     name = "james"  # 类属性
>     __age = 40  # 隐藏属性
>     _sex = "man" # 私有属性
>     # 隐藏方法
>     def __working(self):
>         print("working")
>     # 私有方法
>     def _exx(self):
>         print("私有方法")
>     def funa(self):
>         self.__working()
> 
> p1 = Person()
> p1.funa()
> p1._exx()  # 调用私有方法
> ```

#### 16.3 继承

> 定义： 让类和类之间转变为父子关系，子类默认继承父类的属性和方法
>
> 用法：
>
> ```python
> class Person:
>     name = "james"  # 类属性
>     def eat(self):
>         print("eat")
>     def _love(self):
>         print("love")
> class gril(Person):
>     pass   # 占位符，代码里面类下面不写任何东西，会自动跳过
> liu = gril()
> liu.eat()
> liu._love()
> ```
>
> 总结：子类可以继承父类的属性和方法，就算子类自己没有，也可以使用父类的。

##### 16.3.1 多重继承

```python
class Father:
    name = "james"
    def eat(self):
        print(f"{self.name}在eat")
class Son(Father):
    pass
class GroundSon(Son):
    pass
s = Son()
s.eat()
g = GroundSon()
g.eat()
```

总结： 继承的传递性就是子类拥有父类以及父类的父类中的属性和方法

#### 16.4 方法的重写

> 重写指在子类中定义与父类相同名称的方法  
>
> 相当于 
>
> ```
> a = 1
> a = 2
> ```
>
> ```python
> class Person:
>     def money(self):
>         print("money is here")
> class James(Person):
>     def money(self):
>         print("一百万 ")  # 覆盖父类的方法
> Ji =  James()
> Ji.money()
> ```

##### 16.4.1 对父类方法进行扩展：继承父类的方法，子类也可以增加自己的功能

> 1.  父类名.方法名（self）
>
> 2.  super().方法名()
>
>    super()其实是在实例化这个对象，然后去调用这个方法
>
> 3. super(子类名，self).方法名()
>
> ```python
> # 对父类方法进行扩展：继承父类的方法，子类也可以增加自己的功能
> class Person:
>     def working(self):
>         print("working")
> class James(Person):
>     def working(self):
>        # Person.working(self)   # 第一种写法
>         super().working()      # 推荐
>         # super(James,self).working()
>         print("sleep")
> 
> Ji =  James()
> Ji.working()
> ```

#### 16.5 新式类写法

> 新式类：继承了object类或者该类的 子类都是新式类   
>
> object 对象，python为所有对象提供的基类(顶级父类),提供了一些内置的属性和方法，可以使用dir()查看
>
> ```python
> print(dir(object))
> 
> ['__class__', '__delattr__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__']
> ```
>
> ```python
> class Person(object):
>     pass
> ```

#### 16.6 多重继承

> 子类可以拥有多个父类，并且具有所有父类的属性和方法
>
> ```python
> class Car:
>     def havecar(self):
>         print("havecar")
> class jiazhao:
>     def kaojiazhao(self):
>         print("kaojiazhao")
> class me(Car,jiazhao):  # 继承了havecar和jiazhao类，并具有他们的属性和方法
>     pass
> tai = me()
> tai.havecar()
> tai.kaojiazhao()
> ```
>
> 有多个类的属性和方法时，如果多个父类具有同名方法的时候，调用就近原则，括号内哪一个离得最近，优先调用哪个
>
> 比如`class me(Car,jiazhao)`会优先调用Car的属性和方法

`了解`

>  python中内置的属性`__mro__`可以查看方法搜索顺序
>
> ```python
> print(me.__mro__)
> 
> # (<class '__main__.me'>, <class '__main__.Car'>, <class '__main__.jiazhao'>, <class 'object'>)
> ```
>
> 搜索方法时，会先按照`__mro__`的输出结果，从左往右的顺序查找。找到了就直接执行不再搜索

#### 16.7 多态

> 指：同一种行为不同的表现形式

#####  16.7.1 多态的前提

继承
重写

```python
class Animal:
    def shut(self):
        print("动物会叫")
class Dog:
    def shut(self):
        print("狗汪汪汪")
class Tiger:
    def shut(self):
        print("老虎会吼")
dog = Dog()
dog.shut() # 狗
tiger = Tiger()
tiger.shut() # 老虎
```

> 多态性：定义一个统一的接口，一个接口多种实现
>
> ```python
> def test(obj):
>     obj.shut()
> dog = Dog()
> # dog.shut() # 狗
> test(dog)
> tiger = Tiger()
> # tiger.shut() # 老虎
> test(tiger)
> ```
>
> `说明:`test函数传入不同的对象，执行不同对象的shut（）方法

##### 16.7.2 静态方法

> 使用`@statimethod`来进行修饰，静态方法没有self，cls参数的限制
>
> 静态方法与类无关，可以被转换为函数使用
>
> ```python
> class Person:
>     @staticmethod
>     def run(name):
>         print(f"{name} running")
> 
> p1 = Person()
> p1.run("james")  # 对象访问
> Person.run("james") # 类访问  调用方法的时候传参数
> ```
>
> 静态方法既可以使用对象访问也可以使用类访问
>
> `取消不必要的参数传递，有利于减少不必要的内存占用和性能损耗`

##### 16.7.3 类方法

使用装饰器`@classmethod`来标识为类方法，对于类方法，第一个参数必须是类对象，一般是以`cls`作为第一个参数

```
格式
class 类名：
	@classmethod
	def 方法名(cls,形参)
```

```python
class Person:
    name = "james"  # 类属性：属于类本身，所有实例共享这一份数据

    @classmethod
    def run(cls):  
        """
        类方法：
        1. 使用 @classmethod 修饰
        2. 第一个参数是 cls（class），代表“类本身”
        3. 可以通过 cls 访问类属性或调用其他类方法
        4. 不依赖具体实例
        """
        # 通过 cls 访问类属性 name（等价于 Person.name）
        print(f"{cls.name} running")
# 创建实例对象
p1 = Person()
# 通过实例调用类方法
# 实际上传入的 cls 仍然是 Person 类，而不是 p1
p1.run()

# 通过类直接调用类方法（更推荐的方式）
Person.run()
```

> 操作“类级别的数据”
>
> 比如：
>
> 1. 操作类变量（共享数据）
> 2. 不依赖实例（不需要 new 对象）
> 3. 需要统一入口（工具类）
> 4. 工厂方法（构造对象）
> 5. 全局资源管理（token / config

#### 16.8 `__new__`

##### 16.8.1`__init__`和`__new__`的区别

`__init__`：初始化对象

`__new__` :Object基类提供的内置静态方法

作用：1.在内存中为对象分配空间 2. 返回对象的引用

```python
class Person(object):
     def __new__(cls, *args, **kwargs):
        print("__new__方法")
        res = super().__new__(cls)
        print(res)
        return res
    def __init__(self):
        print("__init__方法")
p1 = Person()
print("p1:" ,p1)  # 输出内存地址
```

`注意：`重写`__new__`方法一定要return `super().__new__(cls)`,否则python解释器得不到分配空间的对象引用，就不会调用`__init__`

```
💡 创建对象就像造房子：
__new__：造出房子 → 必须把房子交出去 → return 对象
__init__：粉刷装修 → 前提是你得有房子 → 取决于 __new__ 的返回值

所以：
👉 __new__ 不返回对象，Python 就不知道你要初始化谁
👉 正确的做法就是 return super().new(cls)
👉 这是创建对象的唯一正规入口
```

#### 16.9 单例模式

> 控制类的实例化，让类只创建一个对象，并对外提供全局访问点。
>
> 在python中主要依赖`__new__`,因为它控制对象的创建

> 实现过程：
>
> ```python
> class Singleton:
>     obj = None
>     def __new__(cls, *args, **kwargs):
>         print("这是NEW方法")
>         if cls.obj == None:
>             cls.obj =  super().__new__(cls)  #将第一次实现保存下来，所以下次能直接使用
>         return cls.obj
> s1 = Singleton()
> print("s1",s1)
> s2 = Singleton()
> print("s2",s2)
> ```

##### 16.9.1 通过导入模块实现单例模式

> 模块就是天然的单例模式

##### 16.9.2 应用场景

1. 回收站对象
2. 音乐播放器， 一个音乐播放软件负责音乐播放的对象只有一个
3. 开发游戏软件    场景管理器
4. 数据库配置     数据库连接池的设计

### 十七、魔法方法&属性

#### 17.1.1 doc

```python
class Person(object):
    """人类的描述信息"""
    pass
print(Person.__doc__)
```

### 十八、文件操作

打开文件 --》读、写文件 --》关闭文件

文件对象的方法：

1. open():创建一个file对象，默认是以只读模式打开
2. read(n):n表示从文件中读取的数据的长度，没有传n值默认一次性读取全部文件
3. write():将指定文件写入文件
4. close():关闭文件

#### 18.1 文件的打开操作

> ```python
> # 打开文件
> f = open("1.txt")
> print(f.name)  # 文件的名字
> print(f.mode)  # 访问模式
> f.close()  # 将文件关闭
> print(f.closed)  # 文件是否关闭
> ```

#### 18.2 读写操作

##### 18.2.1 read(n)

> read(n)  n表示从文件中读取的数据的长度，没有传n值或者传的是负值就默认一次性读取文件的所有内容
>
> read（5）表示 读取数据长度为5

```python
# 读写操作
f = open("1.txt")  # 打开文件
print(f.name)
print(f.read()) # 负数和不填 默认全部读取
f.close()  # 将文件关闭
print(f.closed)  # 文件是否关闭

# 打开桌面文件
f = open(r'C:\Users\atai\Desktop\.txt')
print(f.name)
```

##### 18.2.2 readline(n)

> readline(n)   一次读取一行内容，方法执行完，会把文件指针移到下一行，准备再次读取
>
> ```python
> f = open("1.txt")  # 打开文件
> # print(f.readline())
> while True:
>     txt = f.readline()
>     if not txt:
>         break
>     print(txt,end="")
> f.close()
> ```
>
> 简便方法：
>
> ```python
> with open("1.txt", "r", encoding="utf-8") as f:
>     for line in f:
>         print(line, end="")
> ```

##### 18.2.3 readlines 

> readlines ：按照行的方式把文件内容一次性读取，返回的是一个`列表`，每一行的数据就是列表中的一个元素
>
> ```python
> f = open("1.txt")
> txt = f.readlines()  # 读取文件
> print(txt)
> print(type(txt)) #列表list 类型
> f.close()   #关闭文件
> ```

#### 18.2.4 访问模式

+ r ：只读模式（默认模式），文件必须存在，不存在就会报错
+ w：只写模式。文件存在就会清空文件内容，再去添加内容，不存在就创建文件

```python
# 访问模式 model
f = open("1.txt","w")  # 会重新编辑原来的内容
f.write("11111")
f.read()
f.close()
```

+ +：表示可以同时读写某个文件

> r+：可读写文件，文件不存在就会报错
> w+：先写后读，文件存在就会编辑文件，不存在就会编辑文件
>
> ```python
> f = open("1.txt","w+")  # 会重新编辑原来的内容
> f.write("11111")
> print(f.readline())
> f.close()
> ```
>
> 提示：这里代码，read()，输出空，因为文件写完后，**文件指针**在末尾，所以输出为空
>
> 文件指针：标记从哪个位置开始读取数据
>
> `频繁的读写会怎么样`
>
> 会占用 I/O，程序速度下降。

+ a:追加模式，不存在就创建新文件进行写入，存在则在原有内容的基础上追加新的内容

> ```python
> f = open("2.txt","a")
> f.write("\nlogo1111")
> f.close()
> ```

`解决写完读取为空的问题`

> tell()：查看文件指针当前位置
>
> seek(offset,whence)：移动文件指针到指定位置
>
> + offset = 你要移动多少字节
>
> + whence = 从哪开始算 
>   + whence只有三个值      [0 :从文件开头算 1 :从当前位置算 2 :从文件末尾算]
>
> ```python
> f = open("2.txt","a+")
> f.write("666")
> f.seek(0) # 移动到文件开头 
> print(f.tell())
> print(f.read())
> f.close()
> ```

#### 18.3 编码格式

#####  18.3.1 with open

> 作用：代码执行完，系统自动调用`f.close()`关闭文件
>
> ```python
> with open("1.txt","w") as f: # f是对象
>     f.write("emmm..")
> print(f.closed)
> ```

##### 18.3.2 编码格式

> ```python
> with open("1.txt","w",encoding="utf-8") as f: # f是对象
>     f.write("詹姆四") 
> print(f.closed)
> ```
>
> 解释：
>
> 写入中文的时候，用`utf-8`格式去写入

> 案例：图片复制
>
> ```python
> with open("1.png","rb") as f:
>     img = f.read()
>     print(img)
> with open("2.png","wb") as f:
>     f.write(img)
> ```

##### 18.3.3 os

文件操作

> ```python
> import  os
> os.rename("1.txt","666.txt")  #重命名
> os.remove("666.txt") # 删除txt
> os.mkdir("james")  # 创建文件夹
> os.rmdir("james")  # 删除文件夹
> print(os.getcwd()) # 获取当前目录
> print(os.listdir()) #获取目录列表 不写默认获取当前目录
> ```

### 十九、可迭代对象Iterable

遍历（迭代）：依次从对象中把一个个元素取出来的过程

数据类型：str，list，tuple，dict，set等

#### 19.1.1 可迭代对象的条件

1. 对象实现了`__iter__()`方法
2. `__iter__()`方法返回了迭代器对象

#### 19.1.2 for循环工作原理

1. 先通过`__iter__()`获取可迭代对象的迭代器
2. 对获取到的迭代器不断调用`__next__`方法来获取下一个值并将其赋值给临时变量i

#### 19.1.3 isinstance

>  判断一个对象是否是已知的数据类型。  例如用来判断是否为可迭代对象

```python
# 导入可迭代对象
from collections.abc import Iterable
str = "123"
bool = isinstance(str,Iterable)
print(bool)  # TRUE
```

#### 19.2.1 迭代器

> 一个能记住遍历位置的对象，是可以一个一个取数据的对象
>
> ```python
> # 导入可迭代对象
> from collections.abc import Iterable
> # 创建迭代器对象
> # 调用next方法 获取下一个值
> li = [1,2,3,4]
> li1 = iter(li)
> print(next(li1))
> print(next(li1))
> print(next(li1))
> # 取完元素后，再使用next()会引发StopIteration异常
> print(next(li1))
> ```
>
> ```python
> # 魔法方法
> li = [1,2,3,4]
> li1 = li.__iter__()
> print(li1.__next__())
> print(li1.__next__())
> print(li1.__next__())
> print(li1.__next__())
> ```

#### 19.3 迭代器和可迭代对象

> 可迭代对象：凡是可以作用于`for`循环的都属于可迭代对象 
>
> 迭代器:凡是可以作用于`next()`的都是迭代

```python
name = "james"
print(isinstance(name,Iterable))  # 可迭代对象  TURE
print(isinstance(name,Iterator))  # 迭代器对象  FALSE

name = iter(name)   # 转换成迭代器对象
print(isinstance(name,Iterable))  # 可迭代对象   TRUE
print(isinstance(name,Iterator))  # 迭代器对象   TRUE
```

> **总结**
> 可迭代对象可以通过`iter()`转换成迭代器对象   如果一个对象拥有 iter ()，是**可迭代对象**，
>
> 如果一个对象拥有 next()和 iter ()方法，是**迭代器对象**
>
> dir():查看对象中的属性和方法

#### 19.4 自定义迭代器类

两个特性：`__iter__()`和`__next__()`

```python
class MyIterator(object):
    def __init__(self):
        self.num  = 0
    def __iter__(self):
        return self  # 返回一个迭代器对象
    def __next__(self):
        if self.num == 10:
            raise StopIteration("10 数据已被取完")
        self.num += 1
        return self.num

it = MyIterator()
for i in it:
    print(i)
```

#### 19.5 生成器

##### 19.5.1 生成器表达式

> python 中一边做循环一边做计算的机制，叫生成器
>
> 边读取边处理
>
> **列表推导式**
>
> ```python
> li = (i* 5 for i in range(5))
> print(li)  # <generator object <genexpr> at 0x021BD648>
> for i in range(5):
>     print(next(li))
> ```

##### 19.5.2 生成器函数

Python中，使用了yield关键字的函数就称之为生成器函数

```python
# yield 生成器函数
li = []
def gen2(n):
    a = 0
    while a < n:
        li.append(a)
        yield a  # 暂停 遇到 next()方法才去执行
        a += 1
    return li
gen2(5)  # 只是创建了generator对象，没有调用里面的函数方法
for i in gen2(5):
    print(i)
print(li)
```

```python
def test():
    yield 1
    yield 2
    yield 3
print(test())
te = test()
print(te.__next__())
print(te.__next__())
print(te.__next__())
print(next(test()))  # 调用函数 重新调用
print(next(test()))
print(next(test()))
```

#### 19.6 三者关系

> **可迭代对象**：指实现了python迭代协议，可以通过`for ..in..`循环遍历的对象，比如list、dict、str...、迭代器、生成器
>
> **迭代器**： 可以记住自己遍历位置的对象，直观体现就是可以使用`next()`函数返回值，迭代器只能往后，不能往前
> 				当遍历完毕之后，`next()`会抛出异常
>
> **生成器**：它能记住当前执行位置，是一个用`yield`定义的函数

### 二十、线程

#### 20.1 多线程

**多线程**：同时运行多个线程

**进程：**是操作系统进行资源分配的基本单位，每打开一个程序至少就会有一个进程

**线程：**是cpu调度的基本单位，每一个进程至少都会有一个线程，这个线程通常就是我们所说的主线程

一 个进程默认有一个线程，进程里面可以创建多个线程，线程是依附在进程里面的，没有进程就没有线程。

```python
import threading  # 导入线程模块
import time #导入时间模块
def dance():
    print("dancing ")
    time.sleep(1)
    print("dance finish")
def sing():
    print("singing ")
    time.sleep(1)
    print("sing finish")
if __name__ == "__main__":
    t1 = threading.Thread(target=dance)  # 创建子线程  
    t2 = threading.Thread(target=sing)    # 创建子线程
    t1.start()  # 开启子线程
    t2.start()  # 开启子线程
```

> `t1 = threading.Thread(target=dance)`
>
> **Thread**：线程类参数
>
> **target**：执行的任务名 （传的参数对象）
>
> **args**：以元组的形式给任务传参
>
> **kwargs**: 以字典的形式给任务传参

 **场景：跳完舞后加个完美谢幕**

```python
# 同时唱歌和跳舞
# 加跳完舞后加个完美谢幕
# 导入线程模块
import threading
import time #导入时间模块
def dance(name):
    print(f"{name}dancing ")
    time.sleep(1)
    print("dance finish")
def sing(name):
    print(f"{name}singing ")
    time.sleep(1)
    print("sing finish")
if __name__ == "__main__":
    # 创建子线程
    t1 = threading.Thread(target=dance,args=("james",))    以元组的形式传参，只有一个的时候，要加，
    t2 = threading.Thread(target=sing,args=("james",))    # 创建子线程
    # 守护线程，必须放在start()前面: 主线程执行结束，子线程也会跟着结束。
    t1.daemon = True
    t2.daemon = True
    t1.start()  # 开启子线程
    t2.start()  # 开启子线程
    # 暂停的作用，等子线程执行结束后，主线程才会继续执行，必须放在start()后面
    t1.join()
    t2.join()
    print("完美谢幕")
```

#### 20.2 线程之间是无序的 

线程执行是根据cpu调度决定的

```python
# 循环创建四个线程
def task():
    time.sleep(1)
    print("当前线程的名字：",threading.current_thread().name)
for i in range(5):
    t = threading.Thread(target=task)
    t.start()
```

#### 20.3 线程同步

##### 20.3.1 资源竞争问题

```python
a = 0
b = 1000000
def add():
    for i in range(b):
        global a
        a += 1
    print("a = ", a)
def add2():
    for i in range(b):
        global a
        a += 1
    print("a = ", a)
if __name__ == "__main__":
    t = threading.Thread(target=add)
    t2 = threading.Thread(target=add2)
    t.start()
    t2.start()
```

##### 20.3.2 线程同步

方式一：join

```python
a = 0
b = 1000000
def add():
    for i in range(b):
        global a
        a += 1
    print("a = ", a)
def add2():
    for i in range(b):
        global a
        a += 1
    print("a = ", a)
if __name__ == "__main__":
    t = threading.Thread(target=add)
    t2 = threading.Thread(target=add2)
    t.start()
    t.join()  # 阻塞线程
    t2.start()
    t2.join() 
```

方法二：线程锁

```python
from threading import Lock  # 导入模块锁
import time # 导入时间模块
lock = Lock()
# 资源竞争
a = 0
b = 1000000
def add():
    # 给线程上锁
    lock.acquire()
    for i in range(b):
        global a
        a += 1
    print("a = ", a)
    # 释放锁
    lock.release()
def add2():
    # 给线程上锁
    lock.acquire()
    for i in range(b):
        global a
        a += 1
    print("a = ", a)
    # 释放锁
    lock.release()
if __name__ == "__main__":
    t = threading.Thread(target=add)
    t2 = threading.Thread(target=add2)
    t.start()
    t2.start()
```

> 总结：
>
> 互斥锁的作用:保证同一个时刻只有一个线程去操作共享数据，保证共享数据不会出现错误问题。上锁和释放锁必须成对出现，否则容易造成死锁现象
>
> 死锁：一直等待释放的情景就是死锁，会造成程序停止响应，不能再处理其他事务

### 二十一、进程

>  定义：是操作系统进行资源分配和调度的基本单位，是操作系统结构的基础
>
> 一个正在运行的程序或者软件就是一个进程程序跑起来就成了进程
>
> **注意:**进程里面可以创建多个线程，多进程也可以完成多任务

#### 21.1 进程的状态

**就绪状态：** 运行的条件都已经满足，正在等待cpu执行

**执行状态：**cpu正在执行其功能

**等待（阻塞）状态：**等待某些条件满足，如一个程序sleep了，此时就处于等待状态

##### 21.2 进程语法结构

`multiprocessing`模块提供了`Process`类代表进程对象

###### 21.2.1 Process 类参数

+ target : 执行的目标任务名，即子进程要执行的任务
+ args：以元组形式传参
+ kargs：以字典形式传参

###### 21.2.2 方法

+ `start（）`：开启子进程
+ `is alive()`： 判断子进程是否还活着，存活返回True,死亡返回False
+ `join()`:主进程等待子进程执行结束

###### 21.2.3 常用属性

+ `name`：当前进程的别名。默认Process-N
+ `pid`：当前进程的进程编号

##### 总

```python
from multiprocessing import Process
import os
def sing():
    # 获取子进程，父进程的用例编号
    print(f"子进程的进程编号: {os.getpid()},父进程的进程编号: {os.getppid()}")
    print("Singing")
def dance():
    # 获取子进程，父进程的用例编号
    print(f"子进程的进程编号: {os.getpid()},父进程的进程编号: {os.getppid()}")
    print("dance")

if __name__ == "__main__":
    # 主进程名字
    print(f"主线程：{os.getpid()}")     
    # 创建进程 并且修改名字
    p1 = Process(target=sing,name="1")
    p2 = Process(target=dance,name="2")
    p1.start()
    p2.start()
    # 创建后修改
    p1.name = "3"
    p2.name = "4"
    # 访问name
    print("进程的名字：",p1.name)
    print("进程的名字：",p2.name)
    # 查看子进程编号
    print("jing")
```

##### 21,3 进程间的通信

**Queue ** 队列

> q.put(): 放入数据
>
> q.get(): 取出数据
>
> q.empty(): 判断队列是否为空
>
> q.qsize(): 返回当前队列包含的消息数量
>
> q.full()  :  判断队列是否满了

**操作队列**

```python
# 导入模块
from queue import Queue
q = Queue(3) # 初始化队列  #最多可以接收三条消息，没写或者是负值就代表没有上限，直到内存的尽头
q.put("hello")  # 放数据
q.put("world")
q.put("py")
print(f"现在的数量是 {q.qsize()}") # 返回现在的数量
print(f"现在是否为空 ，{q.empty()}") # 判断队列是否为空
print(f"现在是否满了 ，{q.full()}")
q.get()
print(f"现在的数量是 {q.qsize()}")
```

**进程间的通信**

```python
import time
from multiprocessing import Process, Queue

def wdata(q):
    for i in range(5):
        q.put(i)
        time.sleep(0.2)
    print(q.qsize())
def rdata(q):
    while True:
        if q.empty():
            break
        else:
            print("取出的数据是 ",q.get())
    print(q.qsize())
if __name__ == "__main__":
    li = Queue() # 初始化队列
    p1 = Process(target=wdata, args=(li,))
    p2 = Process(target=rdata,args=(li,))
    p1.start()
    p1.join()  # #主进程处于等待的状态，p1是运行状态
    p2.start()
    # p2.join()
    print(f"进程的状态：{p1.is_alive()}")
    print(f"进程的状态：{p2.is_alive()}")
```

### 二十二、协程

#### 22.1 什么是协程

> 单协程下的开发，又称为微线程注意:线程和进程的操作是由程序触发系统接口，最后的执行者是系统，协程的操作则是程序员

22.1.1 简单实现协程

使用生成器实现简单协程

```python
def task1():
    for i in range(3):
        print("task 1 : ",i)
        yield  # 暂停

def task2():
    for i in range(3):
        print("task 2 : ", i)
        yield  # 暂停
if __name__ == "__main__":
    t1 = task1()
    t2 = task2()
    try:
        while True:
            next(t1)
            next(t2)
    except StopIteration:
        print("StopIteration")
```

**应用场景**

+ 如果一个线程里面IO操作比较多的时候，可以用协程
  + 文件操作。网络请求
+ 适合做高并发处理

#### 22.2 greenlet 

安装命令：`pip install greenlet`

查看已安装的模块：`pip list`

> greenlet 是一个由c语言实现的协程模块。通过设置switch()来实现任意函数之间的切换

**注意**

`greenlet`属于手动切换，当遇到io操作的时候，程序会阻塞，而不能进行自动切换

```python
# 导入模块
from greenlet import greenlet

def sing():
    print("开始唱歌")
    g2.switch()
    print("结束唱歌")
def dance():
    print("start dance ")
    print("finish dance ")
    g1.switch()
if __name__ == "__main__":
    # 创建协程对象
    g1 = greenlet(sing)
    g2  = greenlet(dance)
    g1.switch()
```

#### 22.3 gevent

> 遇到I0操作时，会进行自动切换，属于主动式切换

**使用**

```
gevent.sqawn(函数名): 创建协程对象
gevent.sleep()     : 耗时操作
gevnet.join()      : 阻塞，等待某个协程执行结束
gevent.joinall()   : 等待所有协程对象都执行结束再退出，参数是一个协程对象列表
```

自带耗时操作

```python
import gevent  # 导入gevent模块
def sing():
    print("开始唱歌")
    gevent.sleep(1) # 
    print("结束唱歌")
def dance():
    print("start dance ")
    gevent.sleep(2)
    print("finish dance ")
if __name__ == "__main__":
    # 1. 创建协程对象
    g1 = gevent.spawn(sing)
    g2 = gevent.spawn(dance)
    # 阻塞，等待协程执行结束
    g1.join() # 等待g1 对象执行结束
    g2.join() # 等待g2 对象执行结束
```

> `gevent.sleep()` 的作用是：主动让出当前协程的执行权，让 gevent 去执行其他协程。

**joinall ()**

```python
def sing(name):
    for i in range(3):
        gevent.sleep(1)
        print(f"{name} singing 被送走了{i} 次")
if __name__ == "__main__":
    gevent.joinall([
        gevent.spawn(sing,'Lebron'),
        gevent.spawn(sing,'James')])
```

> `joinall()`的作用是： 阻塞主程序，等待一组协程全部执行完。

#### 22.4 monkey 补丁

> 在模块运行时替换的功能

```python
# monkey 补丁
# 导入模块
from gevent import monkey
monkey.patch_all() # 将用到的time.sleep(代码替换成gevent 里面自己 实现耗时操作的 gevent.sleep()代码
                   # 补丁必须打在代码前面
def sing(name):
    for i in range(3):
        time.sleep(1)
        print(f"{name} singing 被送走了{i} 次")
if __name__ == "__main__":
    gevent.joinall([
        gevent.spawn(sing,'Lebron'),
        gevent.spawn(sing,'James')])
```

#### 22.5 总结

>  线程是cpu调度的基本单位，进程是资源分配的基本单位

**进程、线程和协程对比**

1. 进程:切换需要的资源最大，效率最低
2. 线程:切换需要的资源一般，效率一般
3. 协程:切换需要的资源最小，效率高

**应用场景**

多线程适合 I0密集型操作(文件操作、爬虫),

多进程适合CPU密集型操作(科学及计算、对视频进行高清解码、计算圆周率

**进程、线程、协程都是可以完成多任务的**

 ### 二十三、正则表达式

#### 23.1 正则表达式

字符串处理工具

注意：需要导入re模块

**特点** 

可读性差，通用性强

**步骤**

1. 导入re模块

2. re.match() 

   能匹配出以xxx开头的字符串，如果<u>起始位置</u>没有匹配成功，返回`None`

3. re.group() 

   如果上一步匹配数据成功，使用`group()`去提取数据 

> re.match(pattern,string)
>
> pattern 匹配的正则表达式
>
> string   要匹配的字符串

````python
import re
res = re.match("James","James is GOAT")  # 从开始位置去匹配
print(res)
print(res.group()) # 返回 匹配的字符串 James
````

#### 23.2 匹配单个字符

1. `.`匹配任意一个字符 \n 除外

```python
# 匹配任意一个字符 \n 除外 
res = re.match('.','hello')
print(res.group())
```

2. `[]` 匹配[]中列举的单一字符

```python
# [] 匹配[]中列举的单一字符
res =  re.match('[he].','hello') # 匹配英文
res =  re.match('[1-3]','12345') # 匹配数字
res =  re.match('[测试汉字]','测试测试')  # 匹配字符
# 匹配0-9
res = re.match('[0-9][0-9]','123')
# 匹配a-z A-Z
res = re.match('[a-zA-Z][a-zA-Z][A-Z][a-zA-Z][a-zA-Z]','HeLLooOO')
print(res.group()) 
```

3. `\d` 匹配 数字 

```python
# 匹配 数字 \d
res = re.match('\d','123')
print(res.group()) 
```

4. `\D` 匹配非数字 

```python
# 匹配非数字 \D
res = re.match('\D','.123')
res = re.match('\D','aces')
print(res.group()) 
```

5. `\s` 匹配空格 

```python
# 匹配空格和tab键 \s  "\s\s" 等于一个tab
res = re.match('\s.'," hello")
res = re.match('\s\s.','  h')
```

6. `\S ` 匹配非空格 

```python
# 匹配非空格 \S
res = re.match('\S','|sds')
```

7. `\w` 匹配 单词字符 a-z,A-Z,0-9,_,汉字

```python
# 匹配 a-z,A-Z,0-9,_,汉字
res = re.match('\w\w\w\w\w','Hh_9测')
```

8.  `\W` 匹配非单词字符

```python
# 匹配非单词字符
res = re.match('\W\W',"|+")
```

#### 23.3 匹配多个字符

1. `*` 匹配前一个字符出现0次或者无限次，即可有可无  --常用

   ```python
   # `*` 匹配前一个字符出现0次或者无限次，即可有可无
   res = re.match('\w*','Hh9测')
   print(res.group())
   ```

2. `+` 匹配前一个字符出现至少一次                            --常用

   ```python
   # `+` 匹配前一个字符出现至少一次
   res = re.match('\d+', "12hHH测")
   print(res.group())
   ```

3. `?` 匹配前一个字符出现1次或 0次                          --常用

   ```python
   # `?` 匹配前一个字符出现1次或0次
   res = re.match('\d?', 'w1')
   print(res.group())
   ```

4. `{m}` 匹配前一个字符出现m次    

   ```python
   # `{m}` 匹配前一个字符出现m次
   res = re.match('\d{5}', '12345')
   print(res.group())            
   ```

   > 注意 要数字要完全匹配 不然会报错

5. `{m,n}` 匹配前一个字符出现从m次到n次   范围是 [m.n]

   ```python
   # `{m,n}` 匹配前一个字符出现从m次到n次 
   res = re.match('\w{4,6}', 'word') # 输出 word
   print(res.group())
   ```

#### 23.4 匹配开头和结尾

1. `^` 在正则外面表示 **开头匹配**

   ```python
   res = re.match('^py', "python")
   print(res.group())
   ```

2. `[^py]` 在方括号里表示 **取反**。

   ```python
   res = re.match('[^py]','thon')
   print(res.group())
   ```

3. `$` 匹配结尾

   ```python
   res = re.match('\w{4}o$', 'hello') # hello
   print(res.group())
   ```

   > 注意 match 是**从字符串的口头 开始 匹配**

#### 23.5 匹配分组

1. `|`： 满足任意一个表达式    					 	--常用

   ```python
   # 满足任意一个表达式
   res = re.match('\w|\s\w', " h")  # " h"
   print(res.group())   
   ```

2. `(ab)`： 将括号中的字作为一个分组           --常用 

   ```python
   # 将括号中的字作为一个分组
   # 匹配邮箱
   res = re.match('\w*@(163|qq|email).com',"123@qq.com")
   print(res.group())
   ```

3. `\num`: 匹配分组num匹配到的字符串          ---经常在匹配标签时被使用

   ```python
   res = re.match(r'<(\w*)>.*</\1>',"<html>login</html>") # 使用 r 转义字符 \1 匹配 第一个(\w* )
   res = re.match(r'<(\w*)><(\w*)>.*</\2></\1>',"<html><h>login</h></html>")
   print(res.group()) 
   ```

   注意:**从外到内排序，编号从 1 开始**

4. `(?P<name>)`  分组起别名    `(?p=name)` 引用别名为name分组匹配到的字符串

   ```python
   res = re.match(r'<(?P<L1>\w*)>.*</(?P=L1)>',"<html>login</html>")
   print(res.group()) 
   ```

> 综合练习 匹配网址

```python
# 综合练习 循环匹配网址
L1 = ['www.baidu.com','www.bbi.cn','www.abc.en','www.sd.erg']
for i in L1:
    res = re.match(r'www\.\w*.(com|cn)',i)
    if res:
        print(res.group())
    else:
        print(f"{i} 非法地址 ")
```

#### 23.6 高级用法

1. `search()` ：从头到尾匹配，匹配成功返回第一个成功匹配的对象，通过`group()`进行提取，匹配失败返回None,只匹配一次

   ```python
   # search()
   res = re.search('th','pythonth')
   print(res.group())
   ```

   

2. `findall()`: 从头到尾匹配，匹配成功返回一个`列表`，匹配所有匹配成功的数据，不需要通过group()进行提取，没有group()

   ```python
   # findall()
   res = re.findall('th','pythonth')
   print(len(res))      # 获取列表长度
   ```

   总结：

   1. `match()` : 从头开始匹配，匹配成功返回`match`对象，通过`group()`进行提取，匹配失败就返回None,只匹配一次
   2. `search()` ：从头到尾匹配，匹配成功返回第一个成功匹配的对象，通过`group()`进行提取，匹配失败返回None,只匹配一次
   3. `findall()`: 从头到尾匹配，匹配成功返回一个`列表`，匹配所有匹配成功的数据，不需要通过`group()`进行提取，没有`group()`

3. `sub(pattern,repl,string,count)` : 替换 字符串的内容

   ​	`pattern`: 字符串中 需要被替换的内容

   ​	`repl`： 新内容

   ​	`string`： 要处理的字符串

   ​	`count`：指定被替换的次数

   ```python
   # 替换字符串
   res = re.sub('\d{2}', '1', '今天是10月')
   print(res)
   ```

4. `spilt(pattern,string,maxsplit)`: 

   `pattern`:    正则表达式

   `string`:     字符串

   `maxsplit`:  指定最大分割次数

   ```python
   # 切割字符串
   res = re.split(',','hello,python,hme,world',2)  # ['hello', 'python', 'hme,world']
   print(res)
   
   ```
#### 23.6 贪婪与非贪婪

**贪婪匹配（默认）： 在满足匹配时，匹配尽可能长的字符串**

```python
# 贪婪匹配
res = re.match('em*','emmmppp')
print(res.group())
```

**非贪婪匹配：在满足正则规则的前提下，尽可能少地匹配字符**

```python
# 非贪婪匹配
res = re.match('em+?','emmmppp')
print(res.group())
res = re.match('em{2,5}?','emmmppp')
print(res.group())
```

> 非贪婪 写法：贪婪量词后加 ？
>
> `*?`
>
> `+?`
>
> `??`
>
> `{m,n}?`

 #### 23.7 原生字符串

**`r'' `: 取消python转义**

```python
# 正则表达式匹配 \\
res = re.match(r'\\','\\name')  # 只做正则的转义，用r''去取消python的转义
print(res.group())
```



### 二十四、常用模块

#### 24.8 os模块

##### 一、os模块

作用: 用于和操作系统进行交互

```python
print(os.name) # nt
```

> 对于windows，返回`nt`，对于linux，返回`posix`

##### 二、os.getenv()

读取环境变量 

```python
print(os.getenv("path")) 
```

##### 三、os.path.spilt()  

将目录名和文件名分离，以`元组`的形式接收，第一个元素是 目录路径，第二元素是 文件名

```python
os = os.path.split(r"D:\python-objects\py01\11.py")
os = os[1]
print(os)
```

##### 四、os.path.dirname()

获得目录和文件名 

```python
# 输出目录 和 文件名
print(os.path.dirname(r"D:\python-objects\py01\11.py")) # 目录
print(os.path.basename(r"D:\python-objects\py01\11.py")) # 文件名
```

##### 五、os.path.exists() 

判断路径(文件或目录)是否存在，存在的话就返回`True`,不存在就返回`False`

```python
# 判断路径是否存在
print(os.path.exists(r"D:\python-objects\py01\11.py"))  # TRUE
```

##### 六、os.path.isfile() 

判断文件是否存在

```python
# 判断文件是否存在
print(os.path.isfile(r"D:\python-objects\py01\11.py"))  # TRUE
print(os.path.isfile(r"D:\python-objects\py01/"))       # FALSE
```

##### 七、os.path.isdir()

判断目录是否存在

```python
# 判断目录是否存在
print(os.path.isdir(r"D:\python-objects\py01\11.py"))      # FALSE
print(os.path.isdir(r"D:\python-objects\py01/"))      # TRUE
```

##### 八、os.path.abspath()

获取当前路径下的绝对路径

```python
# 获取当前路径下的绝对路径
print(os.path.abspath("11.py"))
print(os.path.isabs(r"D:\python-objects\py01\11.py")) # 判断是否为绝对路径
```

#### 24.9 sys模块

```python
# 导入sys模块
import sys
# 获得系统默认编码格式
print(sys.getdefaultencoding())
# 获取环境变量的路径，跟解释器相关
print(sys.path)  # 以列表的形式返回，第一项为当前所在的工作目录

# 获取操作系统的平台名称
print(sys.platform)

# 获取pyhthon解释器的版本信息
print(sys.version)
```

#### 24.10 time 模块

```python
# 导入time模块
import time
# 延时操作
time.sleep(2) # 以秒为单位
# 获取时间戳
# 获取到当前的时间戳:以秒计算，从1970年1月1日 00:00:00开始到现在的时间差
print(time.time())  # 返回浮点型

# 将一个时间戳转换为当前时区的struct_time,九个元素
print(time.localtime())
t = time.localtime()
print(t.tm_mday)

# 获取系统当前时间
print(time.asctime())

# 将 结构时间转换为固定的字符串表达式
print(time.asctime(time.localtime()))

# 将时间戳转换为固定的字符串表达式
time.ctime(time.time())

# 将struct_time转换为时间字符串  
print(time.strftime("%Y-%m-%d %H:%M:%S",time.localtime())) # 字符串

# 将时间字符串转换为 struct_time
print(time.strptime('2026-01-02', "%Y-%m-%d"))
```

#### 24.11 logging 模块

 1. 作用：用于记录日志信息

 2. 日志的作用
    1. 程序调试
    2. 了解软件程序运行情况是否正常
    3. 软件程序运行故障分析与问题定位

 3. 级别的排序（从高到低）

    CRITICAL  > ERROR > WARING > INFO > DEBUG > NOTEST

    ```python
    # 日志
    logging.debug("is debug")
    logging.info("is info")
    logging.warning("is warning")
    logging.error("is error")
    logging.critical("is critical")
    # logging默认的level就是 warning,也就是说logging只会显示级别大于等于warning的日志信息
    ```

 4. logging.basicConfig()

    **配置root logger 的参数**

    1. `filename` ：指定日志文件的文件名。所有会显示的日志都会存放到这个文件中去
    2. `filemode` ：文件的打开方式，默认是a，追加模式
    3. `level`:       指定日志显示级别，默认是警告信息`warning`
    4. `format`:      指定日志信息的输出格式

    ```python
    # logging.basicConfig()
    logging.basicConfig(filename='log.log',filemode='w',level=logging.DEBUG,format='%(levelname)s:%(asctime)s\t%(message)s')
    logging.debug("is debug")
    logging.info("is info")
    logging.warning("is warning")
    logging.error("is error")
    logging.critical("is critical")
    ```

    

#### 24.12 random模块

> 作用：用于实现各种分布的伪随机数生成器，可以根据不同的实数分布来随机生成值

1. `random.random()`    产生大于0且小于1之间的小数

   ```python
   print(random.random())
   ```

2. `random.uniform()`   产生指定范围的随机小数

   ```python
   print(random.uniform(1, 3))
   ```

3. `random.randint()`   产生指定范围内的随机整数，包括开头和结尾

   ```python
   print(random.randint(1, 3))
   ```

4. `random.randrange()`  产生start.stop范围内的整数，包含开头但是不包含结尾  step 指定产生随机的步长，随机选择一个数据

   ```python
   print(random.randrange(2, 8, 2))
   ```

   

   












