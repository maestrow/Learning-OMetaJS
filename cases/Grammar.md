
Пример наследования и использования произвольных методов в грамматике.

```
var Extmd = require('../Extmd.ometajs').Extmd;

ometa ExtmdTest <: Extmd {
	small = 'a':c -> this.upper(c),
	big = 'A':c -> lower(c)
}

ExtmdTest.prototype.upper = function (c) {
	return c.toUpperCase();
};

var lower = function (c) {
	return c.toLowerCase();
};
```