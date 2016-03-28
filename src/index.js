require('./index.html')
require('./styles/index.styl')
var Elm = require('./Main')

Elm.embed(Elm.Main, document.getElementById('main'))
