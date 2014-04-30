## Get Intermediate & string

`#name` compiles to string

```ometajs-expr-eval
    :s -> [#spaces, s.replace(/[ \t]+\n/g, '\n')]
```

## Rule names in expression

```ometajs-expr-eval
    rule1:r1 rule2 -> [r1] | rule3:r3 -> [r3]
```

