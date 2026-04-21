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

参见 [Docs/开发指导规范.md](./Docs/开发指导规范.md)。

## 目录结构

```
Agent_Skills_kelen/
├── Readme.md                              # 本文件
├── LICENSE                                # MIT 协议
├── CHANGELOG.md                           # 变更日志
├── .gitignore
├── Docs/                                  # 工作空间级文档
│   └── 开发指导规范.md                      # Skill 开发约定（Steering 文档）
├── adversarial-successor-audit/           # Skill: 对抗性接替者审计
│   ├── SKILL.md                           #   路由 + 流程骨架
│   ├── agents/interface.yaml              #   接口声明
│   ├── references/                        #   审计清单、子模式、案例
│   └── update.sh                          #   部署同步脚本
├── dialectical-self-review/               # Skill: 辩证自我审查
│   ├── SKILL.md
│   ├── agents/interface.yaml
│   ├── references/                        #   辩证协议、第一性原理、案例
│   └── update.sh
└── skill-self-evolution/                  # Skill: 技能自我进化
    ├── SKILL.md
    ├── agents/interface.yaml
    ├── references/                        #   进化判据、工作空间规范、案例
    └── update.sh
```

## 部署约定

- 每个 skill 目录下有 `update.sh`，将本工作空间的内容同步到 `~/.claude/skills/<skill-name>/`
- `~/.claude/skills/update-all.sh` 会自动扫描所有 `*/update.sh` 并执行批量更新
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
