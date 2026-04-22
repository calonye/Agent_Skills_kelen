---
name: env-sync-maintainer-kelen
description: >-
  维护和同步多 AI 工具环境（如 Claude Code / Factory Droid）的配置、规则和 Skills。
  自动检测并修复「单源维护」架构下的漂移、注册表损坏和路径不一致。
  触发场景（用户口语）：
  「同步一下我的 claude 和 factory 配置」两边不一样了
  「修复一下 skill 列表」「update-all 报错了」
  「新建的 skill 怎么没有生效」
  触发场景（AI 自我思考）：
  「检测到 ~/.factory/skills 和 ~/.claude/skills 不一致」
  「update-all.sh 找不到某个 skill」
  「需要创建一个适配不同环境的同步脚本」
  关键词：环境同步、配置漂移、skill 注册、update-all 修复、单源维护。
metadata:
  author: kelen
  version: 0.1.0
---

# 环境同步维护者 / Env Sync Maintainer

确保你的 AI 工具配置在所有环境中保持一致，且永不腐烂。

**核心理念：**
- **单源维护**：`~/.claude/` 是唯一真相源（Upstream），下游通过软链接或同步脚本获取。
- **自愈机制**：`update-all.sh` 不依赖手工注册表，而是通过磁盘扫描（是否有 `update.sh`）和模板一致性检查自动修复。

## 何时使用

- 配置了多个 AI 工具（如 Claude + Factory），发现行为不一致。
- 新增或删除 Skill 后，`update-all.sh` 没有自动识别。
- `update-all.sh` 运行报错或卡住。
- 需要为新环境搭建同步机制。

## 流程

### 1. 环境诊断

先摸清当前状态：
- **上游 (Source)**: 检查 `~/.claude/skills/` 和 `~/.claude/scripts/`
- **下游 (Target)**: 检查 `~/.factory/skills` (软链接？rsync？)
- **注册表**: 检查 `update-all.sh` 的逻辑（是写死列表还是通配符？）

### 2. 搭建单源架构

如果目标环境还没有接入上游，搭建适配层：

**方案 A：软链接 (推荐)**
```bash
# 如果目标环境支持读取软链接
ln -s ~/.claude/skills ~/.factory/skills
```

**方案 B：同步脚本 (如 Factory 不支持链接)**
创建一个 `factory_sync_daemon.py`，在 SessionStart 时运行：
1. `rsync` 脚本文件
2. 适配路径（将 `.claude` 替换为 `.factory`）
3. 验证软链接有效性

详见 `references/sync-patterns.md`。

### 3. 自愈机制植入

修改 `skill_update_scheduler.py` 或 `update-all.sh` 的生成逻辑：

1. **磁盘扫描替代注册表**：不要从 `update-all.sh` 解析已注册 skill，直接扫描目录：
   ```python
   # 已注册 = 目录存在 且 update.sh 存在
   registered = {d.name for d in skills_dir.iterdir() if d.is_dir() and (d / "update.sh").exists()}
   ```

2. **一致性检查替代重建**：`update-all.sh` 内容是确定性的（通配符模式），不需要每次重建，只需检查是否与模板一致：
   ```python
   TEMPLATE = "...通配符脚本..."
   if UPDATE_SCRIPT.read_text() != TEMPLATE:
       tmp.rename(UPDATE_SCRIPT) # 原子写入修复
   ```

3. **原子写入**：所有修复操作（生成 `update.sh`、修复 `update-all.sh`）都使用 `write_to_tmp + rename`，防止进程中断导致文件损坏。

### 4. 验证与发布

- 运行 `python3 skill_update_scheduler.py`（或手动触发）
- 检查 `~/.claude/cache/skill-update-state.json`，确认 `last_status: success`
- 在两个环境中分别运行同一 Skill，确认行为一致

## 不做什么

- 不负责 Skill 内容的编写（那是 skill-creator）
- 不负责 Skill 的逻辑审查（那是 adversarial-successor-audit）
- 不修改非环境同步相关的配置文件

## 参考

- `references/sync-patterns.md` — 常见的单源维护架构模式
- `references/healing-algo.md` — 自愈算法的详细实现逻辑
