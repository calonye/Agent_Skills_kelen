# 变更日志 / Changelog

本项目遵循 [语义化版本号 (SemVer)](https://semver.org/lang/zh-CN/) 规范。

## [0.4.0] - 2026-04-21

### 新增 (Added)

- 新增「AI 对话环境集成」章节：提示词模板 + 一键脚本双轨安装方式 (Add AI dialog environment integration guide)
- 新增 `install.sh` 一键安装脚本，支持 SKILL_DIR/INSTALL_DIR 环境变量适配多工具 (Add install.sh with env var support)
- 支持 Claude Code / Factory Droid / Cursor 等多 AI 工具的安装说明 (Multi-tool install instructions)

## [0.3.0] - 2026-04-21

### 新增 (Added)

- 新增 skill: `skill-self-evolution`（技能自我进化）— 从对话中实时识别方法论并转化为 skill 包 (Add skill: skill-self-evolution)
- `dialectical-self-review` 增加与 `skill-self-evolution` 的关联引用，形成闭环 (Add cross-reference between dialectical-self-review and skill-self-evolution)

## [0.2.0] - 2026-04-21

### 新增 (Added)

- 新增 skill: `dialectical-self-review`（辩证自我审查）— 在行动前对方案做结构化自我反驳 (Add skill: dialectical-self-review)
- 包含五步辩证协议、第一性原理判据链、实际案例 (Include dialectic protocol, first-principles chain, examples)

## [0.1.0] - 2026-04-21

### 新增 (Added)

- 初始化工作空间，建立 Docs/ 目录与开发指导规范 (Init workspace with Docs/ and dev guidelines)
- 首个 skill: `adversarial-successor-audit`（对抗性接替者审计）— 以新人视角做全流程审计 (Add first skill: adversarial-successor-audit)
- 包含审计清单、三个子模式（Bootstrap 死循环检测、入库边界三层判据、AI 可调用性检验）、实际案例 (Include audit checklist, sub-patterns, examples)
- 部署机制：`update.sh` + `~/.claude/skills/update-all.sh` 自动同步 (Add deployment mechanism)
