# OpenAPI 契约

`channel-api.yaml` 是当前首条切片的接口唯一来源。服务端和客户端实现都必须以这份契约为准；不要在客户端另写一套通道业务清单。

后续工具链就绪后，在仓库根目录执行 OpenAPI 校验，并用 `oapi-codegen` 生成 Go 服务端类型/接口。生成文件不提交，规则见 `.gitignore`。
