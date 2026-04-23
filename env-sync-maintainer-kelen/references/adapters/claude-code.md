---
description: 子规则 - Claude Code 环境适配案例
parentRule: SKILL.md
---

# Claude Code 环境适配

## 识别

- AI 工具：Claude Code (Anthropic CLI)
- Skill 格式：SKILL.md（Markdown + YAML frontmatter）
- Skill 目录：`~/.claude/skills/<skill-name>/SKILL.md`

## 同步机制

Claude Code 原生支持 SKILL.md 路由匹配，直接将 skill 目录放入 `~/.claude/skills/` 即可。

**推荐方案：rsync + update.sh**

每个 skill 目录下维护一个 `update.sh`，从源仓库同步到 `~/.claude/skills/`：

```bash
#!/bin/bash
REPO_PATH="<上游仓库路径>"
SKILL_NAME="<skill-name>"
DST="$HOME/.claude/skills/$SKILL_NAME"
[ ! -d "$REPO_PATH/$SKILL_NAME" ] && echo "源目录不存在" && exit 1
mkdir -p "$DST"
rsync -av --exclude='update.sh' "$REPO_PATH/$SKILL_NAME/" "$DST/"
echo "$SKILL_NAME 已更新"
```

## 自愈机制

Claude Code 的 `update-all.sh` 应使用通配符模式：

```bash
#!/bin/bash
SKILLS_DIR="$HOME/.claude/skills"
errors=0
for update_script in "$SKILLS_DIR"/*/update.sh; do
  [ -f "$update_script" ] || continue
  skill_name=$(basename "$(dirname "$update_script")")
  bash "$update_script" > /dev/null 2>&1
  [ $? -eq 0 ] && echo "  $skill_name OK" || { echo "  $skill_name FAIL"; errors=$((errors + 1)); }
done
echo "完成 (errors: $errors)"
```

自愈检查：每次运行前验证 `update-all.sh` 内容与模板一致，不一致则原子写入修复。
