beautify = require('js-beautify').js_beautify

beautifyOpts =
  indent_size: 2

module.exports = (code) ->
  beautify code, beautifyOpts