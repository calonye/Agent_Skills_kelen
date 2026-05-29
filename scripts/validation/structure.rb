# frozen_string_literal: true

require_relative "common"

Dir["skills/*/SKILL.md"].each do |file|
  skill = File.dirname(file)
  expected_name = File.basename(skill)
  _body, meta = frontmatter_for(file)
  raise "#{file}: name must match directory" unless meta["name"] == expected_name
  raise "#{file}: missing description" unless meta["description"].to_s.strip != ""
  raise "#{file}: missing metadata.author" unless meta.dig("metadata", "author").to_s.strip != ""
  raise "#{file}: missing metadata.version" unless meta.dig("metadata", "version").to_s.strip != ""
end

Dir["skills/*/agents/interface.yaml"].each do |file|
  skill = File.dirname(File.dirname(file))
  expected_name = File.basename(skill)
  interface = load_yaml(file)
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
  skill = file[%r{\Askills/[^/]+}]
  body = File.read(file)
  refs = body.scan(/`(references\/[^`]+)`/).flatten.uniq
  missing = refs.reject { |ref| File.exist?(File.join(skill, ref)) }
  raise "#{skill}: missing refs: #{missing.join(", ")}" unless missing.empty?
end
