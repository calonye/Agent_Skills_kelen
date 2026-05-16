# Agent_Skills_kelen

> AI Agent 思维技能孵化工作空间 — 将深度对话中的方法论提炼为可复用的结构化技能。

## 技能清单

- [adversarial-successor-audit-kelen](./skills/adversarial-successor-audit-kelen/) v0.3.0：以「有洁癖的新人接替者」视角做全流程对抗性审计
- [dialectical-self-review-kelen](./skills/dialectical-self-review-kelen/) v0.3.0：在行动前对自己的方案做证据三值、反事实与可选 Agent-assisted 辩证自审
- [skill-self-evolution-kelen](./skills/skill-self-evolution-kelen/) v0.3.0：从对话中实时识别方法论并转化为可部署的 skill 包
- [security-penetration-kelen](./skills/security-penetration-kelen/) v0.1.0：授权 CTF/靶场安全攻防审查、逆向解构与防御加固

### 技能关系

每个 skill 完全独立可用，以下箭头仅标注可选搭配关系：

```text
adversarial-successor-audit-kelen ──→ 可选搭配 ←── dialectical-self-review-kelen
        │                                              │
        │          skill-self-evolution-kelen           │
        │                                              │
        └──────────→ 可选搭配 ←─────────────────────┘

security-penetration-kelen (独立运行，无依赖)
```

## 快速开始

```bash
git clone https://github.com/calonye/Agent_Skills_kelen.git
cd Agent_Skills_kelen

# 一键部署所有公开 skill
bash install.sh

# 安装后自检（以 Claude Code 为例）
ls ~/.claude/skills/dialectical-self-review-kelen
ls ~/.claude/skills/skill-self-evolution-kelen
ls ~/.claude/skills/security-penetration-kelen

# 提交前验证
bash scripts/validate-all.sh

# 或分别验证重点 skill
bash scripts/validate-dialectical-self-review.sh
bash scripts/validate-security-penetration.sh
```

`install.sh` 会在各 skill 目录生成本地 `update.sh`，这是被 `.gitignore` 排除的同步脚本；看到它出现在 ignored 列表中是预期行为。

### 触发词

- adversarial-successor-audit-kelen：「对抗性审计」「新人模拟」「交付前检查」
- dialectical-self-review-kelen：「思辨一下」「先想清楚再做」「方案有没有漏洞」「对抗性审查你的思考」
- skill-self-evolution-kelen：「提炼技能」「这次学到了什么」「方法论转化」
- security-penetration-kelen：「安全审查一下」「授权 CTF 模式」「靶场攻防」

## AI 工具集成

- Claude Code：安装到 `~/.claude/skills/`，执行 `bash install.sh`
- Factory Droid：安装到 `~/.factory/droids/`，阅读每个 SKILL.md 后转换为 droid YAML
- Cursor：安装到 `~/.cursor/rules/`，将 SKILL.md 内容作为规则文件导入
- 其他工具：使用自定义 `SKILL_DIR`，执行 `SKILL_DIR=<path> bash install.sh`

## 目录结构

```text
Agent_Skills_kelen/
├── .gitignore
├── Readme.md
├── CHANGELOG.md
├── LICENSE
├── install.sh
├── scripts/
│   ├── validate-all.sh
│   ├── validate-dialectical-self-review.sh
│   └── validate-security-penetration.sh
│
└── skills/                                ← 项目产物层
    ├── adversarial-successor-audit-kelen/
    ├── security-penetration-kelen/
    │   ├── references/                    ← context-protocol + sandbox-contract + analysis-priorities + tool-orchestration + evidence-chain + vulnerability-taxonomy + remediation-patterns
    │   └── agents/
    ├── dialectical-self-review-kelen/
    └── skill-self-evolution-kelen/
```

每个 skill 内含：`SKILL.md`（路由 + 流程骨架）+ `agents/interface.yaml`（接口声明）+ `references/`（详解、判据、案例）

### 技能自我进化用法

使用 `skill-self-evolution-kelen` 时，适合输入当前对话中已经出现的可复用方法论，而不是历史对话挖掘或通用 skill 创建教学。它会先输出候选方法论、4 层判据和决策选项；只有你确认后，才进入创建或迭代文件。

```text
这次对话里我们形成了一个可复用方法：<一句话描述>。
请用 skill-self-evolution-kelen 判断它是否值得沉淀。
范围：只评估当前对话，不挖历史记录。
输出：候选方法论、4 层判据、建议创建/合入/跳过/待观察。
隐私：来源描述请抽象化，不写私有路径、具体人名、未授权项目名或研发灵感来源。
```

不适用场景：
- 只是总结会议、整理笔记或记录偏好。
- 只是创建一个普通 skill 需求，没有来自当前对话的新方法论。
- 只是项目局部配置、一次性命令或不具备复用价值的做法。

### 授权安全审查用法

使用 `security-penetration-kelen` 时，建议在请求中声明：目标、授权范围、Flag 目标、授权等级和防御目标。例如：

```text
对这个本地靶场 API 启用授权 CTF 模式。范围是 http://localhost:3000，Flag 目标是验证越权读取风险，授权等级 L2，禁止触碰外部网络，最终输出修复和复测方案。
```

可复制模板：

```text
对 <目标> 启用授权 CTF 模式。
目标所有权：<自有 / 已授权 / 本地靶场 / CTF 题目>
范围：<域名、localhost、仓库路径、容器或样本文件>
Flag 目标：<要证明的漏洞、弱点或安全性质>
授权等级：<L0 被动 / L1 主动探测 / L2 受控 PoC / L3 攻防链路分析 / L4 本地靶场深度逆向与解构>
允许动作：<读取源码、低速请求、受控 PoC、静态逆向等>
禁止动作：<外部网络、压力测试、真实凭据导出、生产写操作等>
防御目标：<修复、加固、检测、复测或风险归零>
```

授权等级选择：
- L0：只读源码、配置、日志、依赖和文档。
- L1：对明确授权目标做低风险主动请求。
- L2：在授权目标内构造最小受控 PoC。
- L3：在授权沙箱内串联入口、权限、数据流和影响面，并输出防御闭环。
- L4：仅用于本地 CTF/靶场/自有沙箱的深度逆向、解构和修复导向 PoC。

> `Project/`（本地研发工作空间）、`.cursor/`（本地计划和编辑器状态）和 `*/update.sh`（本地部署脚本）不入库，详见 `.gitignore`。

## 技术规范

- Skill 产物采用结构化目录、渐进披露和本仓库验证脚本作为发布门禁
- 版本管理采用 [语义化版本号 (SemVer)](https://semver.org/lang/zh-CN/)
- 语言约定：中文为主，英文为辅
- Commit 格式：`<type>: <中文简述> [en: <english>]`

## 协议

[MIT License](./LICENSE)
