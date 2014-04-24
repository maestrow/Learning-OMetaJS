###
  sample:
  eval {
    expr: '^digit:a ^digit:b -> a*b'
    input: '56'
  }
###

ometajs = require 'ometajs'
beautify = require './tools/beautify'
fs = require 'fs'

# Common utils

requireFromString = (src, filename) ->
  m = new module.constructor
  m._compile src, filename
  m.exports

skipLines = (text, lines) ->
  text.split('\n').slice(lines).join('\n')

fromFile = (val) ->
  fs.readFileSync val, encoding: 'utf8'

# Business logic heplers

grammarType = {'grammar', 'expr'}

compilationFormat = {'ast', 'json', 'js'}

getGrammarObjectByPath = (path) ->
  pathParts = path.split '/'
  mainGrammarName = pathParts[pathParts.length - 1]
  require(path)[mainGrammarName]

getGrammarObjectByText = (code, grammarName) ->
  src = ometajs.compile code
  requireFromString(src)[grammarName]

generatedGrammarName = 'GeneratedGrammar'

generatedRuleName = 'generatedRule'

generateGrammar = (expression) ->
  "ometa #{generatedGrammarName} {
       #{generatedRuleName} = #{expression}
  }
  "

# Business logic

getGrammarText = (config) ->
  if config.grammarPath? then fromFile config.grammarPath
  else if config.expr? then generateGrammar config.expr
  else throw new Error 'Argument exception'

getGrammarObject = (config) ->
  if config.grammarPath? then getGrammarObjectByPath config.grammarPath
  else if config.expr? then getGrammarObjectByText getGrammarText(config), generatedGrammarName
  else throw new Error 'Argument exception'

getGrammarAst = (config) ->
  parser = ometajs.parser.create getGrammarText config
  parser.execute()

# Public methods

###
  config:
    grammarPath
    expr
    exprPath
    action
    input
    rule
    options
###
exports.eval = (config) ->
  grammar = getGrammarObject config
  config.action = config.action || 'matchAll'
  result = grammar[config.action] config.input, config.rule || generatedRuleName
  result.toString()

###
  config:
    grammarPath
    expr
    exprPath
    truncate
    format
###
exports.compile = (config) ->
  ast = getGrammarAst config
  compiler = ometajs.compiler.create ast
  result = compiler.execute()
  switch config.format
    when compilationFormat.ast
      data = if config.truncate then ast[0][3][0][2][0] else ast
      beautify JSON.stringify data
    when compilationFormat.json
      data = if config.truncate then compiler.result[1] else compiler.result
      beautify JSON.stringify data
    else # js
      skipLines beautify(result), if config.truncate then 13 else 0