# 移动端与服务端工程基线

状态：accepted（2026-09-22）。项目首版采用 Flutter/Dart 移动端、Go 服务端和模块化单体后端；模块化单体保留清晰的领域边界，后续只有在实际压力或隔离需求成立时才拆分服务。完整邮箱及任何可反推出邮箱的匹配数据仍须保持独立边界，不进入社区业务库；隐私认证的跨组织信任边界另见 [ADR 0005](0005-privacy-preserving-email-authentication.md)。

## 影响

- iOS 与 Android 共用 Flutter 客户端代码；当前 Windows 环境优先验证 Android，iOS 构建安排到 macOS 或 CI。
- Go 服务端负责账号、身份、内容、消息和权限等服务端权威规则。
- Go 服务端框架、数据库访问、接口协议和客户端本地存储已在 [ADR 0002](0002-communication-and-persistence-baseline.md) 确认；仓库组织、认证边界和首条垂直切片见 [ADR 0003](0003-repository-auth-and-first-slice.md)。
