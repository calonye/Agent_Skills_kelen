#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/calonye/Agent_Skills_kelen.git"
REPO_NAME="Agent_Skills_kelen"
SKILL_DIR="${SKILL_DIR:-$HOME/.claude/skills}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/$REPO_NAME}"

echo "=== Agent_Skills_kelen 一键安装 ==="
echo "Skill 目标目录: $SKILL_DIR"
echo "仓库本地路径:   $INSTALL_DIR"
echo ""

# 1. Clone or pull
if [ -d "$INSTALL_DIR/.git" ]; then
  echo "[1/3] 仓库已存在，拉取最新版本..."
  git -C "$INSTALL_DIR" pull --ff-only
else
  echo "[1/3] 克隆仓库..."
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

# 2. Deploy all skills
echo "[2/3] 部署 skills..."
deployed=0
for skill_dir in "$INSTALL_DIR"/*/; do
  [ -f "$skill_dir/SKILL.md" ] || continue
  skill_name=$(basename "$skill_dir")

  dst="$SKILL_DIR/$skill_name"
  mkdir -p "$dst"
  rsync -av --exclude='update.sh' "$skill_dir" "$dst/" > /dev/null 2>&1

  # Generate update.sh for future syncs
  cat > "$skill_dir/update.sh" <<EOF
#!/bin/bash
REPO_PATH="$INSTALL_DIR"
SKILL_NAME="$skill_name"
DST="$SKILL_DIR/\$SKILL_NAME"
[ ! -d "\$REPO_PATH/\$SKILL_NAME" ] && echo "源目录不存在" && exit 1
mkdir -p "\$DST"
rsync -av --exclude='update.sh' "\$REPO_PATH/\$SKILL_NAME/" "\$DST/"
echo "\$SKILL_NAME 已更新"
EOF
  chmod +x "$skill_dir/update.sh"

  echo "  ✓ $skill_name"
  deployed=$((deployed + 1))
done

# 3. Create update-all.sh
update_all="$SKILL_DIR/update-all.sh"
cat > "$update_all" <<'ALLEOF'
#!/bin/bash
SKILLS_DIR="$(cd "$(dirname "$0")" && pwd)"
errors=0

for update_script in "$SKILLS_DIR"/*/update.sh; do
  [ -f "$update_script" ] || continue
  skill_name=$(basename "$(dirname "$update_script")")
  echo "Updating $skill_name..."
  bash "$update_script" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "  $skill_name ✓"
  else
    echo "  $skill_name ✗"
    errors=$((errors + 1))
  fi
done

echo "Skill 更新完成 (errors: $errors)"
ALLEOF
chmod +x "$update_all"

echo ""
echo "=== 安装完成 ==="
echo "已部署 $deployed 个 skill 到 $SKILL_DIR"
echo "后续更新运行: $update_all"
echo ""
echo "测试触发词："
echo "  - 「帮我检查一下别人拿到这个项目能不能跑起来」→ adversarial-successor-audit-kelen"
echo "  - 「思辨一下」→ dialectical-self-review-kelen"
echo "  - 「提炼技能」→ skill-self-evolution-kelen"
echo "  - 「同步一下配置」→ env-sync-maintainer-kelen"
