require 'ometajs'
fs = require 'fs'

# settings
dirName = 'grammars'

loadGrammars = ->
  files = fs.readdirSync dirName
  files = files.filter (f) -> f.match /\.ometajs$/
  for file in files
    name = (file.match /^(\w+)\.ometajs$/)[1]
    global[name] = (require './' + dirName + '/' + file)[name]

loadGrammars()

matchAll = (grammar, text, rule) ->
  JSON.stringify grammar.matchAll(text, rule)