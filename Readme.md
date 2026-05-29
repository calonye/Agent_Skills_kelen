# Agent_Skills_kelen

> AI Agent 思维技能孵化工作空间 — 将深度对话中的方法论提炼为可复用的结构化技能。

## 技能清单

- [adversarial-successor-audit-kelen](./skills/adversarial-successor-audit-kelen/) v0.3.0：以严格的新接手者视角做全流程交付审计
- [brainstorming-kelen](./skills/brainstorming-kelen/) v0.1.2：在需求或方案未定时做结构化头脑风暴、多视角模拟和三值收敛
- [dialectical-self-review-kelen](./skills/dialectical-self-review-kelen/) v0.3.2：在行动前对自己的方案做证据三值、反事实与可选 Agent-assisted 辩证自审
- [skill-self-evolution-kelen](./skills/skill-self-evolution-kelen/) v0.3.7：创建、设计、维护、迭代、改进和进化 skill 的生命周期引擎
- [security-penetration-kelen](./skills/security-penetration-kelen/) v0.1.2：授权 CTF/靶场安全攻防审查、逆向解构与防御加固

### 技能关系

每个公开 skill 可作为独立运行时包安装和触发，以下箭头仅标注可选搭配关系：

```text
adversarial-successor-audit-kelen ──→ 可选搭配 ←── dialectical-self-review-kelen
        │                                              │
        │          skill-self-evolution-kelen           │
        │                                              │
        └──────────→ 可选搭配 ←─────────────────────┘

brainstorming-kelen (独立运行，可在方案未定时先发散)
security-penetration-kelen (独立运行，无依赖)
```

## 快速开始

```bash
git clone https://github.com/calonye/Agent_Skills_kelen.git
cd Agent_Skills_kelen

# 一键部署所有公开 skill
bash install.sh

# 安装后自检（以 Claude Code 为例）
ls ~/.claude/skills/adversarial-successor-audit-kelen
ls ~/.claude/skills/brainstorming-kelen
ls ~/.claude/skills/dialectical-self-review-kelen
ls ~/.claude/skills/skill-self-evolution-kelen
ls ~/.claude/skills/security-penetration-kelen

# 维护者本地质量检查（不是 skill 使用依赖，也不是 PR 合并承诺）
bash scripts/validate-all.sh

# 或分别检查重点 skill
bash scripts/validate-dialectical-self-review.sh
bash scripts/validate-security-penetration.sh
```

`install.sh` 会在各 skill 目录生成本地 `update.sh`，这是被 `.gitignore` 排除的同步脚本；看到它出现在 ignored 列表中是预期行为。

验证脚本只覆盖确定性不变量，不能替代维护者对通用性、结构边界和长期维护成本的判断。外部 PR 是候选输入；不符合本仓库质量方向、过于个性化或无法抽象为通用能力的改动，可以直接驳回。优先接受修复确定性错误、改善公开入口一致性、降低维护成本的改动；谨慎接受个性化偏好、局部话术或单一场景规则堆叠。

### 触发词

- adversarial-successor-audit-kelen：「别人接手会不会懵」「README 够不够清楚」「从零跑一遍看看」「交出去前检查一下」；只审交付/接手路径，不审代码实现正确性。输出证据、阻断点、三值裁定、最小修复和复验方式；`validate-all.sh` 覆盖其静态门禁，真实触发需新会话回归。
- brainstorming-kelen：「方案还没定，这个怎么做比较好」「先别写代码，给我几个方案」「我还没想清楚，帮我理一下」「先发散一下」；已有明确方案时不抢占方案审查或实现流程；需要用户裁定且宿主支持交互选项时实际调用原生交互。
- dialectical-self-review-kelen：「这样靠谱吗」「会不会翻车」「先帮我挑这个方案的毛病」「行动前再想想风险」；只审方案逻辑，不替代代码 review；P0 澄清或裁定在宿主可支持时使用原生交互。
- skill-self-evolution-kelen：「帮我创建一个普通 skill」「帮我设计一个 skill」「这个 skill 要怎么继续迭代」「这个 skill 没达到目的」「这个 skill 不好用/不容易触发」「把这个流程沉淀下来」「下次别再从头想一遍」「记住这个方法」「这个以后常用」「沉淀成规则」「不想让这次白费」「审查这个 skill 有没有达到目的」「前面改的 skill 是否真的落实了」；主职责是所有 skill 生命周期任务的首入口，普通创建进入轻量创建分支，思辨/审查/多视角只是质量机制；不用于普通偏好记忆、会议纪要或一次性配置；下游 skill 暴露边界、交互缺陷或自审失效时回流改进上游门禁，必要时做参考对照和脚本适配裁定。
- security-penetration-kelen：「授权范围内看看有没有安全隐患」「这个自有系统权限有没有问题」「本地靶场能不能越权」「防护怎么补」；必须有授权、自有或本地靶场边界；授权选择在宿主可支持时使用原生交互。

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
│   ├── validate-security-penetration.sh
│   └── validation/                       ← 维护者本地质量检查分层脚本
│
└── skills/                                ← 项目产物层
    ├── adversarial-successor-audit-kelen/
    ├── brainstorming-kelen/
    │   ├── references/                    ← brainstorming-protocol + idea-evaluation-criteria + boundary-and-sanitization + eval-prompts
    │   └── agents/
    ├── security-penetration-kelen/
    │   ├── references/                    ← context-protocol + sandbox-contract + analysis-priorities + tool-orchestration + evidence-chain + vulnerability-taxonomy + remediation-patterns
    │   └── agents/
    ├── dialectical-self-review-kelen/
    └── skill-self-evolution-kelen/
        ├── references/                    ← trigger-coverage-matrix + capability-equivalence-protocol + host-interaction-adaptation + eval-prompts
        └── agents/
```

每个 skill 内含：`SKILL.md`（路由 + 流程骨架）+ `agents/interface.yaml`（接口声明）+ `references/`（详解、判据、案例）

默认公开 skill 以 `install.sh` 的 `PUBLIC_SKILLS` 白名单和上方技能清单为准；未列入白名单的历史兼容或孵化中目录不通过默认安装入口部署。源码中被跟踪的孵化 skill 仍不得承载私有运行记录、真实交付物或附件内容。

### 技能自我进化用法

使用 `skill-self-evolution-kelen` 时，适合处理 skill 的创建、设计、维护、迭代、改进和进化；当前对话中出现的可复用方法论，只是它的输入来源之一。它会先判定生命周期任务类型，输出用户目的、4 层判据、决策选项和验证路径；只有你确认后，才进入创建或迭代文件。

它也适用于已有 skill 迭代审查：当你要求“这个 skill 是否达到设计目的”“前面改的 skill 有没有落实”时，应先输出需求覆盖报告、证据缺口、三值裁定和修复顺序，再决定是否修改文件。

维护关注入口、文档、接口、发布一致性和隐私边界；改进关注已暴露问题、最小行为变化和复验方式；自我进化关注本 skill 的目的、结构、触发、前置协议和验证闭环。普通创建同样先进入本 skill 判为 `创建`，再执行轻量创建分支。涉及澄清、授权或方向裁定时，本轮暴露匹配的原生交互候选就应先实际调用；文本选项只作为候选未暴露或真实调用产生可观察失败证据时的降级输出。

```text
我要创建/改进/维护一个 skill：<一句话描述目标>。
请用 skill-self-evolution-kelen 先判断生命周期任务类型和设计目的。
范围：只评估当前目标和相关 skill 文件，不挖历史记录。
输出：生命周期报告、思辨/澄清/调研/决策准备、4 层判据、建议创建/合入/维护/改进/跳过/待观察、验证路径。
隐私：来源描述请抽象化，不写私有路径、具体人名、未授权项目名或研发灵感来源。
```

不适用场景：
- 只是总结会议、整理笔记或记录偏好。
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

- Skill 产物采用结构化目录、渐进披露，并使用维护者本地验证脚本检查确定性发布不变量
- 版本管理采用 [语义化版本号 (SemVer)](https://semver.org/lang/zh-CN/)
- 语言约定：中文为主，英文为辅
- Commit 格式：`<type>: <中文简述> [en: <english>]`

## 协议

[MIT License](./LICENSE)
