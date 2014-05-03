##知乎日报web版（非官方）

###简介
新版实现了一个简陋的MVC框架，并重写了手机和电脑显示样式。

demo：[知乎日报 - 满足你的好奇心](http://www.zhihudaily.net/)

###部署

* crawler.coffee 是用coffee写的node.js实现的爬虫模块（依赖于mysql、rss模块）,需要一直在后台运行。
* 配置nginx的所有非文件请求转发到index.php，index.php是入口文件
* 数据库结构见daily.sql，可以直接导入

###TODO

* 文章搜索
* 主题日报
* 显示评论
* 文章分享

###知识产权

* 所有文章著作权均归用户本人所有
* 对于标注了「禁止转载」的内容提供原文链接（例：[为什么大型商场的第一层通常都是卖化妆品的？ - 知乎日报](http://zhihudaily.faceair.me/story/2096)）