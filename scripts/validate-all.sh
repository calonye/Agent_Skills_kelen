#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

bash -n install.sh
bash -n scripts/validate-dialectical-self-review.sh
bash -n scripts/validate-security-penetration.sh

bash scripts/validate-dialectical-self-review.sh
bash scripts/validate-security-penetration.sh

ruby scripts/validation/structure.rb
ruby scripts/validation/skill-contracts.rb
ruby scripts/validation/public-entrypoints.rb
ruby scripts/validation/content-hygiene.rb

git diff --check

echo "all validations passed"
