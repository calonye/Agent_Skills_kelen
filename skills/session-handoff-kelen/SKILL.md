---
name: session-handoff-kelen
description: >-
  治理会话连续性与交接：在真实会话结束时生成轻量结束日志；在需要续接、
  需要形成可跨会话持续材料的压缩/恢复治理，或用户要求详细记录时，生成可复核交付物、
  续接入口和子 Agent 证据索引。
  触发场景（用户口语）：
  「准备换个会话继续」「给下个会话留一份接手材料」「帮我做接力包」
  「上下文快不够了，先把继续工作的资料准备好」「compact 前先留交接材料」
  「把子 agent 的任务和结果也整理进交接材料」「这个会话结束了，留个简单记录」
  「恢复上次的工作，先核对交接材料」
  触发场景（AI 自我思考）：
  「当前任务仍未完成，但需要跨会话延续，我应该生成可继续执行的交付物」
  「宿主已提示上下文压力或压缩/恢复事件，我需要治理保留内容并验证连续性」
  「宿主确认当前会话结束，我应写轻量结束日志；若需要续接再升级为详细交付物」
  关键词：会话日志、会话交付、上下文交接、上下文恢复、压缩治理、接力包、
  续接材料、session handoff、session end log、context deliverable、resume context。
metadata:
  author: kelen
  version: 0.3.2
---

# 会话连续性与交接治理

本 skill 负责会话生命周期中与连续性相关的最小持久化和交接治理：每个真实结束的会话留下轻量可追踪日志；只有在需要继续执行、需要形成可跨会话持续材料的压缩/恢复治理或用户明确要求时，才生成详细交付物、续接入口和经授权的证据索引。

## 术语边界

- **会话（session）**：由宿主创建、可结束/压缩/恢复或被新会话替代的一段主上下文生命周期；轻量结束日志以真实结束会话为单位。
- **对话（turn / exchange）**：同一会话中的一次或多次普通消息往返；普通对话和普通收尾不等于需要交付的会话切换。
- **详细交付物（handoff deliverable）**：面向续接、需要持久化的新恢复状态或显式详细记录的结构化材料，不等于结束日志；单纯压缩整理或恢复抽查可以只输出结果而不创建文件。
- **子 Agent 上下文**：由主会话分派的独立执行上下文；只有进入详细交付范围且内容获准保留时，才写独立证据记录并关联主会话。

## 边界

- 不把轻量结束日志或详细交付物写成完整对话复刻或未经授权的摘要。
- 不默认保存完整提示词、完整回复、截图、凭据或隐私内容。
- 不依据不可观测的上下文百分比伪造触发判断。
- 不自动修改本 skill 或其他规则文件；发现协议缺口时仅输出 `improvement_candidate`。
- 不执行项目本身的实现、发布、迁移或安全操作。
- 不把带有当前项目路径、阶段或运行状态的续接入口默认写成仓库可重用模板；通用模板必须参数化且经授权。
- 已安装 skill 可覆盖用户口语和 AI 判断触发；没有用户消息时依靠宿主 `SessionEnd`、压缩或恢复事件自动执行，必须另有可验证的宿主事件路由，不能仅凭安装状态宣称成功。
- 不把协议、模板、索引、附件和真实运行记录混成一个文件；架构上必须保持规则包、私有交付物、索引和附件引用解耦。

## 文件索引

- `references/handoff-protocol.md`：结束日志、详细交付、恢复校验、授权和压缩质量流程。
- `references/deliverable-schema.md`：结束日志、详细交付物、子 Agent、附件和 ISON 索引契约。
- `references/eval-prompts.md`：正例、边界、隐私和宿主交互验证。
- `agents/interface.yaml`：能力输入输出和降级状态声明。

## 触发与处理模式

1. **结束记录模式**：宿主提供可核实的会话结束信号，或用户明确结束当前真实会话 → 写轻量 `session_end_log`；不自动升级为详细交付物。
2. **详细交付模式**：用户要求换会话继续、生成交接材料或详细保存当前状态；未完成任务在压缩/上下文压力下需要延续；或恢复过程需要补齐可复核材料 → 写详细交付物和必要索引。
3. **恢复校验模式**：用户要求继续之前的任务、恢复上下文或核对交付材料 → 读取已有日志/交付物，抽查关键完成声明并报告可信状态；默认不新建详细交付物。
4. **压缩治理模式**：宿主明确发出压缩相关信号 → 按保留/排除规则整理有效信息；仅在详细交付触发条件同时成立时写详细交付物。
5. 用户、全局规则或项目规则明确要求本次采用某一模式 → 按优先级执行；高优先级规则无条件要求每次会话产生详细交付物时，记录 `rule_conflict: upstream_unconditional_policy` 并提示收敛到本 skill 的分级模式。
6. 宿主没有暴露可核实的上下文使用量 → 不推测百分比；只记录可观察信号或 `unknown`。
7. `end_log` 请求不替代结束事实证据：必须有用户明确正在结束当前真实会话，或已验证的宿主 `SessionEnd` 事件；否则返回 `handoff_status: blocked` 或 `not_needed`，不得落盘。

触发表面必须区分：
- `conversational`：用户口语或 AI 当前推理已触发本 skill，可在当前运行中执行。
- `host_event`：宿主在无用户消息时发出生命周期事件；只有事件路由已实测可调用本 skill 或等价执行入口时，才声明自动执行成立。
- `rule_route`：已生效的上游规则将当前可观察事件路由到本 skill；仍不替代宿主无消息事件复验。

不触发：
- 同一会话内的普通问答、普通进度汇报或一次回复结束，且没有宿主会话结束/压缩/恢复信号或明确交接请求 → 不写任何文件。
- 任务已完成且宿主尚未确认会话结束 → 不提前生成轻量日志或详细交付物。
- 当前消息本身是在读取既有交付物并继续执行 → 进入恢复校验，不因读取动作自动创建新交付物。

## 执行流程

### 1. 建立范围与存储根目录

识别处理模式、本次主题、目标项目的研发记录文档根目录和授权范围。必须先依据项目规则确定 `authorized_rnd_docs_root`：

- 仓库即项目根且研发产出物与公开仓库内容隔离时，采用 `Project/Docs/`。
- 研发项目目录自身管理研发文档时，采用该项目下的 `Docs/`。
- 仓库内面向外部公开的 `Docs/` 不承载具体任务交付物，除非用户明确授权生成已参数化的公开模板。

在确定的研发文档根目录下使用相对约定：

```text
<authorized_rnd_docs_root>/记录文档/会话日志/session_end_log_YYYY_MM_DD_session{N}.md
<authorized_rnd_docs_root>/记录文档/上下文交付物/context_deliverable_YYYY_MM_DD_session{N}.md
<authorized_rnd_docs_root>/记录文档/归档/会话日志/
<authorized_rnd_docs_root>/记录文档/归档/上下文交付物/
```

若项目已经声明不同的权威目录，优先遵循项目规则并在交付物记录依据；不得静默写入猜测路径。

架构解耦门禁：
- 公共 skill 规则只保存协议、模板和边界；真实会话记录、项目路径、附件引用和执行状态只进入授权研发文档根目录。
- 详细交付物、子 Agent 记录、附件索引和 ISON 导航必须分文件或分区承载；不得为省事把所有内容堆进单一正文。
- 写入前记录 `pre_record_basis`：处理模式、目录依据、授权范围、架构边界和待排除内容。
- 写入后记录 `post_record_verification`：实际路径、索引关系、授权状态、排除内容和残余风险。

### 2. 处理必要澄清与授权

只有以下 P0 问题无法从当前上下文或只读文件确认时才询问：
- 目标交付目录或会话编号无法安全确定。
- 用户要求摘要、完整对话片段、完整子 Agent 输入输出或附件，但授权范围不清。
- 多个互斥续接目标会改变交付物结构或后续行动。

交互规则：
- 发问或提交裁定前，必须先执行“推理/思维链基本要求”的可审计版本：目标重述 → 信息与证据检查 → 不确定性识别 → 反方风险 → 最小决策。不得输出完整隐藏思维链，只输出目标、证据缺口、风险和裁定依据。
- 每轮最多 1 次澄清请求，最多 6 个问题，支持短答、互斥选择和多选。
- 互斥选择必须标 1 个推荐项；多选可以标推荐组合。每个选项都必须附一句核心逻辑理由或取舍影响；证据不足时不得强行推荐，需标明缺口。
- 本轮工具目录或宿主接口暴露支持相应问题类型的原生交互能力时，必须先实际调用该能力呈现问题或裁定选项，不得只在普通文本中仿造选项界面。
- 仅当原生能力未暴露，或真实调用返回不可用、拒绝、题型/题量不支持等可观察证据时，才输出 `ClarificationRequest` 文本降级，并记录 `interaction_mode: text_fallback`、候选工具、状态、原因和证据来源。
- 发问后停止执行，等待回答；不得替用户选择授权范围。

### 3. 写轻量会话结束日志

结束记录模式必须先确认 `end_signal: user_closed | verified_host_session_end`，再只记录：会话标识、脱敏主题标签、结束状态、触发证据、是否存在详细交付物、验证状态和未解决风险是否存在。证据未知时不得创建结束日志。不得写完整对话、推理摘要、子 Agent 原文或附件内容。

### 4. 收集详细交付最小证据

进入详细交付模式后，只收集与连续性、恢复或继续执行直接有关且已经允许读取的信息：
- 当前主题、已确认目标和禁止事项。
- 已修改或待修改文件、验证命令及其结果状态。
- 未完成工作、阻塞、残余风险和下一步验证入口。
- 已分配子 Agent 的任务定义与返回结论的脱敏引用。

默认不收集：
- 完整对话转录、完整提示词、完整子 Agent 输出。
- 截图、录屏、密钥、环境变量内容或业务数据快照。
- 与当前续接目标无关的运行环境扫描。

### 5. 压缩治理与内容保留

压缩治理本身不是摘要授权。默认不生成摘要压缩，脱敏摘要需要明确授权。宿主执行压缩流程或用户授权生成脱敏摘要时：
- 优先排除失败且无信息价值的工具尝试、无产出的重复尝试和已被明确纠正的错误路径。
- 保留用户已确认约束、已验证证据、未完成任务、风险、授权边界、文件定位和复验入口。
- 明示哪些内容被排除、哪些判断仍是未知；不得把推断改写为事实。

### 6. 恢复读取与证据抽查

- 读取既有结束日志或详细交付物时，默认将其视为线索而非权威事实。
- 对会影响下一动作的“已完成”“已验证”声明，抽查 1-2 个可复验证据；无法验证时标为 `pending` 或 `partial`。
- 发现遗漏、失实或过时内容时，报告差异；只有当前模式需要新详细交付且获准写入时，才创建新交付物。

### 7. 生成续接入口并限定持久化范围

- `next_entry` 是本次跨会话续接的导航入口，不默认成为仓库内的可重用文档。
- 带有真实项目文件路径、当前阶段、环境状态或私有计划位置的入口，仅可保留在获准的私有交付物或即时输出中；不得默认建议写入公开文档目录。
- 用户明确需要可重用模板时，先生成仅含占位符和通用结构的模板候选，并确认存放范围；不得将本次具体入口直接复用为通用模板。

### 8. 写入详细交付物和索引

- 每次详细交付产生一个新的 `context_deliverable_YYYY_MM_DD_session{N}.md`；禁止持续追加覆盖旧文件。
- 子 Agent 记录与主会话分离，保存任务定义、允许读取/调用范围、输出目标、结论和脱敏证据引用。
- 附件只在逐次授权后保存，并按所属主会话/子 Agent 目录归类。
- ISON 索引只存最小导航元数据和引用关系；主题默认采用非敏感短标签或 `redacted`，不内嵌完整对话或私密附件内容。
- 旧交付物的归档属于显式维护动作；未获授权不移动或删除文件。
- 研发文档必须保留落实前后状态：写入前记录为什么写、写到哪里、依据什么授权；写入后记录写了什么、验证了什么、哪些内容被排除或待确认，避免文档与研发过程形成隐性技术债。

### 9. 输出与自检

输出：
- 当前处理模式及新建轻量日志或详细交付物的绝对路径。
- 仅在详细交付模式中输出可粘贴至新会话的简洁入口，包含交付物路径、下一步和验证入口。
- 子 Agent/附件索引状态、内容授权状态和交互降级状态。
- `improvement_candidate`：若本次发现协议不足，仅记录建议与证据，不自动编辑规则。

自检：
- 轻量结束日志是否没有混入详细内容；若需续接，下一会话是否可依据交付物定位主题、已证实结果、下一动作和验收方式。
- 文件名是否包含独立 `session{N}`，索引是否引用正确对象。
- 是否误保存未授权摘要、完整提示内容、截图或敏感数据。
- 是否把未知状态、未验证推断或宿主不可观测信息伪装为事实。

## 输出契约

```text
continuity_action: end_log | detailed_handoff | restore_verify | compression_hygiene | not_needed
handoff_status: created | read_verified | clarification_required | not_needed | blocked
session_role: main | subagent
invocation_source: conversational | host_event | rule_route
trigger_reason: explicit_session_end | verified_host_session_end | explicit_continuation | observable_pressure | compact_or_resume | explicit_rule | none
rule_conflict: none | upstream_unconditional_policy
documentation_root: <authorized R&D docs root or pending>
session_end_log_path: <absolute path or pending or not_needed>
deliverable_path: <absolute path or pending>
index_path: <absolute path or pending>
interaction_mode: native_tool | text_fallback | not_needed
native_tool_candidate: <candidate tool or none>
native_tool_status: presented | not_exposed | invocation_rejected | unsupported_question_type | not_needed
fallback_reason: <observable failure reason or none>
capability_evidence: <tool exposure or invocation result evidence>
reasoning_gate: <goal/evidence_gap/risk/decision_basis>
decision_options: <none or options with recommended marker and reason>
architecture_boundary: <protocol/template/index/attachment/runtime-record separation>
rnd_record_state: <pre_record_basis and post_record_verification>
summary_mode: none | authorized_redacted
attachments: none | authorized_references
persistence_scope: output_only | private_deliverable | authorized_generic_template
next_entry: <new-session continuation instruction>
verification: <checked items and unresolved risks>
improvement_candidate: <none or evidence-based proposal>
```

## 参考

- `references/handoff-protocol.md` - 执行细则与授权边界
- `references/deliverable-schema.md` - 目录、模板与 ISON 导航结构
- `references/eval-prompts.md` - 最小行为验证提示
