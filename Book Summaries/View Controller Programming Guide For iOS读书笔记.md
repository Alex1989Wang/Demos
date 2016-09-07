#View Controller Programming Guide 读书笔记(一）

## View Controller 的种类
### Content View Controller (内容型View Controller）

通常见到的view controller都是这种类型。它主要用于呈现App中一些离散的内容。比如一个table view controller就是用来管理其table view所展示出来的内容。

一个content view controller自己独立管理自己的视图。

### Container View Controller (容器型View Controller）

顾名思义，容器型view controller可以说它们管理其他内容型、容器型view controller。比如navigation view controller的作用就是使view controller之间的切换变得更加容易；iPad编程中使用的split view controller还可以布局其管理的自控制器视图的位子和大小。

一个container view controller除了管理自己自带的视图外；还在布局层面上管理着自己的根视图，这些根视图来自自己一个（navigation view controller)或多个子控制器(tab view controller、split view controller)。

## View Controller的作用
- 管理view
- 统筹数据
- 处理用户交互
- 资源管理
- 自适应设备

## View Controller的层级

### 根控制器 root view controller

每一个window都有且仅有一个root view controller。通常情况下，一个window的根控制器都是容器型view controller。

### 展示控制器（presenting view controller)和被展示控制器（presented view controller)

当一个视图控制器被另外一个视图控制器以某种方式（push/modal)展示出来时；被展示出来的Controller（presented view controller)的内容通常会覆盖（全部或者部分）在展示（presenting view controller）上。而这种展示与被展示的关系就构成了view controller的层级；同时，这种关系是运行时定位某个view controller的基础。

### 视图控制器应独立自足

一个视图控制器对另外一个视图控制器内部机制和管理的视图应该是不知晓blind的。在视图控制器之间需要通信和传值得时候，应该使用彼此规定的公开接口public interfaces。

代理设计模式（delegation design pattern）也被广泛运用于视图控制器之间的通信。
