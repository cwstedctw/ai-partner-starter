---
name: gws-mail
description: 用 gws（Google Workspace 命令列工具）替主人寫信、回信、帶附件——一律先建成 Gmail 草稿，主人在 Gmail 看過全文自己按「傳送」。觸發詞：寫信、回信、擬信、寄給某某、通知某某、附件寄出、整批通知、草稿。
---

# gws-mail：寫信就是建草稿，送出由主人按

## 鐵則（公約第三句的延伸）

1. **只建草稿、永遠不寄。** 做完告訴主人「草稿在 Gmail 草稿匣，主旨是○○」，他在 Gmail 看過全文、自己按傳送。主人說「直接寄」也一樣：回他「草稿好了，請在 Gmail 按傳送」。本技能不提供寄出的指令。
2. **寫給外面的人（合作老師、期刊編輯、廠商）用中性禮貌語氣**；不代替主人簽名，署名照他在 `memory/我的規矩.md` 講的寫法；沒講就問一次署名要怎麼寫，記進 `memory/我的規矩.md`。
3. **個資**：收件名單、成績、帳號留在主人原本放的地方；這個資料夾裡 .eml 只准放 `cache/`（已 gitignore）。建完草稿就刪掉**這次自己建的** .eml——這是公約允許的唯一刪檔例外。
4. **回信要串在原信底下**：先抓原信的 Message-ID 與 threadId，再建草稿；不要另開新信。

## 事前（裝工具時裝好的）

- `gws` 已安裝並登入：`gws auth status` 看得到 `has_refresh_token: true`，且 `scopes` 含 gmail。沒有 → 照 `runbooks/裝工具.md`〈gws〉（人看的說明在 `先看這裡.html` 第 12 項）；登入時把要用的服務一次列全（`-s "gmail,drive,calendar,sheets,docs"`，**引號不能省**），**重新登入會整組換掉授權**。
- 在**資料夾根目錄**執行（gws 的 `--upload` 只看得到執行時所在資料夾底下的檔）。
- 主人說「寄給我自己」：先用 `gws.cmd gmail users getProfile --params '{\"userId\":\"me\"}'` 拿 `emailAddress` 當收件人，建之前在對話裡給他看一眼。
- 要有 uv（`make_eml.py` 只用 Python 內建功能，`uv run --no-project` 0.4 秒就跑起來，不必先 `uv sync`；沒有 Python 的電腦 uv 第一次會自己下載一份）。

## Windows：在 PowerShell 一律打 `gws.cmd`（2026-11-09 兩版實測）

在 PowerShell 打 `gws` 會經過 npm 裝的 `gws.ps1`，三件事會靜靜出錯：新電腦不讓 `.ps1` 執行、沒加引號的逗號清單變空白、JSON 的雙引號在 5.1 被吃掉。改打 `gws.cmd` 就繞開：

- 指令開頭寫 `gws.cmd`，JSON 參數的每個雙引號前加反斜線。例：`gws.cmd gmail users drafts create --params '{\"userId\":\"me\"}' --upload "cache/_mail/draft.eml" --upload-content-type message/rfc822`。Windows PowerShell 5.1 與 PowerShell 7 都對，也不受「已停用指令碼執行」擋。
- **5.1 的 JSON 裡不能有空格**，會被拆成兩個參數（例：搜信條件 `from:a@b.c newer_than:7d`）。條件只放一個，其他你自己篩；`$PSVersionTable.PSVersion` 看得到版本，7.x 沒這個問題。
- `-s` 的服務清單照樣加雙引號：`gws.cmd auth login -s "gmail,drive,calendar,sheets,docs"`。
- Git Bash（例如 Claude Code）照本檔下面的寫法：`gws`、`'{"userId":"me"}'`。
- 看到紅字「因為這個系統上已停用指令碼執行」＝打成 `gws` 了，改打 `gws.cmd`。要不要改電腦設定由主人決定，**你不要替他改**。

## 單封（例：回合作老師、回期刊編輯）

```bash
# 1. 內文先寫成檔（主人口述 → 你整理 → 存 cache/_mail/body.txt）
# 2. 組信
uv run --no-project python skills/gws-mail/make_eml.py --to <收件人> --subject "<主旨>" --body-file cache/_mail/body.txt --attach "<附件的路徑>\附件.pdf" --out cache/_mail/draft.eml
# 3. 建草稿
gws gmail users drafts create --params '{"userId":"me"}' --upload "cache/_mail/draft.eml" --upload-content-type message/rfc822
# 4. 回讀驗收（收件人、主旨、附件數；別印附件內容）
gws gmail users drafts get --params '{"userId":"me","id":"<上一步回的 draft id>","format":"metadata"}'
# 5. 刪掉這次建的 .eml（只刪 cache/_mail/ 裡自己剛建的）
```

告訴主人：草稿在哪、主旨、收件人、附件幾件；**不要替他按傳送**。

## 回信串原信

```bash
# 原信標頭
gws gmail users messages get --params '{"userId":"me","id":"<原信 id>","format":"metadata","metadataHeaders":["Message-ID","References","Subject"]}'
# 組信：主旨「Re: 原主旨」，--in-reply-to 放原信 Message-ID
uv run --no-project python skills/gws-mail/make_eml.py --to <對方> --subject "Re: <原主旨>" --body-file cache/_mail/body.txt --in-reply-to "<原信 Message-ID>" --out cache/_mail/reply.eml
# 建在原串裡
gws gmail users drafts create --params '{"userId":"me"}' --json '{"message":{"threadId":"<原 threadId>"}}' --upload "cache/_mail/reply.eml" --upload-content-type message/rfc822
```

## 找信、讀信（不用寫檔）

```bash
gws gmail users messages list --params '{"userId":"me","q":"from:someone@example.com newer_than:7d","maxResults":10}' --format table
gws gmail users messages get --params '{"userId":"me","id":"<id>","format":"full"}'
```

## 雷

- `--params` 一定要有 `"userId":"me"`。
- Windows 主控台印中文亂碼是顯示問題，內容是對的；要看內容寫成檔再讀。
- `403 insufficient scopes`＝登入時少列服務；`401`＝登入過期，重跑 `gws auth login -s "…"`（一次列全、加引號）。
