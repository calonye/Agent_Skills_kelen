---
description: 七大领域安全分析流程 — Web/Backend/Binary/Pwn/Crypto/Forensics/Identity 的分析路径与优先级
parentRule: SKILL.md
---

# 安全分析优先级 / Analysis Priorities

## 领域路由

根据目标类型自动选择分析路径。每领域按优先级递减排列。

## 1. Web / API

分析路径：入口 HTML → 路由注册 → 存储机制 → 认证/会话 → 上传处理 → Worker/Service Worker → 隐藏端点

- 第一步：读取所有入口 HTML 文件，提取 JS bundle URL、API 端点模式、表单 action
- 第二步：检查路由注册表（React Router / Next.js pages / Express routes），发现未认证端点
- 第三步：审查浏览器存储使用（Cookie 属性、localStorage 敏感数据、sessionStorage 清理逻辑）
- 第四步：分析认证流程 — CSRF token 生成、JWT 验证、OAuth redirect_uri 校验
- 第五步：检查协议与解析层 — SSRF、XXE、SSTI、反序列化、GraphQL schema 暴露、WebSocket 鉴权
- 第六步：检查文件上传 — MIME 类型校验、服务端重命名、路径穿越防护
- 第七步：检查 Service Worker 和 Web Worker 对缓存的操纵能力

优先级判据：先静态分析可读源码，后按授权级别动态验证端点行为。发现未认证写端点标为高风险或严重，需附证据链。

## 2. Backend / async

分析路径：入口点 → 中间件链顺序 → RPC/消息处理器 → 状态转换 → 队列/任务 → 重试与幂等性

- 第一步：映射所有入口点（HTTP handler、gRPC service、消息队列 consumer）
- 第二步：审查中间件顺序 — CORS → Auth → Rate Limit → Body Parser 的顺序错误可能形成高风险缺陷
- 第三步：追踪状态转换 — 订单/用户/资源的合法状态迁移路径，非法跳转即漏洞
- 第四步：分析异步任务 — 队列消息是否可被未认证来源注入
- 第五步：检查重试逻辑 — 非幂等操作重试可能导致重复扣款/多次创建

## 3. Binary / suspicious sample

分析路径：文件头 → 导入表 → 字符串 → 段结构 → 行为线索 → 静态风险结论

- 第一步：识别文件格式（PE/ELF/Mach-O），定位入口点和段表
- 第二步：提取导入表，按功能分类（网络 I/O、文件 I/O、进程操作、加密）
- 第三步：提取可打印字符串，搜索 URL、IP、文件路径、注册表键模式并脱敏
- 第四步：静态识别反调试、反虚拟机、混淆和可疑加载行为
- 第五步：反编译控制流，恢复关键函数、协议字段、加密/编码流程和配置解析逻辑
- 第六步：提取嵌入配置线索，记录硬编码地址、密钥形态、互斥体名称等风险证据
- 第七步：输出静态风险结论和隔离建议，不运行可疑样本，除非用户提供专用沙箱并明确授权

## 4. Native / pwn lab

分析路径：二进制格式 → 安全防护 → 输入边界 → 崩溃证据 → 受控 PoC → 根因定位 → 修复方向

- 第一步：checksec — NX、PIE、Canary、RELRO、FORTIFY
- 第二步：确认编译器、运行库、符号、ASLR/PIE 影响和调试器可用性
- 第三步：寻找输入边界问题 — 固定缓冲区、长度校验缺失、格式化字符串、未初始化内存
- 第四步：区分栈、堆、UAF、double free、整数溢出和类型混淆等缺陷形态
- 第五步：记录崩溃条件 — 输入、异常、堆栈摘要和可复现步骤
- 第六步：在本地靶场内构造最小受控 PoC，证明可控性或不可控性，不导出为通用攻击链
- 第七步：定位根因函数和数据流，给出修复方向 — 长度校验、安全 API、编译防护和回归测试

## 5. Crypto / stego

分析路径：变换链 → 参数提取 → 元数据分析 → 隐藏信道 → 文件尾部数据 → 签名/验证逻辑 → 信任边界

- 第一步：恢复完整加密流程 — 从明文到密文的每一层操作及其顺序
- 第二步：提取所有参数 — IV、nonce、密钥长度、填充方式、迭代次数
- 第三步：检查元数据 — EXIF、文件末尾追加数据、最低有效位
- 第四步：寻找非标准变换 — 自定义 S-box、异或模式、循环移位模式
- 第五步：审查验证逻辑 — nonce reuse、padding oracle、MAC-then-encrypt、时序侧信道、RSA/ECC 参数误用、签名校验缺陷
- 第六步：识别信任边界 — 哪些数据来自用户且未验证就被加密/签名

## 6. Forensics / traffic / timeline

分析路径：证据源 → 时间线 → 文件/内存/日志/流量 → 关联图 → 结论复现

- 第一步：识别证据源 — 磁盘镜像、内存 dump、日志、pcap、HAR、容器层、浏览器存储
- 第二步：建立时间线 — 文件 mtime/ctime、日志时间戳、请求序列、进程生命周期
- 第三步：提取 IOC 和行为线索 — 域名、IP、路径、哈希、用户、进程、认证事件
- 第四步：关联多源证据，区分事实、推断和待确认项
- 第五步：输出脱敏证据链、影响范围、恢复建议和检测规则
- 第六步：不导出真实个人数据、真实凭据或第三方敏感样本

## 7. Identity / Windows / cloud

分析路径：令牌/票据流 → 凭据存储与可用性 → 横向移动路径 → 容器与运行时差异 → 部署产物来源

- 第一步：跟踪认证令牌生命周期 — 签发、传递、验证、刷新、吊销的全链路
- 第二步：检查凭据存储 — 环境变量、配置文件、CI secret、容器 secret mount
- 第三步：静态映射横向风险路径 — 服务账户权限、跨命名空间访问、IAM 角色链；不执行横向移动，不尝试访问跨命名空间资源
- 第四步：对比容器内外的凭据差异 — host 上的 `/var/run/docker.sock`、特权模式
- 第五步：按环境拆解身份面 — AWS/Azure/GCP IAM、K8s RBAC、AD/Kerberos、OIDC/SAML/OAuth
- 第六步：审查部署产物 — Dockerfile 中的 `COPY --from` 源、CI 日志残留

## 通用判据

优先使用运行时行为推翻静态分析结论：
- 运行时进程实际监听端口 > nmap 扫描结果
- strace/dtrace 追踪的实际文件操作 > 源码中的 import 语句
- 实际 HTTP 响应中的 Set-Cookie > 配置文件中的 cookie 设置

`<segment>` 标记为模板占位符，在实际分析中替换为目标具体值。

---

## 相关参考

- `sandbox-contract.md` — 沙箱授权范围、证据优先级与责任边界
- `tool-orchestration.md` — 工具选择与编排（Shell/Browser/脚本的协调策略）
- `evidence-chain.md` — 证据链管理（输入→请求→响应→观察→结论→复现）
- `vulnerability-taxonomy.md` — 漏洞分类体系与严重度评估（CVSS）
- `remediation-patterns.md` — 按漏洞类型的修复模式
