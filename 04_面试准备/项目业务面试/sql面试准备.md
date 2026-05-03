# SQL 接口测试面试准备

## 这份笔记怎么用

这份是 5-7k 接口测试岗位的 SQL 面试前冲刺版，重点不是数据库底层原理，而是能说清楚：

- 基础查询怎么写。
- `where`、`order by`、`limit` 怎么用。
- `count`、`sum`、`group by` 怎么做统计。
- `join` 怎么做多表关联。
- 接口测试里怎么用 SQL 查库校验。

一句话说明 SQL 在测试里的作用：

> 接口返回只能说明接口层返回了结果，关键业务还需要结合数据库确认是否真实落库、状态是否正确、金额是否一致。比如下单后，我会查订单主表确认订单是否生成，再查订单明细表确认商品和数量是否正确。

## 常用表和业务含义

结合 CRMEB 或商城接口测试，常见表可以这样理解：

- `eb_user`：用户表，校验用户信息、状态、余额、积分。
- `eb_store_product`：商品表，校验商品名称、价格、库存、上下架状态。
- `eb_store_order`：订单主表，校验订单号、用户、支付状态、实付金额。
- `eb_store_order_cart_info`：订单商品明细表，校验订单里买了什么商品、买了几件。

常见关联：

- `eb_store_order.uid = eb_user.uid`
- `eb_store_order_cart_info.oid = eb_store_order.id`
- `eb_store_order_cart_info.product_id = eb_store_product.id`

## 高频面试题

### 1. 你平时怎么用 SQL 做测试？

> 我主要用 SQL 做接口测试后的数据校验。比如接口返回成功后，我会查数据库确认数据是否真实落库、状态是否正确、金额是否一致。像下单场景，我会查订单主表确认订单是否生成，再查订单明细表确认商品和数量是否正确。

### 2. `select`、`where`、`order by`、`limit` 分别是干什么的？

> `select` 是指定查询哪些字段，`where` 是条件筛选，`order by` 是排序，`limit` 是限制返回条数。实际测试里这几个经常一起用，比如按创建时间倒序查某个用户最新的一笔订单。

示例：

```sql
select id, order_id, uid, pay_price, paid
from eb_store_order
where uid = 35
order by id desc
limit 1;
```

### 3. `select *` 和查询指定字段有什么区别？

> `select *` 会查询所有字段，临时排查时可以用，但正式查询或面试回答里我更倾向写明确字段。这样返回数据更少，也更方便看重点，比如只查订单号、用户 ID、支付状态和实付金额。

### 4. SQL 里 `=` 和 `like` 有什么区别？

> `=` 是精确匹配，适合查确定的订单号、用户 ID、状态值；`like` 是模糊匹配，适合按关键词查商品名、用户名等。测试里如果我知道明确订单号，会用 `=`；如果只知道商品名称的一部分，可以用 `like`。

示例：

```sql
select id, store_name, price
from eb_store_product
where store_name like '%手机%';
```

### 5. `and` 和 `or` 怎么用？

> `and` 表示多个条件同时满足，`or` 表示满足其中一个条件即可。接口测试查库时经常会组合条件，比如查某个用户已支付的订单，就会用 `uid = 35 and paid = 1`。

示例：

```sql
select order_id, uid, paid, pay_price
from eb_store_order
where uid = 35 and paid = 1;
```

### 6. `count`、`sum`、`group by` 怎么用？

> `count` 用来统计数量，`sum` 用来求和，`group by` 用来按某个字段分组统计。比如统计每个用户有多少订单、总共支付多少钱，就可以按 `uid` 分组。

示例：

```sql
select uid, count(*) as order_count, sum(pay_price) as total_amount
from eb_store_order
group by uid
order by total_amount desc
limit 10;
```

### 7. `inner join` 和 `left join` 有什么区别？

> `inner join` 只返回两张表都匹配上的数据；`left join` 会保留左表全部数据，右表匹配不到时显示为空。测试查库时我常用 `left join`，因为我想先保留主表数据，再看明细表或商品表有没有匹配记录。

### 8. 怎么校验订单是否真实落库？

> 我会拿下单接口返回的订单号去查订单主表 `eb_store_order`，确认这笔订单有没有写入数据库，同时核对用户 ID、支付状态、实付金额这些关键字段。

```sql
select id, order_id, uid, paid, pay_price
from eb_store_order
where order_id = '{{order_no}}';
```

### 9. 怎么校验订单买了哪些商品？

> 我会先用订单号定位订单主表，再关联订单明细表，确认这笔订单买了哪些商品、每个商品买了几件。

```sql
select a.order_id, a.uid, b.product_id, b.cart_num
from eb_store_order a
left join eb_store_order_cart_info b on a.id = b.oid
where a.order_id = '{{order_no}}';
```

### 10. 怎么校验订单商品名称、数量和金额？

> 这题我会做三表联查。先用订单号定位订单主表，再关联订单明细表拿商品 ID 和购买数量，最后关联商品表查商品名称。这样可以同时校验商品信息、购买数量和订单金额是否一致。

```sql
select a.order_id, b.product_id, c.store_name, b.cart_num, a.pay_price
from eb_store_order a
left join eb_store_order_cart_info b on a.id = b.oid
left join eb_store_product c on c.id = b.product_id
where a.order_id = '{{order_no}}';
```

### 11. 如果接口返回成功，但数据库没有数据怎么办？

> 我会先确认接口请求参数是否正确，再确认接口返回的业务码是否真的成功。如果接口确实成功但数据库没有数据，要看是不是异步写入、事务回滚、写入了其他表、测试环境数据库连错，或者数据被定时任务清理了。必要时会结合后端日志继续排查。

### 12. 如果页面、接口、数据库数据不一致，你怎么排查？

> 我会先分层判断。第一步看页面请求的接口和参数是否正确；第二步看接口响应数据是否正确；第三步查数据库确认底层数据。如果数据库正确但接口不对，可能是后端查询或缓存问题；如果接口正确但页面不对，可能是前端字段映射或展示逻辑问题；如果数据库本身不对，就继续查业务写入逻辑。

### 13. 删除、修改数据的 SQL 面试怎么说？

> 测试工作里我会谨慎执行 `update` 和 `delete`，尤其不能直接在生产环境操作。如果要准备或清理测试数据，会先确认环境、确认条件、先 `select` 查出目标数据，再执行修改，并且尽量带明确条件，避免误改整表。

示例：

```sql
-- 先确认目标数据
select id, order_id, paid
from eb_store_order
where order_id = '{{order_no}}';
```

## 接口测试常见查库场景

### 登录 / 用户接口

- 查用户是否存在。
- 查账号状态是否正常。
- 查用户信息是否和接口返回一致。

### 商品接口

- 查商品是否存在。
- 查价格、库存、上下架状态是否正确。
- 查接口返回的商品信息是否和数据库一致。

### 购物车接口

- 查购物车记录是否生成。
- 查商品数量是否正确。
- 查重复加入购物车是新增记录还是更新数量。

### 下单接口

- 查订单主表是否生成订单。
- 查订单明细是否记录商品和数量。
- 查订单金额是否正确。
- 查库存是否扣减。

### 支付 / 退款接口

- 查支付状态是否更新。
- 查支付金额是否一致。
- 查退款状态和退款金额是否正确。
- 查账户余额、积分、优惠券是否有对应变化。

## 易错点

- SQL 条件判断用 `=`，不是 `==`。
- 字符串一般用单引号，比如 `'test01'`。
- 数字字段通常直接写数字，不用引号。
- 能不用 `select *` 就尽量不用。
- 查库前确认连接的是正确环境的数据库。
- 下单校验不要只查订单主表，还要查订单明细表。
- 金额字段要注意优惠、运费、实付金额和精度。
- `update` / `delete` 必须带明确条件，操作前先 `select` 确认。

## 最后速背

> 我用 SQL 做接口测试校验时，不是单纯查一条数据，而是围绕业务结果查库。比如下单接口，我会先用接口返回的订单号查订单主表，确认订单是否落库、用户和支付状态是否正确；再关联订单明细表和商品表，确认买了什么商品、数量和金额是否一致。如果涉及支付、退款、优惠券、积分这些场景，我还会继续查对应的账户流水、优惠券记录或库存变化，确保接口返回、页面展示和数据库结果一致。
