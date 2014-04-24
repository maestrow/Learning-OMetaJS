###

  Run and see Usage info

###

# Requirements

cli = require 'commander'
fs = require 'fs'
grammar = require './lib/grammar'

# Helpers

getGrammarPath = (relPath) -> "./../#{relPath}.ometajs"

fromFile = (val) ->
  fs.readFileSync val, encoding: 'utf8'

# Command line options

requiredOpts = (obj, props, err) ->
  err = err || []
  for p in props
    if p.constructor is Array
      err.push 'At least one option should be specified: ' + p.join(', ') if (orP for orP in p when obj[orP]?).length == 0
    else if !obj[p]? then err.push "Option #{p} is required"
  throw new Error err.join('\n') if err.length

shouldBeInList = (value, choises, msg = "value must be in #{choises}") ->
  throw new Error msg if choises.indexOf(value) == -1

getOutputStream = (val) ->
  if val? then fs.createWriteStream val else process.stdout

fromFileOpts = (opts, keys) ->
  keys.forEach (option) -> opts[option] = fromFile opts["#{option}Path"] if opts["#{option}Path"]?

prepareOptions = (opts) ->
  opts.output = getOutputStream opts.output
  fromFileOpts opts, ['input', 'expr']

# CLI Commands logic

evaluate = ->
  [args..., opts] = arguments
  if args[2]? then opts.action = args[i++]
  else if args[1]?
    opts.expr = args[0]
    opts.input = args[1]
  else if args[0]? then opts.action = args[0]
  opts.action = if typeof(opts.action) != 'string' then 'matchAll'
  shouldBeInList opts.action, ['match', 'matchAll']
  requiredOpts opts, [['grammarPath', 'exprPath', 'expr'], ['inputPath', 'input']]
  throw new Error 'rule is required when grammar specified' if opts.grammarPath? and !opts.rule?
  prepareOptions opts
  opts.output.write grammar.eval opts

compile = ->
  [expr, opts] = arguments
  opts.expr = expr if expr?
  prepareOptions opts
  requiredOpts opts, [['grammarPath', 'exprPath', 'expr']]
  opts.output.write grammar.compile opts

# CLI

cli
  .version '0.0.1'

cli.Command.prototype.addCommonOptions = ->
  @option '-i, --inputPath <file>', 'An input file'
  @option '-g, --grammarPath <file>', 'A grammar file', getGrammarPath
  @option '-e, --exprPath <file>', 'A file with expression'
  @option '-o, --output <file>', 'If omitted stdout will be used'

cli.on '--help', ->
  message = [
    '  You can specify only one options from each list, but not their combinations:'
    '    -g, -ef, e'
    '    -i, if'
    '  Examples:'
    '    cli.coffee eval "^digit:a ^digit:b -> a*b" "56"'
    '    cli.coffee eval """123""" "123"'
    '    cli.coffee compile "^digit:a ^digit:b -> a*b" -t -f json'
  ]
  console.log message.join '\n'

cli
  .command 'eval [matchAll|match] [expr] [input]'
  .description 'Match input text against grammar'
  .addCommonOptions()
  .option '-r, --rule <name>', 'A rule name to apply'
  .action evaluate

cli
  .command 'compile [expr]'
  .description 'Compile grammar (or expression) into javascript or json AST'
  .addCommonOptions()
  .option '-t, --truncate', 'Truncate compiled code to valuable part'
  .option '-f, --format <ast|json|js>', 'Format to compile to'
  .action compile

cli.parse process.argv
cli.help() if !cli.args.length