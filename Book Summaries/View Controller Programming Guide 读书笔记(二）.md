#View Controller Programming Guide 读书笔记(二）

## 处理用户交互

尽管view controllers是responder的子类，但是view controllers很少直接处理用户交互。view controllers通常是以下面几种方式处理交互：

- Action Methods.一些UI空间会调用其action method来向view controller上报特定的用户交互行为；手势识别器（gesture recognizers）也可以定义action methods。
- Notificationi Observers.视图控制器可以成为系统通知或者其他对象发送的通知的监听者。在监听到通知之后做出相应的回应。
- Data Source & Delegate.视图控制器可以作为其他对象的数据源或者代理。

## 设计一个自定义的Container View Controller
