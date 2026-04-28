---
description: 子规则 - Factory Droid 环境适配案例
parentRule: SKILL.md
---

# Factory Droid 环境适配

## 识别

- AI 工具：Factory Droid CLI
- Skill 格式：droid YAML（`.md` 文件 + YAML frontmatter）
- Droid 目录：`~/.factory/droids/<name>.md`

## 同步机制

Factory Droid 的 droid 格式与 SKILL.md 不完全一致，需要格式转换：

**方案 A：软链接 skills 目录（推荐）**

Factory 支持读取 `~/.factory/skills/` 下的 SKILL.md 文件，可直接软链接：

```bash
ln -s ~/.claude/skills ~/.factory/skills
```

**方案 B：同步脚本（如软链接不生效）**

创建 `factory_sync_daemon.py`，在 SessionStart 时运行：
1. rsync `~/.claude/scripts/` → `~/.factory/scripts/`（带路径适配）
2. 验证 `~/.factory/rules/` 下的软链接有效性
3. 仅在内容变更时同步（checksum 对比）

**路径适配规则**：
- `CLAUDE.md` → `AGENTS.md`
- `.claude/cache` → `.factory/cache`
- `.claude/` → `.factory/`

## 自愈机制

与 Claude Code 类似，但 Factory 侧不需要重复自愈逻辑：
- 若 `~/.factory/skills` 是软链接，自愈由 Claude 侧负责
- 若使用同步脚本，自愈由同步脚本的 SessionStart hook 负责

## 注意事项

- Factory 的 rules 系统（`~/.factory/rules/`）与 Claude Code 的规则系统加载机制不同
- 需要验证 rules 中的软链接指向仍有效
- SessionStart hook 支持 matcher：startup / resume / compact / clear
