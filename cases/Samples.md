Прочие примеры, пока не отнесенные ни к одной из категорий

```ometajs-eval
    between :t :n = (apply(t) -> ShmakoWiki.arrAdd(n, t)):nn (~oneOf(ShmakoWiki.arrCopy(nn)) allInline(nn))*:c apply(t) -> c,
    fromTo :x :y = seq(x):s (~seq(y) char)*:c seq(y):e -> [s, c.join(''), e]
```

## oneOf

Вариант, встреченный в shmakowiki:
```
    oneOf :a ?(a.length == 1) = apply(a.pop()),
    oneOf :a ?(a.length > 1) = apply(a.pop()) | oneOf(a),
```

Более удачный вариант:
```ometajs-eval
    oneOf :a = apply(a.pop()) | ?(a.length > 0) oneOf(a),
```

```ometajs-eval
    trans = [:t apply(t):ans] -> ans,
```

## _offset, _source

```
ometa Chars {
    ch = char:c -> this._source.substr(0, this._offset),
    chars = ch+
}
```