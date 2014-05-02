grammar = require '../../lib/grammar'
beautify = require '../../lib/tools/beautify'

# Returns structured data:
# [
#   {
#     expr,
#     ast,
#     json,
#     js,
#     evaluations: [ { input, result }, ... ]
#   },
#   ...
# ]
exports.CodeParser = class CodeParser
  constructor: (@code, @opts) ->
    @opts ?= {}
    @opts.parserFormat ?= 'expr'
    @opts.applyRule ?=
      if @opts.parserFormat is 'expr' then undefined
      else (@code.match /(\w+)\s*=/)[1]

  getIndentationLevel = (line) ->
    if /^\s*$/.test line then -1 # empty line
    else
      match = /^(\t|    )+/.exec line
      throw new Error 'All lines in code block must have at least one indentation level' if match is null
      match[0].replace(/[ ]{4}/g, '\t').length

  # compiles expression to different formats
  compile = (parser) ->
    result = {parser}
    for outputFormat in ['ast', 'json', 'js']
      result[outputFormat] = grammar.compile {
        parser
        parserFormat: @opts.parserFormat
        truncate: true
        outputFormat
      }
    result

  evaluate = (parser, input) ->
    try
      grammar.eval {
        parser
        input
        parserFormat: @opts.parserFormat
        applyRule: @opts.applyRule
      }
    catch err
      err.message.replace /\n/g, '\\n'

  newBlock = (data) ->
    data.evaluations = []
    @result.push data

  newEval = (input, result) ->
    @result.last().evaluations.push {input, result}

  getAst: ->
    @result = []
    for l in @code.split /\r?\n/
      lvl = getIndentationLevel l
      l = l.replace /^\s+/, '' # right spaces may be valuable
      switch lvl
        when -1 then '' # empty line
        when 1
          newBlock.call @, compile.call @, expr = l
        when 2
          newEval.call @, l, evaluate.call @, expr, l
        else throw new Error 'Only two indentation levels make sense'
    @result

  parse: (debug) ->
    if debug is on
      astText = beautify JSON.stringify @getAst()
      "\n\n```\n#{astText}\n```\n\n"
    else @getAst()