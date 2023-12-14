
<div align="center">
<br><br>

# OASX

<br>

<br>

同 [OAS](https://github.com/runhey/OnmyojiAutoScript) 对接的全平台 GUI

</br>
</div>

### 关于OAS

OAS 是阴阳师的一款自动化脚本，同时也是基于 Alas 进行开发。

Alas 的GUI设计是方案是 [PyWebIO](https://github.com/pywebio/PyWebIO) + [Electron](https://www.electronjs.org/)，实现上非常高效快速，非常满足当时的设计需求。但是同样存在相当的问题：

- 性能开销大，Electron以臃肿而臭名昭著。
- 扩展性受限，所能实现的需求基本依赖于PyWebIO库，缺乏灵活性。
- 屎山难以搬，Alas的长期发展使得其GUI同游戏强耦合，新入手难以理解。

为此 OAS 进行了初次尝试，即 [Qt for Python](https://wiki.qt.io/Qt_for_Python) + [Qt QML](https://doc.qt.io/qt-6/qtqml-index.html), QML语言是Qt家族的一个分支，是基于C++的解释型语言，使用的QML库是[FluentUI](https://github.com/zhuzichu520/FluentUI)，几乎可以满足上方的不足，但是会存在更多的问题。

- QML并不够成熟，缺少三方库管理，非常灵活的代码写法...生态很少
- 运行速度低，qml <-> c++ <-> python 绕了挺多层的数据导致其他的额外开销
- 无法理解的内存回收机制，缓存策略挺绕的，实际下来并不可以
- 只有桌面端

至此将 OAS 的 GUI 部分拆离出来形成 OASX，并希望其可以对接 Alas 体系的其他游戏脚本。

- 全平台，Flutter 以全平台著称，随时用手机控制你的游戏脚本是非常便捷的
- 性能开销低，编译型语言几乎等同于原生语言开发
- 生态足够丰富，Flutter 以移动端起家，几年的发展其桌面端足够成熟，以及丰富的第三方包




## 许可证 LICENSE

This project is licensed under the GNU General Public License v3.0.

## 声明 Announcement
本软件开源、免费，仅供学习交流使用。开发者团队拥有本项目的最终解释权。使用本软件产生的所有问题与本项目与开发者团队无关。


### 开发进度

**截至2023.11.18**

![image-20231118214829823](https://runhey-img-stg1.oss-cn-chengdu.aliyuncs.com/img2/202311182148357.png)

![image-20231118214939238](https://runhey-img-stg1.oss-cn-chengdu.aliyuncs.com/img2/202311182149299.png)

已完成：！！！Can run

- ✔几乎完成展示界面的搭建，关于后端的对接几乎没有开始；（11.18）

- ✔UI样式的调整，作为非专业人士，这并不够优秀（11.18 勉强过得去）

- ✔规划完善的、合乎的接口设计方案 （11.18 勉强过得去）

还需：

- 其他平台的适配，没有苹果的开发者身份，也不能发布

- 进行了一些语言本地化，那麽大的工作量这个翻译，那得累死
- 逐步将oas 的启动迁移至oasx
- 对游戏的视频监控（组内有做视频的，等等 我就会了）
- 加一个，从 OASX 查看日志（导出分享）

细节上的优化：

- 中文字体有些问题，有点是粗体有些不是 很奇怪，未知
- 切换dart/light时候有些组件不会立即生效
- 各种逻辑上的小问题，等着大量测试吧
- log的样式，不过是从python那边来调



## 我们打算在2024.1.1全面切换新到GUI



### 版本要求

**！！！ 很小心Flutter 的版本，这个玩意居然会修改接口导致报错**

- Flutter 3.16.4+

```
Flutter 3.16.4 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 2e9cb0aa71 (3 days ago) • 2023-12-11 14:35:13 -0700
Engine • revision 54a7145303
Tools • Dart 3.2.3 • DevTools 2.28.4
```



## 如何开始(~测试)

#### 1.配置好OASX

从源码来进行debug

[Flutter官网](https://flutter.cn/)，按照官网的步骤进行安装，推荐用vscode

```shell
flutter pub get 
```

选用window设备。

或者是直接下载构建好的release， 如果已经可以有的话

#### 2.启动OAS服务

切换你的分钟到`dev-flutter`

手动用 git 切换，或者是在`./config/deploy.yaml`下进行修改 -> 找到`Get -> Branch` 将master改为 dev-flutter

这个时候你就可以在根目录找到 server.py文件了，直接启动即可

#### 3.启动OASX

![image-20231118233910512](https://runhey-img-stg1.oss-cn-chengdu.aliyuncs.com/img2/202311182339052.png)

用户名和密码不用填，地址就是你的服务端的ip+port。端口在`./config/deploy.yaml`的 Webui->WebuiPort 一般是22288，然后就进入了主界面,开始愉快玩耍。哦对了模拟器记得开着。



## 翻译

翻译量太大了，谁闲着有空来整整

代码在`./lib/common`下， 照着来填就可以了



## Logo

原先的图标太丑了，或者说当时整的比较随意，我们需要一个新的logo，看到群头像的吗，那玩意当时随便搞的。

我们打算整一个新的，截至是大概24年春节后两个星期，总之就是开学前。

如果你是这方面的或者是认识这方面的朋友，都欢迎邀请为此创作，咱们不要版权，你的还是你的。

