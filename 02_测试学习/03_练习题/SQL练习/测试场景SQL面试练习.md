# 测试场景 SQL 面试练习

## 使用说明

这组练习从软件测试工程师的角度出发，不只关注 SQL 是否能执行，还关注能否使用数据库验证接口结果、检查业务数据一致性，以及定位异常数据。

## 练习表结构

### 订单表 `orders`

| 字段 | 含义 |
| --- | --- |
| `id` | 订单主键 |
| `order_no` | 订单号 |
| `user_id` | 用户 ID |
| `status` | 订单状态 |
| `total_amount` | 订单实际支付金额 |
| `created_at` | 创建时间 |

### 订单明细表 `order_item`

| 字段 | 含义 |
| --- | --- |
| `id` | 明细主键 |
| `order_id` | 订单主键 |
| `product_id` | 商品 ID |
| `quantity` | 商品数量 |
| `unit_price` | 商品单价 |

### 商品表 `products`

| 字段 | 含义 |
| --- | --- |
| `id` | 商品主键 |
| `name` | 商品名称 |
| `stock` | 商品库存 |
| `status` | 商品状态 |

### 支付表 `payments`

| 字段 | 含义 |
| --- | --- |
| `id` | 支付记录主键 |
| `order_id` | 订单主键 |
| `transaction_no` | 第三方支付流水号 |
| `pay_status` | 支付状态 |
| `pay_amount` | 支付金额 |
| `created_at` | 支付记录创建时间 |

### 退款表 `refunds`

| 字段 | 含义 |
| --- | --- |
| `id` | 退款记录主键 |
| `order_id` | 订单主键 |
| `refund_status` | 退款状态 |
| `refund_amount` | 退款金额 |
| `created_at` | 退款记录创建时间 |

## 题目一：校验订单是否成功落库

知识点：单表查询、`WHERE`、`LIMIT`、接口数据与数据库数据校验。

> 下单接口返回成功和订单号 `202608170001`。请查询订单是否真实落库，并核对订单状态及金额。

```mysql
SELECT
    id,
    order_no,
    user_id,
    status,
    total_amount
FROM orders
WHERE order_no = '202608170001'
LIMIT 1;
```

测试关注点：

- 是否能通过接口返回的订单号查到唯一订单。
- `user_id` 是否为当前下单用户。
- `status` 是否符合当前业务阶段。
- `total_amount` 是否与接口和页面显示一致。
- 如果查不到数据，需要继续排查事务回滚、异步写入、数据库环境错误或接口错误返回成功等问题。

## 题目二：校验订单商品明细

知识点：三表连接、`LEFT JOIN`、`ON`、字段计算、表别名。

> 使用订单号查询订单中的商品名称、购买数量、商品单价及每项商品的金额。

```mysql
SELECT
    o.id AS order_id,
    o.order_no,
    p.name AS product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS line_amount
FROM orders o
LEFT JOIN order_item oi
    ON oi.order_id = o.id
LEFT JOIN products p
    ON p.id = oi.product_id
WHERE o.order_no = '202608170001';
```

如果还需要计算订单的商品金额合计：

```mysql
SELECT
    o.order_no,
    o.total_amount,
    SUM(oi.quantity * oi.unit_price) AS calculated_amount
FROM orders o
LEFT JOIN order_item oi
    ON oi.order_id = o.id
WHERE o.order_no = '202608170001'
GROUP BY o.order_no, o.total_amount;
```

测试关注点：

- 订单主表存在，但明细表没有数据时，`LEFT JOIN` 仍会返回订单，明细字段显示为 `NULL`。
- 商品 ID、商品名称、数量和单价是否与下单请求一致。
- 商品金额合计不一定等于实际支付金额，还需要考虑优惠券、折扣和运费。

易错点：

- `ON` 用来说明两张表如何关联；`IN` 用来判断一个值是否在一组值中。
- 正确结构是 `LEFT JOIN 表 ON 关联条件`。
- 使用聚合函数 `SUM()` 时，其他非聚合字段通常需要写入 `GROUP BY`。

## 题目三：排查支付状态不一致

知识点：两表连接、明确查询字段、支付链路数据一致性。

> 支付接口返回成功，但订单页面仍显示“待支付”。请使用 SQL 排查原因。

```mysql
SELECT
    o.order_no,
    o.status AS order_status,
    o.total_amount,
    p.transaction_no,
    p.pay_status,
    p.pay_amount,
    p.created_at AS pay_time
FROM orders o
LEFT JOIN payments p
    ON o.id = p.order_id
WHERE o.order_no = '202608170001'
ORDER BY p.created_at DESC;
```

测试关注点：

- 支付字段全部为 `NULL`：订单存在，但支付记录没有落库。
- `pay_status` 为成功，订单仍是待支付：支付成功后订单状态没有同步更新。
- `pay_status` 为待支付或失败：接口可能错误返回成功，或异步回调尚未完成。
- `pay_amount` 与 `total_amount` 不一致：支付金额可能存在异常。
- 同一订单存在多条支付记录时，需要结合流水号和创建时间判断是否为重复支付或正常重试。

易错点：

- `order_no` 属于订单表，应写成 `o.order_no`。
- 面试中尽量查询需要验证的字段，不建议直接使用 `SELECT *`。

## 题目四：查询重复支付的订单

知识点：`WHERE`、`GROUP BY`、`COUNT()`、`HAVING`、去重统计。

> 用户连续点击两次支付按钮。请查询存在两条及以上支付成功记录的订单。

```mysql
SELECT
    order_id,
    COUNT(*) AS success_payment_count
FROM payments
WHERE pay_status = 'success'
GROUP BY order_id
HAVING COUNT(*) >= 2;
```

如果需要判断是否真的产生了多个不同的第三方支付流水：

```mysql
SELECT
    order_id,
    COUNT(DISTINCT transaction_no) AS transaction_count
FROM payments
WHERE pay_status = 'success'
GROUP BY order_id
HAVING COUNT(DISTINCT transaction_no) >= 2;
```

测试关注点：

- 同一订单是否产生多个成功支付流水。
- 是否发生重复扣款。
- 支付接口是否做了幂等控制。
- 重复记录是同一流水重复落库，还是确实产生了不同支付流水。

易错点：

- “两条及以上”使用 `>= 2`，“超过两条”使用 `> 2`。
- `WHERE` 在分组前过滤原始记录，`HAVING` 在分组统计后过滤分组。
- `SELECT COUNT(*) > 2` 只会显示判断结果 `0` 或 `1`，不会过滤不符合条件的分组。

## 题目五：查询超额退款的异常订单

知识点：金额比较、聚合统计、累计退款、`HAVING`。

> 退款接口返回成功。请查询单次退款金额大于订单实际支付金额的异常订单。

```mysql
SELECT
    o.order_no,
    o.total_amount,
    r.refund_amount,
    r.refund_status,
    r.created_at
FROM refunds r
JOIN orders o
    ON o.id = r.order_id
WHERE r.refund_status = 'success'
  AND r.refund_amount > o.total_amount
ORDER BY r.created_at DESC;
```

一笔订单可能多次部分退款，因此还需要检查累计退款金额：

```mysql
SELECT
    o.order_no,
    o.total_amount,
    SUM(r.refund_amount) AS total_refund_amount
FROM refunds r
JOIN orders o
    ON o.id = r.order_id
WHERE r.refund_status = 'success'
GROUP BY o.id, o.order_no, o.total_amount
HAVING SUM(r.refund_amount) > o.total_amount;
```

测试关注点：

- 单次退款是否超过订单实际支付金额。
- 多次部分退款的累计金额是否超过实际支付金额。
- 只统计退款成功的记录，不能把失败或处理中的退款计算进去。
- 是否存在重复退款，以及退款接口是否具备幂等性。

易错点：

- 表别名写在表名后面，例如 `FROM refunds r`。
- SQL 的书写顺序为 `SELECT`、`FROM`、`JOIN ... ON`、`WHERE`、`GROUP BY`、`HAVING`、`ORDER BY`、`LIMIT`。
- 表之间的基础关联关系放在 `ON` 中，查询结果的过滤条件通常放在 `WHERE` 或 `HAVING` 中。

## 本轮练习总结

### `ON` 和 `IN`

- `ON`：定义两张表之间的关联关系。
- `IN`：判断某个字段值是否属于一组候选值。

```mysql
SELECT o.order_no, p.pay_status
FROM orders o
LEFT JOIN payments p
    ON p.order_id = o.id
WHERE p.pay_status IN ('success', 'processing');
```

### `WHERE` 和 `HAVING`

- `WHERE`：在分组前过滤一行一行的原始数据。
- `HAVING`：在 `GROUP BY` 和聚合计算后过滤分组结果。

### 测试工程师的 SQL 回答思路

1. 先说明验证目的，例如确认数据是否落库、状态是否同步或金额是否一致。
2. 使用接口返回的业务唯一标识定位数据，例如订单号或支付流水号。
3. 通过主键和外键关联主表、明细表及流水表。
4. 核对状态、金额、用户、数量和时间等关键字段。
5. 考虑漏写、重复写入、异步延迟、事务回滚和接口幂等等异常情况。
