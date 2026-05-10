# SQL 面试速背稿（基础查询 + 业务查询）

这份笔记是结合当前 CRMEB 项目的常用表和业务场景整理的，目标不是背语法，而是让回答更像真实做过接口校验和查库验证的人。

---

## 一、项目里常用的表

- `eb_user`：用户表
- `eb_store_product`：商品表
- `eb_store_order`：订单主表
- `eb_store_order_cart_info`：订单商品明细表

### 常用关联关系

- `eb_store_order.uid = eb_user.uid`
- `eb_store_order_cart_info.oid = eb_store_order.id`
- `eb_store_order_cart_info.product_id = eb_store_product.id`

---

## 二、基础查询怎么答

基础查询重点是：

- `select`：查哪些字段
- `where`：筛选哪些数据
- `order by`：按什么排序
- `limit`：限制返回多少条

面试里不要只说“我会写 SQL”，要说成：

> 我会先确定要查哪张表、查哪些字段，再结合业务条件用 `where` 做筛选，必要时用 `order by` 查最新数据，用 `limit` 控制返回条数，避免整表查询。

---

## 三、基础查询标准题

### 1. 查最新上架的 10 条商品

```sql
select id, store_name, price
from eb_store_product
order by id desc
limit 10;
```

### 2. 查状态正常的 5 个用户

```sql
select uid, account, nickname
from eb_user
where status = 1
order by uid desc
limit 5;
```

### 3. 查某个商品详情

```sql
select id, store_name, price, stock
from eb_store_product
where id = 2;
```

### 4. 查账号为 `test01` 的用户

```sql
select uid, account, nickname, status
from eb_user
where account = 'test01'
limit 1;
```

### 5. 查支付状态为 0 的 20 条订单

```sql
select id, order_id, uid, pay_price, paid, add_time
from eb_store_order
where paid = 0
order by add_time desc
limit 20;
```

### 6. 查某个用户的订单

```sql
select order_id, pay_price, paid
from eb_store_order
where uid = 35;
```

---

## 四、基础查询口语回答

### 1. `where`、`order by`、`limit` 分别是干什么的

可以这样答：

> `where` 是条件筛选，用来缩小数据范围；`order by` 是排序，比如按创建时间倒序查最新订单；`limit` 是限制返回条数，常用于分页或者只取前几条数据。实际工作里这三个经常一起用，因为查询既要准确，也要控制返回量。

### 2. `select *` 和 `select 指定字段` 有什么区别

可以这样答：

> 我更倾向写明确字段，比如 `select id, store_name, price`。这样查询效率更高，返回数据更少，也更方便定位问题。`select *` 在临时排查时可以用，但正式 SQL 或面试回答里我会尽量避免。

### 3. 为什么会把 `where` 和 `limit` 一起用

可以这样答：

> 因为表数据很多时，`where` 可以先过滤掉无关数据，`limit` 再控制返回数量，这样查询更精准，也能减少不必要的数据扫描和结果返回。在接口测试和查库验证时，我很多时候只需要最新一条或者前几条数据。

---

## 五、基础查询易错点

- SQL 条件判断用 `=`，不是 `==`
- 数字字段通常直接写数字，不用引号
- 字符串一般用单引号，比如 `'test01'`
- 能不用 `select *` 就尽量不用
- 业务字段要分清：
  - 用户状态常看 `status`
  - 支付状态常看 `paid`
  - 创建时间常看 `add_time`

---

## 六、业务查询怎么答

业务查询不要只说会 `join`、`group by`、`count`、`sum`，而要说成：

> 我会结合业务场景做 SQL 校验。比如订单创建后，我会查订单主表确认是否落库，再查订单明细表确认买了什么商品、买了几件；如果涉及商品名称，我会再联商品表；如果涉及报表或统计，我会用 `group by`、`count`、`sum` 去核对订单数、金额和销量，确保页面展示、接口返回和数据库结果一致。

---

## 七、业务查询标准题

### 1. 校验订单是否落库

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
left join eb_store_order_cart_info b
on a.id = b.oid
where a.order_id = '{{order_no}}';
```

### 3. 校验订单里的商品名称和数量

业务话术：

> 这题我会做三表联查。先用订单号在订单主表里定位这笔订单，再通过订单主键关联订单明细表，拿到商品 ID 和购买数量，最后再关联商品表查商品名称。这样可以同时校验订单金额、商品信息和购买数量是否一致。

```sql
select a.order_id, b.product_id, c.store_name, b.cart_num, a.pay_price
from eb_store_order a
left join eb_store_order_cart_info b
on a.id = b.oid
left join eb_store_product c
on c.id = b.product_id
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
left join eb_store_product c
on c.id = b.product_id
group by b.product_id, c.store_name
order by total_num desc
limit 10;
```

---

## 八、业务查询核心思路

### 1. 查单笔订单是否落库

- 先找订单主表
- 核对订单号、用户、支付状态、实付金额

### 2. 查订单买了什么

- 再联订单明细表
- 核对商品 ID、购买数量

### 3. 查商品名称

- 再联商品表
- 核对商品名称和数量是否一致

### 4. 查用户统计

- 想到 `group by + count(*) + sum(pay_price)`

### 5. 查商品销量

- 想到订单明细表
- 按 `product_id` 分组
- 用 `sum(cart_num)` 统计销量

---

## 九、面试里怎么说“我怎么用 SQL 做业务数据校验”

可以直接背：

> 我做业务数据校验时，一般会先选核心业务链路，比如下单、支付、退款、会员权益发放、优惠券核销这些场景。用户在前端完成操作后，我会先看接口返回和页面结果，再用 SQL 去查关键业务表，确认数据是否真实落库、状态是否正确流转、金额是否一致。比如订单场景里，我会查订单主表确认订单号、用户 ID、支付状态、实付金额；再查订单明细表确认买了什么商品、数量是否正确；如果涉及余额、积分、优惠券，我还会继续查用户表、账户变动表或者优惠券记录表，确认是否真的扣减或发放成功。如果是报表或者统计类功能，我会先确认统计口径，再通过 SQL 做抽样汇总，比如用 `count`、`sum`、`group by` 去核对订单数、金额、优惠券核销数，确保页面展示和数据库结果一致。

---

## 十、面试前最后提醒

### 1. 回答时尽量带业务词

不要只说：

> 我会 `join`

尽量说：

> 我会联查订单主表、订单明细表和商品表，确认订单是否真实落库、买了什么商品、数量和金额是否一致。

### 2. 回答时尽量带“验证目的”

不要只说：

> 我会查库

尽量说：

> 我会查库确认是否落库、状态是否正确、金额是否一致。

### 3. SQL 不会全写也没关系

面试里先把思路说清楚很重要：

- 查哪张表
- 用什么字段关联
- 想验证什么结果

只要这三点清楚，面试官通常会觉得你是做过业务校验的人。
