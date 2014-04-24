fs = require 'fs'
path = require 'path'
{markdown} = require 'markdown'
grammar = require './lib/grammar'
#{task} = require './debugCakefile' # uncomment to debug

###
Common Utils
###

processFile = (fileName, processor) ->
  processor fs.readFileSync(fileName).toString()

getFileNameWithoutExtension = (filename) ->
  filename.split('.')[...-1].join('.')

repeat = (str, count) ->
  (str while count--).join ''

indent = (text, level) ->
  text.replace /^/, repeat('\t', level || 1)

split = (text) ->
  text.split /\r?\n/

###
Helpers
###

toCodeBlock = (text) ->
  t = indent text
  t = '\n' + text unless /^\s*\n/.test t
  t = text + '\n' unless /\n\s*$/.test t

###
Business logic
###

lineTypes = { 'empty', 'md', 'code' }

groupLines = (lines) ->
  result = []
  block = []

  getLineType = (line) ->
    if /^\s*$/.test line then lineTypes.empty
    else if /^\S+/.test line then lineTypes.md
    else if /^\t+|    /.test line then lineTypes.code
    else throw new Error 'Unknown line type'

  for l in lines
    lt = getLineType l
    if lt != block[0] and lt isnt lineTypes.empty
      result.push block if block.length
      block = [lt]
    block.push l
  result

processCodeLines = (lines) ->
  getIndentationLevel = (line) ->
    if /^\s*$/.test line then 0 # empty line
    else
      match = /^(\t|    )+/.exec line
      throw new Error 'All lines in code block must have at least one indentation level' if match is null
      match[0].replace(/[ ]{4}/g, '\t').length

  # compiles expression to different formats
  compile = (expr) ->
    result = {}
    for format in ['ast', 'json', 'js']
      result[format] = grammar.compile {
        expr: l
        truncate: true
        format
      }
    result

  evaluate = (expr, input) ->
    try
      grammar.eval {expr,input}
    catch err
      err

  result = for l in lines
    lvl = getIndentationLevel l
    l = l.replce /^\s+/, '' # right spaces may be valuable
    switch lvl
      when 0 then '' # empty line
      when 1
        compile expr = l
      when 2
        evaluate expr, l
      else throw new Error 'Only two indentation levels make sense'

  result.join '\n'

buildExpression = (content) ->
  groups = groupLines content.split('\n')
  result = for g in groups
    switch g[0]
      when lineTypes.md then g[1..].join('\n')
      when lineTypes.code then processCodeLines g[1..]
      else throw new Error 'Unknown line type'
  markdown.toHTML result.join '\n'

###
Templates
###

templates =
  main: """

  """
  inputAndResult: "`${input}` *>>>* `${result}`"
  compiled: """
    ### AST:*
    ${ast}
    ### Json:*
    ###
  """

###
Tasks
###

task 'build', 'Builds all cases', (opts) ->
  dirname = 'cases'
  outputDir = path.resolve(__dirname, opts.outDir || 'doc')
  for f in fs.readdirSync("./#{dirname}") when /\.expr.md$/.test f
    newFileName = outputDir + '/' + getFileNameWithoutExtension(f) + '.html'
    content = processFile path.resolve(__dirname, "#{dirname}/#{f}"), buildExpression
    fs.writeFileSync newFileName, content
