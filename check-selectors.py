#!/usr/bin/env python3
"""Fail if a compiled css drops any selector present in the upstream Cinnamon css.
usage: check-selectors.py upstream.css themed.css..."""
import re, sys

def norm(sel):
    # pseudo-class order inside a compound selector is irrelevant (:hover:default == :default:hover)
    return ' '.join(re.sub(r'((?::[\w-]+)+)', lambda m: ''.join(sorted(re.findall(r':[\w-]+', m.group(1)))), c)
                    for c in sel.split())

def selectors(path):
    s = re.sub(r'/\*.*?\*/', '', open(path).read(), flags=re.S)
    return {norm(x) for m in re.finditer(r'([^{}]+)\{[^{}]*\}', s)
            for x in m.group(1).split(',') if x.strip()}

up = selectors(sys.argv[1])
bad = False
for f in sys.argv[2:]:
    missing = sorted(up - selectors(f))
    for m in missing: print(f'{f}: dropped upstream selector {m}')
    bad |= bool(missing)
sys.exit(bad)
