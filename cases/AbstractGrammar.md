# Внутреннее устройство класса AbstractGrammar

В данном файле приводятся правила базового класса грамматики, которые описаны в классе 
[AbstractGrammar](https://github.com/veged/ometa-js/blob/nodejs/lib/ometajs/core/grammar.js#L437).

Метод `_rule` имеет 5 аргументов:

    name {String} rule name
    nocache {Boolean}  If true - rule will be applied without left-recursion check.
    args {Array} (optional) arguments
    cons {AbstractGrammar}
    body {Function} rule's body

AbstractGrammar Rules:

- token
- anything
- space
- spaces
- fromTo(from, to)
- exactly
- char
- letter
- digit
- seq
- listOf
- empty
- end


## fromTo

Обратите внимание на параметры, которые передаются в метод `_rule` в следующих скомпилированных выражениях.
```ometajs-eval        
    fromTo('/*', '*/')
        /* this is a comment */
```

## digit

```ometajs-eval
    digit
        5
    ^digit
        5
```

## seq

В отличии от простой строки в метод `seq` можно передать параметр
```ometajs-eval
    seq('qwe')
        qwer
```

## apply

apply - это правило, которое вызывает применение указанного в первом аргументе правила. 
Остальные аргументы передаются в качестве параметров этому правилу. 
```ometajs-eval
    apply('fromTo', '/*', '*/')
        /* this is a comment */ and this is a code
```

## listOf

Список из последовательностей записанных через разделитель. 
Последовательности должны удовлетворять правилу, указанному в первом аргументе.
Разделитель задается во втором аргументе
```ometajs-eval
    listOf(`digit, '..')
        1..2..3..4..5i
```