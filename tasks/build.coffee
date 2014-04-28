#{task} = require '../debugging/debugCakefile' # uncomment to debug
fs = require 'fs'
path = require 'path'
marked = require 'marked'
{CodeParser} = require './build/CodeParser'
{Templator} = require './build/Templator'

###
Common Utils
###

Array::last = -> @[@length - 1]

isArray = (x) ->
  typeof x is 'object' and x.constructor is Array

processFile = (fileName, processors) ->
  content = fs.readFileSync(fileName).toString()
  if isArray processors
    for p in processors
      content = p content
    content
  else processors content

getFileNameWithoutExtension = (filename) ->
  filename.split('.')[...-1].join('.')

split = (text) ->
  text.split '\r?\n'

join = (lines) ->
  lines.join '\n'

###
Business logic
###

preProcess = (content) ->
  debugThisMethod = false
  opts = {defaultDelimeter:'\n'}
  rxText = "```ometajs-expr-eval+\\r?\\n([\\s\\S]+?)\\r?\\n```"
  matches = content.match new RegExp rxText, 'g'
  for match in matches
    code = (match.match new RegExp rxText)[1]
    data = new CodeParser(code).parse(debugThisMethod)
    text = if debugThisMethod then data else new Templator(opts).apply data, templates
    content = content.replace match, text
  content

task 'build', 'Builds all cases', (opts) ->
  opts ?= {}
  opts.srcDir ?= '../cases'
  opts.outDir ?= '../doc'
  srcDir = path.resolve(__dirname, opts.srcDir)
  outDir = path.resolve(__dirname, opts.outDir)
  for f in fs.readdirSync srcDir when /\.expr.md$/.test f
    newFileName = outDir + '/' + getFileNameWithoutExtension(f) + '.html'
    content = processFile "#{srcDir}/#{f}", [preProcess, marked]
    fs.writeFileSync newFileName, content

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
    ${json}
    ```

    **Javascript:**
    ```
    ${js}
    ```

    #### Matching

    ${evaluations}
  """
  evaluations: "* `${input}` **evaluates to:** `${result}`"

