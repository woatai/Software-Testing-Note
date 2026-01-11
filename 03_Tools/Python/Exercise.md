# PY Exercise

## Exercise 1

> 编写Python代码，遍历前10个数字，并在每次迭代中打印当前数和上一个数的总和。
>
> Write Python code to iterate through the first 10 numbers and, in each iteration, print the sum of the current and previous number.

**答案**

```python
p_num = 0
for i in range(1,11):
    x_num = p_num + i
    print(f"Current Number {i} Previous Number {p_num} Sum: {x_num}")
    p_num = i
```

