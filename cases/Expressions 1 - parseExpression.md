# OMetaJS Expressions Use Cases

Реализацию обработки описанных синтаксических конструкций смотрите в методе
[parseExpresion](https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L179) парсера.

## Sequence match ``123''
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L322>

```ometajs-eval
    ``123''
        12
        1234
```

## Token match "123"
<http://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L316>

```ometajs-eval
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

```ometajs-eval
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

```ometajs-eval
     -> { 1+1 }
        la la la
    ^digit:a ^digit:b -> { a*b }
        78
```

## Not
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L28>

```ometajs-eval
    ~"666" -> { 'ok' }
        666
        6666
```

## Lookahead
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L276>

```ometajs-eval
    ``123'' & ``456''
        123456
```

## Regexp @/.../
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L272>

```ometajs-eval
    @/\d+/
        123
```

## Local %host-language-code
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L264>

## Predicate ?host-language-code
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L258>

```ometajs-eval
    ?this._match('2')
```

Other examples:
* `'<' ?{this._options.phase == 'pre'} | '>' ?{this._options.phase == 'post'}`

## Super call ^rule
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L250>

```ometajs-eval
    ^digit
        5
```

## String's chars match < a b c >
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L239>

```ometajs-eval
    <'a' 's' 'd'>
        asdf
```

## Array match [ a b c ]
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L228>

## Choice group (a | b | c)
<https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/parser.js#L212>

```ometajs-eval
    ('a'|'b'|'c')
        b
```

