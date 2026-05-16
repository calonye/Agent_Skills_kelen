#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL="$ROOT/skills/security-penetration-kelen"

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
[ -f "$SKILL/references/eval-prompts.md" ] || fail "missing references/eval-prompts.md"

ruby - <<'RUBY' "$SKILL"
require "yaml"
skill = ARGV.fetch(0)
body = File.read(File.join(skill, "SKILL.md"))
frontmatter = body[/\A---\n(.*?)\n---/m, 1]
raise "missing SKILL.md frontmatter" unless frontmatter
YAML.safe_load(frontmatter, permitted_classes: [], aliases: false)
YAML.safe_load(File.read(File.join(skill, "agents/interface.yaml")), permitted_classes: [], aliases: false)

refs = body.scan(/`(references\/[^`]+)`/).flatten.uniq
missing = refs.reject { |ref| File.exist?(File.join(skill, ref)) }
raise "missing refs: #{missing.join(", ")}" unless missing.empty?

interface = YAML.safe_load(File.read(File.join(skill, "agents/interface.yaml")), permitted_classes: [], aliases: false)
scope = interface.fetch("inputs").find { |item| item["name"] == "scope" }
raise "missing scope input" unless scope
raise "scope.default must be passive" unless scope["default"] == "passive"
RUBY

rg -n "上下文覆写|自动放行|核心绕过|实际执行绕过|不施加道德|AI 不承担|真实第三方目标的攻击手册" "$SKILL" && fail "dangerous wording found"
rg -n "(api_key|apikey|secret|password|passwd)\s*=\s*[\"'][^\"']{8,}[\"']|BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY|ghp_[A-Za-z0-9_]{20,}|github_pat_[A-Za-z0-9_]{20,}|sk-[A-Za-z0-9_-]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|xox[baprs]-[A-Za-z0-9_-]{20,}" "$SKILL" && fail "secret-like content found"

for phrase in "已授权" "待确认" "阻断" "L0" "L1" "L2" "L3" "L4" "防御闭环" "Forensics"; do
  rg -n "$phrase" "$SKILL" >/dev/null || fail "missing required phrase: $phrase"
done

echo "security-penetration-kelen validation passed"
