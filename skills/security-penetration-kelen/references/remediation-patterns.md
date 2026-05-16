---
description: 按漏洞类型的修复模式 — 注入/认证/授权/加密/配置五大类修复方案
parentRule: SKILL.md
---

# 漏洞修复模式 / Remediation Patterns

## 注入类 → 参数化查询

不可拼接用户输入到 SQL/命令。修复示例：
- PHP: PDO prepared statements
- Java: PreparedStatement
- Python: cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))

## 认证类 → 会话管理加固

- 登录后立即使旧 session 失效
- session cookie 设 HttpOnly + Secure + SameSite=Strict
- 敏感操作要求重新认证

## 授权类 → RBAC 实现

- 每个 API 端点独立检查用户角色
- 资源所有权在数据层校验 (WHERE user_id = ?)
- 禁止依赖客户端隐藏按钮做权限控制

## 加密类 → 算法升级 + 密钥轮换

- 使用 AEAD 模式 (认证加密)
- IV/Nonce 必须随机且不可重用
- 密钥通过环境变量注入，不入库

## 配置类 → 硬化模板

- 默认拒绝、显式允许
- 移除所有调试端点、默认账户、示例配置
- 最小权限原则：服务账户只需必要权限

## 修复验证

每项修复完成后确认：原 PoC 不再可用、回归测试通过、同级漏洞是否一并修复、是否引入新的攻击面。

`<segment>` 标记为模板占位符，在实际分析中替换为目标具体值。