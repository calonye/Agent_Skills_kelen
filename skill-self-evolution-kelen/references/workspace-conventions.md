# 工作空间目录规范 / Workspace Conventions

> 基于 DocumentManagementStandard 的 skill 工作空间约定。

## 工作空间结构

```
Agent_Skills_kelen/                  # 工作空间根目录
├── Readme.md                        # 工作空间说明 + 版本记录
├── Docs/                            # 工作空间级文档
│   └── 开发指导规范.md               # skill 开发约定
├── <skill-name>/                    # 每个 skill 一个目录
│   ├── SKILL.md                     # 主文件（路由 + 流程骨架）
│   ├── agents/
│   │   └── interface.yaml           # 接口声明
│   ├── references/                  # 详解、判据、案例
│   └── update.sh                    # 同步到 ~/.claude/skills/
└── ...
```

## 命名规范

- Skill 目录名：kebab-case（如 `skill-self-evolution`）
- SKILL.md 的 `name` 字段与目录名一致
- references 文件名：kebab-case + `.md`

## 部署规范

每个 skill 的 `update.sh` 模板：

```bash
#!/bin/bash
REPO_PATH="$HOME/Agent_Skills_kelen"
SKILL_NAME="<skill-name>"
DST="$HOME/.claude/skills/$SKILL_NAME"

if [ ! -d "$REPO_PATH/$SKILL_NAME" ]; then
  echo "源目录不存在: $REPO_PATH/$SKILL_NAME"
  exit 1
fi

mkdir -p "$DST"
rsync -av --exclude='update.sh' "$REPO_PATH/$SKILL_NAME/" "$DST/"
echo "$SKILL_NAME 已更新"
```

注意：`~/.claude/skills/<skill-name>/update.sh` 是部署端的副本，内容相同但不被 rsync 覆盖（`--exclude='update.sh'`）。

## Readme.md 更新规则

每次新增或迭代 skill 时：
1. 在目录结构部分加入新 skill 条目
2. 在版本部分加入变更记录
