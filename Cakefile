# http://www.mikedellanoce.com/2013/04/coffeescript-tip-modular-cakefile.html
fs = require('fs')
regEx = new RegExp '\.coffee$'
tasks = fs.readdirSync('tasks')
require('./tasks/' + task.replace(regEx, '')) for task in tasks when regEx.test task
