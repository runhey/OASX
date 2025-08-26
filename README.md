
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

至此将 OAS 的 GUI 部分拆离出来形成 OASX。

- 全平台，Flutter 以全平台著称，随时用手机控制你的游戏脚本是非常便捷的
- 性能开销低，编译型语言几乎等同于原生语言开发
- 生态足够丰富，Flutter 以移动端起家，几年的发展其桌面端足够成熟，以及丰富的第三方包




## 许可证 LICENSE

This project is licensed under the GNU General Public License v3.0.

## 声明 Announcement
本软件开源、免费，仅供学习交流使用。开发者团队拥有本项目的最终解释权。使用本软件产生的所有问题与本项目与开发者团队无关。



### 版本要求

**很小心Flutter 的版本，这个玩意居然会修改接口导致报错**


```
Flutter 3.27.1 • channel [user-branch] • unknown source
Framework • revision 17025dd882 (8 months ago) • 2024-12-17 03:23:09 +0900
Engine • revision cb4b5fff73
Tools • Dart 3.6.0 • DevTools 2.40.2
```



## Logo

原先的图标太丑了，或者说当时整的比较随意，我们需要一个新的logo，看到群头像的吗，那玩意当时随便搞的。

我们打算整一个新的，截至是大概24年春节后两个星期，总之就是开学前。

如果你是这方面的或者是认识这方面的朋友，都欢迎邀请为此创作，咱们不要版权，你的还是你的。

