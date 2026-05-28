#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

bash -n install.sh
bash -n scripts/validate-dialectical-self-review.sh
bash -n scripts/validate-security-penetration.sh

bash scripts/validate-dialectical-self-review.sh
bash scripts/validate-security-penetration.sh

ruby - <<'RUBY'
require "yaml"

Dir["skills/*/SKILL.md"].each do |file|
  skill = File.dirname(file)
  expected_name = File.basename(skill)
  body = File.read(file)

  frontmatter = body[/\A---\n(.*?)\n---/m, 1]
  raise "missing frontmatter: #{file}" unless frontmatter
  meta = YAML.safe_load(frontmatter, permitted_classes: [], aliases: false)
  raise "#{file}: name must match directory" unless meta["name"] == expected_name
  raise "#{file}: missing description" unless meta["description"].to_s.strip != ""
  raise "#{file}: missing metadata.author" unless meta.dig("metadata", "author").to_s.strip != ""
  raise "#{file}: missing metadata.version" unless meta.dig("metadata", "version").to_s.strip != ""
end

Dir["skills/*/agents/interface.yaml"].each do |file|
  skill = File.dirname(File.dirname(file))
  expected_name = File.basename(skill)
  interface = YAML.safe_load(File.read(file), permitted_classes: [], aliases: false)
  raise "#{file}: name must match directory" unless interface["name"] == expected_name
  required_tools = Array(interface["tools_required"]).map(&:to_s)
  optional_tools = Array(interface["tools_optional"]).map(&:to_s)
  required_text = required_tools.join("\n")
  optional_text = optional_tools.join("\n")
  [
    "AskUserQuestion",
    "request_user_input",
    "Agent-assisted review",
    "Parallel review"
  ].each do |tool|
    raise "#{file}: #{tool} must not be required" if required_text.include?(tool)
  end
  if (required_text.include?("AskUserQuestion") || optional_text.include?("AskUserQuestion")) &&
      !Array(interface["constraints"]).join("\n").include?("硬依赖")
    raise "#{file}: clarification tool must declare non-hard-dependency constraint"
  end
end

Dir["skills/*/{SKILL.md,references/**/*.md}"].each do |file|
  skill = File.dirname(file)
  skill = file[%r{\Askills/[^/]+}]
  body = File.read(file)
  refs = body.scan(/`(references\/[^`]+)`/).flatten.uniq
  missing = refs.reject { |ref| File.exist?(File.join(skill, ref)) }
  raise "#{skill}: missing refs: #{missing.join(", ")}" unless missing.empty?
end

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
  unless system("git", "ls-files", "--error-unmatch", file, out: File::NULL, err: File::NULL)
    raise "#{file}: must be tracked because SKILL.md and validation gates depend on it"
  end
end
raise "#{skill_file}: exceeds 500 lines" if body.lines.count > 500
raise "#{skill_file}: markdown table found" if body.match?(/^\|.*\|$/)
raise "#{skill_file}: repeated blank lines found" if body.match?(/\n{3,}/)
[
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
].each do |phrase|
  raise "#{skill_file}: missing #{phrase}" unless body.include?(phrase)
end

interface = YAML.safe_load(File.read(File.join(self_evolution, "agents/interface.yaml")), permitted_classes: [], aliases: false)
constraints = interface.fetch("constraints").join("\n")
[
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
].each do |phrase|
  raise "#{self_evolution}/agents/interface.yaml: missing #{phrase}" unless constraints.include?(phrase)
end
self_evolution_required_tools = interface.fetch("tools_required", [])
raise "#{self_evolution}/agents/interface.yaml: only Read should be required" unless self_evolution_required_tools == ["Read"]
self_evolution_optional_tools = interface.fetch("tools_optional", [])
["Create", "Edit", "Execute", "LS", "Grep", "Glob"].each do |tool|
  raise "#{self_evolution}/agents/interface.yaml: missing optional tool #{tool}" unless self_evolution_optional_tools.include?(tool)
end
trigger_matrix = File.join(self_evolution, "references/trigger-coverage-matrix.md")
trigger_matrix_body = File.read(trigger_matrix)
[
  "用户自然口语",
  "AI 推理触发",
  "发现层关键词",
  "误触发边界",
  "正例",
  "近邻例",
  "负例",
  "AI 自触发例"
].each do |phrase|
  raise "#{trigger_matrix}: missing #{phrase}" unless trigger_matrix_body.include?(phrase)
end
capability_equivalence = File.join(self_evolution, "references/capability-equivalence-protocol.md")
raise "#{capability_equivalence}: missing" unless File.exist?(capability_equivalence)
capability_equivalence_body = File.read(capability_equivalence)
[
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
].each do |phrase|
  raise "#{capability_equivalence}: missing #{phrase}" unless capability_equivalence_body.include?(phrase)
end
[
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
].each do |phrase|
  raise "#{skill_file}: missing self-evolution trigger #{phrase}" unless body.include?(phrase)
end
[
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
].each do |phrase|
  raise "#{skill_file}: missing self-application phrase #{phrase}" unless body.include?(phrase)
end
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
[
  "记住这个方法",
  "当前对话形成了可复用判断框架",
  "Skill 生命周期进化引擎",
  "创建、设计、维护、迭代、改进、自我进化或进化 skill",
  "思辨/澄清/调研前置协议",
  "触发覆盖验证",
  "改进或迭代已有 skill"
].each do |phrase|
  raise "#{self_evolution}/agents/interface.yaml: missing route phrase #{phrase}" unless File.read(File.join(self_evolution, "agents/interface.yaml")).include?(phrase)
end
[
  "把这个流程沉淀下来，下次别再从头想一遍",
  "审查这个 skill 有没有达到原本设计目的",
  "如果融合了某流程，就应该能替代它的效果",
  "帮我创建一个普通 skill",
  "整理会议纪要",
  "复杂任务完成后准备收工"
].each do |phrase|
  raise "#{trigger_matrix}: missing trigger eval phrase #{phrase}" unless trigger_matrix_body.include?(phrase)
end
self_evolution_eval = File.join(self_evolution, "references/eval-prompts.md")
self_evolution_eval_body = File.read(self_evolution_eval)
[
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
].each do |phrase|
  raise "#{self_evolution_eval}: missing #{phrase}" unless self_evolution_eval_body.include?(phrase)
end
host_interaction = File.join(self_evolution, "references/host-interaction-adaptation.md")
raise "#{host_interaction}: missing" unless File.exist?(host_interaction)
host_interaction_body = File.read(host_interaction)
[
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
].each do |phrase|
  raise "#{host_interaction}: missing #{phrase}" unless host_interaction_body.include?(phrase)
end
[
  [skill_file, body],
  [File.join(self_evolution, "agents/interface.yaml"), File.read(File.join(self_evolution, "agents/interface.yaml"))],
  [File.join(self_evolution, "references/skill-design-principles.md"), File.read(File.join(self_evolution, "references/skill-design-principles.md"))]
].each do |file, file_body|
  [
    "交互",
    "实际调用",
    "自动",
    "私有"
  ].each do |phrase|
    raise "#{file}: missing generation gate #{phrase}" unless file_body.include?(phrase)
  end
end
design_principles = File.join(self_evolution, "references/skill-design-principles.md")
design_principles_body = File.read(design_principles)
[
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
].each do |phrase|
  raise "#{design_principles}: missing design principle phrase #{phrase}" unless design_principles_body.include?(phrase)
end
[
  "name: <skill-name>-kelen",
  "<skill-name>-kelen/"
].each do |term|
  raise "#{design_principles}: hardcoded repo suffix in generic template: #{term}" if design_principles_body.include?(term)
end

successor = "skills/adversarial-successor-audit-kelen"
successor_skill = File.join(successor, "SKILL.md")
successor_body = File.read(successor_skill)
successor_protocol = File.join(successor, "references/multi-perspective-protocol.md")
successor_protocol_body = File.read(successor_protocol)
[
  "multi_perspective",
  "多视角接替审计",
  "成立",
  "修正",
  "推翻",
  "交叉合并",
  "残余风险",
  "references/multi-perspective-protocol.md",
  "references/eval-prompts.md"
].each do |phrase|
  raise "#{successor_skill}: missing #{phrase}" unless successor_body.include?(phrase)
end
raise "#{successor_protocol}: missing" unless File.exist?(successor_protocol)
successor_eval = File.join(successor, "references/eval-prompts.md")
raise "#{successor_eval}: missing" unless File.exist?(successor_eval)
successor_eval_body = File.read(successor_eval)
[
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
].each do |phrase|
  raise "#{successor_eval}: missing #{phrase}" unless successor_eval_body.include?(phrase)
end
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
[
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
].each do |phrase|
  raise "#{successor_protocol}: missing #{phrase}" unless successor_protocol_body.include?(phrase)
end
successor_interface = YAML.safe_load(File.read(File.join(successor, "agents/interface.yaml")), permitted_classes: [], aliases: false)
successor_constraints = successor_interface.fetch("constraints").join("\n")
[
  "多视角模式仍是只读审计",
  "不要求真实多 agent",
  "无法复验项标为待确认",
  "成立 / 修正 / 推翻",
  "不得给出可交付结论",
  "待确认只是证据状态",
  "execution_strategy",
  "修复闭环"
].each do |phrase|
  raise "#{successor}/agents/interface.yaml: missing #{phrase}" unless successor_constraints.include?(phrase)
end
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
successor_forbidden_content = /
  100%|
  完全可用|
  绝对无风险|
  前任|
  洁癖|
  强迫症|
  研发来源|
  来源链路|
  灵感来源|
  设计来源|
  具体外部规范名
/x
[
  successor_skill,
  successor_protocol,
  File.join(successor, "agents/interface.yaml")
].each do |file|
  raise "#{file}: successor content hygiene term found" if File.read(file).match?(successor_forbidden_content)
end

brainstorming = "skills/brainstorming-kelen"
brainstorming_skill = File.join(brainstorming, "SKILL.md")
brainstorming_body = File.read(brainstorming_skill)
[
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
].each do |phrase|
  raise "#{brainstorming_skill}: missing #{phrase}" unless brainstorming_body.include?(phrase)
end
brainstorming_protocol = File.join(brainstorming, "references/brainstorming-protocol.md")
brainstorming_protocol_body = File.read(brainstorming_protocol)
[
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
].each do |phrase|
  raise "#{brainstorming_protocol}: missing #{phrase}" unless brainstorming_protocol_body.include?(phrase)
end
brainstorming_interface = YAML.safe_load(File.read(File.join(brainstorming, "agents/interface.yaml")), permitted_classes: [], aliases: false)
brainstorming_constraints = brainstorming_interface.fetch("constraints").join("\n")
[
  "不修改任何文件",
  "不执行实现",
  "不要求真实多 agent",
  "AskUserQuestion 不作为硬依赖",
  "常规 0-3 问",
  "最多 6 问",
  "multi_select",
  "P1/P2 未知必须进入延后确认队列",
  "待确认只是证据状态"
].each do |phrase|
  raise "#{brainstorming}/agents/interface.yaml: missing #{phrase}" unless brainstorming_constraints.include?(phrase)
end
brainstorming_required_tools = brainstorming_interface.fetch("tools_required", [])
raise "#{brainstorming}/agents/interface.yaml: AskUserQuestion must not be required" if brainstorming_required_tools.any? { |tool| tool.to_s.include?("AskUserQuestion") || tool.to_s.include?("request_user_input") }
brainstorming_forbidden_content = /
  100%|
  完全可用|
  绝对无风险|
  必然成功|
  来源于|
  灵感来自|
  某次对话|
  私有路径示例|
  具体外部规范名|
  skill-creator|
  yao-meta-skill|
  ModuleDesign|
  DocumentManagementStandard|
  AI Agent 规则孵化工厂|
  Claude|
  Factory|
  Cursor|
  \/Users\/|
  \/home\/
/x
Dir["#{brainstorming}/**/*.{md,yaml}"].each do |file|
  raise "#{file}: brainstorming content hygiene term found" if File.read(file).match?(brainstorming_forbidden_content)
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
  body = File.read(file)
  raise "#{file}: missing native interaction invocation rule" unless body.include?("实际调用")
  raise "#{file}: missing native interaction state" unless body.include?("native_tool")
  raise "#{file}: missing text fallback state" unless body.include?("text_fallback")
end

handoff = "skills/session-handoff-kelen"
handoff_skill = File.join(handoff, "SKILL.md")
raise "#{handoff_skill}: missing" unless File.exist?(handoff_skill)
handoff_body = File.read(handoff_skill)
handoff_interface = File.join(handoff, "agents/interface.yaml")
handoff_protocol = File.join(handoff, "references/handoff-protocol.md")
handoff_schema = File.join(handoff, "references/deliverable-schema.md")
handoff_eval = File.join(handoff, "references/eval-prompts.md")
[
  handoff_interface,
  handoff_protocol,
  handoff_schema,
  handoff_eval
].each do |file|
  raise "#{file}: missing" unless File.exist?(file)
end
[
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
  "invocation_source",
  "不能仅凭安装状态宣称成功",
  "证据未知时不得创建结束日志",
  "恢复读取与证据抽查",
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
].each do |phrase|
  raise "#{handoff_skill}: missing #{phrase}" unless handoff_body.include?(phrase)
end
schema_body = File.read(handoff_schema)
[
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
  "reasoning_gate",
  "decision_options",
  "architecture_boundary",
  "pre_record_basis",
  "post_record_verification"
].each do |phrase|
  raise "#{handoff_schema}: missing #{phrase}" unless schema_body.include?(phrase)
end
eval_body = File.read(handoff_eval)
[
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
  "推理/思维链基本要求",
  "推荐标识",
  "pre_record_basis",
  "post_record_verification"
].each do |phrase|
  raise "#{handoff_eval}: missing #{phrase}" unless eval_body.include?(phrase)
end
raise "#{handoff}: execution history must not remain in skill package" if Dir.exist?(File.join(handoff, "memory"))
readme = File.read("Readme.md")
install = File.read("install.sh")
same_set = ->(left, right) { left.sort == right.sort }
[
  "--exclude='.DS_Store'",
  "--exclude='._*'",
  "--exclude='update.sh'"
].each do |phrase|
  raise "install.sh: missing rsync exclude #{phrase}" unless install.include?(phrase)
end
public_skills = install[/^PUBLIC_SKILLS="\$\{PUBLIC_SKILLS:-(.*?)\}"/, 1].to_s.split
raise "install.sh: incubating handoff skill must not be public by default" if public_skills.include?("session-handoff-kelen")
readme_public_skills = readme.scan(/^- \[([^\]]+)\]\(\.\/skills\/\1\/\) v[0-9]+\.[0-9]+\.[0-9]+/).flatten
readme_self_checks = readme.scan(%r{^ls ~/.claude/skills/([^\s]+)}).flatten
install_trigger_pairs = install.scan(/echo "  - 「(.+?)」→ ([^"]+)"/)
trigger_names = install_trigger_pairs.map(&:first)
trigger_skills = install_trigger_pairs.map(&:last)
install_trigger_map = install_trigger_pairs.to_h { |trigger, skill_name| [skill_name, trigger] }

# Public entry invariants: install allowlist, README list, README self-checks,
# and install test triggers must describe the same public skill set.
raise "Readme.md: public skill list must match PUBLIC_SKILLS" unless same_set.call(readme_public_skills, public_skills)
raise "Readme.md: self-check skill list must match PUBLIC_SKILLS" unless same_set.call(readme_self_checks, public_skills)
raise "install.sh: public install trigger count must match PUBLIC_SKILLS" unless install_trigger_pairs.length == public_skills.length
raise "install.sh: duplicate public install trigger text" unless trigger_names.uniq.length == trigger_names.length
raise "install.sh: duplicate public install trigger skill" unless trigger_skills.uniq.length == trigger_skills.length
raise "install.sh: public install triggers must match PUBLIC_SKILLS" unless same_set.call(install_trigger_map.keys, public_skills)

public_skills.each do |skill_name|
  skill_path = File.join("skills", skill_name, "SKILL.md")
  raise "#{skill_path}: missing public skill directory" unless File.exist?(skill_path)
  frontmatter = File.read(skill_path)[/\A---\n(.*?)\n---/m, 1]
  version = YAML.safe_load(frontmatter, permitted_classes: [], aliases: false).dig("metadata", "version").to_s
  raise "Readme.md: missing public skill #{skill_name}" unless readme.include?(skill_name)
  raise "Readme.md: version mismatch for #{skill_name}" unless readme.include?("[#{skill_name}](./skills/#{skill_name}/) v#{version}")
  raise "Readme.md: missing self-check for #{skill_name}" unless readme.include?("ls ~/.claude/skills/#{skill_name}")
  trigger = install_trigger_map.fetch(skill_name)
  raise "#{skill_path}: missing install trigger #{trigger}" unless File.read(skill_path).include?(trigger)
end
tracked_skill_files = `git ls-files 'skills/*/SKILL.md'`.lines.map(&:strip)
tracked_skill_names = tracked_skill_files.map { |path| path.split("/")[1] }
incubating_tracked_skills = tracked_skill_names - public_skills
unless incubating_tracked_skills.empty?
  raise "Readme.md: missing public allowlist boundary for tracked incubating skills" unless readme.include?("默认公开 skill 以 `install.sh` 的 `PUBLIC_SKILLS` 白名单")
  incubating_tracked_skills.each do |skill_name|
    raise "Readme.md: incubating skill must not appear in public skill list: #{skill_name}" if readme.include?("[#{skill_name}](./skills/#{skill_name}/)")
    raise "install.sh: incubating skill must not appear in install test triggers: #{skill_name}" if install.include?("→ #{skill_name}")
  end
end
[
  "使用当前仓库，跳过拉取",
  "git -C \"$INSTALL_DIR\" pull --ff-only"
].each do |phrase|
  raise "install.sh: missing install source handling #{phrase}" unless install.include?(phrase)
end
[
  "trigger-coverage-matrix",
  "capability-equivalence-protocol",
  "host-interaction-adaptation"
].each do |phrase|
  raise "Readme.md: missing self-evolution reference entry #{phrase}" unless readme.include?(phrase)
end

natural_trigger_checks = {
  "skills/adversarial-successor-audit-kelen/SKILL.md" => [
    "别人接手会不会懵",
    "README 够不够清楚",
    "从零跑一遍看看"
  ],
  "skills/brainstorming-kelen/SKILL.md" => [
    "这个怎么做比较好",
    "我还没想清楚，帮我理一下",
    "给我几个方案"
  ],
  "skills/dialectical-self-review-kelen/SKILL.md" => [
    "这样靠谱吗",
    "会不会翻车",
    "先帮我挑这个方案的毛病"
  ],
  "skills/skill-self-evolution-kelen/SKILL.md" => [
    "帮我设计一个 skill",
    "帮我创建一个普通 skill",
    "这个 skill 要怎么继续迭代",
    "记住这个方法",
    "这个以后常用",
    "沉淀成规则",
    "不想让这次白费",
    "审查这个 skill 有没有达到目的",
    "前面改的 skill 是否真的落实了"
  ],
  "skills/security-penetration-kelen/SKILL.md" => [
    "看看有没有安全隐患",
    "权限有没有问题",
    "能不能越权"
  ]
}
natural_trigger_checks.each do |file, phrases|
  file_body = File.read(file)
  phrases.each do |phrase|
    raise "#{file}: missing natural trigger #{phrase}" unless file_body.include?(phrase)
    raise "Readme.md: missing natural trigger #{phrase}" unless readme.include?(phrase)
  end
end
[
  "只审交付/接手路径",
  "先别写代码，给我几个方案",
  "先帮我挑这个方案的毛病",
  "不用于普通偏好记忆",
  "必须有授权、自有或本地靶场边界"
].each do |phrase|
  raise "Readme.md: missing trigger boundary #{phrase}" unless readme.include?(phrase)
end

security_interface = YAML.safe_load(File.read("skills/security-penetration-kelen/agents/interface.yaml"), permitted_classes: [], aliases: false)
raise "skills/security-penetration-kelen/agents/interface.yaml: only Read should be required" unless security_interface.fetch("tools_required", []) == ["Read"]
security_optional_tools = security_interface.fetch("tools_optional", [])
["Shell", "Grep", "Glob", "LS"].each do |tool|
  raise "skills/security-penetration-kelen/agents/interface.yaml: missing optional tool #{tool}" unless security_optional_tools.include?(tool)
end
security_constraints = security_interface.fetch("constraints").join("\n")
[
  "ClarificationRequest",
  "证据不足时不得伪造 CVSS 精确评分"
].each do |phrase|
  raise "skills/security-penetration-kelen/agents/interface.yaml: missing #{phrase}" unless security_constraints.include?(phrase)
end

forbidden_skill_terms = /
  skill-creator|
  yao-meta-skill|
  ModuleDesign|
  DocumentManagementStandard|
  AI Agent 规则孵化工厂|
  Claude 侧维护|
  Factory 侧维护|
  Cursor 侧维护|
  灵感来源链路|
  设计来源|
  具体外部规范名
/x
Dir["skills/**/*.{md,yaml}"].each do |file|
  body = File.read(file)
  raise "#{file}: research provenance term found" if body.match?(forbidden_skill_terms)
end
RUBY

rg -n "env-sync-maintainer-kelen|同步一下配置|两边不一样了|修复 skill 列表" \
  Readme.md install.sh skills/security-penetration-kelen/SKILL.md >/dev/null && \
  fail "incubating env-sync public reference found"

if rg -n "Claude Code|Factory Droid|Cursor|~/.claude|~/.factory|~/.cursor|CLAUDE\\.md|AGENTS\\.md|\\.factory|\\.ai-local" \
  skills --glob '!skills/env-sync-maintainer-kelen/references/adapters/**' >/dev/null; then
  fail "runtime-specific or host-entry terms found outside adapter references"
fi

git diff --check

echo "all validations passed"
