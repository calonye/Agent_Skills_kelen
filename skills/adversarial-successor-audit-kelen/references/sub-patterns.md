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
- 把含有 `~/...` 或 `<HOME>/...` 绝对路径的文件入库 → 泄漏个人信息

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

---

## 子模式 D：提交内容隐私扫描

### 定义

入库文件不应包含个人路径、密钥、本地配置等隐私信息。这是一个常被忽略但影响严重的边界问题——`.gitignore` 只管「哪些文件不入库」，不管「入库文件里有什么内容」。

### 检测方法

```bash
# 扫描所有入库文件中的个人路径模式
git ls-files | xargs grep -n '/Users/\|/home/[a-z]' 2>/dev/null
# 扫描密钥/令牌模式
git ls-files | xargs grep -n 'api_key\|secret\|token\s*=' 2>/dev/null
# 扫描硬编码主机名
git ls-files | xargs grep -n 'localhost:\|127\.0\.0\.1' 2>/dev/null
```

### 典型错误

- 部署脚本中硬编码 `/Users/你的用户名/...` 路径 → 其他开发者无法直接使用
- `workspace-conventions.md` 中示例路径用真实用户路径 → 泄漏信息 + 降低可移植性
- `.env` 文件意外入库 → 泄漏 API 密钥

### 修正模式

将个人信息替换为模板变量：
- `/Users/你的用户名/projects/` → `<YOUR_REPO_PATH>` 或 `$HOME/projects/`
- 硬编码路径 → 环境变量（`$HOME`、`$(pwd)`）
- 密钥 → 环境变量引用（`$API_KEY`）+ `.env.example` 模板

### 验证方法

```bash
# CI 可集成此检查
git ls-files | xargs grep -n '/Users/\|/home/[a-z]' 2>/dev/null
# 预期输出为空，若有输出则报错
```

---

## 子模式 E：目录树一致性检验

### 定义

Readme.md 中的目录结构树应与 `git ls-files` 的实际内容严格对应。目录树是新人首次浏览项目时看到的地图——如果地图与实际不符，新人会困在错误的预期中。

### 检测方法

```
1. 从 Readme.md 的目录结构树中提取所有目录和文件名
2. 对每个条目，验证它在 git tracked 文件中确实存在
3. 反向检查：是否有 git tracked 的关键文件在目录树中遗漏
4. 特别注意：目录树不应包含 git-ignored 的文件/目录（如 Docs/、update.sh）
```

### 典型错误

- 目录树列出了 `Docs/` 但实际 git clone 后看不到（git-ignored）→ 新人困惑
- 目录树缺少新建的 skill 目录 → 新人不知道它存在
- 目录树列出了 `update.sh` 但它不入库 → 新人 clone 后找不到

### 修正模式

- 目录树只展示 `git ls-files` 能看到的文件和目录
- git-ignored 的内容用注释或引文提示，不画进树形图
- 每次 skill 新增/删除/重命名后，必须更新目录树

### 验证方法

```bash
# 提取目录树中列出的目录名
grep -oP '[\w-]+(?=/|$)' Readme.md | sort > /tmp/tree_dirs.txt
# 提取 git tracked 的顶层目录
git ls-files | cut -d/ -f1 | sort -u > /tmp/git_dirs.txt
# 差异检查
diff /tmp/tree_dirs.txt /tmp/git_dirs.txt
# 预期：无差异（目录树与实际一致）
```
