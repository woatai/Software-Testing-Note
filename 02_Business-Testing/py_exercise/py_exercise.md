# py_exercise

## basic

### e1 找出亚军

> 根据你大学运动会的参赛者得分表，你需要找出亚军分数。你被给予n个分数。将它们存储在一个列表中，并找到亚军的分数。
>
> ​	输入格式
> 第一行包含n。第二行包含一个由n个整数组成的数组A，每元素之间用空格分隔。
>
>  ![image-20260113150908523](py_exercise.assets/image-20260113150908523.png)
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