# 实际案例：三层架构项目的迭代审计

## 背景

用户 fork 了一个多级 fork 仓库，需要建立完整的 AI 协作规则、Git 工作流、自动化脚本。

## 审计轮次与发现

### 第一轮：全私有方案

**设计：** 所有规则/脚本/文档放入 `.ai-local/`（git-ignored）。

**发现 #1 [严重] Bootstrap 死循环：**
- `package.json` 写了 `"setup": "bash .ai-local/scripts/setup.sh"`
- `.ai-local/` 被 git-ignored
- clone 后 `bun run setup` → `No such file or directory`

**发现 #2 [严重] AI 入口缺失：**
- `AGENTS.md` / `CLAUDE.md` / `.factory/rules.md` 全部 git-ignored
- 新 AI 工具打开仓库看不到任何规则

**修正：** 采用两层架构 — 骨架入库（AGENTS.md + scripts/）+ 个人层私有（.ai-local/）。

### 第二轮：两层架构修正后

**发现 #3 [中等] 废弃残留：**
- `.ai-local/` 中残留多个旧版文件
- 新人会被困惑「哪个是真的」

**发现 #4 [中等] .gitignore 注释过时：**
- 注释说「自动化脚本本地私有」但脚本已入库

**修正：** 清理残留、更新注释。

### 第三轮：新人全流程模拟

**发现 #5 [中等] AGENTS.md 缺快速开始：**
- 直接从开发铁律讲起，新人不知道「我该先干什么」

**发现 #6 [严重] 交互脚本对 AI 不可用：**
- `sync.sh` / `commit.sh` 用 `read` / `select` 交互
- AI 工具无 stdin，脚本会阻塞

**修正：** 加快速开始段落、全部脚本支持 `--yes` 非交互参数。

## 总结

三轮审计共发现 6 个问题（3 严重 + 2 中等 + 1 轻微），每轮修正后再审都能发现新的遗漏。这验证了「对抗性接替者审计」的核心价值：**不是一次性的，而是迭代式的，每轮修正后都值得再走一遍。**
