/*
Suppose that when you evaluate an expression, you get an error:

 > coffee cli.coffee eval "^digit:a ^digit:b -> a+b" "56"
 Error: generatedRule rule failed at: 1:1


 56
 ^
 at GeneratedGrammar.getError [as _getError] (C:\Users\Андрей\AppData\Roaming\npm\node_modules\omet
 ajs\lib\ometajs\core\grammar.js:84:37)
 at Function.matchAll (C:\Users\Андрей\AppData\Roaming\npm\node_modules\ometajs\lib\ometajs\core\gr
 ammar.js:61:17)
 at Object.exports.eval (Z:\tmp\coffeescript\commander\lib\grammar.js:112:36)
 at Command.evaluate (Z:\tmp\coffeescript\commander\cli.coffee:57:21)
 at Command.<anonymous> (C:\Users\Андрей\AppData\Roaming\npm\node_modules\commander\index.js:249:8)

 at Command.EventEmitter.emit (events.js:98:17)
 at Command.parseArgs (C:\Users\Андрей\AppData\Roaming\npm\node_modules\commander\index.js:478:12)
 at Command.parse (C:\Users\Андрей\AppData\Roaming\npm\node_modules\commander\index.js:370:21)
 at Object.<anonymous> (Z:\tmp\coffeescript\commander\cli.coffee:104:5)
 at Object.<anonymous> (Z:\tmp\coffeescript\commander\cli.coffee:1:1)
 at Module._compile (module.js:456:26)

Then you can compile that expression:
 > coffee cli.coffee compile "^digit:a ^digit:b -> a+b" -o expr.js
and debug it
 */

var grammar = require('./../tmp/testGrammar.js').GeneratedGrammar;
var result = grammar.matchAll('55', 'generatedRule');
console.log(result);