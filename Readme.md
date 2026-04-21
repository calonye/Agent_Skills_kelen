# Agent_Skills_kelen

> AI Agent 思维技能孵化工作空间 — 将深度对话中的方法论提炼为可复用的结构化技能。

## 项目概述

本仓库是个人 AI Agent Skill 的孵化与迭代空间。每个 skill 是一个独立的方法论包，遵循 [yao-meta-skill](https://github.com/anthropics/yao-meta-skill) 规范，可部署到 Claude Code / Codex 等 AI 工具的 skill 系统中。

**核心理念**：AI 在深度对话中会领悟新的思维方式和工作方法，但这些领悟会随 session 结束而消亡。本项目将这些方法论结构化、固化为可复用的 skill 包，让 AI 具备持续自我进化的能力。

## 技能清单

| 技能 | 描述 | 版本 | 状态 |
|------|------|------|------|
| [adversarial-successor-audit](./adversarial-successor-audit/) | 以「有洁癖的新人接替者」视角做全流程对抗性审计 | v0.1.0 | 可用 |
| [dialectical-self-review](./dialectical-self-review/) | 在行动前对自己的方案做结构化自我反驳 | v0.1.0 | 可用 |
| [skill-self-evolution](./skill-self-evolution/) | 从对话中实时识别方法论并转化为可部署的 skill 包 | v0.1.0 | 可用 |

### 技能关系

```
对话产生领悟
      ↓
skill-self-evolution ──→ 识别 + 判断 + 转化为新 skill
      ↑                          ↓
      └── dialectical-self-review ←── 辩证审查发现新模式
                                          ↓
                              adversarial-successor-audit ←── 交付前审计
```

## 快速开始

### 安装部署

```bash
# 克隆仓库
git clone https://github.com/calonye/Agent_Skills_kelen.git
cd Agent_Skills_kelen

# 部署单个 skill 到 Claude Code
bash adversarial-successor-audit/update.sh

# 部署所有 skill（需要 ~/.claude/skills/update-all.sh）
~/.claude/skills/update-all.sh
```

### 使用方式

Skill 部署到 `~/.claude/skills/` 后，AI 工具会根据 `SKILL.md` 的 `description` 字段自动路由匹配。触发方式：

- **adversarial-successor-audit**：说「对抗性审计」「新人模拟」「交付前检查」
- **dialectical-self-review**：说「思辨一下」「对抗性审查你的思考」「先想清楚再做」
- **skill-self-evolution**：说「提炼技能」「这次对话学到了什么」「方法论转化」

### 开发新 Skill

参见 `Docs/开发指导规范.md`（本地私有，不入库）。

## 目录结构

```
Agent_Skills_kelen/
├── Readme.md                              # 本文件
├── LICENSE                                # MIT 协议
├── CHANGELOG.md                           # 变更日志
├── .gitignore
├── Docs/                                  # (git-ignored) 内部设计文档
├── adversarial-successor-audit/           # Skill: 对抗性接替者审计
│   ├── SKILL.md                           #   路由 + 流程骨架
│   ├── agents/interface.yaml              #   接口声明
│   ├── references/                        #   审计清单、子模式、案例
│   └── update.sh                          #   (git-ignored) 本地部署脚本
├── dialectical-self-review/               # Skill: 辩证自我审查
│   ├── SKILL.md
│   ├── agents/interface.yaml
│   ├── references/                        #   辩证协议、第一性原理、案例
│   └── update.sh                          #   (git-ignored)
└── skill-self-evolution/                  # Skill: 技能自我进化
    ├── SKILL.md
    ├── agents/interface.yaml
    ├── references/                        #   进化判据、工作空间规范、案例
    └── update.sh                          #   (git-ignored)
```

## 部署约定

每个 skill 需要一个本地 `update.sh` 脚本将内容同步到 AI 工具的 skill 目录。该脚本含本机绝对路径，因此不入库（已 gitignore），需自行创建。

### 单个 skill 的 update.sh 模板

在每个 skill 目录下创建 `update.sh`，将 `<YOUR_REPO_PATH>` 替换为你的本地仓库路径：

```bash
#!/bin/bash
REPO_PATH="<YOUR_REPO_PATH>"          # 例如: /Users/yourname/projects/Agent_Skills_kelen
SKILL_NAME="adversarial-successor-audit"  # 替换为对应 skill 名
DST="$HOME/.claude/skills/$SKILL_NAME"

if [ ! -d "$REPO_PATH/$SKILL_NAME" ]; then
  echo "源目录不存在: $REPO_PATH/$SKILL_NAME"
  exit 1
fi

mkdir -p "$DST"
rsync -av --exclude='update.sh' "$REPO_PATH/$SKILL_NAME/" "$DST/"
echo "$SKILL_NAME 已更新"
```

### 批量更新脚本 update-all.sh

放在 `~/.claude/skills/update-all.sh`，自动扫描所有 skill 的 `update.sh` 并执行：

```bash
#!/bin/bash
SKILLS_DIR="$HOME/.claude/skills"
errors=0

for update_script in "$SKILLS_DIR"/*/update.sh; do
  [ -f "$update_script" ] || continue
  skill_name=$(basename "$(dirname "$update_script")")
  echo "Updating $skill_name..."
  bash "$update_script" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "  $skill_name ✓"
  else
    echo "  $skill_name ✗"
    errors=$((errors + 1))
  fi
done

echo "Skill 更新完成 (errors: $errors)"
```

### 一键初始化

克隆仓库后，运行以下命令为所有 skill 生成 `update.sh` 并部署：

```bash
REPO_PATH="$(pwd)"
for skill_dir in */; do
  [ -f "$skill_dir/SKILL.md" ] || continue
  skill_name="${skill_dir%/}"
  cat > "$skill_dir/update.sh" <<EOF
#!/bin/bash
REPO_PATH="$REPO_PATH"
SKILL_NAME="$skill_name"
DST="\$HOME/.claude/skills/\$SKILL_NAME"
[ ! -d "\$REPO_PATH/\$SKILL_NAME" ] && echo "源目录不存在" && exit 1
mkdir -p "\$DST"
rsync -av --exclude='update.sh' "\$REPO_PATH/\$SKILL_NAME/" "\$DST/"
echo "\$SKILL_NAME 已更新"
EOF
  chmod +x "$skill_dir/update.sh"
  bash "$skill_dir/update.sh"
  echo "✓ $skill_name deployed"
done
```

- **开发在本仓库进行**，通过 `update.sh` 发布到 AI 工具运行环境

## 技术规范

- Skill 格式遵循 [yao-meta-skill](https://github.com/anthropics/yao-meta-skill) 规范
- 版本管理采用 [语义化版本号 (SemVer)](https://semver.org/lang/zh-CN/)
- 语言约定：中文为主，英文为辅
- Commit 格式：`<type>: <中文简述> [en: <english>]`

## 致谢

- [yao-meta-skill](https://github.com/anthropics/yao-meta-skill) — Skill 工程方法论框架
- 本项目中的方法论提炼自 [Cli-Proxy-API-Management-Center-fork](https://github.com/calonye/Cli-Proxy-API-Management-Center-fork) 的 AI 协作规则建设对话

## 协议

[MIT License](./LICENSE) — Copyright (c) 2026 calonye
