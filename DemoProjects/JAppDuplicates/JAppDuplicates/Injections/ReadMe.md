# YTTInjectedContentKit

iOS壳版本场景下的批量修改类名、属性名、插入混淆代码、修改项目名称的shell脚本

具体的实现和使用方法请参考我的博客文章：  
[iOS使用shell脚本注入混淆内容](https://my.oschina.net/FEEDFACF/blog/1621956)  
[iOS使用Shell脚本批量修改类名称](https://my.oschina.net/FEEDFACF/blog/1627398)  
[iOS使用shell脚本批量修改属性](https://my.oschina.net/FEEDFACF/blog/1626928)  


## 已经实现功能

- [x] 批量修改类名称 RenameClasses.sh
- [x] 批量修改类属性名 RenameProperty.sh
- [x] 添加混淆的代码 injectedContentShell.sh
- [x] 恢复到修改之前状态 discardallchanges.sh
- [x] 修改项目名称 RenameProject.sh  
	
**RenameProject.sh 位于./DevPods/InjectedContentKit/ZytInjectContentExampleProj/Shell目录下，ZytInjectContentExampleProj是对应的测试工程**  
**其它的脚本位于./DevPods/InjectedContentKit/Example/injectContentShell目录下,Example是对应的测试工程**/

## TODOS
- [ ] RenameDir.sh 修改文件夹脚本
- [ ] RenameFunction.sh 批量修改方法名脚本

## 使用方法
- 执行`./main.sh`批量修改类名和方法名  
- 执行`./discardallchanges.sh`恢复到原来的状态  
- 执行`injectedContentShell.sh`批量添加混淆内容
**这两个方法要配套使用，否则会出岔子，导致临时文件不能正确删除，切记**


## 文件及其作用

### 类处理相关文件
- GenRenameClasses.sh 从指定的目录读取类文件生成重命名类的配置文件RenameClasses.cfg
- RenameClasses.cfg 生成的重命名类的配置文件
- RenameClasses.sh 读取RenameClasses.cfg配置文件，修改配置的类名、修改引用、修改在pbxproj文件中的索引

### 属性处理相关文件
- RenameProperty.sh 读取RenameProperties.cfg配置文件，批量修改指定目录下的类对应的属性名
- RenameProperties.cfg 该文件自动生成的，保存需要修改的属性名
- DefaultBlackListPropertiesConfig.cfg 配置在该文件中的属性不会被修改，修改会出现问题的属性在这个文件中添加配置，默认添加了一些是系统类的属性，如果因为某些属性的修改出现问题，往这个文件中添加配置即可


### 注入内容处理相关文件
- injectedContentConfig.cfg 注入内容配置文件，每一行作为注入的内容，需要自行添加更多的配置到该文件中
- injectedContentShell.sh 注入内容脚本
