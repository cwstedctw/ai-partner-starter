# 存到我的 GitHub：帶回去、每天存、換電腦、陳老師有新版 → 你來做，主人只確認帳號與說好

> 主人說「幫我存到我自己的 GitHub」「帶回去用」「備份夥伴資料夾」「換電腦」「另一台電腦也要用」「先幫我拉最新的」「陳老師有新版，幫我更新」「幫我打包一份」「幫我把這份備份還原進來」就是這本；「幫我收工」的第 4 步走這本的〈每天存〉。做完之後，這個資料夾在他**自己的 GitHub 帳號**有一份只有他看得到的（Private）repo，名字固定 `my-ai-partner`：換電腦、電腦壞了，都接得回來。人看的說明在 `先看這裡.html` 第 9 項；指令以這本為準。

## 停手

- **只推到他自己帳號的 Private repo。** 推之前看 `git remote get-url --push --all origin`：有 `cwstedctw/ai-partner-starter`、是 `no_push`、或不是 `https://github.com/<他的帳號>/` 開頭 → 停。repo 不是 Private → 停、不推，告訴他。〈第一次〉第 8 步之前還沒有 `origin`，那一次靠三件事守：第 2 步他確認過帳號、第 8 步的指令有 `--private`、第 9 步回讀。
- **帳號念給他聽**：第一次、換電腦都把登入的 GitHub 帳號念出來，他說「是我的」才往下。教室和共用電腦常留著別人的登入。
- **每次推之前都掃個資**（〈掃個資〉那一行）。掃到就停，不推。Private 不等於可以放個資。
- **新出現的檔先看兩件事**（`status` 列出來、以前沒存過的檔）：
  - 不是 `.md`、`.txt`（PDF、Word、Excel、圖片、.eml）→ 列檔名與大小，他說好才存；單檔超過 50 MB 不存，請他留在原本的地方。這類檔掃個資多半**掃不到裡面**（Excel、Word 是壓縮過的，PDF、圖片讀不到字），問的時候一併說：「這個檔我掃不到裡面，有沒有真的證號、手機、學號，要請你自己確認。」
  - 出現在他的區域以外（根目錄、`skills/`…）→ 先問他那是什麼。是他的資料 → 他說好就替他搬進 `workspace/`（他自己做的、還會改的）或 `material/`（拿來參考的；他點頭的搬動不算你自己寫 `material/`），重掃一次；掃個資只掃他的區域，放在外面的掃不到。
- **已經存上去才發現有個資** → 停，告訴他。只把檔案改掉不夠：舊的版本還留在 GitHub。請他問陳老師，不要自己改歷史。
- **不用這些**：`--force`、`reset --hard`、`rebase`、`clean`、`--allow-unrelated-histories`。卡住就停，把畫面最後幾行原樣給他看。
- **登入是他的事**：瀏覽器登入由他按；帳號、密碼、驗證碼不替他輸入、不叫他貼給你、不寫進任何檔。`gh auth status` 的輸出有一行 Token（遮過的）：只跟他說有沒有登入、是哪個帳號，不要整段貼出來，也不要寫進檔。
- **推不上去照實說**：網路斷、登入過期、被拒絕 → 說「存在這台電腦了，還沒到 GitHub」，不要一直重試。
- **陳老師那邊永遠 `no_push`**：`upstream` 只拿來拉更新。
- 會印檔名的 git 指令一律加 `-c core.quotepath=false`（中文檔名才不會變成一串數字）。

**他的區域**＝`memory/`、`projects/`、`runbooks/` 裡的手冊、`workspace/`、`material/`。**骨架**＝其他全部（`AGENTS.md`、`CLAUDE.md`、`roles/`、`skills/`、根目錄的 `.html`、`.cmd`、`開始.md`、`README.md`、`.gitignore`、`.gitattributes`）。

## 先看現在是哪一種

他說的是「幫我打包一份」或「幫我把這份備份還原進來」→ 不看這張表，直接做最後的〈沒有 GitHub〉那一段（資料夾有沒有接 git 都能做）。

其他的話：打 `git remote -v`（叫不到 git → 先照 `裝工具.md`），照第一個符合的做：

| 看到 | 是哪一種 | 做哪一段 |
|---|---|---|
| `not a git repository` | ZIP 拿到的資料夾，還沒接 git | 〈第一次〉走 B |
| `origin` 是 `cwstedctw/ai-partner-starter` | 從陳老師那邊 clone 的，還沒存到他自己那邊 | 〈第一次〉走 A |
| `origin` 是 `github.com/<他的帳號>/…`，另有 `upstream` | 已經接好 | 〈每天存〉，或他要的那一段 |
| `origin` 是 `github.com/<他的帳號>/…`，沒有 `upstream` | 剛從他自己的 repo 抓回來（換電腦） | 〈換電腦之後〉 |
| 其他 | 不認得 | 停，把輸出原樣給他看，請他問陳老師 |

## 第一次：存到他自己的 GitHub

0. 先用白話說計畫，他說好才動：「我會在你自己的 GitHub 帳號開一個只有你看得到的私人資料夾（GitHub 叫它 repo），名字是 my-ai-partner，把這個資料夾存一份上去。陳老師那邊維持原樣：你拿得到陳老師的更新，你的東西不會存到陳老師那邊。」
   - 只看不改的指令（`git remote -v`、`git --version`、`gh --version`、`gh auth status`、`gh api user`）可以在他說好之前先跑；第 3 步起會改東西，一定等他說好。
   - 這個「好」管到第 5 步。第 6 步列出要存的東西之後，還要他再說一次好，才存上去。
1. **工具**：`git --version`、`gh --version`。缺 → 照 `裝工具.md` 裝（裝完要整個重開 AI 程式，重開後請他再說一次這句）。GitHub CLI 裝不了（沒有 winget、單位擋）→ 走這一段最後的〈沒有 GitHub CLI〉。
2. **登入與帳號**：`gh auth status`。沒登入（它說 `not logged into any GitHub hosts`）→ `gh auth login --web --git-protocol https`，把一次性代碼念給他，他在瀏覽器貼上、按授權。然後 `gh api user --jq .login`，念給他：「現在登入的 GitHub 帳號是 ○○，是你的嗎？」不是 → 停。那是別人的登入，要不要 `gh auth logout` 換成他的，由他決定。
3. **陳老師那邊改叫 upstream**
   - 走 A：`git remote rename origin upstream`，再打 `git remote -v`：`upstream` 的 push 那行要是 `no_push`；不是就 `git remote set-url --push upstream no_push`。
   - 走 B：先看 `.gitignore` 在不在、裡面有沒有 `cache/` 和 `client_secret` 這兩行。沒有 → 停，請他問陳老師（少了它，登入設定檔和上千個套件檔會一起存上去）。有 → `git init -b main`、`git remote add upstream https://github.com/cwstedctw/ai-partner-starter.git`、`git remote set-url --push upstream no_push`。
4. **這個資料夾的署名**（只設這個資料夾，不動整台電腦）：分兩次打 `gh api user --jq .login`、`gh api user --jq .id`，然後 `git config user.name "<login>"`、`git config user.email "<id>+<login>@users.noreply.github.com"`。這是 GitHub 給的隱藏信箱，他真的信箱不會出現在紀錄裡。
5. **掃個資**（下面那一行）。
6. **看要存什麼**（這一步是關卡：他說好，才做第 7、8 步）：`git -c core.quotepath=false status --short -uall` 列的是他改過、新增的檔。剛 clone、還沒改過東西時這裡是空的，正常：存上去的是**整個資料夾**，`git ls-files` 列得出每一個檔。用白話跟他說：「會存上去的是你的筆記、手冊、成品、你放的參考資料，和陳老師給的骨架；`cache/`、登入設定檔、Python 套件不會存。」新出現的檔照〈停手〉那兩件事先問；他說不存的，把路徑加進 `.git/info/exclude`（同〈每天存〉第 4 步），再打一次 `status`，那個檔不在清單裡了才往下。
7. `git add -A`、`git commit -m "我的第一版"`。走 A 而且他還沒改過任何東西，它會說 `nothing to commit`（結束碼是 1），沒關係，直接下一步。
8. **開 repo 並推上去**：`gh repo create my-ai-partner --private --source . --remote origin --push`。這一個指令同時開 repo 和推，`--private` 不能少。
   - 出現 `Name already exists` → 停，問他：以前存過嗎？
     - 存過 → 這個資料夾不要再存一份。原來那份要在**另一個空資料夾**抓回來（`先看這裡.html`〈肆　平常怎麼用〉表格裡「換新電腦」那一句）；這個資料夾裡他新寫的東西，列給他看，由他決定要不要搬過去。
     - 沒存過（那是別的東西）→ 請他另取一個英數名字（例如 `my-ai-partner-2`），後面都用那個名字；提醒他 `先看這裡.html`〈肆　平常怎麼用〉「換新電腦」那一句裡的名字也要跟著改。
9. **驗三件事**，三項都對才往下；有一項不對 → 停，照實說是哪一項：
   - `gh repo view <帳號>/my-ai-partner --json nameWithOwner,visibility,url`（一定要寫出 `<帳號>/my-ai-partner`，不寫的話它可能去看陳老師那一個）：`visibility` 是 `PRIVATE`、`nameWithOwner` 是他的帳號開頭。
   - `git -c core.quotepath=false status -sb`：第一行是 `## main...origin/main`，沒有 `ahead`。寫的是 `upstream/main` → `git branch --set-upstream-to=origin/main main` 再看一次。
   - `git ls-remote origin HEAD` 印的那一串，跟 `git rev-parse HEAD` 一樣。
10. 把網址念給他，請他用瀏覽器開一次，看 repo 名字旁邊有沒有 **Private**。**他說有，才回「存好了」。** 再告訴他以後的三句話：每天「幫我收工」就會存；另一台電腦開工先說「先幫我拉最新的」；「陳老師有新版，幫我更新」。
11. 先跟他說一聲要在兩個檔的檔尾各加一行，再做：`memory/log.md` 記一行；`memory/我的規矩.md` 加一行 `- 夥伴資料夾存在 GitHub：<帳號>/my-ai-partner（Private）；收工時存（日期）。`（檔尾有一行空的 `- ` 就填在那一行）。這兩行留到今天收工一起存，也跟他說一聲：今天下班說「幫我收工」，它們才會到 GitHub。

### 沒有 GitHub CLI（gh 裝不了才走）

1. 請他用瀏覽器登入 github.com → 右上角「＋」→ New repository → Repository name 打 `my-ai-partner` → 選 **Private** → **不要勾** Add a README → Create repository。請他把網址上的帳號念給你（`github.com/<帳號>/my-ai-partner`）。
2. **推之前先確認 Private**：這條路你查不了。請他看 repo 名字旁邊有沒有 Private，他說有才往下；log 記「主人在瀏覽器確認 Private」。
3. 署名：`git config user.name "<帳號>"`、`git config user.email "<帳號>@users.noreply.github.com"`。
4. 照上面第 3、5、6、7 步做，然後 `git remote add origin https://github.com/<帳號>/my-ai-partner.git`、`git push -u origin main`。會跳 GitHub 登入視窗，他自己登。
5. 驗：第 9 步的後兩項照做，再接第 10、11 步。

## 掃個資（每次推之前）

```
git -c core.quotepath=false grep --untracked -nE '[A-Z][1289][0-9]{8}|09[0-9]{2}-?[0-9]{3}-?[0-9]{3}|(^|[^0-9])4[0-9]{8}([^0-9]|$)' -- memory projects runbooks workspace material
```

- 沒有輸出、結束碼 1＝乾淨，往下。（`git grep` 沒找到東西就是回 1，不是失敗。）
- 印出 `fatal`、`error`，或結束碼比 1 大＝**沒掃成**。停，不推，把那一行原樣給他看。
- 有輸出 → **停，不推**。告訴他哪個檔、第幾行、像哪一種（證號、手機、學號的格式），**不要把那串號碼再念一次，也不要寫進 log**。請他照 `material/範例-改名前後.md` 改，改完重掃。他要你代改也可以：把那一行改成範例那種寫法（號碼不留），改完重掃。
- 他說「那是範例，不是真的」→ 他確認過才往下，log 記一行「掃到 N 處，主人確認是範例」。
- 這一行只抓得到證號（含新式居留證）、手機（有沒有連字號都抓）、學號三種格式；舊式居留證（兩個英文字加八碼）跟發票號碼長得一樣，刻意不抓。姓名、地址、帳號它抓不到，靠公約第五句：你看到就提醒他。
- 最後那一段 `4` 開頭九碼是東華大學的學號格式；主人在別的學校或單位，問他那邊的學號或員工編號長什麼樣，把那一段換掉，並記在 `memory/我的規矩.md`。九碼數字也可能是統編或流水號：掃到了一樣照上面那一條說（哪個檔、第幾行，號碼不念），由他判斷，不要自己當成沒事。
- 只掃這五個資料夾，裡面出廠的手冊也一起掃。五個資料夾以外的骨架是陳老師的，不掃（裡面的測試資料和套件清單會誤報）；所以他的資料不能放在這五個資料夾外面，照〈停手〉。
- 這一行只看磁碟上現在的檔，已經 commit 的舊版本它看不到。照這本存的每一次都是先掃才 commit，所以平常不會漏；他自己或別的程式另外 commit 過東西，那幾次就沒掃過。你知道有這種情形 → 先停，跟他說那幾次沒掃過，他說好才推。

## 每天存（「幫我收工」第 4 步，或他說「幫我存一下」）

1. `git remote get-url --push --all origin`：
   - 不是 git 資料夾、電腦叫不到 git、沒有 origin、或 origin 是陳老師的 → 還沒接（這裡不要轉去裝工具）。只說一句：「這個資料夾還沒存到你自己的 GitHub；要的話說『幫我存到我自己的 GitHub』。」他說不用 → `memory/我的規矩.md` 檔尾加一行「不存 GitHub（日期）」，那一行在就不再提。
   - 是 `https://github.com/<帳號>/<名字>` → `<帳號>` 要跟 `memory/我的規矩.md`「夥伴資料夾存在 GitHub」那一行寫的一樣（沒有那一行就用 `gh api user --jq .login` 對）。對不上 → 停，告訴他。
   - 再看 `git branch --show-current`：不是 `main` → 停，把輸出給他看，請他問陳老師。
2. 有 gh：`gh repo view <帳號>/<名字> --json visibility --jq .visibility` 要印 `PRIVATE`。不是 → 停，告訴他「這個 repo 現在不是私人的」，不推。沒有 gh → 不登入去看那個網址：`curl.exe -s -o NUL -w "%{http_code}" https://github.com/<帳號>/<名字>`（Mac：`curl -s -o /dev/null -w "%{http_code}" https://github.com/<帳號>/<名字>`）印 `404`＝外面看不到，往下；印 `200`＝現在是公開的 → 停、不推，告訴他；印別的或連不上 → 這次查不了，請他用瀏覽器看一眼 repo 名字旁邊的 Private 還在不在，他說在才推。
3. 掃個資。
4. `git -c core.quotepath=false status --short -uall`。新出現的檔照〈停手〉那兩件事先問；他說不存的，把路徑加進 `.git/info/exclude`（不要改 `.gitignore`，那是骨架），再打一次 `status`：那個檔不在清單裡了才往下。還在＝git 已經在管它了（以前存過，或別的程式先加進去），寫 exclude 擋不住 → 停，這次不存，告訴他是哪個檔。
5. `git add -A`、`git commit -m "收工 YYYY-MM-DD"`（日期讀電腦的；他說的不是收工，就把「收工」換成「存一下」，更新骨架之前先存的那一次寫「更新前先存」）。它說 `nothing to commit`（結束碼 1）也照樣做第 6 步（之前可能有沒推上去的）。說 `Please tell me who you are` → 先做〈第一次〉第 4 步的署名。
6. `git push origin HEAD`。
   - 被拒絕（`rejected`、`fetch first`：另一台電腦先存過）→ `git pull --no-rebase --no-edit origin main`，沒衝突就再推一次。有衝突 → `git merge --abort`，告訴他：「今天的已經存在這台電腦，還沒到 GitHub；兩台電腦改到同一個地方，要請陳老師看。」
   - 網路或登入失敗 → 照〈停手〉照實說。
7. 驗：`git -c core.quotepath=false status -sb` 的第一行沒有 `ahead`、第一行下面沒有列任何檔；`git ls-remote origin HEAD` 跟 `git rev-parse HEAD` 一樣。都對才回：「存好了，<網址>。」第 5 步沒有新的 commit、第 6 步也說 `Everything up-to-date` → 回「今天沒有要存的」。存這件事本身不用另外記 log（存的紀錄就是那個 commit）；今天要記的事，在第 5 步之前記完。

## 兩台電腦都在用：「先幫我拉最新的」

- `git status --short` 要是空的。有還沒存的 → 先跟他說「這台有還沒存的東西，我先存再拉」，做〈每天存〉。然後 `git pull --no-rebase --no-edit origin main`。
- 有衝突 → `git merge --abort`，照實說。`runbooks/目錄.md` 和 `memory/log.md` 設了「兩邊都留」（`.gitattributes` 的 `merge=union`），兩台各加幾行不會衝突；log 的行可能不照時間排，看每行開頭的時間。
- 規矩只有一條，跟他說一次：一台收工存了，另一台開工先拉。

## 換電腦之後（他在新電腦的空資料夾，把自己的 repo 抓回來了）

1. **確認帳號**（只看不改的指令，同〈第一次〉第 0 步那幾個，可以在問之前先跑）。有 gh：`gh api user --jq .login` 念給他確認（同〈第一次〉第 2 步）。沒有 gh：`git remote get-url origin`，把網址裡的帳號念給他：「這份是從 ○○ 的 GitHub 抓下來的，是你的帳號嗎？」（gh 在第 4 步裝工具時會裝。）
2. **接回陳老師那邊**（只拉不推）：`git remote add upstream https://github.com/cwstedctw/ai-partner-starter.git`、`git remote set-url --push upstream no_push`、`git fetch upstream`。
   - `Repository not found` → 他的帳號現在讀不到陳老師的 repo（邀請過期或被移除）。他自己的東西不受影響；要拿陳老師的更新，再請陳老師邀請。
   - 抓到了 → `git merge-base HEAD upstream/main`：印出一串＝之後拿得到陳老師更新；什麼都沒印＝這份當初是 ZIP 來的，陳老師更新要等陳老師給做法。結果留到第 5 步一起記。
3. 署名：同〈第一次〉第 4 步。還沒有 gh → 先用〈沒有 GitHub CLI〉第 3 步那一種。
4. 工具：照 `裝工具.md`（那本「裝之前一項一個好」的規矩照舊）。gws 登入要在這台重做；`client_secret.json` 不在 repo 裡，要再跟陳老師拿，還沒拿到就先跳過 gws 登入，其他照做。
5. log 記一行「換到新電腦：陳老師那邊接回了沒；工具哪幾項好了、哪幾項還沒」。這一行現在只在這台，跟他說一聲：他在這台說「幫我收工」才會存上去。舊電腦還要用的話，提醒他照〈兩台電腦都在用〉：那一台下次開工先說「先幫我拉最新的」。

## 陳老師有新版：「陳老師有新版，幫我更新」

1. 先做〈每天存〉：更新之前他的東西先存好，合壞了還救得回來。
2. `git fetch upstream`。`Repository not found` → 同上，停。
3. `git merge-base HEAD upstream/main` 什麼都沒印（ZIP 來的）→ 停：「這份是 ZIP 來的，沒辦法自動併陳老師的新版，請問陳老師。」不要加 `--allow-unrelated-histories`（目錄每一列會變成兩份）。
4. `git -c core.quotepath=false log --oneline HEAD..upstream/main`：沒有東西 → 回「已經是最新的」，結束。
5. 跟他說陳老師改了什麼，他說好才往下：
   - `git -c core.quotepath=false diff --stat HEAD...upstream/main`：用白話說改了哪幾類（說明頁、手冊、技能）。
   - `git -c core.quotepath=false diff --name-only HEAD...upstream/main -- memory projects runbooks workspace material`：這裡列的是陳老師也改了、而且放在他的區域裡的檔（出廠的手冊、記事範本）。把檔名念給他：他沒改過的會換成陳老師的新版；他改過同一個檔的，兩邊的修改會合在一起。
6. `git merge --no-edit upstream/main`。沒衝突 → 第 7 步。有衝突 → `git -c core.quotepath=false diff --name-only --diff-filter=U` 列出來，**照規則**一個一個解：
   - 在他的區域 → 留他的：`git checkout --ours -- <檔>`。是出廠就有的手冊（例如 `裝工具.md`）也留他的，並告訴他「這本陳老師也改了，沒有換」。
   - 是骨架 → 用陳老師的：`git checkout --theirs -- <檔>`，並告訴他哪幾個檔換成陳老師的版本。
   - 全部解完：`git add -A`、`git commit --no-edit`。
   - 不是單純兩邊都改（一邊刪掉、改檔名），或你不確定 → `git merge --abort`，回到更新前，照實說，請他問陳老師。
7. 併完之後，**先把這一節從磁碟重讀一次**（這本手冊自己可能也換成新版了），照新版的這一步做。順序：
   - `runbooks/目錄.md`：把每一列 `→` 後面的檔名拿出來，看有沒有同一本手冊出現兩列（陳老師改了某一列的字，兩邊都留就會重複）。有 → 先跟他說要動這個檔，留陳老師的那一列。重數列數。
   - log 記一行「更新骨架：陳老師 <短碼>；換了哪些檔；目錄現在幾列」。
   - 再做一次〈每天存〉：合併、目錄的修正、log 一起存上去，照它的第 7 步驗。
   - 請他開新對話，貼「請讀 AGENTS.md，報到。」（公約可能換了）。

## 沒有 GitHub：「幫我打包一份」

他不開 GitHub 帳號、或單位不准 → 走這條。他說這句就打包，不必先問他有沒有 GitHub（有 GitHub 的人也可以多留一份）。只包五個資料夾（`memory`、`projects`、`runbooks`、`workspace`、`material`）：他的東西都在裡面，出廠的手冊也會一起包進去；其他骨架和套件不包。不用 GitHub 的人換電腦、拿陳老師的新版，都是同一條路：先打包 → 拿陳老師的新資料夾 → 還原。

### 打包

1. 掃個資：用上面那一行，把 `--untracked` 換成 `--no-index`（有沒有接 git 都這樣換：打包包的是磁碟上每一個檔，他說過不存 GitHub 的也在裡面，`--no-index` 才掃得到那些）。連 git 都沒有 → 跟他說「這次沒辦法自動掃」，請他自己想一下有沒有放真的證號、手機、學號。
2. **先**在 `memory/log.md` 記一行「打包備份：<檔名>」，再打包：這一行才會在備份裡。
3. 打包（檔名的日期直接寫數字，例如 20261110；沒有 `cache` 資料夾就先建；同一天要再包一次，檔名後面加 `-2`，不要蓋前一份）：
   - PowerShell：`Compress-Archive -Path memory,projects,runbooks,workspace,material -DestinationPath cache\AI夥伴-備份-20261110.zip -Force`
   - 你在 Git Bash：`powershell.exe -NoProfile -Command "Compress-Archive -Path memory,projects,runbooks,workspace,material -DestinationPath cache\AI夥伴-備份-20261110.zip -Force"`
   - Mac：`zip -r "cache/AI夥伴-備份-20261110.zip" memory projects runbooks workspace material`
4. 回讀。`Compress-Archive` 成功時什麼都不印，結束碼也不可靠，要自己數（PowerShell；在 Git Bash 就把整行用**單引號**包起來，放在 `powershell.exe -NoProfile -Command` 後面）：

   ```
   Add-Type -AssemblyName System.IO.Compression.FileSystem; $z=[IO.Compression.ZipFile]::OpenRead((Resolve-Path cache\AI夥伴-備份-20261110.zip)); ($z.Entries | Where-Object { $_.Name }).Count; $z.Dispose(); (Get-ChildItem memory,projects,runbooks,workspace,material -Recurse -File).Count
   ```

   Mac：`unzip -Z1 "cache/AI夥伴-備份-20261110.zip" | grep -vc '/$'; find memory projects runbooks workspace material -type f | wc -l`

   要印出**兩個數字而且一樣**（ZIP 裡的檔數＝五個資料夾的檔數）才算包好。只印一個數字、有紅字、兩個不一樣 → 沒包好，照實說。Windows 上帶「隱藏」屬性的檔不會進 ZIP、兩邊也都不算（Word、Excel 開著時的 `~$` 暫存檔就是這種，不要緊）；他有刻意設成隱藏的檔，要請他自己另外搬。
5. 告訴他檔案在哪、多大、裡面幾個檔（他說過不存 GitHub 的檔也在這一包裡），請他**自己**搬到雲端硬碟或隨身碟。`cache/` 裡的那一份不會被存上 GitHub，也不保證留著；你不要替他搬，他說搬走了才刪 `cache/` 那一份。

### 還原：「幫我把這份備份還原進來」

在陳老師給的新資料夾裡做。ZIP 裡的五個資料夾會**蓋掉**這個資料夾的同名檔，連這本手冊也會被蓋成打包那天的舊版：照你現在讀到的這一版做完，中途不要重讀。

1. 先說再做：「備份裡的檔會蓋掉這個資料夾裡同名的檔。」他說好才往下。他已經在這個資料夾裡寫過東西 → 蓋掉就救不回來，先請他把整個資料夾複製一份，他說複製好了才解開。怎麼知道寫過：沒接 git（`git status` 說 `not a git repository`）就問他；有接 git 就看 `git -c core.quotepath=false status --short -uall --ignored -- memory projects runbooks workspace material`，列得出東西＝有還沒存的（git 只救得回存過的版本）。`!!` 開頭的是 git 從來沒存過的檔（他說過不存 GitHub 的、被 `.gitignore` 擋掉的），蓋掉一樣救不回來；路徑裡有 `__pycache__` 的是程式的暫存，不算。
2. **沒接 git 才做**：解開之前，先把陳老師的新版留一份（有接 git 的不用，git 換得回來）。`cache/陳老師新版` 已經在＝這個資料夾還原過一次 → **不要再複製**（現在的五個資料夾已經混了他的檔，再複製會把留著的那份新版蓋掉），用原來那一份，直接做第 3 步。
   - PowerShell：`New-Item -ItemType Directory -Force cache\陳老師新版 | Out-Null; Copy-Item memory,projects,runbooks,workspace,material cache\陳老師新版 -Recurse -Force`
   - Git Bash 或 Mac：`mkdir -p cache/陳老師新版 && cp -R memory projects runbooks workspace material cache/陳老師新版/`
3. 解開：
   - PowerShell：`Expand-Archive -Path "<ZIP 的路徑>" -DestinationPath . -Force`
   - 你在 Git Bash：`powershell.exe -NoProfile -Command "Expand-Archive -Path '<ZIP 的路徑>' -DestinationPath . -Force"`
   - Mac：`unzip -o "<ZIP 的路徑>" -d .`
4. 把出廠的東西換回陳老師的新版（備份裡的是打包那天的舊版）。兩種資料夾的規則一樣，只是拿來比的東西不同。

   **有接 git：**
   - `git -c core.quotepath=false status --short -uall`，一個一個看：`??`＝多半是他新增的檔（他寫的手冊、他的計畫夾、成品、參考資料），也可能是陳老師新版已經拿掉的舊出廠檔 → 都留著；` M memory/…`、` M projects/` 底下各計畫夾裡的檔、他自己寫的手冊 → 留備份的（他的）；` M runbooks/目錄.md` 與其他標 ` M` 的出廠檔 → 照下面兩條規則。目錄用 `git -c core.quotepath=false diff -- runbooks/目錄.md` 看；出廠檔要換回新版用 `git checkout -- <檔>`（換回的是這個資料夾上次存的版本：剛從陳老師那邊拿的資料夾，那就是陳老師的新版；他在這個資料夾存過自己改的那個檔，換回的是他存的那一版，跟他說一聲）。
   - 他不存 GitHub 的話，這些改動留在資料夾裡就好，不用 commit。

   **沒接 git**（拿第 2 步留的那一份比）：
   - `git -c core.quotepath=false -c core.safecrlf=false diff --no-index --stat cache/陳老師新版/runbooks runbooks`：列出內容不一樣的手冊，和只有他那邊有的手冊（多半是他寫的，也可能是陳老師新版已經拿掉的舊手冊；都留著）。結束碼 1＝有不一樣，不是失敗。（`-c core.safecrlf=false` 不能省：少了它，Windows 會每個檔多印一行 `LF will be replaced by CRLF` 的提醒，把結果洗掉。）目錄用 `git -c core.quotepath=false -c core.safecrlf=false diff --no-index cache/陳老師新版/runbooks/目錄.md runbooks/目錄.md` 看；出廠檔要換回新版用 `Copy-Item "cache\陳老師新版\runbooks\<檔>" runbooks -Force`（Git Bash 或 Mac：`cp "cache/陳老師新版/runbooks/<檔>" runbooks/`）。
   - 同一行把兩個 `runbooks` 換成 `projects`、`material`、`workspace`，各看一次。只有他那邊有的（他的計畫夾、參考資料、成品）→ 留著；`projects/` 底下各計畫夾裡的檔 → 他的，留著；其他內容不一樣的（各資料夾的 `README.md`、`material/範例-改名前後.md` 這類）→ 照下面〈出廠檔的規則〉，換回新版的寫法一樣，把路徑裡的 `runbooks` 換成那個資料夾。`memory/` 不用比，裡面都是他的。
   - 連 git 都沒有 → 用這一行列出內容不一樣的手冊：`Get-ChildItem cache\陳老師新版\runbooks -File | Where-Object { (Get-FileHash $_.FullName).Hash -ne (Get-FileHash (Join-Path runbooks $_.Name)).Hash } | ForEach-Object { $_.Name }`（Mac：`diff -rq cache/陳老師新版/runbooks runbooks`，`differ` 那幾行是內容不一樣的，`Only in runbooks` 那幾行是只有他那邊有的），目錄兩份都打開來對；其他三個資料夾的出廠檔一個一個問他。

   **目錄的規則**：`+` 開頭的列（備份有、陳老師新版沒有）念給他：他加的 → 留著；他不認得的 → 多半是陳老師新版已經拿掉的舊手冊，他說好就把那一列從目錄拿掉（那本手冊的檔留著不刪）。有 `-` 開頭的列（陳老師新版有、備份沒有）→ 先跟他說，把那幾列加回目錄檔尾；加完看有沒有同一本手冊出現兩列（把每一列 `→` 後面的檔名拿出來比），有就留陳老師的那一列。重數列數。

   **出廠檔的規則**（內容不一樣、不是他寫的，例如 `裝工具.md`、`projects/README.md`）：問他「這個檔你改過嗎？」沒改過 → 換回陳老師的新版；改過 → 留他的，告訴他「這個檔陳老師也改了，沒有換」。
5. 回讀：他的手冊、成品、參考資料各挑一個打開看得到；`runbooks/目錄.md` 的列數念給他。log 記一行「還原備份：<ZIP 檔名>；目錄幾列；哪幾個出廠檔換回陳老師新版」。`cache/陳老師新版` 先留著不刪（他之後想把哪個檔換回新版還用得到）。請他開新對話，貼「請讀 AGENTS.md，報到。」

## 驗收

- 第一次：第 9 步三項都過，而且他在瀏覽器看過 Private，才回「存好了」。
- 每天存、拉最新的、更新骨架：回他「存好了」之前，`status -sb` 沒有 `ahead`、`ls-remote` 跟 `rev-parse` 對得上。
- 打包：回讀的兩個數字一樣，才說包好了、檔在哪。
- 還原：他的檔打得開、目錄列數念過，才說還原好了；哪些出廠檔換回陳老師新版、哪些留他的，都跟他說。
- 沒過就說沒過：卡在哪一步、畫面上的原文。

## 未試

- 2026-11-10 在陳老師的 Windows 電腦真的跑過的：〈第一次〉走 A，第 0 到 11 步，由一個沒看過這本的 AI 夥伴照著做，存到 GitHub 上真的 Private repo；另外從外面回讀過（`gh repo view` 是 PRIVATE、不登入去看是 404、本機和遠端的 HEAD 一樣、`upstream` 的 push 還是 `no_push`）。那一次用的是前一版資料夾（給行政同仁的那一版，還沒有 `projects/`）。
- 2026-11-11 在同一台電腦、用五個資料夾的假資料夾（裡面全是假資料）一行一行跑過的：
  - 〈掃個資〉：沒接 git 的資料夾用 `--no-index`，掃得到放在 `projects/` 計畫夾裡的假號碼；有接 git 的資料夾裡，寫進 `.git/info/exclude` 的檔 `--untracked` 掃不到、`--no-index` 掃得到。
  - 〈打包〉第 3、4 步：PowerShell 5.1、PowerShell 7、Git Bash 三種寫法，回讀的兩個數字都一樣。
  - 〈還原〉第 2 到 4 步「沒接 git」的每一行：PowerShell 5.1、PowerShell 7，Git Bash 的 `cp` 寫法也跑過。
  - 〈還原〉第 3、4 步「有接 git」的每一行（`status`、看目錄的 `diff`、`git checkout -- <檔>`）。
  - 〈還原〉第 1 步加了 `--ignored` 的那一行：寫進 `.git/info/exclude` 的檔列成 `!!`，`cache/` 裡的不會列出來。〈每天存〉第 4 步：已經 `git add` 過的檔，寫進 exclude 之後 `status` 照樣列得出來。
  - 同一天另外用前一版資料夾試過兩件（跟資料夾有幾個無關）：`Compress-Archive` 不收帶「隱藏」屬性的檔（PowerShell 5.1 與 7 都一樣，檔名開頭是點的照收）；`curl.exe` 不登入去看，Private 的 repo 印 404、公開的印 200。
- 11-11 那幾項是陳老師那邊逐行打指令、看結果。**還沒有 AI 夥伴照〈打包〉〈還原〉兩段從頭走過一遍**，也沒用主人真的資料夾試過。〈每天存〉〈兩台電腦都在用〉〈換電腦之後〉〈陳老師有新版〉在這一版也沒有照著走過的紀錄。第一次做的時候每一步都照實回報，卡住就停。
- 只寫了做法、沒有造出來跑過的情形：同一個資料夾還原第二次（`cache/陳老師新版` 已經在）；他存過自己改的出廠檔之後再 `git checkout -- <檔>`；備份帶回陳老師新版已經拿掉的舊出廠檔。
- Mac 的每一行（`zip`、`unzip`、數檔數、Mac 上的 `cp -R`、`diff -rq`）都還沒跑過；`diff -rq` 那一行只在 Windows 的 Git Bash 跑過。Windows 包的 ZIP 拿到 Mac 還原、或反過來，也沒試過。五個資料夾裡有捷徑（symlink）時，Mac 的 `zip -r` 和 `find -type f` 算法不同，回讀的兩個數字可能對不上（推論，沒試）：對不上就照〈打包〉第 4 步當沒包好，照實說。
- 沒登入時重新登入（`gh auth login` 的代碼流程）、〈沒有 GitHub CLI〉整段、〈第一次〉走 B（ZIP 來的資料夾）：都還沒跑過。走到這幾段，卡住就停，不要硬做。
