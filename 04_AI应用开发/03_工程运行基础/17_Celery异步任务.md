# Celery 异步任务

## 是什么

Celery 可以把耗时任务放到后台执行，不阻塞接口。

## 怎么用

上传文档后，解析、切片、embedding 可以交给 Celery 慢慢处理。
