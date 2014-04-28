# https://gist.github.com/maestrow/11353631
exports.Templator = class Templator
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

