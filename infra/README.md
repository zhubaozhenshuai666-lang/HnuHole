# 本地基础设施

```powershell
docker compose -f infra/docker-compose.yml up -d
```

服务：

- PostgreSQL：`localhost:5432`，数据库 `hnuhole`
- Mailpit SMTP：`localhost:1025`
- Mailpit Web：`http://localhost:8025`

本地数据保存在 `infra/.data/`，已被 Git 忽略。不要把真实密码或生产连接串写入仓库。
