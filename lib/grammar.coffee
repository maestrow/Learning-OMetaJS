###
  sample:
  eval {
    parser: '^digit:a ^digit:b -> a*b'
    input: '56'
  }
###

ometajs = require 'ometajs'
beautify = require './tools/beautify'
fs = require 'fs'

# Common utils

Array::last = -> @[@length - 1]

requireFromString = (src, filename) ->
  m = new module.constructor
  m.paths = module.paths;
  m._compile src, filename
  m.exports

skipLines = (text, lines) ->
  text.split('\n').slice(lines).join('\n')

fromFile = (val) ->
  fs.readFileSync val, encoding: 'utf8'

# Business logic heplers

parserFormat = {'grammar', 'rule', 'expr'}

compilationFormat = {'ast', 'json', 'js'}

getGrammarObjectByPath = (path) ->
  pathParts = path.split '/'
  mainGrammarName = pathParts[pathParts.length - 1]
  require(path)[mainGrammarName]

getGrammarObjectByText = (code, grammarName) ->
  getRrammarName = (code) ->
    matches = code.match         /ometa (\w+)/g
    match = matches.last().match /ometa (\w+)/
    match[1]
  grammarName ?= getRrammarName code
  src = ometajs.compile code
  requireFromString(src)[grammarName]

generatedGrammarName = 'GeneratedGrammar'

generatedRuleName = 'generatedRule'

generateGrammarByRule = (rule) ->
  "ometa #{generatedGrammarName} {
       #{rule}
  }
  "

generateGrammarByExpr = (expression) ->
  generateGrammarByRule "#{generatedRuleName} = #{expression}"

# Business logic

getGrammarText = (config) ->
  if config.parserPath? then fromFile config.parserPath
  else if config.parser?
    switch config.parserFormat
      when parserFormat.grammar then config.parser
      when parserFormat.rule then generateGrammarByRule config.parser
      when parserFormat.expr then generateGrammarByExpr config.parser
      else
        if config.parser.match /\=/ then generateGrammarByRule config.parser
        else generateGrammarByExpr config.parser
  else throw new Error 'Argument exception'

getGrammarObject = (config) ->
  if config.parserPath? then getGrammarObjectByPath config.parserPath
  else if config.parser? then getGrammarObjectByText getGrammarText(config)
  else throw new Error 'Argument exception'

getGrammarAst = (config) ->
  parser = ometajs.parser.create getGrammarText config
  parser.execute()

# Public methods

###
  config:
    parserPath
    parser
    exprPath
    action
    input
    applyRule
    options
###
exports.eval = (config) ->
  grammar = getGrammarObject config
  config.action = config.action || 'matchAll'
  result = grammar[config.action] config.input, config.applyRule || generatedRuleName
  result.toString()

###
  config:
    parserPath | parser,
    parserFormat,
    truncate,
    outputFormat
###
exports.compile = (config) ->
  ast = getGrammarAst config
  compiler = ometajs.compiler.create ast
  result = compiler.execute()
  switch config.outputFormat
    when compilationFormat.ast
      data = if config.truncate then ast[0][3][0][2][0] else ast
      beautify JSON.stringify data
    when compilationFormat.json
      data = if config.truncate then compiler.result[1] else compiler.result
      beautify JSON.stringify data
    else # js
      skipLines beautify(result), if config.truncate then 13 else 0