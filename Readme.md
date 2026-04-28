# Agent_Skills_kelen

> AI Agent 思维技能孵化工作空间 — 将深度对话中的方法论提炼为可复用的结构化技能。

## 技能清单

| 技能 | 描述 | 版本 |
|------|------|------|
| [adversarial-successor-audit-kelen](./adversarial-successor-audit-kelen/) | 以「有洁癖的新人接替者」视角做全流程对抗性审计 | v0.2.0 |
| [dialectical-self-review-kelen](./dialectical-self-review-kelen/) | 在行动前对自己的方案做结构化自我反驳 | v0.2.0 |
| [skill-self-evolution-kelen](./skill-self-evolution-kelen/) | 从对话中实时识别方法论并转化为可部署的 skill 包 | v0.2.0 |
| [env-sync-maintainer-kelen](./env-sync-maintainer-kelen/) | 通用环境适配与 Skill 自愈 | v0.2.0 |

### 技能关系

```
对话产生领悟
      ↓
skill-self-evolution-kelen ──→ 识别 + 判断 + 转化为新 skill
      ↑                                    ↓
      └── dialectical-self-review-kelen ←── 辩证审查发现新模式
                                              ↓
                                  adversarial-successor-audit-kelen ←── 交付前审计

env-sync-maintainer-kelen ──→ 多环境同步与自愈（独立运行）
```

## 快速开始

```bash
git clone https://github.com/calonye/Agent_Skills_kelen.git
cd Agent_Skills_kelen

# 一键部署所有 skill
bash install.sh

# 或部署单个 skill（需先创建 update.sh）
bash adversarial-successor-audit-kelen/update.sh
```

### 触发词

| 技能 | 口语触发词 |
|------|-----------|
| adversarial-successor-audit-kelen | 「对抗性审计」「新人模拟」「交付前检查」 |
| dialectical-self-review-kelen | 「思辨一下」「先想清楚再做」「挑挑毛病」 |
| skill-self-evolution-kelen | 「提炼技能」「这次学到了什么」「方法论转化」 |
| env-sync-maintainer-kelen | 「同步一下配置」「两边不一样了」「修复 skill 列表」 |

## AI 工具集成

| 工具 | Skill 目录 | 安装方式 |
|------|-----------|---------|
| Claude Code | `~/.claude/skills/` | `bash install.sh` |
| Factory Droid | `~/.factory/droids/` | 阅读每个 SKILL.md 转换为 droid YAML |
| Cursor | `~/.cursor/rules/` | 将 SKILL.md 内容作为规则文件导入 |
| 其他 | 自定义 `SKILL_DIR` | `SKILL_DIR=<path> bash install.sh` |

## 目录结构

```
Agent_Skills_kelen/
├── .gitignore
├── Readme.md
├── CHANGELOG.md
├── LICENSE
├── install.sh
│
├── adversarial-successor-audit-kelen/
├── dialectical-self-review-kelen/
├── skill-self-evolution-kelen/
└── env-sync-maintainer-kelen/
    └── 每个 skill 内含：
        SKILL.md                 # 路由 + 流程骨架
        agents/interface.yaml    # 接口声明
        references/              # 详解、判据、案例
```

> `Docs/`（开发指导规范）和 `*/update.sh`（本地部署脚本）不入库，详见 `.gitignore`。

## 技术规范

- Skill 格式遵循 [yao-meta-skill](https://github.com/anthropics/yao-meta-skill) 规范
- 版本管理采用 [语义化版本号 (SemVer)](https://semver.org/lang/zh-CN/)
- 语言约定：中文为主，英文为辅
- Commit 格式：`<type>: <中文简述> [en: <english>]`

## 协议

[MIT License](./LICENSE)
