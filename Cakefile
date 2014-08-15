# http://www.mikedellanoce.com/2013/04/coffeescript-tip-modular-cakefile.html
fs = require('fs')
regEx = new RegExp '\.coffee$'
tasks = fs.readdirSync('tasks')
require('./tasks/' + t.replace(regEx, '')) for t in tasks when regEx.test t

task 'options', 'options test', (opts) ->
  console.log opts



