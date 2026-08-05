# SQL 面试准备整理版

## 一句话定位

SQL 在测试里的作用不是单纯写查询语句，而是用来做业务结果校验。接口返回只能说明接口层返回了结果，关键业务还要结合数据库确认是否真实落库、状态是否正确、金额是否一致。

面试里可以这样说：

> 我用 SQL 主要做接口测试后的数据校验。比如下单接口返回成功后，我会先拿订单号查订单主表，确认订单是否真实生成、用户和支付状态是否正确；再查订单明细表，确认买了什么商品、数量是否正确；如果涉及支付、退款、优惠券或积分，还会继续查对应的状态和流水变化。

这份笔记的目标是：

- 能讲清楚基础查询：`select`、`where`、`order by`、`limit`。
- 能讲清楚统计查询：`count`、`sum`、`group by`。
- 能讲清楚多表关联：`inner join`、`left join`。
- 能结合接口测试说明怎么查库校验落库、状态、金额、明细。
- 不把自己包装成数据库专家，重点体现测试场景里的查库能力。

## 常用表和业务含义

结合 CRMEB 或商城接口测试，常见表可以这样理解：

- `eb_user`：用户表，校验用户信息、状态、余额、积分。
- `eb_store_product`：商品表，校验商品名称、价格、库存、上下架状态。
- `eb_store_order`：订单主表，校验订单号、用户、支付状态、实付金额。
- `eb_store_order_cart_info`：订单商品明细表，校验订单里买了什么商品、买了几件。

常见关联关系：

- `eb_store_order.uid = eb_user.uid`
- `eb_store_order_cart_info.oid = eb_store_order.id`
- `eb_store_order_cart_info.product_id = eb_store_product.id`

## 基础查询怎么答

基础查询重点是：

- `select`：查哪些字段。
- `where`：筛选哪些数据。
- `order by`：按什么排序。
- `limit`：限制返回多少条。

面试里不要只说“我会写 SQL”，可以说成：

> 我会先确定要查哪张表、查哪些字段，再结合业务条件用 `where` 做筛选，必要时用 `order by` 查最新数据，用 `limit` 控制返回条数，避免整表查询。

### 基础查询示例

查最新上架的 10 条商品：

```sql
select id, store_name, price
from eb_store_product
order by id desc
limit 10;
```

查状态正常的 5 个用户：

```sql
select uid, account, nickname
from eb_user
where status = 1
order by uid desc
limit 5;
```

查某个商品详情：

```sql
select id, store_name, price, stock
from eb_store_product
where id = 2;
```

查账号为 `test01` 的用户：

```sql
select uid, account, nickname, status
from eb_user
where account = 'test01'
limit 1;
```

查支付状态为 0 的 20 条订单：

```sql
select id, order_id, uid, pay_price, paid, add_time
from eb_store_order
where paid = 0
order by add_time desc
limit 20;
```

查某个用户的订单：

```sql
select order_id, pay_price, paid
from eb_store_order
where uid = 35;
```

## 高频面试题

### 1. 你平时怎么用 SQL 做测试？

思路：

- 接口后查库。
- 校验落库。
- 校验状态和金额。
- 结合下单场景。

回答：

> 我主要用 SQL 做接口测试后的数据校验。比如接口返回成功后，我会查数据库确认数据是否真实落库、状态是否正确、金额是否一致。像下单场景，我会查订单主表确认订单是否生成，再查订单明细表确认商品和数量是否正确。

### 2. `select`、`where`、`order by`、`limit` 分别是干什么的？

思路：

- `select` 查字段。
- `where` 做筛选。
- `order by` 排序。
- `limit` 限制条数。

回答：

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

思路：

- `select *` 查全部。
- 指定字段更清晰。
- 减少无关数据。
- 面试更推荐明确字段。

回答：

> `select *` 会查询所有字段，临时排查时可以用，但正式查询或面试回答里我更倾向写明确字段。这样返回数据更少，也更方便看重点，比如只查订单号、用户 ID、支付状态和实付金额。

### 4. SQL 里 `=` 和 `like` 有什么区别？

思路：

- `=` 精确匹配。
- `like` 模糊匹配。
- 结合订单号和商品名。

回答：

> `=` 是精确匹配，适合查确定的订单号、用户 ID、状态值；`like` 是模糊匹配，适合按关键词查商品名、用户名等。测试里如果我知道明确订单号，会用 `=`；如果只知道商品名称的一部分，可以用 `like`。

示例：

```sql
select id, store_name, price
from eb_store_product
where store_name like '%手机%';
```

### 5. `and` 和 `or` 怎么用？

思路：

- `and` 同时满足。
- `or` 满足其一。
- 查订单常组合条件。

回答：

> `and` 表示多个条件同时满足，`or` 表示满足其中一个条件即可。接口测试查库时经常会组合条件，比如查某个用户已支付的订单，就会用 `uid = 35 and paid = 1`。

示例：

```sql
select order_id, uid, paid, pay_price
from eb_store_order
where uid = 35 and paid = 1;
```

### 6. 为什么会把 `where` 和 `limit` 一起用？

思路：

- `where` 过滤范围。
- `limit` 控制返回量。
- 常用于查最新一条或前几条。

回答：

> 因为表数据很多时，`where` 可以先过滤掉无关数据，`limit` 再控制返回数量，这样查询更精准，也能减少不必要的数据扫描和结果返回。在接口测试和查库验证时，我很多时候只需要最新一条或者前几条数据。

### 7. `count`、`sum`、`group by` 怎么用？

思路：

- `count` 统计数量。
- `sum` 统计金额。
- `group by` 分组。
- 订单统计场景。

回答：

> `count` 用来统计数量，`sum` 用来求和，`group by` 用来按某个字段分组统计。比如统计每个用户有多少订单、总共支付多少钱，就可以按 `uid` 分组。

示例：

```sql
select uid, count(*) as order_count, sum(pay_price) as total_amount
from eb_store_order
group by uid
order by total_amount desc
limit 10;
```

### 8. `inner join` 和 `left join` 有什么区别？

思路：

- `inner join` 只要匹配数据。
- `left join` 保留左表。
- 测试常保留主表排查。

回答：

> `inner join` 只返回两张表都匹配上的数据；`left join` 会保留左表全部数据，右表匹配不到时显示为空。测试查库时我常用 `left join`，因为我想先保留主表数据，再看明细表或商品表有没有匹配记录。

## 业务查询标准题

### 1. 校验订单是否真实落库

业务话术：

> 我会拿下单接口返回的订单号去查订单主表 `eb_store_order`，确认这笔订单有没有真实写入数据库，同时核对订单所属用户、支付状态和实付金额这些关键字段是否正确。

```sql
select id, order_id, uid, paid, pay_price
from eb_store_order
where order_id = '{{order_no}}';
```

### 2. 校验订单商品明细

业务话术：

> 我会用订单号先定位订单主表，再把订单主表和订单明细表关联起来，确认这笔订单买了哪些商品、每个商品买了几件。

```sql
select a.order_id, a.uid, b.product_id, b.cart_num
from eb_store_order a
left join eb_store_order_cart_info b on a.id = b.oid
where a.order_id = '{{order_no}}';
```

### 3. 校验订单里的商品名称和数量

业务话术：

> 这题我会做三表联查。先用订单号在订单主表里定位这笔订单，再通过订单主键关联订单明细表，拿到商品 ID 和购买数量，最后再关联商品表查商品名称。这样可以同时校验订单金额、商品信息和购买数量是否一致。

```sql
select a.order_id, b.product_id, c.store_name, b.cart_num, a.pay_price
from eb_store_order a
left join eb_store_order_cart_info b on a.id = b.oid
left join eb_store_product c on c.id = b.product_id
where a.order_id = '{{order_no}}';
```

### 4. 统计每个用户的订单数和总支付金额

业务话术：

> 这题我会先按 `uid` 分组，因为要统计每个用户的数据；然后用 `count(*)` 统计每个用户下了多少单，用 `sum(pay_price)` 统计每个用户总共支付了多少钱；最后按总支付金额倒序排序，取前 10 条。

```sql
select a.uid, count(*) as order_count, sum(a.pay_price) as total_amount
from eb_store_order a
group by a.uid
order by total_amount desc
limit 10;
```

### 5. 统计每个商品卖出了多少件

业务话术：

> 这题我不会直接假设商品表里一定有现成销量字段，而是会从订单明细表去统计。因为订单明细表里记录了每个商品买了几件，所以我会先把订单明细表和商品表关联起来，再按 `product_id` 分组，用 `sum(cart_num)` 统计每个商品的总销量，最后按销量倒序取前 10 条。

```sql
select b.product_id, c.store_name, sum(b.cart_num) as total_num
from eb_store_order_cart_info b
left join eb_store_product c on c.id = b.product_id
group by b.product_id, c.store_name
order by total_num desc
limit 10;
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

## 异常场景怎么排查

### 1. 如果接口返回成功，但数据库没有数据怎么办？

思路：

- 确认请求参数。
- 确认业务码。
- 排查异步、事务、环境。
- 结合日志。

回答：

> 我会先确认接口请求参数是否正确，再确认接口返回的业务码是否真的成功。如果接口确实成功但数据库没有数据，要看是不是异步写入、事务回滚、写入了其他表、测试环境数据库连错，或者数据被定时任务清理了。必要时会结合后端日志继续排查。

### 2. 如果页面、接口、数据库数据不一致，你怎么排查？

思路：

- 页面请求。
- 接口响应。
- 数据库结果。
- 分层定位。

回答：

> 我会先分层判断。第一步看页面请求的接口和参数是否正确；第二步看接口响应数据是否正确；第三步查数据库确认底层数据。如果数据库正确但接口不对，可能是后端查询或缓存问题；如果接口正确但页面不对，可能是前端字段映射或展示逻辑问题；如果数据库本身不对，就继续查业务写入逻辑。

### 3. 删除、修改数据的 SQL 面试怎么说？

思路：

- 谨慎操作。
- 不直接动生产。
- 先 `select` 确认。
- `update` / `delete` 必须带条件。

回答：

> 测试工作里我会谨慎执行 `update` 和 `delete`，尤其不能直接在生产环境操作。如果要准备或清理测试数据，会先确认环境、确认条件、先 `select` 查出目标数据，再执行修改，并且尽量带明确条件，避免误改整表。

示例：

```sql
-- 先确认目标数据
select id, order_id, paid
from eb_store_order
where order_id = '{{order_no}}';
```

## 易错点

- SQL 条件判断用 `=`，不是 `==`。
- 字符串一般用单引号，比如 `'test01'`。
- 数字字段通常直接写数字，不用引号。
- 能不用 `select *` 就尽量不用。
- 查库前确认连接的是正确环境的数据库。
- 下单校验不要只查订单主表，还要查订单明细表。
- 金额字段要注意优惠、运费、实付金额和精度。
- 用户状态常看 `status`，支付状态常看 `paid`，创建时间常看 `add_time`。
- `update` / `delete` 必须带明确条件，操作前先 `select` 确认。

## 最后速背

面试官问“你怎么用 SQL 做测试”，可以直接背：

> 我做业务数据校验时，一般会先选核心业务链路，比如下单、支付、退款、会员权益发放、优惠券核销这些场景。用户在前端完成操作后，我会先看接口返回和页面结果，再用 SQL 去查关键业务表，确认数据是否真实落库、状态是否正确流转、金额是否一致。比如订单场景里，我会查订单主表确认订单号、用户 ID、支付状态、实付金额；再查订单明细表确认买了什么商品、数量是否正确；如果涉及余额、积分、优惠券，我还会继续查用户表、账户变动表或者优惠券记录表，确认是否真的扣减或发放成功。如果是报表或者统计类功能，我会先确认统计口径，再通过 SQL 做抽样汇总，比如用 `count`、`sum`、`group by` 去核对订单数、金额、优惠券核销数，确保页面展示、接口返回和数据库结果一致。
