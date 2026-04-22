# 三个子模式详解 / Sub-Patterns

## 子模式 A：Bootstrap 死循环检测

### 定义

当一个系统的「初始化工具」本身依赖「初始化的输出」时，就形成了 bootstrap 死循环。clone 后无法完成第一步初始化。

### 检测方法

```
1. 列出 package.json 中所有 scripts 条目
2. 检查每个条目指向的文件路径
3. 确认该路径是否在 .gitignore 中
4. 若被忽略 → bootstrap 死循环
```

### 典型案例

```json
// package.json
"setup": "bash .ai-local/scripts/setup.sh"
// .gitignore
.ai-local/
```

`setup` 指向 `.ai-local/scripts/setup.sh`，但 `.ai-local/` 被忽略。clone 后该文件不存在，`bun run setup` 直接报 `No such file`。

### 修正模式

将初始化入口脚本移到入库目录（如 `scripts/setup.sh`），让初始化过程**生成**私有目录，而非**依赖**私有目录。

---

## 子模式 B：入库边界三层判据

### 定义

决定一个文件是否应入库（git tracked）的三层判断框架。

### 三层判据

| 层 | 内容类型 | 入库？ | 理由 |
|---|---------|-------|------|
| 1 | 客观项目规范（身份/分支/提交/工具链） | 是 | 任何新人/AI 都需要读到 |
| 2 | 自动化工具（脚本/钩子/CI） | 是 | clone 后必须立即可用 |
| 3 | 个人偏好/隐私（人格/记忆/私有路径/密钥） | 否 | 含个人信息或本机路径 |

### 典型错误

- 把 AGENTS.md（项目规范，层 1）放入 .gitignore → 新 AI 工具无法读到规则
- 把 scripts/（自动化工具，层 2）放入 .gitignore → clone 后命令全部 broken
- 把含有 `/Users/kelen/...` 绝对路径的文件入库 → 泄漏个人信息

### 验证方法

```
遍历所有 git-ignored 文件 → 用三层判据逐个检查 → 发现层 1/2 被忽略则报错
遍历所有 git-tracked 文件 → 检查是否含私有路径/密钥 → 发现则报错
检查 .gitignore 注释与实际行为是否一致
```

---

## 子模式 C：AI 可调用性检验

### 定义

所有交互式脚本必须同时支持非交互参数模式，否则 AI 工具（Claude Code / Codex / Cursor）无法调用。

### 检测方法

```
1. 在所有 .sh 文件中搜索 `read -r` / `select` / `read -p`
2. 检查同一脚本是否支持等价的命令行参数（--yes / --type= / --source=）
3. 若不支持 → AI 不可调用
```

### 典型案例

```bash
# 交互式（人类用）
read -r -p "选择 [1/2/3]: " choice

# 非交互式（AI 用）
# bun run sync -- --source=upstream --yes
```

### 修正模式

```bash
ARG_SOURCE="" ; ARG_YES=false
for arg in "$@"; do
  case "$arg" in
    --source=*) ARG_SOURCE="${arg#--source=}" ;;
    --yes)      ARG_YES=true ;;
  esac
done

# 若有参数则跳过交互
if [[ -n "$ARG_SOURCE" ]]; then
  choice="$ARG_SOURCE"
else
  read -r -p "选择: " choice
fi
```

### 验证方法

```bash
# 对每个脚本执行 dry-run（无 stdin）
echo "" | bash scripts/git/sync.sh --source=fetch-only 2>&1
# 若退出码为 0 且无阻塞 → 通过
```
