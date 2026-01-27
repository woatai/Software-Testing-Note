# py_exercise

网址：https://pynative.com/python-basic-exercise-for-beginners/

黑客松

https://www.hackerrank.com/dashboard 

## basic

### e1 找出亚军

> 根据你大学运动会的参赛者得分表，你需要找出亚军分数。你被给予n个分数。将它们存储在一个列表中，并找到亚军的分数。
>
> ​	输入格式
> 第一行包含n。第二行包含一个由n个整数组成的数组A，每元素之间用空格分隔。
>
>   ![image-20260113150908523](py_exercise.assets/image-20260113150908523.png)
>
> 输入
>
> ```
> 5
> 2 3 6 6 5
> ```
>
> 输出
>
> ```
> 5
> ```
>
> 解释
>
> 给定列表是[2,3,6,6,5]。最大分值为6，次大分值为5。因此，我们打印5作为亚军得分。

```python
def  find_sec(n,arr):
    list_arr = list(arr)
    sec_max = None
    max = None
    for i in list_arr:
        if max is None or i > max:
            if max is not None:
                sec_max = max
            max = i
        elif i != max and (sec_max is None or i > sec_max):
            sec_max = i
    print(sec_max)
n = 5
arr = map(int, "-1 -1 -2 ".split())
find_sec(n,arr)
```

考虑正负数的情况

将负数的判断 放在 > 的前面

### e2 求前一个数的和

> 需求：遍历前10个数字，并在每次迭代中打印当前数和上一个数的总和。

```python
p_num = 0
for i in range(1,11):
    x_num = p_num + i
    print(f"Current Number {i} Previous Number {p_num} Sum: {x_num}")
    p_num = i
```

### e3 计算两个数的乘积和 和

> 给定两个整数，编写一个Python程序，仅当它们的乘积等于或小于1000时返回其乘积;否则返回它们的和。

```python
```

### e4  嵌套列表

> 给定一个班级中N名学生的姓名和成绩，将它们存储在一个嵌套列表中，并打印出成绩排名第二低的学生的姓名。
>
> **注意**: 如果有多名学生的成绩为第二低分，则按字母顺序排列他们的名字，并在每行打印一个名字。
>
> **示例**
>
> 记录列表=[["chi",20.0],["beta",50.0],["alpha",50.0]]
>
> 分数的有序列表是[20.0,50.0]，因此第二低分是50.0。有两个学生的分数为该值:["beta"，"alpha"]。按字母
>
> 顺序排序后，姓名依次打印如下:
>
> ```
>alpha
> beta
> ```
> 
> 约束条件
>
> + 2 《 N 《 5
>+ 总会有一个第二低的分数
> 
> 输出格式
>
> 打印成绩第二低的学生姓名。如果有多个学生，按字母顺序排列并逐个输出在新行上。
>
> 举例输入：
>```
> 5
> Harry
> 37.21
> Berry
> 37.21
> Tina
> 37.2
> Akriti
> 41
> Harsh
> 39
> ```
> 
> 输出：
>
> ```
>Berry
> Harry
> ```
> 
> 本班有5名学生，其姓名和成绩已整理成以下列表:
>
> python_students = [['Harry', 37.21], ['Berry', 37.21],['Tina',37.2], ['Akriti',41], ['Harsh',39]]
>
> 最低成绩为37.2，属于Tina。第二低成绩为37.21，属于Harry和Berry，因此我们按字母顺序排列他们的名字，并将每个名字打印在新行上。
>

```python
def find_sec(arr):
    sec = None
	# 通过集合 {} 去查重 ，然后用sorted 去排序
    scores  = sorted({score for _,score in arr }) 
    #找出第二
    sec = scores[1]
   
    fin_li = sorted(name for name,score in arr if score == sec)  
    for i in fin_li:
        print(i)
if __name__ == "__main__":
     arr = []
    for _ in range(int(input())):
        name = input()
        score = float(input())
        arr.append([name,score])
    print(arr)
```

### e5 打印偶数数列的字符串

```python
str = input('输入你的字符 ')
for i in range(0,len(str),2):
    print(str[i])
```

### e6 元组 

```python
# python 3
if __name__ == '__main__':
   num  = int(raw_input())
   l1 = map(int,raw_input().split()) # map 映射 列表将其强转为 int 数据类型
   print(hash(tuple(l1)))
```

> 元组的应用场景：
>
> 1. 通常设置不可变的配置 
>
>    比如订单状态 order_status = ('待支付','已支付','已取消')
>
> 2. 函数返回多个值 其实也是元组
>
> 3. 表示“一组强关联数据” 比如经纬度  point = (113.25, 23.01)   # 经度, 纬度
>
> 4. 作为字典的key 
>
>    ```python
>    d = {}
>    d[(1,2)] = 'ok'
>    print(d[(1,2)])
>    ```

## String

### e1 String Split and Join

> 在python 字符串可以根据分隔符进行分割。
>
> 例子:
>
> ```python
> >>> a = "this is a string"
> >>> a = a.split(" ") # a is converted to a list of strings. 
> >>> print a
> ['this', 'is', 'a', 'string']
> ```
>
> 连接字符串很简单：
>
> ```python
> >>> a = "-".join(a)
> >>> print a
> this-is-a-string 
> ```

任务

给定一个字符串。用空格分隔符“ ”分割该字符串，并用连字符“-”连接。

**函数描述**

在下方编辑器中完成split_and_join函数。

split_and_join有以下参数:

+ 字符串行:由空格分隔的单词组成的字符串

**返回值**

+ 字符串: 结果字符串

**输入格式**
一行包含由空格分隔的单词组成的字符串。

示例输入

```
this is a string  
```

示例输出

```
this-is-a-string
```

```python
def split_and_join(line):
    return "-".join(line.split(" "))

if __name__ == '__main__':
    line = input()
    result = split_and_join(line)
    print(result)
```

###  e2 你叫什么名字?

你被给予一个人的名字和姓氏在两行上。你的任务是读取它们并打印以下内容:

> Hello `firstname` `lastname`! You just delved into python.

**函数描述**

在下方编辑器中完成print_full_name函数。

print_full_name函数具有以下参数:

+ 字符串first:名字
+ 字符串last:姓氏

**输出内容**

+ string: 'Hello 先名 姓氏!你刚刚进入了Python'，其中先名和姓氏被替换为 first 和 last。

**输入格式**

第一行包含名字，第二行包含姓氏。

**约束条件**

名字和姓氏的长度均 <= 10。

**例子输出**

```
Ross
Taylor
```

**例子输入**

```
Hello Ross Taylor! You just delved into python.
```

```python
def print_full_name(first, last):
    print(f"Hello {first} {last}! You just delved into python.")

if __name__ == '__main__':
```

### e3 突变

**示例输入**

```
STDIN           Function
-----           --------
abracadabra     s = 'abracadabra'
5 k             position = 5, character = 'k'
```

**示例输出**

```
abrackdabra
```

```python
def mutate_string(string, position, character):
    res = string[:position] + character + string[position+1:]
    return res
```

### e4 找到一个字符串

在这个挑战中，用户输入一个字符串和一个子字符串。你需要统计子字符串在给定字符串中出现的次数。字符串遍历将从左到右进行，而不是从右到左。

**注意：**字符串区分大小写。 

**输入格式**

输入的第一行包含原始字符串。下一行包含子字符串。

**约束条件**

1 《 len（string）《200 

字符串中的每个字符都是ASCII字符。

**输出格式**

输出表示子字符串在原字符串中出现总次数的整数。

**输入示例**

```
ABCDCDC
CDC
```

**输出示例**

```
2
```

```python
def count_substring(string, sub_string):
    count = 0
    for i in range(0,len(string)-len(sub_string)+1):
        # print(string[i:len(sub_string)+i])
        if string[i:len(sub_string)+i] == sub_string:
            count += 1
    return count
```























assert

>  断言语句，主要用于 校验某个条件是否成立，如果不成立就**立即**抛出异常，常用于**测试、调试、校验前置条件**。 	
>
>  **assert = “我认为这里一定是对的，否则程序就该报错”**

基本语法：

```python
assert 条件, "错误说明"
```

例子：

