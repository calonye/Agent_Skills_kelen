# 变更日志 / Changelog

本项目遵循 [语义化版本号 (SemVer)](https://semver.org/lang/zh-CN/) 规范。

## [未发布] - 2026-05-25

### 新增 (Added)

- 新增孵化 skill：`session-handoff-kelen`，用于跨会话交付物、子 Agent 证据索引、附件授权引用与续接入口；保持不进入默认公开安装白名单。
- `skill-self-evolution-kelen` 新增宿主交互能力适配协议，覆盖原生提问/选择优先、文本降级原因记录与真实宿主复验。

### 变更 (Changed)

- `session-handoff-kelen` 纠偏为会话连续性与交接治理：区分会话、对话与子 Agent 上下文；有可验证结束证据的真实结束会话仅生成轻量日志；仅在续接、需要形成跨会话持续材料的压缩/恢复治理或显式详细记录需要时生成详细交付物；索引默认最小脱敏，并区分可由口语/规则触发的执行与必须实测宿主路由的无消息生命周期事件执行。
- `session-handoff-kelen` 补强澄清/裁定前推理闸门、选项推荐与理由、架构解耦和研发文档落实前后记录，降低交接材料技术债。
- `skill-self-evolution-kelen` 补入下游缺陷回流、运行产物隔离、自动演化禁令和交互式裁定门禁。
- `skill-self-evolution-kelen` 补强自我进化递归终止、命名兼容、SemVer 裁定和输出模板泛化，避免维护/改进任务退回旧方法论沉淀模型。
- `skill-self-evolution-kelen` 补齐接口级自审失效回流、参考对照和脚本适配约束，并将长期/高性能脚本场景的 Rust 优先策略纳入设计门禁。
- `skill-self-evolution-kelen` 收窄自我进化修复后的同步范围，仅同步受影响入口，避免小修诱发 README、验证脚本或研发记录的非必要扩散。
- `brainstorming-kelen`、`dialectical-self-review-kelen` 与 `security-penetration-kelen` 增加原生交互能力优先、文本仅为受限降级的澄清/授权规则。
- `scripts/validate-all.sh` 与 `scripts/validate-dialectical-self-review.sh` 增强 handoff 孵化边界、交互状态与上游设计门禁验证。
- `skill-self-evolution-kelen` 将普通创建纳入生命周期首入口，以轻量创建分支替代旁路；同步修正公开触发说明和回归门禁。
- 涉及澄清、授权或裁定的自研 skill 改为基于本轮原生交互候选的真实调用结果判定降级，记录候选、状态、原因与证据来源，避免将执行访问权限或未经实测的宿主假设当成交互结论。

### 版本变更 (Version Bumps)

- brainstorming-kelen：v0.1.0 → v0.1.2
- dialectical-self-review-kelen：v0.3.0 → v0.3.2
- skill-self-evolution-kelen：v0.3.2 → v0.3.7
- security-penetration-kelen：v0.1.0 → v0.1.2
- session-handoff-kelen：孵化纠偏版 v0.3.2

## [0.7.0] - 2026-04-30

### 新增 (Added)

- 新增 skill: `security-penetration-kelen` — 授权 CTF/靶场安全攻防审查、逆向解构与防御加固 (Add skill: security-penetration-kelen)
- `security-penetration-kelen` 新增 `references/context-protocol.md` — CTF 授权上下文协议（合约确认、操作分级、证据记录与防御闭环）(Add authorized CTF context protocol)
- `security-penetration-kelen` 新增 8 个 reference：analysis-priorities、context-protocol、evidence-chain、remediation-patterns、sandbox-contract、tool-orchestration、vulnerability-taxonomy、eval-prompts (Add 8 security skill references)
- 新增 `scripts/validate-security-penetration.sh`，用于提交前验证安全 skill 的 YAML、引用、默认授权、危险语义和基础 secret 扫描 (Add validation script for security skill)
- `dialectical-self-review-kelen` 新增 `references/eval-prompts.md` 与 `references/agent-assisted-review.md`，用于触发回归、边界验证和可选只读 Agent-assisted 升级 (Add eval prompts and optional agent-assisted review protocol)
- 新增 `scripts/validate-dialectical-self-review.sh`，用于提交前验证辩证自审 skill 的 YAML、引用、触发关键语义、表格残留和本地路径污染 (Add validation script for dialectical self-review skill)
- 新增 `scripts/validate-all.sh`，统一运行 shell 语法、两个重点 skill 验证、YAML/frontmatter、reference 引用闭合和 `git diff --check` (Add unified validation entrypoint)
- `dialectical-self-review-kelen` 支持 AskUserQuestion/ClarificationRequest 可选澄清能力：证据未知且继续推进会制造关键假设时，最多提出 1 次、1-6 个最少澄清问题，支持多选；无工具时降级为文本待确认块 (Add optional AskUserQuestion/ClarificationRequest clarification gate)
- `dialectical-self-review-kelen` 澄清节流规则增强为 `question_budget`：保留每轮最多 1 次、每次最多 6 问，同时新增 P0/P1/P2 优先级、延后确认队列、复杂迁移负例和同轮二次追问验证 (Add question budget, prioritization, deferred queue, and clarification throttling evals)
- 新增 skill: `brainstorming-kelen` — 结构化头脑风暴、多视角模拟、对抗审查、AskUserQuestion/ClarificationRequest 可选澄清与三值收敛 (Add skill: brainstorming-kelen)
- `skill-self-evolution-kelen` 新增 `references/structural-audit-methodology.md` — 通用结构一致性审计方法论：批量创建同类产物时的三步审计流程（提取基线→交叉对比→差异裁决）(Add structural audit methodology)
- `skill-self-evolution-kelen/references/skill-design-principles.md` 验证原则新增第 4 条：批量创建后做结构一致性审计 (Add structural audit verification principle)
- `skill-self-evolution-kelen` 新增行为验证、发布入口验证、隐私抽象化和运行时适配边界，并将研发来源与执行规则分离 (Add behavior validation, release gates, privacy abstraction, runtime boundaries, and separate R&D provenance from execution rules)
- `skill-self-evolution-kelen` 新增 `references/trigger-coverage-matrix.md`，用于设计用户自然口语、AI 推理触发、发现层关键词和误触发边界 (Add trigger coverage matrix)
- `skill-self-evolution-kelen` 移除仓库发布规范型 reference，避免工作空间适配规则混入独立 skill 包 (Remove workspace publishing reference from skill package to keep skill rules independent)
- `adversarial-successor-audit-kelen` 新增多视角接替审计协议，支持角色矩阵、三值裁定、交叉合并和残余风险收敛 (Add multi-perspective successor audit protocol with role matrix, ternary verdicts, synthesis, and residual-risk closure)
- `dialectical-self-review-kelen` 新增 `references/known-blindspots.md` — AI 系统性认知盲区清单 (Add known cognitive blindspots reference)

### 变更 (Changed)

- `skill-self-evolution-kelen` 重新收束为 skill 生命周期进化引擎：主职责明确为创建、设计、维护、迭代、改进和进化 skill；思辨、审查、多视角、澄清和能力等价降级为质量机制；同步更新接口、触发回归、README 和验证门禁 (Reposition skill-self-evolution-kelen as a skill lifecycle evolution engine)
- `skill-self-evolution-kelen` 补强思辨/澄清/调研/决策准备前置协议，并拆出维护、改进、自我进化独立路径；补充自然口语触发和回归门禁 (Add pre-decision protocol, separate maintenance/improvement/self-evolution paths, and strengthen natural trigger regression)
- **独立可用性重构**：所有 skill 解耦，交叉引用降级为「可选搭配」，移除「闭环」等依赖性语言 (Decouple all skills, make cross-references optional)
  - `dialectical-self-review-kelen`：新增递归终止判据（防无限循环）+ 代码层面线索标记 + 证据三值/反事实检查 + 可选 AskUserQuestion/ClarificationRequest 澄清闸门 + 可选 Agent-assisted 升级协议；前置路由边界，避免抢占 brainstorming、代码审查、安全审查和交付审计 (Add recursive termination, code evidence markers, evidence ternary, counterfactual checks, optional clarification gate, optional Agent-assisted review, and route boundaries)
  - `adversarial-successor-audit-kelen`：子模式 D 补充标准化 ripgrep 扫描命令集 + 子模式 A 新增 Dry-Run 验证 + 结论判定补充默认阈值 (Add scan commands, dry-run, default thresholds)
  - `skill-self-evolution-kelen`：步骤③三层交互重构为单层一次性呈现 + 名称一致性检查前置 + 第4层判据拆分（已复用/预期复用）(Restructure step ③ from 3-layer to 1-layer, split criterion 4)
  - `skill-design-principles.md` 交叉引用规范重写为独立可用性原则 (Rewrite cross-reference guidelines for independence)
- 所有 SKILL.md 输出格式模板前加显式替换声明 (Add template replacement declarations to all output formats)
- `Readme.md` 技能关系图改为独立节点图 + 版本号更新 + 新增 security-penetration-kelen skill (Update skill relationship diagram to independent nodes)
- `.gitignore` 新增 `.cursor/` 本地计划与编辑器状态忽略，避免泄露未入库计划和思路演化痕迹 (Ignore local Cursor plans and editor state)
- `security-penetration-kelen` 执行协议调整为授权 CTF/靶场语义：保留深度攻防、逆向、解构和受控 PoC 能力，并用三值授权状态、L0-L4 操作等级和防御闭环约束边界 (Reframe security skill around authorized CTF/sandbox semantics with L0-L4 levels and defensive closure)
- `install.sh` 改为公开 skill 白名单部署，并补充 `security-penetration-kelen` 测试触发词，保持 README 与安装输出一致 (Deploy public skills by allowlist and add security-penetration-kelen trigger test to install.sh)
- `install.sh` 公开 skill 白名单新增 `brainstorming-kelen`，README 技能清单、触发词和目录树同步公开入口 (Add brainstorming-kelen to public install allowlist and README)
- `Readme.md` 新增 `skill-self-evolution-kelen` 首次使用模板、确认后写入说明、边界和隐私提示 (Add first-use template, confirmation boundary, and privacy guidance for skill-self-evolution-kelen)
- `Readme.md` 公开触发词改为更自然的口语表达，并补充近邻边界和授权边界说明 (Improve public trigger phrases and route boundaries)
- `env-sync-maintainer-kelen` 暂时移出公开发布跟踪集，并通过 `.gitignore` 保留为本地孵化目录 (Move env-sync-maintainer-kelen out of the public release tracking set and keep it as a local incubating directory)
- `skill-self-evolution-kelen` 补强已有 skill 迭代和自我适用路径，要求输出需求覆盖报告并拆分静态覆盖、当前会话执行和新会话真实触发状态 (Strengthen existing-skill iteration and self-application with requirement coverage and trigger-state separation)
- `skill-self-evolution-kelen` 新增能力等价协议，用于证明“融合、借鉴或替代某流程效果”已覆盖触发、流程、输出、边界和验证，而不是只写参考说明 (Add capability equivalence protocol for proving borrowed or replacement workflow effects)
- `adversarial-successor-audit-kelen` 新增 `references/eval-prompts.md`，补齐交付审计的正例、近邻例和负例行为回归 (Add eval prompts for successor audit behavior regression)
- `adversarial-successor-audit-kelen` 补强 discovery 边界、execution_strategy 标注、修复闭环、待确认语义、接口枚举、能力语义工具和黄金/失败样例门禁 (Strengthen discovery boundaries, execution strategy, repair loop, ternary semantics, interface enums, capability-based tools, and eval gates)
- `security-penetration-kelen` 接口工具解耦，仅要求读取能力；授权不完整时输出 ClarificationRequest，证据不足时不得伪造 CVSS 精确评分 (Decouple security interface tools and add authorization clarification plus CVSS anti-fabrication guard)

### 版本变更 (Version Bumps)

- adversarial-successor-audit-kelen：v0.2.0 → v0.3.0
- brainstorming-kelen：新创建 → v0.1.0
- dialectical-self-review-kelen：v0.2.0 → v0.3.0
- skill-self-evolution-kelen：v0.2.0 → v0.3.2
- security-penetration-kelen：新创建 → v0.1.0

## [0.6.0] - 2026-04-28

### 新增 (Added)

- adversarial-successor-audit-kelen 新增子模式 D（提交内容隐私扫描）和 E（目录树一致性检验）(Add sub-patterns D and E: privacy scan and directory tree consistency)
- adversarial-successor-audit-kelen 审计清单新增「提交内容隐私」和「目录树一致性」检查项 (Add privacy scan and directory tree consistency check items)

### 变更 (Changed)

- 目录重组：4 个 skill 目录移入 `skills/` 子目录，项目产物与仓库元信息分层 (Restructure: move skills into `skills/` subdirectory)
- 新增 `Project/` 本地研发工作空间（gitignore），含 `Docs/Steering/开发指导规范.md` (Add `Project/` local workspace with `Docs/Steering/`)
- `.gitignore` 从排除 `Docs/` 改为排除 `Project/` 整个目录（本地类统一归入研发工作空间）(Change .gitignore from `Docs/` to `Project/`)
- `install.sh` 扫描路径从 `$INSTALL_DIR/*/` 改为 `$INSTALL_DIR/skills/*/` (Update install.sh scan path to `skills/` subdirectory)
- Readme.md 技能清单链接加 `skills/` 前缀 (Update Readme.md skill links with `skills/` prefix)
- Readme.md 目录结构更新为 `skills/` + `Project/` 两层 (Update Readme.md directory structure)
- workspace-conventions.md 目录结构图和 REPO_PATH 更新 (Update workspace-conventions structure and REPO_PATH)
- workspace-conventions.md 补齐 frontmatter (Add frontmatter to workspace-conventions.md)

### 修正 (Fixed)

- sub-patterns.md 标题从「三个子模式」修正为「子模式」（与实际五个子模式一致）(Fix sub-patterns title from "three" to generic)
- 所有 references 文件补齐 frontmatter（parentRule + description），与 skill-design-principles.md 和 adapters/*.md 保持一致 (Add frontmatter to all references files for consistency)
- 开发指导规范.md 更新 skill 开发流程路径和 REPO_PATH (Update steering doc skill path and REPO_PATH)
- Project/Readme.md 新增本地研发工作空间说明 (Add Project/Readme.md for local workspace)

## [0.5.4] - 2026-04-28

### 修正 (Fixed)

- env-sync-maintainer-kelen SKILL.md 补充缺失的 schedule 字段，与其他 skill 风格一致 (Add missing schedule field to env-sync-maintainer-kelen SKILL.md)
- skill-self-evolution-kelen schedule 字段精简，移除与 description 重复的触发场景描述 (Simplify schedule field, remove redundant trigger descriptions)
- skill-self-evolution-kelen SKILL.md 4 层判断标准从表格改为编号列表，符合紧凑原则 (Convert table to numbered list per compactness principle)
- workspace-conventions.md 补充最后更新日期 (Add last-updated date to workspace-conventions.md)
- 开发指导规范.md 移入 Docs/Steering/ 子目录，符合文档管理规范 (Move steering doc to Docs/Steering/ per document management standard)
- 开发指导规范.md 版本号更新至 v0.4.0，新增「文件归属性质分类」章节 (Bump steering doc to v0.4.0, add file attribution classification)
- Readme.md 精简重写（264 行 → 97 行），移除冗余部署细节 (Simplify Readme.md from 264 to 97 lines, remove verbose deployment details)
- Readme.md 目录结构改为提交类/本地类分隔标注 (Restructure Readme.md directory tree with tracked/ignored separation)
- Readme.md update.sh 模板示例移除 /Users/you 路径模式 (Remove /Users/you path pattern from Readme.md template)
- .gitignore 注释规范化，按本地类/系统生成文件分组 (Normalize .gitignore comments by attribution category)
- workspace-conventions.md 新增「归属性质分类」段落 (Add attribution classification section to workspace-conventions)
- 文档管理规范新增「仓库即根场景分类规则」(Add repo-as-root classification rule to document management standard)
- workspace-conventions.md REPO_PATH 示例移除个人路径，改为纯模板变量 (Remove personal path from workspace-conventions REPO_PATH example)
- sub-patterns.md 典型错误中的个人路径改为通用路径 (Replace personal path with generic path in sub-patterns examples)
- 开发指导规范.md REPO_PATH 实例改为通用模板变量 (Replace REPO_PATH instance with generic template in steering doc)
- 3 个 skill 的 update.sh 中 SKILL_NAME 缺少 -kelen 后缀，导致同步目标目录名不一致 (Fix SKILL_NAME missing -kelen suffix in update.sh)
  - adversarial-successor-audit → adversarial-successor-audit-kelen
  - dialectical-self-review → dialectical-self-review-kelen
  - skill-self-evolution → skill-self-evolution-kelen
- env-sync-maintainer-kelen 补充本地 update.sh 脚本 (Add local update.sh for env-sync-maintainer-kelen)
- install.sh 默认路径逻辑修正：优先环境变量 → 检测仓库目录 → 回退克隆路径 (Fix install.sh default path logic: env var → detect repo → fallback clone)
- workspace-conventions.md REPO_PATH 模板从硬编码路径改为通用模板变量 (Change workspace-conventions REPO_PATH from hardcoded path to template variable)
- Readme.md 目录结构补充 generic.md + 修正路径示例 (Add generic.md to Readme directory structure + fix path examples)

### 新增 (Added)

- env-sync-maintainer-kelen/references/adapters/generic.md — 通用环境适配模板，填补 SKILL.md 中引用但缺失的文件 (Add generic adapter template for env-sync-maintainer-kelen)

### 变更 (Changed)

- 删除旧克隆 ~/Agent_Skills_kelen/（v0.4.0 残留，skill 无 -kelen 后缀，与主工作空间不同步）(Remove stale clone at ~/Agent_Skills_kelen/)

## [0.5.3] - 2026-04-24

### 修正 (Fixed)

- SKILL.md 参考描述清除具体项目名和对话编号（examples.md 泛化）(Generalize examples.md references)
- 所有 SKILL.md 正文中 skill 名加 -kelen 后缀（消除旧名残留）(Add -kelen suffix to all skill name references)
- dialectical-self-review 交叉引用从「强制触发」改为「相关技能」（独立可用，不耦合）(Change cross-references from forced triggers to related skills)
- adversarial-successor-audit 增加相关技能段落 (Add related skills section)
- skill-self-evolution 增加相关技能段落 (Add related skills section)
- Readme.md 技能关系图加 -kelen 后缀 + env-sync-maintainer 触发词 (Add -kelen suffix to skill names in Readme)
- Readme.md/install.sh 触发词验证加 -kelen 后缀 (Add -kelen suffix to trigger test words)
- interface.yaml name 字段与目录名一致（3 个 skill）(Fix interface.yaml name fields to match directory names)
- workspace-conventions.md 个人路径改为模板变量 + 目录结构更新 (Replace personal paths with template variables)
- skill-design-principles.md 增加验证原则和交叉引用规范 (Add verification principles and cross-reference guidelines)
- workspace-conventions.md 命名规范改为 -kelen 后缀 (Update naming convention to include -kelen suffix)

### 变更 (Changed)

- 删除冗余的 ~/.factory/rules/ 文件（skill-routing.md、progressive-disclosure.md、agent-team.md），规则内容由 factory_sync_daemon.py 自动从 CLAUDE.md 同步到 AGENTS.md (Remove redundant rule files, sync from CLAUDE.md via daemon)
- AGENTS.md 路由规则从外部引用改为内联 + Factory 专属模型映射保留 (Inline routing rules in AGENTS.md, keep Factory-specific model mapping)

## [0.5.2] - 2026-04-23

### 修正 (Fixed)

- CLAUDE.md 增加上下文路由(Contextual Routing)规则 #7：状态感知、决策风险、交付验收、新环境自适应四种触发类型 (Add contextual routing rule #7 to CLAUDE.md)
- AGENTS.md 从外部文件引用改为内联路由规则（从 CLAUDE.md 同步），解决 Factory 侧触发层断裂问题 (Inline routing rules in AGENTS.md, synced from CLAUDE.md, fix trigger layer breakage)
- skill-design-principles.md 补充两层路由机制说明：发现层(description) + 触发层(CLAUDE.md/AGENTS.md)缺一不可 (Add two-layer routing explanation: discovery layer + trigger layer)
- skill-self-evolution-kelen 步骤④ 增加名称一致性检查：路由规则、目录名、name 字段三者必须一致 (Add name consistency check in deployment verification)
- skill-self-evolution-kelen 步骤③ 决策格式优化：每选项附带快速决策信息，「待观察」替代 brain 笔记 (Optimize decision format with fast-decision info, replace brain with watchlist)

### 新增 (Added)

- factory_sync_daemon.py 增加 AGENTS.md 规则自动同步：从 CLAUDE.md 提取路由规则 → AGENTS.md（带路径适配 + checksum 去重）(Add AGENTS.md rule auto-sync to factory_sync_daemon.py)

## [0.5.1] - 2026-04-23

### 修正 (Fixed)

- skill-routing.md 上下文路由通用化，移除特定环境路径硬编码，增加「新环境自适应触发」(Generalize contextual routing, add new-environment trigger)
- env-sync-maintainer-kelen 重构为通用方法论，不绑定具体工具，适配案例拆到 references/adapters/ (Refactor as universal methodology with adapter case studies)
- skill-self-evolution-kelen 步骤③改为三层决策（粗粒度→细化→确认），必须等用户回复，不可自行跳过 (Three-layer decision: coarse → refine → confirm, must wait for user)
- 新增 `references/skill-design-principles.md` 通用设计原则（格式规范、内容净化、触发词覆盖、明确判断不干扰原则），入库 (Add universal design principles, committed to repo)

### 新增 (Added)

- env-sync-maintainer-kelen/references/adapters/claude-code.md — Claude Code 适配案例 (Add Claude Code adapter)
- env-sync-maintainer-kelen/references/adapters/factory-droid.md — Factory Droid 适配案例 (Add Factory Droid adapter)

## [0.5.0] - 2026-04-23

### 新增 (Added)

- 新增 skill: `env-sync-maintainer-kelen`（环境同步维护）— 多 AI 工具环境配置同步与 Skill 自愈 (Add skill: env-sync-maintainer-kelen)
- `skill-self-evolution-kelen` 增加用户决策机制（至少 5 项选择，最后一项为补充说明）(Add user decision mechanism to skill-self-evolution-kelen)
- `skill-self-evolution-kelen` 吸收通用 skill 生成与元设计流程能力 (Integrate generic skill generation and meta-design workflow capabilities)
- `~/.factory/rules/skill-routing.md` 增加上下文路由（状态感知、决策风险、交付验收触发）(Add contextual routing to skill-routing.md)
- `Docs/开发指导规范.md` 吸收通用模块设计规范（渐进式披露、紧凑原则、规则与说明分离、内容净化规范）(Integrate generic module design standards into dev guidelines)

### 变更 (Changed)

- 所有 skill 命名加 `-kelen` 后缀水印 (Add -kelen suffix to all skill names)
- 清理所有 SKILL.md 中的无实质内容（移除 origin 字段、心路历程、非权威引用）(Clean up non-essential content from all SKILL.md files)
- `Readme.md` 致谢段落精简，移除特定对话引用 (Simplify acknowledgments in Readme.md)
- 更新 `Docs/开发指导规范.md` 至 v0.3.0，增加 frontmatter 设计规范、触发词覆盖要求 (Update dev guidelines to v0.3.0)

## [0.4.0] - 2026-04-21

### 新增 (Added)

- 新增「AI 对话环境集成」章节：提示词模板 + 一键脚本双轨安装方式 (Add AI dialog environment integration guide)
- 新增 `install.sh` 一键安装脚本，支持 SKILL_DIR/INSTALL_DIR 环境变量适配多工具 (Add install.sh with env var support)
- 支持 Claude Code / Factory Droid / Cursor 等多 AI 工具的安装说明 (Multi-tool install instructions)

## [0.3.0] - 2026-04-21

### 新增 (Added)

- 新增 skill: `skill-self-evolution`（技能自我进化）— skill 生命周期进化能力雏形 (Add skill: skill-self-evolution)
- `dialectical-self-review` 增加与 `skill-self-evolution` 的关联引用，形成闭环 (Add cross-reference between dialectical-self-review and skill-self-evolution)

## [0.2.0] - 2026-04-21

### 新增 (Added)

- 新增 skill: `dialectical-self-review`（辩证自我审查）— 在行动前对方案做结构化自我反驳 (Add skill: dialectical-self-review)
- 包含五步辩证协议、第一性原理判据链、实际案例 (Include dialectic protocol, first-principles chain, examples)

## [0.1.0] - 2026-04-21

### 新增 (Added)

- 初始化工作空间，建立 Docs/ 目录与开发指导规范 (Init workspace with Docs/ and dev guidelines)
- 首个 skill: `adversarial-successor-audit`（对抗性接替者审计）— 以新人视角做全流程审计 (Add first skill: adversarial-successor-audit)
- 包含审计清单、三个子模式（Bootstrap 死循环检测、入库边界三层判据、AI 可调用性检验）、实际案例 (Include audit checklist, sub-patterns, examples)
- 部署机制：`update.sh` + `~/.claude/skills/update-all.sh` 自动同步 (Add deployment mechanism)
