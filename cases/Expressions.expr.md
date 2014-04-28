## Sequence match ``123''
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L322>

```ometajs-expr-eval
    ``123''
        12
        1234
```

## Token match "123"
<http://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L316>

```ometajs-expr-eval
    "123"
        123
        123 4
        1234
        12
    "123"*
        123 123 123
```

## String match '123'
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L312>

```ometajs-expr-eval
    'a'
        a
    'aa'
        aa
```

## Number match 123
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L308>

## Rule invocation name or name(...)
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L291>

## Host language result -> { ..code.. }
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L286>

```ometajs-expr-eval
     -> { 1+1 }
        la la la
    ^digit:a ^digit:b -> { a*b }
        78
```

## Not
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L28>

```ometajs-expr-eval
    ~"666" -> { 'ok' }
        666
        6666
```

## Lookahead
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L276>

```ometajs-expr-eval
    ``123'' & ``456''
        123456
```

## Regexp @/.../
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L272>

```ometajs-expr-eval
    @/\d+/
        123
```

## Local %host-language-code
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L264>

## Predicate ?host-language-code
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L258>

```ometajs-expr-eval
    ?this._match('2')
```

## Super call ^rule
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L250>

```ometajs-expr-eval
    ^digit
        5
```

## String's chars match < a b c >
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L239>

```ometajs-expr-eval
    <'a' 's' 'd'>
        asdf
```

## Array match [ a b c ]
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L228>

## Choice group (a | b | c)
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L212>

```ometajs-expr-eval
    ('a'|'b'|'c')
        b
```