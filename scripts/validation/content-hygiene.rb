# frozen_string_literal: true

require_relative "common"

successor = "skills/adversarial-successor-audit-kelen"
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
  File.join(successor, "SKILL.md"),
  File.join(successor, "references/multi-perspective-protocol.md"),
  File.join(successor, "agents/interface.yaml")
].each do |file|
  raise "#{file}: successor content hygiene term found" if File.read(file).match?(successor_forbidden_content)
end

brainstorming = "skills/brainstorming-kelen"
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

private_runtime_record_terms = /
  \/Users\/kelen\/|
  context_deliverable_[0-9]{4}_[0-9]{2}_[0-9]{2}_session[0-9]+\.md|
  session_end_log_[0-9]{4}_[0-9]{2}_[0-9]{2}_session[0-9]+\.md|
  attachments\/session[0-9]+
/x
`git ls-files`.lines.map(&:strip).each do |file|
  next unless File.file?(file)

  raise "#{file}: private runtime record term found" if File.read(file).match?(private_runtime_record_terms)
end

if rg_matches?(
  "-n",
  "env-sync-maintainer-kelen|同步一下配置|两边不一样了|修复 skill 列表",
  "Readme.md",
  "install.sh",
  "skills/security-penetration-kelen/SKILL.md"
)
  raise "incubating env-sync public reference found"
end

if rg_matches?(
  "-n",
  "Claude Code|Factory Droid|Cursor|~/\\.claude|~/\\.factory|~/\\.cursor|CLAUDE\\.md|AGENTS\\.md|\\.factory|\\.ai-local",
  "skills",
  "--glob",
  "!skills/env-sync-maintainer-kelen/references/adapters/**"
)
  raise "runtime-specific or host-entry terms found outside adapter references"
end
