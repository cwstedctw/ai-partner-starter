#!/bin/bash
# Mac 版檢查工具：雙擊（或 bash 檢查工具.command）看工具裝好了沒。只印版本，不印帳號與金鑰。
cd "$(dirname "$0")" || exit 1
# 雙擊開的終端機不一定有 Homebrew 與 uv 的路徑，補上常見位置
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo
echo "  檢查工具。 OK＝找到了   MISSING＝要用但還沒裝   --＝選配，或還沒做"
echo "  ------------------------------------------------------------------"
chk() { # 名稱 指令 必要(1)/選配(0) 說明
  if command -v "$1" >/dev/null 2>&1; then
    printf "  OK       %-6s %s\n" "$1" "$($2 2>/dev/null | head -1)"
  elif [ "$3" = "1" ]; then
    printf "  MISSING  %-6s %s\n" "$1" "$4"
  else
    printf "  --       %-6s 選配：%s\n" "$1" "$4"
  fi
}
chk git  "git --version"  1 "記下每一版"
chk gh   "gh --version"   1 "存到自己的 GitHub 要用"
chk node "node --version" 0 "要用 gws 才裝"
chk gws  "gws --version"  0 "讓 AI 夥伴處理信箱與雲端硬碟"
chk uv   "uv --version"   0 "要用 gws 寫信才裝"
chk brew "brew --version" 0 "有的話裝工具比較快；沒有也可以"

echo
echo "  登入"
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then echo "  OK       GitHub CLI 已登入"; else echo "  --       GitHub CLI 還沒登入：gh auth login"; fi
else
  echo "  --       GitHub CLI 還沒裝"
fi
if command -v gws >/dev/null 2>&1; then
  if gws auth status 2>/dev/null | grep -Eq '"has_refresh_token"[^,]*true'; then echo "  OK       gws 已存好 Google 登入"; else echo "  --       gws 還沒登入（要先有 client_secret.json，見 先看這裡.html 第 12 項）"; fi
else
  echo "  --       gws 沒裝，跳過"
fi

echo
echo "  電腦：$(uname -m)（arm64＝Apple 晶片，x86_64＝Intel）"
echo "  一定要的是 git、gh 與 GitHub 登入；其他是選配。"
echo "  ChatGPT、Claude 桌面版這裡查不到：各打開一次、登入就好。"
echo
if [ "$1" != "--no-pause" ]; then read -r -p "  按 Enter 關閉 " _; fi
