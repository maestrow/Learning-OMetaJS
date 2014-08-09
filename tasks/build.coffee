#{task} = require '../debugging/debugCakefile' # uncomment to debug
fs = require 'fs'
path = require 'path'
marked = require 'marked'
{CodeParser} = require './build/CodeParser'
{Templator} = require 'treetemplator'


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
Templates
###

layoutTpl =
  _: fs.readFileSync('cases/layout/layout.html').toString()

templates =
  _: """

    ### Expression ` ${parser} `

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


###
Business logic
###

preProcess = (content) ->
  debugThisMethod = false
  tplOpts = {defaultDelimeter:'\n'}
  rxText = "```ometajs-eval(\\{.+?\\})?\\r?\\n([\\s\\S]+?)\\r?\\n```"
  matches = content.match new RegExp rxText, 'g'

  getData = (parserOpts, code) ->
    parserOpts = if parserOpts? then parserOpts.replace /([a-z][^:]*)(?=\s*:)/g, '"$1"' else {}
    new CodeParser(code, parserOpts).parse(debugThisMethod)

  for match in matches
    data = getData.apply @, (match.match new RegExp rxText)[1..2]
    text = if debugThisMethod then data else new Templator(tplOpts).apply data, templates
    content = content.replace match, text
  content

layout = (content) ->
  new Templator().apply { content }, layoutTpl

task 'build', 'Builds all cases', (opts) ->
  opts ?= {}
  opts.mask ?= '\\.md$'
  opts.srcDir ?= '../cases'
  opts.outDir ?= '../doc'
  srcDir = path.resolve(__dirname, opts.srcDir)
  outDir = path.resolve(__dirname, opts.outDir)
  fs.unlinkSync path.resolve outDir, f for f in fs.readdirSync outDir #when /\.html$/.test f
  rx = new RegExp(opts.mask)
  for f in fs.readdirSync srcDir when rx.test f
    newFileName = outDir + '/' + getFileNameWithoutExtension(f) + '.html'
    content = processFile "#{srcDir}/#{f}", [preProcess, marked, layout]
    fs.writeFileSync newFileName, content

