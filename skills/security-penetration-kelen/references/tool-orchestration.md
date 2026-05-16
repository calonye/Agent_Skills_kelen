---
description: 工具选择与编排 — Shell/Browser/脚本的协调策略
parentRule: SKILL.md
---

# 工具选择与编排 / Tool Orchestration

## Shell 优先

安全分析中优先使用 shell 命令进行被动侦察。产生网络请求或状态变化前，必须确认授权级别允许：

- rg (ripgrep)：代码模式搜索，优先于 grep
- find + ls：目录结构映射
- git log/diff：变更历史追踪
- curl -v：HTTP 请求重放与验证，仅用于明确授权目标；默认只使用非状态改变请求，带认证、写请求、批量扫描或重放生产请求前必须二次确认

## 浏览器工具

需要渲染态分析、存储检查、fetch/XHR/WebSocket 追踪时使用：

- browser_snapshot：获取页面结构和 aria refs
- browser_network_requests：捕获网络流量
- browser_console_messages：检查客户端错误和日志

## 脚本编排

- 小型 Python/Node 脚本用于解码、重放、变换校验
- 一次只改变一个变量验证行为
- 保留原始产物和派生产物的分离
- 不编排持久化、规避检测、凭据窃取、横向移动或破坏性利用脚本

## 证据优先级

```
运行时行为 > 网络流量 > 当前服务资源 > 进程配置 > 持久化状态 > 生成产物 > 源码 > 注释
```

`<segment>` 标记为模板占位符，在实际分析中替换为目标具体值。
