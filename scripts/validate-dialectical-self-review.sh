#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL="$ROOT/skills/dialectical-self-review-kelen"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

need() {
  command -v "$1" >/dev/null 2>&1 || fail "missing command: $1"
}

need rg
need ruby

[ -f "$SKILL/SKILL.md" ] || fail "missing SKILL.md"
[ -f "$SKILL/agents/interface.yaml" ] || fail "missing agents/interface.yaml"
[ -f "$SKILL/references/known-blindspots.md" ] || fail "missing references/known-blindspots.md"
[ -f "$SKILL/references/eval-prompts.md" ] || fail "missing references/eval-prompts.md"
[ -f "$SKILL/references/agent-assisted-review.md" ] || fail "missing references/agent-assisted-review.md"

ruby - <<'RUBY' "$SKILL"
require "yaml"
skill = ARGV.fetch(0)
body = File.read(File.join(skill, "SKILL.md"))
frontmatter = body[/\A---\n(.*?)\n---/m, 1]
raise "missing SKILL.md frontmatter" unless frontmatter
meta = YAML.safe_load(frontmatter, permitted_classes: [], aliases: false)
raise "metadata.version must be 0.3.0" unless meta.dig("metadata", "version") == "0.3.0"

interface = YAML.safe_load(File.read(File.join(skill, "agents/interface.yaml")), permitted_classes: [], aliases: false)
mode = interface.fetch("inputs").find { |item| item["name"] == "mode" }
raise "missing mode input" unless mode
raise "mode.default must be self" unless mode["default"] == "self"
budget = interface.fetch("inputs").find { |item| item["name"] == "question_budget" }
raise "missing question_budget input" unless budget
default_budget = budget.fetch("default")
raise "question_budget.max_requests_per_turn must be 1" unless default_budget["max_requests_per_turn"] == 1
raise "question_budget.max_questions_per_request must be 6" unless default_budget["max_questions_per_request"] == 6
raise "question_budget.requires_stop_after_request must be true" unless default_budget["requires_stop_after_request"] == true
clarification_budget = interface.fetch("outputs").find { |item| item["name"] == "clarification_budget" }
raise "missing clarification_budget output" unless clarification_budget

refs = body.scan(/`(references\/[^`]+)`/).flatten.uniq
missing = refs.reject { |ref| File.exist?(File.join(skill, ref)) }
raise "missing refs: #{missing.join(", ")}" unless missing.empty?

required_refs = %w[
  references/dialectic-protocol.md
  references/first-principles.md
  references/known-blindspots.md
  references/eval-prompts.md
  references/agent-assisted-review.md
  references/examples.md
]
missing_required = required_refs - refs
raise "SKILL.md does not reference: #{missing_required.join(", ")}" unless missing_required.empty?
RUBY

for phrase in "证据三值" "反事实" "Agent-assisted" "known-blindspots" "brainstorming" "security-penetration-kelen" "AskUserQuestion" "ClarificationRequest" "question_budget" "P0" "延后确认队列" "成立" "推翻" "修正"; do
  rg -n "$phrase" "$SKILL" >/dev/null || fail "missing required phrase: $phrase"
done

ruby - <<'RUBY' "$SKILL/references/eval-prompts.md"
file = ARGV.fetch(0)
body = File.read(file)
section = body[/^## Prompt \d+：AskUserQuestion.*?(?=^## Prompt |\z)/m]
raise "missing AskUserQuestion eval prompt" unless section

[
  /输入：/,
  /期望：/,
  /待确认/,
  /AskUserQuestion|ClarificationRequest/,
  /1-6|最多 6|最少澄清/,
  /每轮最多\s*1\s*次|最多\s*1\s*次澄清请求|只能出现\s*1\s*个/,
  /多选|互斥选择|短答/,
  /其他\/不确定|其他|不确定/,
  /无回答时保守路径/,
  /不凭空假设|不编造|缺失事实/
].each do |pattern|
  raise "AskUserQuestion eval missing #{pattern.inspect}" unless section.match?(pattern)
end

complex = body[/^## Prompt \d+：复杂迁移.*?(?=^## Prompt |\z)/m]
raise "missing complex migration clarification eval prompt" unless complex
[
  /P0/,
  /延后确认队列/,
  /最多提出 6 个/,
  /停止或只读/,
  /不得降级执行迁移/
].each do |pattern|
  raise "complex migration eval missing #{pattern.inspect}" unless complex.match?(pattern)
end

second = body[/^## Prompt \d+：禁止同轮二次追问.*?(?=^## Prompt |\z)/m]
raise "missing no second clarification eval prompt" unless second
[
  /最多输出 1 个/,
  /不在同一轮追加第二个澄清请求/,
  /等待用户回答/
].each do |pattern|
  raise "no second clarification eval missing #{pattern.inspect}" unless second.match?(pattern)
end

multi = body[/^## Prompt \d+：多选澄清降级.*?(?=^## Prompt |\z)/m]
raise "missing multi-select clarification fallback eval prompt" unless multi
[
  /multi_select/,
  /可多选/,
  /其他\/不确定|其他|不确定/,
  /降级为 1 个 ClarificationRequest/,
  /questions_used_this_request/
].each do |pattern|
  raise "multi-select clarification eval missing #{pattern.inspect}" unless multi.match?(pattern)
end
RUBY

rg -n '^\|.*\|$' "$SKILL" && fail "markdown table found"
rg -n "TODO|FIXME|TBD|待补|待完善" "$SKILL" && fail "unfinished marker found"
rg -n "/Users/|/private/|/var/folders/" "$SKILL" --glob '!update.sh' && fail "local absolute path found"
rg -n "(api_key|apikey|secret|password|passwd)\s*=\s*[\"'][^\"']{8,}[\"']|BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY|ghp_[A-Za-z0-9_]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|xox[baprs]-[A-Za-z0-9_-]{20,}" "$SKILL" --glob '!update.sh' && fail "secret-like content found"

echo "dialectical-self-review-kelen validation passed"
