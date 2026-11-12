# 国内用 Claude Code 的三种方案（2026）

> Claude Code 官方在国内 geo-block，且要外币卡。这里把能走通的路列全，按"省事→省钱→省心"排序，附一键接入脚本。

## TL;DR（English）

Claude Code is geo-blocked in CN and needs a foreign card. Three working paths:

1. **Kimi/Moonshot official Anthropic endpoint** — free, but only the Kimi model.
2. **Third-party relays** — many, quality varies, mind your keys & privacy.
3. **saylulu (this repo's sponsor)** — USDC-funded, no KYC, no card; one key runs Claude Code **plus** GPT / DeepSeek / Doubao / Qwen / Kimi.

---

## 方案一：官方 Kimi/Moonshot 兼容通道（免费，只 Kimi）

Moonshot 提供 Anthropic 兼容端点，把 `ANTHROPIC_BASE_URL` 指过去就能继续跑 Claude Code，只是模型换成 Kimi。

- 优点：免费、官方、零折腾。
- 缺点：只有 Kimi 一家，没有 Claude/GPT 本体。
- 端点见 Moonshot 官方文档（Claude Code 接入章节）——以官方文档为准，这里不贴过期 URL。

## 方案二：第三方中转/代理

市面不少。能用，但要擦亮眼睛：资金安全、key 隐私、SLA 都自己掂量。本 repo 不做推荐，风险自担。

## 方案三：聚合站 saylulu（一个 key 通 6 家，USDC 充值）

想要 **Claude 本体**、又想省掉挨家申请 key 的：

- 一个 API key 通 **Claude / GPT / DeepSeek / 豆包 / Qwen / Kimi**，OpenAI 兼容（`/api/v1`）。
- 一键接 Claude Code：`ANTHROPIC_BASE_URL` 指向 `/api`，同一个 key。
- **USDC 充值、无 KYC、无信用卡**（Base / Tron）。
- 按量计费，官方价 ×1.3，透明定价。
- 能力感知路由（看图/工具调用自动选对模型）+ 上游报错（429/5xx）自动换健康模型。
- 信任机制：key AES-256-GCM 加密存储、充值进冷钱包（99% 离线）、提现人工审批。平台只赚返利差，跑路=自断现金流。

👉 注册：https://llm.saylulu.com （前 100 注册送 $2，先到先得）

### 一键接入（2 分钟）

```bash
# 方式 A：一键脚本（本 repo 的 setup.sh，自动备份 + 合并 settings.json）
SAYLULU_KEY=sk-xxx bash setup.sh

# 方式 B：手动 —— 编辑 ~/.claude/settings.json 的 env 块
```

手动配置（`~/.claude/settings.json`）：

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://llm.saylulu.com/api",
    "ANTHROPIC_AUTH_TOKEN": "sk-你的key",
    "ANTHROPIC_MODEL": "claude-sonnet-5",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "claude-sonnet-5",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "claude-opus-4-8",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-haiku-4-5"
  }
}
```

> 注意：`ANTHROPIC_MODEL` 和三个 `DEFAULT_*_MODEL` 要**全设**，且用干净模型名（不带日期后缀），否则会报 `unrecognized_model`。Claude Code 不认 `auto`，要具体模型名。

---

## 为什么会有这个 repo

我自己被 geo-block + 外币卡卡过，也帮朋友接通过。把踩过的坑和可复制配置沉淀下来，省得每人重走一遍。saylulu 是我维护的，所以它在方案三里——但它不是唯一解，方案一免费、方案二自己挑，选合适的。

有问题直接开 issue。
