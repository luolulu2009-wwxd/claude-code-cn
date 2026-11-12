#!/usr/bin/env bash
set -euo pipefail

# saylulu Claude Code 一键接入脚本
# 把 ANTHROPIC_* env 块写进 ~/.claude/settings.json（自动备份 + 合并，不覆盖其他配置）。

SETTINGS="$HOME/.claude/settings.json"
BASE_URL="https://llm.saylulu.com/api"

die() { echo "✗ $*" >&2; exit 1; }

command -v python3 >/dev/null 2>&1 || die "需要 python3（macOS / Linux 都自带）"

# 1. API key：优先读环境变量 SAYLULU_KEY，否则交互输入
if [[ -n "${SAYLULU_KEY:-}" ]]; then
  KEY="$SAYLULU_KEY"
else
  printf "saylulu API key（在 https://llm.saylulu.com/dashboard 拿）: "
  read -r KEY
fi
[[ -n "$KEY" ]] || die "key 不能为空"

# 2. 备份已有配置
if [[ -f "$SETTINGS" ]]; then
  cp "$SETTINGS" "$SETTINGS.bak.$(date +%s)"
  echo "· 已备份原 settings.json"
fi

# 3. 合并 env 块（用 python3 做 JSON 合并，避免破坏已有内容）
python3 - "$SETTINGS" "$KEY" "$BASE_URL" <<'PY'
import json, os, sys
path, key, base = sys.argv[1], sys.argv[2], sys.argv[3]
settings = {}
if os.path.exists(path):
    with open(path, encoding="utf-8") as f:
        try:
            settings = json.load(f)
        except json.JSONDecodeError as e:
            sys.exit(f"现有的 settings.json 不是合法 JSON：{e}，请先修好或删掉再跑")
env = settings.setdefault("env", {})
env.update({
    "ANTHROPIC_BASE_URL": base,
    "ANTHROPIC_AUTH_TOKEN": key,
    "ANTHROPIC_MODEL": "claude-sonnet-5",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-sonnet-5",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "claude-opus-4-8",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-haiku-4-5",
})
os.makedirs(os.path.dirname(path), exist_ok=True)
with open(path, "w", encoding="utf-8") as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)
    f.write("\n")
print(f"· 已写入 {path}")
PY

echo "✓ 完成。重启 Claude Code，然后跑：claude"
