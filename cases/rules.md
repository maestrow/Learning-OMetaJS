## Atomic operation

Starts atomic operation which can either fail or success (won't be commited partially).

В следующем перимере один и тот же шаблон выполняется как неатомарная и как атомарная операция. 
В первом случае будет возвращено значение сопоставления текста с последним выражением. 
Во втором - весь текст, как успешно сопоставленный выражению в скобках.
```ometajs-eval
    `a `b
        ab
    (`a `b)
        ab
```

Операнды оператора ИЛИ выполняются как атомарная операция:
```ometajs-eval
    `a | `b `c
        a
        bc
```

Оператор & (lookahead) создает атомарную операцию
```ometajs-eval
    `a & `b `b
        abb
        ab
        a
```


## Преобразование значения ->

Оператор `->` может быть использован после обращению к любому правилу.

```
    ('a':c -> c.toUpperCase()):x ('B':c -> c.toLowerCase()):y -> x+y
```

## Variables

### Variable in expression

```ometajs-eval
    char:x char:y -> [y, x]
        12
```

### Rule with parameters

```ometajs-eval
    fromTo :x :y = seq(x):s (~seq(y) char)*:c seq(y):e -> [s, c.join(''), e]
```


## Intermediate value in rule name

```ometajs-eval
    :s -> [#spaces, s.replace(/[ \t]+\n/g, '\n')]
```

