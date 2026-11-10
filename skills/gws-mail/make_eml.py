# -*- coding: utf-8 -*-
"""make_eml — 在本機組一封 .eml（UTF-8 內文、中文檔名附件、可串接原信），交給 gws 建成 Gmail 草稿。

為什麼要這支：寄信、建草稿、帶附件一律走 gws；gws 用 --upload 直接把 .eml 傳上去，
附件不會經過 AI 的對話。每次手寫一段 Python 組信容易錯，所以固化成這支（起手框架版，
改自原團隊的 skills/gws-mail/make_eml.py）。

  uv run --no-project python skills/gws-mail/make_eml.py --to someone@example.com --subject "主旨" \
      --body-file cache/_mail/body.txt --attach 報表.xlsx --out cache/_mail/draft.eml

之後（在資料夾根目錄執行）：
  gws gmail users drafts create --params '{"userId":"me"}' \
      --upload "cache/_mail/draft.eml" --upload-content-type message/rfc822

規矩（寫在 SKILL.md，這裡只提醒）：
- 只建草稿，不寄。主人在 Gmail 看過全文、自己按「傳送」。
- .eml 可能含個資：這個資料夾裡只准放 cache/（已 gitignore）、用完就刪。
- gws 的 --upload 只吃「執行 gws 時所在資料夾」底下的檔，所以 .eml 放 cache/、用相對路徑。
"""
from __future__ import annotations

import argparse
import mimetypes
import sys
from email.message import EmailMessage
from email import policy
from pathlib import Path

for _st in (sys.stdout, sys.stderr):
    try:
        _st.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

# 起手框架版：From 留空＝由 Gmail 以登入帳號填；簽名檔有才附（放這支旁邊的 signature.txt）
DEFAULT_SIGNATURE_PATH = Path(__file__).with_name("signature.txt")

MIME_OVERRIDE = {
    ".xlsx": ("application", "vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
    ".docx": ("application", "vnd.openxmlformats-officedocument.wordprocessingml.document"),
    ".pptx": ("application", "vnd.openxmlformats-officedocument.presentationml.presentation"),
    ".pdf": ("application", "pdf"),
}


def _git_repo_root(start: Path):
    cur = start.resolve()
    for parent in [cur, *cur.parents]:
        if (parent / ".git").exists():
            return parent
    return None


def check_out_path(out: Path) -> None:
    """.eml 可能含個資：在 git 資料夾裡只准放 cache/；資料夾外隨意（但 gws 的 --upload 看的是執行時所在的資料夾）。"""
    repo = _git_repo_root(out.parent if not out.is_dir() else out)
    if repo:
        rel = out.resolve().relative_to(repo).as_posix()
        if not (rel == "cache" or rel.startswith("cache/")):
            sys.exit(f"拒寫：{out} 在這個資料夾裡但不在 cache/ 底下。.eml 可能含個資——放 cache/（已 gitignore）或資料夾外。")


def append_signature(body: str, signature: str | None) -> str:
    if signature is None:
        if not DEFAULT_SIGNATURE_PATH.exists():
            return body
        signature = DEFAULT_SIGNATURE_PATH.read_text(encoding="utf-8-sig")
    sig = signature.strip()
    if not sig or sig in body:
        return body
    return f"{body.rstrip()}\n\n{sig}\n"


def compose_eml(*, from_addr: str, to, subject: str, body: str,
                cc=None, bcc=None, attachments=None, in_reply_to: str | None = None,
                references: str | None = None, include_signature: bool = True,
                signature: str | None = None) -> bytes:
    msg = EmailMessage(policy=policy.SMTP)   # SMTP policy → \r\n 行尾
    if from_addr:
        msg["From"] = from_addr
    msg["To"] = ", ".join(to) if isinstance(to, (list, tuple)) else to
    if cc:
        msg["Cc"] = ", ".join(cc) if isinstance(cc, (list, tuple)) else cc
    if bcc:
        msg["Bcc"] = ", ".join(bcc) if isinstance(bcc, (list, tuple)) else bcc
    msg["Subject"] = subject
    if in_reply_to:
        msg["In-Reply-To"] = in_reply_to
        msg["References"] = references or in_reply_to
    msg.set_content(append_signature(body, signature) if include_signature else body)
    for ap in (attachments or []):
        p = Path(ap)
        if not p.exists():
            sys.exit(f"附件不存在：{p}")
        ext = p.suffix.lower()
        if ext in MIME_OVERRIDE:
            maintype, subtype = MIME_OVERRIDE[ext]
        else:
            guess, _ = mimetypes.guess_type(p.name)
            maintype, subtype = (guess.split("/", 1) if guess else ("application", "octet-stream"))
        msg.add_attachment(p.read_bytes(), maintype=maintype, subtype=subtype, filename=p.name)
    return bytes(msg)


def main(argv=None):
    ap = argparse.ArgumentParser(prog="make_eml", description="組 .eml（交給 gws drafts create 建草稿）")
    ap.add_argument("--from", dest="from_addr", default="", help="寄件人；留空由 Gmail 以登入帳號填")
    ap.add_argument("--to", action="append", required=True, help="收件人（可重複）")
    ap.add_argument("--cc", action="append", default=None)
    ap.add_argument("--bcc", action="append", default=None, help="密件副本（可重複；整批通知用，收件人互相看不到）")
    ap.add_argument("--bcc-file", default=None, help="BCC 名單檔，一行一個 email")
    ap.add_argument("--subject", required=True)
    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument("--body", help="內文字串")
    g.add_argument("--body-file", help="內文檔（UTF-8）")
    ap.add_argument("--signature-file", default=None, help="純文字簽名檔；沒給就用同夾 signature.txt（沒有這個檔就不附）")
    ap.add_argument("--no-signature", action="store_true", help="不附簽名")
    ap.add_argument("--attach", action="append", default=[], help="附件路徑（可重複）")
    ap.add_argument("--in-reply-to", default=None, help="原信 RFC822 Message-ID（回信串接用）")
    ap.add_argument("--references", default=None, help="預設同 --in-reply-to")
    ap.add_argument("--out", required=True, help="輸出 .eml（資料夾內限 cache/，用完就刪）")
    args = ap.parse_args(argv)

    body = args.body if args.body is not None else Path(args.body_file).read_text(encoding="utf-8-sig")
    signature = (Path(args.signature_file).read_text(encoding="utf-8-sig") if args.signature_file else None)
    bcc = list(args.bcc or [])
    if args.bcc_file:
        bcc += [l.strip() for l in Path(args.bcc_file).read_text(encoding="utf-8").splitlines() if l.strip()]
    out = Path(args.out)
    check_out_path(out)
    raw = compose_eml(from_addr=args.from_addr, to=args.to, cc=args.cc, bcc=bcc or None, subject=args.subject,
                      body=body, attachments=args.attach, in_reply_to=args.in_reply_to,
                      references=args.references, include_signature=not args.no_signature, signature=signature)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_bytes(raw)
    print(f"→ {out.as_posix()}（{len(raw)} bytes，附件 {len(args.attach)} 件）")
    print("下一步（只建草稿，主人看過自己寄）：")
    print(f"  gws gmail users drafts create --params '{{\"userId\":\"me\"}}' "
          f"--upload \"{out.as_posix()}\" --upload-content-type message/rfc822")
    print(r"  （在 PowerShell：開頭改打 gws.cmd，--params 寫成 '{\"userId\":\"me\"}'，其他照上一行；見 SKILL.md）")


if __name__ == "__main__":
    main()
