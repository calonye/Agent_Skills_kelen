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
raise "#{skill_file}: exceeds 500 lines" if body.lines.count > 500
raise "#{skill_file}: markdown table found" if body.match?(/^\|.*\|$/)
raise "#{skill_file}: repeated blank lines found" if body.match?(/\n{3,}/)
[
  "五段自我进化协议",
  "第一性原理 4 层验证",
  "呈现完整决策信息后必须等待用户回复",
  "名称一致性检查",
  "references/skill-design-principles.md",
  "references/structural-audit-methodology.md",
  "行为验证",
  "外部工具",
  "来源",
  "隐私"
].each do |phrase|
  raise "#{skill_file}: missing #{phrase}" unless body.include?(phrase)
end

interface = YAML.safe_load(File.read(File.join(self_evolution, "agents/interface.yaml")), permitted_classes: [], aliases: false)
constraints = interface.fetch("constraints").join("\n")
[
  "4 层第一性原理验证",
  "具体来源链路",
  "等待用户确认",
  "结构一致性审计",
  "最小行为验证"
].each do |phrase|
  raise "#{self_evolution}/agents/interface.yaml: missing #{phrase}" unless constraints.include?(phrase)
end

forbidden_skill_terms = /
  skill-creator|
  yao-meta-skill|
  ModuleDesign|
  DocumentManagementStandard|
  AI Agent 规则孵化工厂|
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
