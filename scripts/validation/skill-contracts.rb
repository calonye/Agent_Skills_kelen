# frozen_string_literal: true

require_relative "common"

self_evolution = "skills/skill-self-evolution-kelen"
skill_file = File.join(self_evolution, "SKILL.md")
body = File.read(skill_file)
core_self_evolution_refs = [
  "references/trigger-coverage-matrix.md",
  "references/capability-equivalence-protocol.md",
  "references/host-interaction-adaptation.md",
  "references/eval-prompts.md"
].map { |ref| File.join(self_evolution, ref) }
core_self_evolution_refs.each do |file|
  raise "#{file}: missing" unless File.exist?(file)
  raise "#{file}: must be tracked because SKILL.md and validation gates depend on it" unless tracked_file?(file)
end
raise "#{skill_file}: exceeds 500 lines" if body.lines.count > 500
raise "#{skill_file}: markdown table found" if body.match?(/^\|.*\|$/)
raise "#{skill_file}: repeated blank lines found" if body.match?(/\n{3,}/)
require_phrases(skill_file, body, [
  "六段生命周期协议",
  "生命周期 4 层验证",
  "前置协议：思辨、澄清、调研、决策准备",
  "澄清门槛",
  "证据调研",
  "思辨审查",
  "决策准备",
  "Skill 生命周期进化报告",
  "创建、设计、维护、迭代、改进和进化",
  "质量机制",
  "质量维度门禁",
  "示例驱动准备",
  "资源边界裁定",
  "执行自由度裁定",
  "脚本适配裁定",
  "前向测试",
  "参考对照",
  "前次自审标为未完全成功",
  "收敛、约束、稳定、通用性、兼容性、解耦性、扩展性和独立性",
  "呈现完整决策信息后必须等待用户回复",
  "名称一致性检查",
  "references/skill-design-principles.md",
  "references/trigger-coverage-matrix.md",
  "references/capability-equivalence-protocol.md",
  "references/structural-audit-methodology.md",
  "references/eval-prompts.md",
  "行为验证",
  "触发验证",
  "自我适用",
  "需求覆盖",
  "能力等价",
  "递归终止",
  "SemVer",
  "`-kelen` 是本仓库默认命名约定",
  "已识别对象、问题与候选动作",
  "已有 skill 迭代",
  "新会话真实触发",
  "外部工具",
  "来源",
  "隐私"
])

interface = load_yaml(File.join(self_evolution, "agents/interface.yaml"))
constraints = interface.fetch("constraints").join("\n")
require_phrases("#{self_evolution}/agents/interface.yaml", constraints, [
  "主要职责是 skill 的创建、设计、维护、迭代、改进和进化",
  "收敛、约束、稳定、通用性、兼容性、解耦性、扩展性和独立性",
  "思辨/澄清/调研/决策准备前置协议",
  "生命周期 4 层第一性原理验证",
  "每轮最多 1 次",
  "每次最多 6 问",
  "单选只标 1 个推荐项",
  "多选可标推荐组合",
  "具体来源链路",
  "等待用户确认",
  "触发覆盖矩阵",
  "结构一致性审计",
  "最小行为验证",
  "需求覆盖报告",
  "能力等价报告",
  "自我适用",
  "前次自审标为未完全成功",
  "参考对照",
  "脚本适配裁定",
  "优先 Rust",
  "递归终止",
  "SemVer",
  "improvement_candidate",
  "维护、改进和自我进化必须走独立执行路径",
  "新会话真实触发",
  "普通创建 skill 同样必须先进入本生命周期入口"
])
self_evolution_required_tools = interface.fetch("tools_required", [])
raise "#{self_evolution}/agents/interface.yaml: only Read should be required" unless self_evolution_required_tools == ["Read"]
self_evolution_optional_tools = interface.fetch("tools_optional", [])
["Create", "Edit", "Execute", "LS", "Grep", "Glob"].each do |tool|
  raise "#{self_evolution}/agents/interface.yaml: missing optional tool #{tool}" unless self_evolution_optional_tools.include?(tool)
end

trigger_matrix = File.join(self_evolution, "references/trigger-coverage-matrix.md")
trigger_matrix_body = File.read(trigger_matrix)
require_phrases(trigger_matrix, trigger_matrix_body, [
  "用户自然口语",
  "AI 推理触发",
  "发现层关键词",
  "误触发边界",
  "正例",
  "近邻例",
  "负例",
  "AI 自触发例"
])

capability_equivalence = File.join(self_evolution, "references/capability-equivalence-protocol.md")
raise "#{capability_equivalence}: missing" unless File.exist?(capability_equivalence)
capability_equivalence_body = File.read(capability_equivalence)
require_phrases(capability_equivalence, capability_equivalence_body, [
  "能力等价协议",
  "融合",
  "替代某流程效果",
  "能力等价矩阵",
  "触发能力",
  "产出能力",
  "流程能力",
  "约束能力",
  "验证能力",
  "迁移能力",
  "成立",
  "修正",
  "推翻",
  "部分等价",
  "新会话真实触发未验证"
])

require_phrases(skill_file, body, [
  "把这个流程沉淀下来",
  "下次别再从头想一遍",
  "这个 skill 没达到目的",
  "这个 skill 不好用",
  "这个 skill 不容易触发",
  "不想让这次白费",
  "以后还会遇到这种问题吧",
  "复杂任务完成后准备收工",
  "用户未明说创建 skill",
  "同类判断多次复现"
], label: "self-evolution trigger")

require_phrases(skill_file, body, [
  "审查这个 skill 有没有达到目的",
  "前面改的 skill 是否真的落实了",
  "用户要求改进已有 skill",
  "按优先级逐个审查",
  "能力等价矩阵",
  "不能只写“已融合”",
  "不得只按普通创建流程处理",
  "仍先进入本 skill 判定为 `创建`",
  "静态文件覆盖",
  "当前会话按规则手动执行",
  "新会话真实触发",
  "不继续展开第二轮自我进化",
  "SemVer 裁定",
  "维护/改进 skill"
], label: "self-application phrase")
raise "#{skill_file}: decision template hardcodes repo suffix" if body.include?("创建新 skill `<name>-kelen`")
raise "#{skill_file}: missing runtime-neutral decision template name" unless body.include?("创建新 skill `<skill-name>`")

stale_self_evolution_terms = [
  "## 五段自我进化协议",
  "五段自我进化循环",
  "### 已识别的方法论"
]
[
  [skill_file, body],
  [File.join(self_evolution, "references/examples.md"), File.read(File.join(self_evolution, "references/examples.md"))]
].each do |file, file_body|
  stale_self_evolution_terms.each do |term|
    raise "#{file}: stale self-evolution term found: #{term}" if file_body.include?(term)
  end
end

self_evolution_interface_body = File.read(File.join(self_evolution, "agents/interface.yaml"))
require_phrases("#{self_evolution}/agents/interface.yaml", self_evolution_interface_body, [
  "记住这个方法",
  "当前对话形成了可复用判断框架",
  "Skill 生命周期进化引擎",
  "创建、设计、维护、迭代、改进、自我进化或进化 skill",
  "思辨/澄清/调研前置协议",
  "触发覆盖验证",
  "改进或迭代已有 skill"
], label: "route phrase")

require_phrases(trigger_matrix, trigger_matrix_body, [
  "把这个流程沉淀下来，下次别再从头想一遍",
  "审查这个 skill 有没有达到原本设计目的",
  "如果融合了某流程，就应该能替代它的效果",
  "帮我创建一个普通 skill",
  "整理会议纪要",
  "复杂任务完成后准备收工"
], label: "trigger eval phrase")

self_evolution_eval = File.join(self_evolution, "references/eval-prompts.md")
self_evolution_eval_body = File.read(self_evolution_eval)
require_phrases(self_evolution_eval, self_evolution_eval_body, [
  "skill 生命周期请求应触发",
  "维护请求应触发",
  "改进请求应触发",
  "自我进化闭环应触发",
  "自然口语应触发",
  "低专业度口语应触发",
  "AI 自触发",
  "已有 skill 迭代应触发",
  "自我适用应触发",
  "能力等价应触发",
  "普通创建需求首进生命周期入口但不强行自进化",
  "普通事实记忆不应创建 skill",
  "一次性整理不应创建 skill",
  "偏好记忆不应创建 skill",
  "区分静态触发覆盖和真实会话触发",
  "维护、改进和自我进化请求必须走独立路径",
  "思辨/澄清/调研/决策准备",
  "需求覆盖报告",
  "能力等价矩阵",
  "下游缺陷应回流自我改进",
  "自审失效应回流",
  "前次自审结论标为未完全成功",
  "脚本适配",
  "不绑定特定 skill 名称",
  "裁定选项应使用宿主交互能力",
  "interaction_mode: native_tool"
])

host_interaction = File.join(self_evolution, "references/host-interaction-adaptation.md")
raise "#{host_interaction}: missing" unless File.exist?(host_interaction)
host_interaction_body = File.read(host_interaction)
require_phrases(host_interaction, host_interaction_body, [
  "交互式提问或选择能力",
  "short_text",
  "single_choice",
  "multi_select",
  "native_tool",
  "text_fallback",
  "native_tool_candidate",
  "native_tool_status",
  "capability_evidence",
  "执行访问权限和原生交互能力分别判定",
  "不得把 Markdown 中的选项列表宣称为弹窗工具调用成功",
  "每个选项必须包含一句核心逻辑理由或取舍影响",
  "多选题可标推荐组合",
  "不得输出没有理由的裸选项",
  "推荐来自证据强度、风险和复验成本"
])

[
  [skill_file, body],
  [File.join(self_evolution, "agents/interface.yaml"), self_evolution_interface_body],
  [File.join(self_evolution, "references/skill-design-principles.md"), File.read(File.join(self_evolution, "references/skill-design-principles.md"))]
].each do |file, file_body|
  require_phrases(file, file_body, [
    "交互",
    "实际调用",
    "自动",
    "私有"
  ], label: "generation gate")
end

design_principles = File.join(self_evolution, "references/skill-design-principles.md")
design_principles_body = File.read(design_principles)
require_phrases(design_principles, design_principles_body, [
  "命名规则由目标运行时或目标仓库约定决定",
  "`-kelen` 是本仓库默认水印",
  "不是跨环境强制后缀",
  "示例驱动准备",
  "资源边界裁定",
  "执行自由度裁定",
  "脚本适配裁定",
  "前向测试门槛",
  "禁止为了显得完整而创建空目录",
  "`SKILL.md` 只保留触发面、核心执行骨架、输出契约和必要分支",
  "确定性越高，越应减少模型自由发挥",
  "优先复用仓库既有工具链",
  "优先 Rust",
  "高性能脚本/运行时",
  "不创建脚本时说明原因",
  "不泄露预期答案、修复意图或作者结论"
], label: "design principle phrase")
forbid_phrases(design_principles, design_principles_body, [
  "name: <skill-name>-kelen",
  "<skill-name>-kelen/"
], label: "hardcoded repo suffix in generic template")

successor = "skills/adversarial-successor-audit-kelen"
successor_skill = File.join(successor, "SKILL.md")
successor_body = File.read(successor_skill)
successor_protocol = File.join(successor, "references/multi-perspective-protocol.md")
successor_protocol_body = File.read(successor_protocol)
require_phrases(successor_skill, successor_body, [
  "multi_perspective",
  "多视角接替审计",
  "成立",
  "修正",
  "推翻",
  "交叉合并",
  "残余风险",
  "references/multi-perspective-protocol.md",
  "references/eval-prompts.md"
])
raise "#{successor_protocol}: missing" unless File.exist?(successor_protocol)
successor_eval = File.join(successor, "references/eval-prompts.md")
raise "#{successor_eval}: missing" unless File.exist?(successor_eval)
successor_eval_body = File.read(successor_eval)
require_phrases(successor_eval, successor_eval_body, [
  "交付前新人路径",
  "多视角交叉审查",
  "代码正确性审查",
  "安全漏洞审查",
  "直接修复",
  "不修改文件",
  "成立 / 修正 / 推翻",
  "黄金输出样例",
  "失败样例",
  "能力等价矩阵",
  "触发状态记录",
  "静态文件覆盖",
  "新会话真实触发",
  "claim/evidence/risk/fix/retest"
])
{
  "成立" => "证据支持",
  "修正" => "修复和复验",
  "推翻" => "关键前提不成立"
}.each do |term, evidence|
  raise "#{successor_protocol}: missing tri-state #{term}" unless successor_protocol_body.include?(term) && successor_protocol_body.include?(evidence)
end
successor_roles_cn = %w[新人执行者 文档维护者 自动化维护者 发布守门人 隐私边界审查者]
successor_roles_en = %w[newcomer docs automation release privacy]
successor_roles_cn.each do |role|
  raise "#{successor_skill}: missing role #{role}" unless successor_body.include?(role)
  raise "#{successor_protocol}: missing role #{role}" unless successor_protocol_body.include?(role)
end
require_phrases(successor_protocol, successor_protocol_body, [
  "single_actor",
  "sequential_simulation",
  "parallel_review",
  "claim",
  "evidence",
  "risk",
  "fix",
  "retest",
  "冲突账本",
  "execution_strategy",
  "修复闭环状态"
])
successor_interface = load_yaml(File.join(successor, "agents/interface.yaml"))
successor_constraints = successor_interface.fetch("constraints").join("\n")
require_phrases("#{successor}/agents/interface.yaml", successor_constraints, [
  "多视角模式仍是只读审计",
  "不要求真实多 agent",
  "无法复验项标为待确认",
  "成立 / 修正 / 推翻",
  "不得给出可交付结论",
  "待确认只是证据状态",
  "execution_strategy",
  "修复闭环"
])
{
  "scope" => %w[full diff],
  "focus" => %w[docs scripts workflow ci all],
  "mode" => %w[single multi_perspective],
  "execution_strategy" => %w[single_actor sequential_simulation parallel_review],
  "dependency_policy" => %w[no_external_required optional_enhancement_only]
}.each do |name, expected|
  item = successor_interface.fetch("inputs").find { |input| input["name"] == name }
  raise "#{successor}/agents/interface.yaml: missing input #{name}" unless item
  raise "#{successor}/agents/interface.yaml: enum mismatch for #{name}" unless item["enum"] == expected
end
successor_optional_tools = successor_interface.fetch("tools_optional", [])
%w[run_readonly_commands search_text list_files inspect_file_tree].each do |tool|
  raise "#{successor}/agents/interface.yaml: missing optional capability #{tool}" unless successor_optional_tools.include?(tool)
end
successor_perspective = successor_interface.fetch("inputs").find { |item| item["name"] == "perspective_set" }
raise "#{successor}/agents/interface.yaml: missing perspective_set input" unless successor_perspective
successor_roles_en.each do |role|
  raise "#{successor}/agents/interface.yaml: missing perspective role #{role}" unless successor_perspective["description"].to_s.include?(role)
end
tools_required = successor_interface.fetch("tools_required", [])
raise "#{successor}/agents/interface.yaml: Execute must not be required" if tools_required.any? { |tool| tool.to_s.include?("Execute") }
[
  [successor_skill, successor_body],
  [successor_protocol, successor_protocol_body],
  [File.join(successor, "agents/interface.yaml"), File.read(File.join(successor, "agents/interface.yaml"))]
].each do |file, file_body|
  raise "#{file}: missing read-only constraint" unless file_body.match?(/只读|不修改|不执行写入/)
end

brainstorming = "skills/brainstorming-kelen"
brainstorming_skill = File.join(brainstorming, "SKILL.md")
brainstorming_body = File.read(brainstorming_skill)
require_phrases(brainstorming_skill, brainstorming_body, [
  "结构化头脑风暴",
  "ClarificationRequest",
  "question_budget",
  "multi_select",
  "成立",
  "修正",
  "推翻",
  "claim / evidence / risk / fix / retest",
  "references/brainstorming-protocol.md",
  "references/idea-evaluation-criteria.md",
  "references/boundary-and-sanitization.md",
  "references/eval-prompts.md"
])
brainstorming_protocol = File.join(brainstorming, "references/brainstorming-protocol.md")
brainstorming_protocol_body = File.read(brainstorming_protocol)
require_phrases(brainstorming_protocol, brainstorming_protocol_body, [
  "single_actor",
  "sequential_simulation",
  "parallel_review",
  "claim",
  "evidence",
  "risk",
  "fix",
  "retest",
  "冲突账本",
  "并发只是执行优化"
])
brainstorming_interface = load_yaml(File.join(brainstorming, "agents/interface.yaml"))
brainstorming_constraints = brainstorming_interface.fetch("constraints").join("\n")
require_phrases("#{brainstorming}/agents/interface.yaml", brainstorming_constraints, [
  "不修改任何文件",
  "不执行实现",
  "不要求真实多 agent",
  "AskUserQuestion 不作为硬依赖",
  "常规 0-3 问",
  "最多 6 问",
  "multi_select",
  "P1/P2 未知必须进入延后确认队列",
  "待确认只是证据状态"
])
brainstorming_required_tools = brainstorming_interface.fetch("tools_required", [])
if brainstorming_required_tools.any? { |tool| tool.to_s.include?("AskUserQuestion") || tool.to_s.include?("request_user_input") }
  raise "#{brainstorming}/agents/interface.yaml: AskUserQuestion must not be required"
end

[
  File.join(brainstorming, "SKILL.md"),
  File.join(brainstorming, "agents/interface.yaml"),
  File.join(brainstorming, "references/brainstorming-protocol.md"),
  File.join(brainstorming, "references/eval-prompts.md"),
  "skills/dialectical-self-review-kelen/SKILL.md",
  "skills/dialectical-self-review-kelen/agents/interface.yaml",
  "skills/dialectical-self-review-kelen/references/dialectic-protocol.md",
  "skills/dialectical-self-review-kelen/references/eval-prompts.md",
  "skills/security-penetration-kelen/SKILL.md",
  "skills/security-penetration-kelen/agents/interface.yaml"
].each do |file|
  file_body = File.read(file)
  raise "#{file}: missing native interaction invocation rule" unless file_body.include?("实际调用")
  raise "#{file}: missing native interaction state" unless file_body.include?("native_tool")
  raise "#{file}: missing text fallback state" unless file_body.include?("text_fallback")
end

handoff = "skills/session-handoff-kelen"
handoff_skill = File.join(handoff, "SKILL.md")
raise "#{handoff_skill}: missing" unless File.exist?(handoff_skill)
handoff_body = File.read(handoff_skill)
handoff_interface = File.join(handoff, "agents/interface.yaml")
handoff_protocol = File.join(handoff, "references/handoff-protocol.md")
handoff_schema = File.join(handoff, "references/deliverable-schema.md")
handoff_eval = File.join(handoff, "references/eval-prompts.md")
require_files([
  handoff_interface,
  handoff_protocol,
  handoff_schema,
  handoff_eval
])
require_phrases(handoff_skill, handoff_body, [
  "会话连续性与交接治理",
  "术语边界",
  "对话（turn / exchange）",
  "context_deliverable_YYYY_MM_DD_session{N}.md",
  "session_end_log_YYYY_MM_DD_session{N}.md",
  "归档/上下文交付物",
  "ISON",
  "interaction_mode",
  "native_tool",
  "text_fallback",
  "native_tool_candidate",
  "native_tool_status",
  "capability_evidence",
  "默认不生成摘要压缩",
  "脱敏摘要需要明确授权",
  "不自动修改本 skill",
  "不推测百分比",
  "不自动升级为详细交付物",
  "rule_conflict: upstream_unconditional_policy",
  "persistence_scope",
  "authorized_rnd_docs_root",
  "continuity_action",
  "primary_action",
  "secondary_actions",
  "invocation_source",
  "host_event_evidence",
  "index_update_state",
  "decision_envelope",
  "artifacts",
  "不能仅凭安装状态宣称成功",
  "证据未知时不得创建结束日志",
  "恢复读取与证据抽查",
  "30 秒恢复块",
  "skipped_no_hook",
  "improvement_candidate",
  "推理/思维链基本要求",
  "推荐项",
  "推荐组合",
  "pre_record_basis",
  "post_record_verification",
  "architecture_boundary",
  "规则包、私有交付物、索引",
  "references/handoff-protocol.md",
  "references/deliverable-schema.md",
  "references/eval-prompts.md"
])
handoff_interface_body = File.read(handoff_interface)
require_phrases(handoff_interface, handoff_interface_body, [
  "enum",
  "end_signal",
  "host_event_evidence",
  "authorization_scope",
  "decision_envelope",
  "artifacts",
  "primary_action",
  "secondary_actions"
])
schema_body = File.read(handoff_schema)
require_phrases(handoff_schema, schema_body, [
  "session_role",
  "parent_session_id",
  "agent_id",
  "full_content_authorized",
  "attachments_authorized",
  "ISON",
  "record_type",
  "authorization",
  "verified_host_session_end",
  "non-sensitive short label | redacted",
  "native_tool_candidate",
  "native_tool_status",
  "capability_evidence",
  "primary_action",
  "secondary_actions",
  "host_event_evidence",
  "reasoning_gate",
  "decision_options",
  "architecture_boundary",
  "pre_record_basis",
  "post_record_verification",
  "index_update_state",
  "index_paths",
  "attachment_refs",
  "decision_envelope",
  "artifacts",
  "rnd_pre_record",
  "rnd_post_record"
])
eval_body = File.read(handoff_eval)
require_phrases(handoff_eval, eval_body, [
  "明确换会话",
  "子 Agent 记录",
  "摘要需授权",
  "交互工具优先",
  "普通进度汇报",
  "真实会话正常结束",
  "宿主事件未验证",
  "结束证据未知",
  "恢复后抽查",
  "压缩治理",
  "普通对话收尾",
  "区分对话与会话",
  "具体开场白写成通用模板",
  "研发交付物写入公开文档",
  "上游规则过宽",
  "upstream_unconditional_policy",
  "authorized_generic_template",
  "不可观测百分比",
  "未经授权保存原文附件",
  "native_tool",
  "ClarificationRequest",
  "真实调用返回拒绝",
  "研发记录前后状态与解耦",
  "HND-EVAL-017",
  "HND-EVAL-018",
  "HND-EVAL-019",
  "HND-EVAL-020",
  "HND-EVAL-021",
  "HND-EVAL-022",
  "HND-EVAL-023",
  "HND-EVAL-024",
  "结构化回归夹具",
  "expected_action",
  "must_include",
  "must_not_include",
  "index_update_state: skipped_no_hook",
  "推理/思维链基本要求",
  "推荐标识",
  "pre_record_basis",
  "post_record_verification"
])
raise "#{handoff}: execution history must not remain in skill package" if Dir.exist?(File.join(handoff, "memory"))

security_interface_path = "skills/security-penetration-kelen/agents/interface.yaml"
security_interface = load_yaml(security_interface_path)
raise "#{security_interface_path}: only Read should be required" unless security_interface.fetch("tools_required", []) == ["Read"]
security_optional_tools = security_interface.fetch("tools_optional", [])
["Shell", "Grep", "Glob", "LS"].each do |tool|
  raise "#{security_interface_path}: missing optional tool #{tool}" unless security_optional_tools.include?(tool)
end
security_constraints = security_interface.fetch("constraints").join("\n")
require_phrases(security_interface_path, security_constraints, [
  "ClarificationRequest",
  "证据不足时不得伪造 CVSS 精确评分"
])
