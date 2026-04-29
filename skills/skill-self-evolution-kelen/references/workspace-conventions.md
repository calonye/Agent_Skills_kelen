---
description: 工作空间目录规范，定义仓库即根场景下的归属性质分类和目录结构
parentRule: SKILL.md
---

# 工作空间目录规范 / Workspace Conventions

> 基于 DocumentManagementStandard 的 skill 工作空间约定。
> 最后更新: 2026-04-28

## 归属性质分类（仓库即根场景）

本仓库以 Git 仓库根目录作为工作空间，文件按归属性质分为两类：
- **提交类（git tracked）**：仓库元信息 + 项目产物（skills/），随仓库流通
- **本地类（git ignored）**：Project/ 下的研发工作空间文件、部署脚本、系统文件，仅供本地使用
- 分界线是 `.gitignore`，注释中标注每条规则的归属类别

## 工作空间结构

```
Agent_Skills_kelen/                  # 仓库根目录
├── Readme.md                        # 仓库说明
├── CHANGELOG.md                     # 变更日志
├── LICENSE                          # MIT 协议
├── install.sh                       # 一键安装脚本（入库）
├── .gitignore                       # Git 忽略规则
├── skills/                          # 项目研发层：所有 skill 产物
│   └── <skill-name>-kelen/          # 每个 skill 一个目录
│       ├── SKILL.md                 # 路由 + 流程骨架
│       ├── agents/interface.yaml    # 接口声明
│       ├── references/              # 详解、判据、案例
│       └── update.sh                # 同步脚本（gitignore，本地生成）
└── Project/                         # 本地研发工作空间（gitignore，不入库）
    ├── Readme.md                    # 研发工作空间说明
    └── Docs/Steering/               # Steering 文档
        └── 开发指导规范.md
```

## 命名规范

- Skill 目录名：kebab-case + `-kelen` 后缀（如 `skill-self-evolution-kelen`）
- SKILL.md 的 `name` 字段与目录名一致
- interface.yaml 的 `name` 字段与目录名一致
- references 文件名：kebab-case + `.md`

## 部署规范

每个 skill 的 `update.sh` 模板：

```bash
#!/bin/bash
REPO_PATH="<YOUR_REPO_PATH>/skills"    # 例如: Agent_Skills_kelen 仓库下的 skills/ 目录
SKILL_NAME="<skill-name>-kelen"       # 例如: adversarial-successor-audit-kelen
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
2. 在 Readme.md 技能清单表格中加入新 skill
3. 在版本部分加入变更记录
4. 确认 `name` 字段、目录名、interface.yaml 三者一致（使用 `-kelen` 后缀）
