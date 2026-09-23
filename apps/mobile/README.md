# Hnuhole Mobile

当前代码实现任务 1 的入口树和通道目录客户端边界：

- 未登录：只显示无节点树外壳和邮箱登录入口；
- 登录后：请求 `GET /api/v1/channels`，完整校验七项后再显示节点；
- 目录失败：不显示部分节点，保留重试；
- 节点场景：二维可拖动，`mutual_help` 和 `technology` 位于场景深处；
- 拖动位置只在当前登录会话内保留。

本机暂未安装 Flutter/Dart SDK，因此尚未执行 `flutter pub get`、`flutter analyze` 或运行客户端。认证页面会在下一步接入，当前由宿主回调提供已验证会话令牌。
