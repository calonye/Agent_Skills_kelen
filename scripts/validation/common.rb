# frozen_string_literal: true

require "yaml"
require "English"

ROOT = File.expand_path("../..", __dir__)
Dir.chdir(ROOT)

def load_yaml(path)
  YAML.safe_load(File.read(path), permitted_classes: [], aliases: false)
end

def frontmatter_for(path)
  body = File.read(path)
  frontmatter = body[/\A---\n(.*?)\n---/m, 1]
  raise "missing frontmatter: #{path}" unless frontmatter

  [body, YAML.safe_load(frontmatter, permitted_classes: [], aliases: false)]
end

def require_files(paths)
  paths.each do |path|
    raise "#{path}: missing" unless File.exist?(path)
  end
end

def require_phrases(path, body, phrases, label: nil)
  phrases.each do |phrase|
    message = label ? "#{path}: missing #{label} #{phrase}" : "#{path}: missing #{phrase}"
    raise message unless body.include?(phrase)
  end
end

def forbid_phrases(path, body, phrases, label:)
  phrases.each do |phrase|
    raise "#{path}: #{label}: #{phrase}" if body.include?(phrase)
  end
end

def same_set?(left, right)
  left.sort == right.sort
end

def tracked_file?(path)
  system("git", "ls-files", "--error-unmatch", path, out: File::NULL, err: File::NULL)
end

def rg_matches?(*args)
  system("rg", *args, out: File::NULL)
  status = $CHILD_STATUS&.exitstatus
  return true if status == 0
  return false if status == 1

  raise "rg failed: rg #{args.join(' ')}"
end
