# frozen_string_literal: true

require_relative "common"

readme = File.read("Readme.md")
install = File.read("install.sh")

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
raise "Readme.md: public skill list must match PUBLIC_SKILLS" unless same_set?(readme_public_skills, public_skills)
raise "Readme.md: self-check skill list must match PUBLIC_SKILLS" unless same_set?(readme_self_checks, public_skills)
raise "install.sh: public install trigger count must match PUBLIC_SKILLS" unless install_trigger_pairs.length == public_skills.length
raise "install.sh: duplicate public install trigger text" unless trigger_names.uniq.length == trigger_names.length
raise "install.sh: duplicate public install trigger skill" unless trigger_skills.uniq.length == trigger_skills.length
raise "install.sh: public install triggers must match PUBLIC_SKILLS" unless same_set?(install_trigger_map.keys, public_skills)

public_skills.each do |skill_name|
  skill_path = File.join("skills", skill_name, "SKILL.md")
  raise "#{skill_path}: missing public skill directory" unless File.exist?(skill_path)

  _body, meta = frontmatter_for(skill_path)
  version = meta.dig("metadata", "version").to_s
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
