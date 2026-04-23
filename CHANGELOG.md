# 变更日志 / Changelog

本项目遵循 [语义化版本号 (SemVer)](https://semver.org/lang/zh-CN/) 规范。

## [0.5.1] - 2026-04-23

### 修正 (Fixed)

- skill-routing.md 上下文路由通用化，移除特定环境路径硬编码，增加「新环境自适应触发」(Generalize contextual routing, add new-environment trigger)
- env-sync-maintainer-kelen 重构为通用方法论，不绑定具体工具，适配案例拆到 references/adapters/ (Refactor as universal methodology with adapter case studies)
- skill-self-evolution-kelen 步骤③改为三层决策（粗粒度→细化→确认），必须等用户回复，不可自行跳过 (Three-layer decision: coarse → refine → confirm, must wait for user)
- 新增 `references/skill-design-principles.md` 通用设计原则（格式规范、内容净化、触发词覆盖、明确判断不干扰原则），入库 (Add universal design principles, committed to repo)

### 新增 (Added)

- env-sync-maintainer-kelen/references/adapters/claude-code.md — Claude Code 适配案例 (Add Claude Code adapter)
- env-sync-maintainer-kelen/references/adapters/factory-droid.md — Factory Droid 适配案例 (Add Factory Droid adapter)

## [0.5.0] - 2026-04-23

### 新增 (Added)

- 新增 skill: `env-sync-maintainer-kelen`（环境同步维护）— 多 AI 工具环境配置同步与 Skill 自愈 (Add skill: env-sync-maintainer-kelen)
- `skill-self-evolution-kelen` 增加用户决策机制（至少 5 项选择，最后一项为补充说明）(Add user decision mechanism to skill-self-evolution-kelen)
- `skill-self-evolution-kelen` 融合 yao-meta-skill 和 skill-creator 设计模式 (Integrate design patterns from yao-meta-skill and skill-creator)
- `~/.factory/rules/skill-routing.md` 增加上下文路由（状态感知、决策风险、交付验收触发）(Add contextual routing to skill-routing.md)
- `Docs/开发指导规范.md` 融合 ModuleDesign 规范（渐进式披露、紧凑原则、规则与说明分离、内容净化规范）(Integrate ModuleDesign standards into dev guidelines)

### 变更 (Changed)

- 所有 skill 命名加 `-kelen` 后缀水印 (Add -kelen suffix to all skill names)
- 清理所有 SKILL.md 中的无实质内容（移除 origin 字段、心路历程、非权威引用）(Clean up non-essential content from all SKILL.md files)
- `Readme.md` 致谢段落精简，移除特定对话引用 (Simplify acknowledgments in Readme.md)
- 更新 `Docs/开发指导规范.md` 至 v0.3.0，增加 frontmatter 设计规范、触发词覆盖要求 (Update dev guidelines to v0.3.0)

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
