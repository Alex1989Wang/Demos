用户通知（User Notifications）可以有两种形式：

- 本地通知（Local Notifications）
- 远程通知（Remote Notifications）

它们和应用编程中使用的应用内广播通知（使用NSNotificationCenter）或者KVO的通知是不一样的。用户通知能够让不在前台的App提示它们的用户有新的通知到达。

##通知到达如何处理

- App不在前台。当App不在前台时，用户通知可以通过Aler，icon badge nubmer, sound和vibration方式向用户呈现。当用户点击Alert上的action button，会唤醒app，同时传入通知内容。那么此时是系统代理App接受通知。
- App在前台时。会由App的delegate来处理到达的用户通知。

对于远程通知来讲，当设备没有网络的时候，如果有多条用户通知到达，APNs的服务器只会记住用户的最后一条。在下次用户设备连接网络的时候，将这条推送下发。

在WIFI条件下，注册远程通知是可能失败的。原因是当下使用的WIFI屏蔽了APNs服务的端口。

Token trust ensures that notifications are routed only between legitimate start and end points. Token trust
involves the use of a device token, which is an opaque identifier assigned to a specific app on a specific
device. Each app instance receives its unique token when it registers with APNs and must share this token
with its provider. Thereafter, the token must accompany each notification sent by your provider. Providing
the token ensures that the notification is delivered only to the app/device combination for which it is
intended. 设备的token可能变化（比如在用户选择系统升级的时候），所以，必须在每次启动App的时候重新获取最新的设备token。

