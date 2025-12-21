## 一、Fiddler简介

+ fiddler是位于客户端和服务器端的HTTP代理
+ 目前最常用的http抓包工具之一
+ 功能非常强大，是web调试的利器
  + 监控浏览器所有的HTTP/HTTPS流量
  + 查看、分析请求内容细节
  + 伪造客户端请求和服务器响应测试网站的性
  + 解密HTTPS的web会话
  + 全局、局部断点功能

使用场景

+ 接口调试，线上环境调试，web性能分析
+ 判断前后端bug、开发环境hosts设置、mock、弱网断网

## 二、基本操作

### 2.1 抓取请求

### 2.2 删除请求

clear

### 2.3 过滤请求

![image-20250721110807649](fiddler笔记.assets/image-20250721110807649.png)

### 2.4 抓取https

![image-20250721111907438](fiddler笔记.assets/image-20250721111907438.png)

[Fiddler抓包工具保姆级使用教程（超详细）_抓包软件怎么使用-CSDN博客](https://blog.csdn.net/Mubei1314/article/details/122389950)

> 步骤
>
> Tools-0ptions-HTTPS-勾选左边所有选项-重启fiddler
>
> 需要再actions上导入安全证书

## 三、抓包

什么是抓包？

抓取客户端发给服务器的消息

抓取服务器发给客户端的消息

**应用场景**

+ 通过抓包工具截取观察网站的请求信息，更深入了解网站
+ 帮助我们进行日志定位与描述
+ 通过抓包工具拦截修改请求信息，绕过界面的限制，测试服务端的功能

### 3.1 移动端抓包

> 步骤

+ tools->Options->Connections，勾选Allow remote computers to connect
+ 手机和电脑连上在同一个局域网
+ 在网路中设置代理
+ 为手机安装ssl证书



## 四、接口和接口自动化

## 五、弱网测试

工具栏Rules>Performance>Simulate Modem Speeds勾选表示开启弱网

在菜单栏的 Rules > Customize Rules  
搜索modem字样，搜索2g/3g的网速的速率

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/07513af415de2b887c43c47d186fcafa.png)

