# Agent_Skills_kelen

> AI Agent 思维技能孵化工作空间 — 将深度对话中的方法论提炼为可复用的结构化技能。

## 项目概述

本仓库是个人 AI Agent Skill 的孵化与迭代空间。每个 skill 是一个独立的方法论包，可部署到 Claude Code / Factory Droid 等 AI 工具的 skill 系统中。

**核心理念**：AI 在深度对话中会领悟新的思维方式和工作方法，但这些领悟会随 session 结束而消亡。本项目将这些方法论结构化、固化为可复用的 skill 包，让 AI 具备持续自我进化的能力。

## 技能清单

| 技能 | 描述 | 版本 | 状态 |
|------|------|------|------|
| [adversarial-successor-audit-kelen](./adversarial-successor-audit-kelen/) | 以「有洁癖的新人接替者」视角做全流程对抗性审计 | v0.2.0 | 可用 |
| [dialectical-self-review-kelen](./dialectical-self-review-kelen/) | 在行动前对自己的方案做结构化自我反驳 | v0.2.0 | 可用 |
| [skill-self-evolution-kelen](./skill-self-evolution-kelen/) | 从对话中实时识别方法论并转化为可部署的 skill 包 | v0.2.0 | 可用 |
| [env-sync-maintainer-kelen](./env-sync-maintainer-kelen/) | 通用环境适配与 Skill 自愈方法论 | v0.2.0 | 可用 |

### 技能关系

```
对话产生领悟
      ↓
skill-self-evolution-kelen ──→ 识别 + 判断 + 转化为新 skill
      ↑                                    ↓
      └── dialectical-self-review-kelen ←── 辩证审查发现新模式
                                              ↓
                                  adversarial-successor-audit-kelen ←── 交付前审计

env-sync-maintainer-kelen ──→ 多环境同步与自愈（独立运行，保持所有环境一致）
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

- **adversarial-successor-audit-kelen**：说「对抗性审计」「新人模拟」「交付前检查」
- **dialectical-self-review-kelen**：说「思辨一下」「对抗性审查你的思考」「先想清楚再做」
- **skill-self-evolution-kelen**：说「提炼技能」「这次对话学到了什么」「方法论转化」
- **env-sync-maintainer-kelen**：说「同步一下配置」「两边不一样了」「修复 skill 列表」

### 开发新 Skill

遵循仓库内各 skill 的 `SKILL.md` 和 `references/skill-design-principles.md` 中的设计规范。

## AI 对话环境集成

在 AI 对话（Claude Code / Factory Droid / Cursor 等）中，可以让 AI 自动完成 skill 的安装和配置。以下提供两种方式。

### 方式一：提示词模板（推荐）

将以下内容直接发送给 AI，它会自动执行安装部署：

**Claude Code 环境：**

> 请帮我安装 Agent_Skills_kelen 思维技能包：
> 1. 将仓库 https://github.com/calonye/Agent_Skills_kelen.git 克隆到 ~/Agent_Skills_kelen
> 2. 将所有含 SKILL.md 的子目录同步到 ~/.claude/skills/（排除 update.sh）
> 3. 为每个 skill 生成 update.sh 同步脚本
> 4. 验证部署结果：列出 ~/.claude/skills/ 下已安装的 skill

**Factory Droid 环境：**

> 请帮我安装 Agent_Skills_kelen 思维技能包：
> 1. 将仓库 https://github.com/calonye/Agent_Skills_kelen.git 克隆到本地
> 2. 阅读每个 skill 的 SKILL.md，将其转换为 droid 配置文件
> 3. 将 droid 配置部署到 ~/.factory/droids/ 或项目下的 .factory/droids/

**其他 AI 工具（Cursor / Windsurf 等）：**

> 请帮我安装 Agent_Skills_kelen 思维技能包：
> 1. 将仓库 https://github.com/calonye/Agent_Skills_kelen.git 克隆到本地
> 2. 将所有含 SKILL.md 的子目录同步到该工具的 skill/规则 目录
> 3. 验证 AI 能根据触发词自动路由到对应 skill

### 方式二：一键脚本

在 AI 对话中让 AI 执行以下命令：

```bash
# 默认部署到 ~/.claude/skills/
curl -fsSL https://raw.githubusercontent.com/calonye/Agent_Skills_kelen/main/install.sh | bash

# 自定义 skill 目录（适配非 Claude Code 环境）
SKILL_DIR=~/.cursor/skills curl -fsSL https://raw.githubusercontent.com/calonye/Agent_Skills_kelen/main/install.sh | bash

# 自定义仓库本地路径
INSTALL_DIR=~/projects/Agent_Skills_kelen curl -fsSL https://raw.githubusercontent.com/calonye/Agent_Skills_kelen/main/install.sh | bash
```

脚本会自动完成：clone/pull 仓库 → 部署所有 skill → 生成 update.sh → 创建 update-all.sh。

### 各 AI 工具的 Skill 目录约定

| AI 工具 | 默认 Skill 目录 | 说明 |
|---------|-----------------|------|
| Claude Code | `~/.claude/skills/` | 原生支持 SKILL.md 路由匹配 |
| Factory Droid | `.factory/droids/` 或 `~/.factory/droids/` | 需将 SKILL.md 转换为 droid YAML 配置 |
| Cursor | `~/.cursor/rules/` 或项目 `.cursor/rules/` | 将 SKILL.md 内容作为规则文件导入 |
| 其他工具 | 自定义 | 设置 `SKILL_DIR` 环境变量后使用一键脚本 |

### 验证安装

安装完成后，在 AI 对话中尝试以下触发词：

```
「帮我检查一下别人拿到这个项目能不能跑起来」  → adversarial-successor-audit-kelen
「思辨一下」                                  → dialectical-self-review-kelen
「提炼技能」                                  → skill-self-evolution-kelen
「同步一下配置」                              → env-sync-maintainer-kelen
```

如果 AI 自动进入对应 skill 的流程，说明安装成功。

## 目录结构

```
Agent_Skills_kelen/
├── Readme.md                              # 本文件
├── LICENSE                                # MIT 协议
├── CHANGELOG.md                           # 变更日志
├── install.sh                             # 一键安装脚本（入库）
├── .gitignore
├── Docs/                                  # 开发指导规范（gitignore，不入库）
├── adversarial-successor-audit-kelen/     # Skill: 对抗性接替者审计
│   ├── SKILL.md                           #   路由 + 流程骨架
│   ├── agents/interface.yaml              #   接口声明
│   └── references/                        #   审计清单、子模式、案例
├── dialectical-self-review-kelen/         # Skill: 辩证自我审查
│   ├── SKILL.md
│   ├── agents/interface.yaml
│   └── references/                        #   辩证协议、第一性原理、案例
├── skill-self-evolution-kelen/            # Skill: 技能自我进化
│   ├── SKILL.md
│   ├── agents/interface.yaml
│   └── references/                        #   进化判据、工作空间规范、设计原则、案例
└── env-sync-maintainer-kelen/             # Skill: 通用环境适配与自愈
    ├── SKILL.md
    └── references/
        └── adapters/                      #   各工具适配案例
            ├── claude-code.md
            └── factory-droid.md
```

## 部署约定

每个 skill 需要一个本地 `update.sh` 脚本将内容同步到 AI 工具的 skill 目录。该脚本含本机绝对路径，因此不入库（已 gitignore），需自行创建。

### 单个 skill 的 update.sh 模板

在每个 skill 目录下创建 `update.sh`，将 `<YOUR_REPO_PATH>` 替换为你的本地仓库路径：

```bash
#!/bin/bash
REPO_PATH="<YOUR_REPO_PATH>"          # 例如: $HOME/Agent_Skills_kelen
SKILL_NAME="adversarial-successor-audit-kelen"  # 替换为对应 skill 名
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

- [yao-meta-skill](https://github.com/anthropics/yao-meta-skill) — Skill 工程方法论框架参考

## 协议

[MIT License](./LICENSE) — Copyright (c) 2026 calonye
