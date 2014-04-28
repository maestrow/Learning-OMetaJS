#{task} = require '../debugging/debugCakefile' # uncomment to debug
fs = require 'fs'
path = require 'path'
grammar = require '../lib/grammar'
marked = require 'marked'
highlight = require 'highlight'
beautify = require '../lib/tools/beautify'

###
Common Utils
###

isArray = (x) ->
  typeof x is 'object' and x.constructor is Array

Array::last = -> @[@length - 1]

processFile = (fileName, processor) ->
  processor fs.readFileSync(fileName).toString()

getFileNameWithoutExtension = (filename) ->
  filename.split('.')[...-1].join('.')

repeat = (str, count) ->
  (str while count--).join ''

indent = (text, level) ->
  text.replace /^/, repeat('\t', level || 1)

###
Templates
###

templates =
  _: """
    ### Expression ` ${expr} `

    #### Compilations

    **AST:**
    ```
    ${ast}
    ```

    **JSON:**
    ```
    ${ast}
    ```

    **Javascript:**
    ```
    ${ast}
    ```

    #### Matching

    ${evaluations}
  """
  evaluations: "* `${input}` *>>>* `${result}`"

###
Business logic
###

marked.setOptions {
  highlight: (code, lang) ->
    if not lang? then code
    else switch lang
      when 'ometajs-expr-eval'
        debug = false
        data = new CodeParser(code).parse(debug)
        if debug then data else
          opts = {defaultDelimeter:'\n'}
          marked new Templator(opts).apply data, templates
      else highlight.highlight(lang, code).value;
}

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
class CodeParser
  getIndentationLevel = (line) ->
    if /^\s*$/.test line then -1 # empty line
    else
      match = /^(\t|    )+/.exec line
      throw new Error 'All lines in code block must have at least one indentation level' if match is null
      match[0].replace(/[ ]{4}/g, '\t').length

  # compiles expression to different formats
  compile = (expr) ->
    result = {expr}
    for format in ['ast', 'json', 'js']
      result[format] = grammar.compile {
        expr: expr
        truncate: true
        format
      }
    result

  evaluate = (expr, input) ->
    try
      grammar.eval {expr,input}
    catch err
      err.message.replace /\n/g, '\\n'

  newBlock = (data) ->
    data.evaluations = []
    @result.push data

  newEval = (input, result) ->
    @result.last().evaluations.push {input, result}

  constructor: (@code) ->

  getAst: ->
    @result = []
    for l in @code.split /\r?\n/
      lvl = getIndentationLevel l
      l = l.replace /^\s+/, '' # right spaces may be valuable
      switch lvl
        when -1 then '' # empty line
        when 1
          newBlock.call @, compile expr = l
        when 2
          newEval.call @, l, evaluate expr, l
        else throw new Error 'Only two indentation levels make sense'
    @result

  parse: (debug) ->
    if debug is on then beautify JSON.stringify @getAst()
    else @getAst()

class Templator
  isArray = (x) ->
    typeof x is 'object' and x.constructor is Array

  constructor: (@opts) ->
    @opts ?= {}
    @opts.defaultDelimeter ?= ''

  apply: (data, tpl) ->
    t = if typeof tpl is 'object' then tpl._ else tpl
    if typeof data is 'string' then t.replace /\$\{\}/g, data
    else if isArray data
      (@apply.call @, o, tpl for o in data).join tpl._delimeter || @opts.defaultDelimeter
    else
      for p of data when data.hasOwnProperty(p) and p[0] isnt '_'
        substitution = if typeof data[p] is 'string' then data[p] else @apply.call @, data[p], tpl[p]
        r = new RegExp "\\$\\{#{p}\\}", 'g'
        t = t.replace r, substitution
      t

###
Tasks
###

task 'build', 'Builds all cases', (opts) ->
  opts ?= {}
  opts.srcDir ?= '../cases'
  opts.outDir ?= '../doc'
  srcDir = path.resolve(__dirname, opts.srcDir)
  outDir = path.resolve(__dirname, opts.outDir)
  for f in fs.readdirSync srcDir when /\.expr.md$/.test f
    newFileName = outDir + '/' + getFileNameWithoutExtension(f) + '.html'
    content = processFile "#{srcDir}/#{f}", marked
    fs.writeFileSync newFileName, content
