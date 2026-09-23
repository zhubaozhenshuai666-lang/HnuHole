# Git 与 GitHub 工作流（项目约定）

本项目使用本地 Git 保存提交历史，使用 GitHub Actions 做自动检查。用户不需要预先熟悉 Git；每次操作都应说明命令的作用、执行位置和预期结果。

## 当前状态

- 本地仓库已由项目维护者初始化；远程 `origin` 已绑定 `https://github.com/zhubaozhenshuai666-lang/HnuHole.git`。
- 当前开发分支为 `feature/engineering-baseline`，已跟踪 `origin/feature/engineering-baseline`；`main` 已跟踪 `origin/main`。
- 首次提交前先检查 `git status`，确认没有把 `.env`、凭据、构建产物或本地基础设施数据加入提交。
- 后续推送使用当前明确的分支名，不把功能分支直接改名或强推到 `main`；合并和分支保护以 GitHub 仓库设置为准。

## 后续首次提交流程

在项目根目录执行：

```powershell
git status
git add .
git status
git commit -m "chore: initialize project workspace"
```

提交前必须先检查第二次 `git status` 的暂存文件列表；发现不应提交的文件时，先从暂存区移除并修正 `.gitignore`。

## 当前远程推送流程

```powershell
git status
git push
```

如果本地分支尚未设置上游，先使用 `git push -u origin <当前分支名>`，成功后以后直接执行 `git push`。不要把访问令牌、密码或 `.env` 文件写入命令、提交或仓库。Actions 的检查结果以 GitHub 页面为准，失败时先读取日志，再修改代码。
