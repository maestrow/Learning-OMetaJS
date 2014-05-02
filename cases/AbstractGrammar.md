## Внутреннее устройство класса AbstractGrammar

### _rule

Метод имеет 5 аргументов:

    name {String} rule name
    nocache {Boolean}  If true - rule will be applied without left-recursion check.
    args {Array} (optional) arguments
    cons {AbstractGrammar}
    body {Function} rule's body

Обратите внимание на параметры, которые передаются в метод `_rule` в следующих скомпилированных выражениях.

```ometajs-eval
    digit
        5
    ^digit
        5
    fromTo('/*', '*/')
        /* this is a comment */
```


## AbstractGrammar Rules

- digit
- letter
- fromTo(from, to)