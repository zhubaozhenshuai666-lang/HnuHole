# Git 与 GitHub 工作流（项目约定）

本项目使用本地 Git 保存提交历史，使用 GitHub Actions 做自动检查。用户不需要预先熟悉 Git；每次操作都应说明命令的作用、执行位置和预期结果。

## 当前状态

- 本地仓库由项目维护者初始化；目前不绑定远程 GitHub 地址。
- 首次提交前先检查 `git status`，确认没有把 `.env`、凭据、构建产物或本地基础设施数据加入提交。
- 创建远程仓库后再配置 `origin`，首次推送使用明确的分支名，不用凭记忆执行命令。

## 后续首次提交流程

在项目根目录执行：

```powershell
git status
git add .
git status
git commit -m "chore: initialize project workspace"
```

提交前必须先检查第二次 `git status` 的暂存文件列表；发现不应提交的文件时，先从暂存区移除并修正 `.gitignore`。

## 后续远程推送流程

只有在 GitHub 仓库实际创建后，才填写真实地址：

```powershell
git remote add origin <GitHub仓库地址>
git branch -M main
git push -u origin main
```

不要把访问令牌、密码或 `.env` 文件写入命令、提交或仓库。Actions 的检查结果以 GitHub 页面为准，失败时先读取日志，再修改代码。
