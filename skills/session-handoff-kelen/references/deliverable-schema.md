---
description: 轻量会话结束日志、详细交付物、子 Agent 证据、附件与 ISON 索引的数据契约
parentRule: SKILL.md
---

# 会话连续性数据契约

## 研发文档根目录

`<authorized_rnd_docs_root>` 必须依据目标项目的文档管理规则确定：
- 仓库即项目根且研发内容需要隔离：`Project/Docs/`。
- 项目目录以 `Docs/` 管理研发内容：`<project>/Docs/`。
- 面向外部公开的仓库 `Docs/` 不默认保存具体会话交付物。

## 默认相对目录

```text
<authorized_rnd_docs_root>/记录文档/
├── 会话日志/
│   ├── index.ison
│   └── session_end_log_YYYY_MM_DD_session{N}.md
├── 上下文交付物/
│   ├── _baseline.md
│   ├── index.ison
│   ├── context_deliverable_YYYY_MM_DD_session{N}.md
│   ├── agents/
│   │   └── session{N}/
│   │       └── agent_<agent_id>.md
│   └── attachments/
│       └── session{N}/
│           ├── main/
│           └── agents/<agent_id>/
└── 归档/
    ├── 会话日志/
    └── 上下文交付物/
```

该结构是默认相对约定；目标项目声明不同结构时，记录适配依据并遵循目标项目。

## 轻量会话结束日志字段

创建前置条件：必须取得 `user_closed` 或 `verified_host_session_end` 结束证据。若结束事实仅为推测或 `unknown`，不得创建轻量结束日志。

```yaml
template_version: "0.1"
session_id: "<YYYY_MM_DD_sessionN>"
record_type: "session_end_log"
topic_label: "<non-sensitive short label | redacted>"
invocation_source: "<conversational | host_event | rule_route>"
end_signal: "<user_closed | verified_host_session_end>"
end_status: "<complete | paused | blocked | unknown>"
detailed_handoff: "<relative path | none>"
unresolved_risk_present: "<yes | no | unknown>"
verification_state: "<verified | partial | pending>"
updated_at: "<timestamp>"
```

正文只允许补充最小事实引用，不写完整会话摘要或详细任务状态。

## 详细主会话交付物字段

```yaml
template_version: "0.1"
session_id: "<YYYY_MM_DD_sessionN>"
session_role: "main"
record_type: "detailed_handoff"
topic: "<本轮唯一主题>"
invocation_source: "<conversational | host_event | rule_route>"
trigger_evidence: "<user_request | verified_host_signal | rule_route>"
interaction_mode: "<native_tool | text_fallback | not_needed>"
native_tool_candidate: "<candidate tool | none>"
native_tool_status: "<presented | not_exposed | invocation_rejected | unsupported_question_type | not_needed>"
fallback_reason: "<observable failure reason | none>"
capability_evidence: "<tool exposure or invocation result evidence>"
reasoning_gate: "<goal/evidence_gap/risk/decision_basis>"
decision_options: "<none | options_with_recommendation_and_reason>"
architecture_boundary: "<protocol/template/index/attachment/runtime-record separation>"
pre_record_basis: "<mode/root/authorization/boundary/exclusions>"
post_record_verification: "<paths/index/authorization/exclusions/risks>"
summary_mode: "<none | authorized_redacted>"
redaction_status: "<not_needed | applied | pending_authorization>"
status: "<in_progress | paused | complete | blocked>"
child_agents: ["<agent_id>"]
attachments: ["<authorized relative path>"]
next_action: "<下一步动作>"
verification: "<验证状态与入口>"
```

正文最小章节：
- 决策前推理闸门与证据缺口
- 架构边界和研发记录前后状态
- 目标与本轮边界
- 已确认事实和证据引用
- 当前修改与验证状态
- 未完成事项、阻塞与残余风险
- 子 Agent 和附件索引
- 新会话入口与下一验证动作
- 省略内容与授权状态

## 子 Agent 记录字段

```yaml
template_version: "0.1"
session_role: "subagent"
parent_session_id: "<YYYY_MM_DD_sessionN>"
agent_id: "<stable id>"
role: "<角色或领域>"
task_scope: "<任务范围>"
allowed_reads_or_calls: ["<authorized object>"]
expected_output: "<输出目标>"
result_status: "<completed | partial | failed | blocked>"
evidence_references: ["<redacted reference>"]
full_content_authorized: false
attachments_authorized: false
```

默认正文只存任务定义、允许范围、结论、风险与复验建议，不写完整原文。

## ISON 导航记录

ISON 用于导航关系和状态索引，不用于储存全文。每条记录至少包含：

```text
record_type: session_end_log | detailed_handoff | subagent | attachment
record_id: <stable id>
parent_id: <empty or session id>
path: <relative path>
topic: <non-sensitive short label | redacted>
status: <in_progress | paused | complete | blocked | archived>
authorization: <default_minimal | authorized_redacted | authorized_attachment>
updated_at: <timestamp>
verification_state: <verified | partial | pending>
```

写入要求：
- 创建轻量结束日志或详细交付物时追加新的导航记录，不覆盖既有正文。
- 索引默认仅保留非敏感短标签；无法确认主题是否敏感时写 `redacted`。
- 附件记录只引用已授权文件。
- 归档时更新导航状态与路径，并保留原记录关联。
