import json, re, sys
from pathlib import Path

root = Path(__file__).parent
out = root.parent / "app" / "lib" / "i18n"

def read(lang):
    props = {}
    for line in (root / "bundles" / f"messages_{lang}.properties").read_text(encoding="utf-8").splitlines():
        if line.strip() and not line.startswith("#"):
            k, v = line.split("=", 1)
            props[k.strip()] = v.strip()
    return props

def ident(key):  # ticket.form.title -> ticketFormTitle
    first, *rest = key.split(".")
    return first + "".join(p[0].upper() + p[1:] for p in rest)

for lang in ("de", "en"):
    arb = {"@@locale": lang}
    for key, text in read(lang).items():
        arb[ident(key)] = text
        names = re.findall(r"\{(\w+)\}", text)
        if names:
            arb["@" + ident(key)] = {"placeholders": {n: {"type": "String"} for n in names}}
    (out / f"app_{lang}.arb").write_text(json.dumps(arb, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("geschrieben:", f"app_{lang}.arb")
