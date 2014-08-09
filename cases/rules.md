## Intermediate value in rule name

```ometajs-eval
    :s -> [#spaces, s.replace(/[ \t]+\n/g, '\n')]
```

```ometajs-eval
    between :t :n = (apply(t) -> ShmakoWiki.arrAdd(n, t)):nn (~oneOf(ShmakoWiki.arrCopy(nn)) allInline(nn))*:c apply(t) -> c,
```