---
description: 子规则 - 通用环境适配模板
parentRule: SKILL.md
---

# 通用环境适配模板

适用于尚无专用适配案例的 AI 工具或自定义环境。

## 识别

使用以下检查序列确定当前环境：

1. **Skill 目录探测**：检查常见路径是否存在
   - `~/.claude/skills/` → Claude Code
   - `~/.factory/droids/` 或 `.factory/droids/` → Factory Droid
   - `~/.cursor/rules/` 或项目内 `.cursor/rules/` → Cursor
   - 自定义路径（用户指定）
2. **格式探测**：检查目录中的文件类型
   - 存在 `SKILL.md`（YAML frontmatter + Markdown） → SKILL.md 格式
   - 存在 `.md` 文件（YAML frontmatter） → droid 格式
   - 存在 `.md` 文件（纯规则） → 规则格式
3. **版本管理**：检查是否有 Git 仓库、package.json 或其他版本标识

## 同步机制模板

### 步骤 1：确定目标目录

```bash
# 由用户指定或自动探测
SKILL_DIR="${SKILL_DIR:-$HOME/.claude/skills}"
```

### 步骤 2：选择同步方式

按以下优先级选择：

1. **软链接**（若工具支持符号链接）
   - 优点：零延迟、完全同步
   - 缺点：部分工具不识别符号链接
2. **rsync 同步脚本**（推荐）
   - 优点：灵活、支持格式转换
   - 缺点：需要手动或定时触发
3. **直接复制**（兼容性兜底）
   - 优点：任何环境都能工作
   - 缺点：手动维护、易遗忘

### 步骤 3：格式适配（如需）

若目标环境不使用 SKILL.md 格式，需要转换：

- **SKILL.md → droid YAML**：提取 frontmatter 中的 name/description，将正文作为 droid 描述
- **SKILL.md → 纯规则**：去除 frontmatter，保留规则段落
- **其他格式**：根据目标工具文档适配

### 步骤 4：创建 update.sh

```bash
#!/bin/bash
REPO_PATH="<上游仓库路径>"
SKILL_NAME="<skill-name>-kelen"
DST="<目标 skill 目录>/$SKILL_NAME"
[ ! -d "$REPO_PATH/$SKILL_NAME" ] && echo "源目录不存在" && exit 1
mkdir -p "$DST"
rsync -av --exclude='update.sh' "$REPO_PATH/$SKILL_NAME/" "$DST/"
echo "$SKILL_NAME 已更新"
```

## 自愈机制模板

### 注册表自愈

不依赖手工维护的注册表，改用磁盘扫描：

```bash
#!/bin/bash
SKILLS_DIR="<目标 skill 目录>"
for skill_dir in "$SKILLS_DIR"/*/; do
  [ -f "$skill_dir/SKILL.md" ] || continue
  echo "$(basename "$skill_dir") ✓"
done
```

### 一致性检查

```bash
#!/bin/bash
# 检查 update-all.sh 是否与模板一致
EXPECTED='#!/bin/bash
SKILLS_DIR="$(cd "$(dirname "$0")" && pwd)"'
HEAD=$(head -2 "$SKILLS_DIR/update-all.sh")
[ "$HEAD" = "$EXPECTED" ] || echo "update-all.sh 需要修复"
```

## 注意事项

- 新环境适配完成后，建议提交适配案例到 `references/adapters/` 目录
- 适配脚本中使用环境变量而非硬编码路径（如 `$HOME` 代替 `/home/user`）
- 所有文件操作使用原子写入（写临时文件 + rename）
