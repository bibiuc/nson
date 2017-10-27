Emitter = require './emitter'
encode = require './encode'
decode = require './decode'

class NSON
  constructor: (emitter = new Emitter) ->
    @encode = encode(emitter)
    @decode = decode(emitter)

module.exports = NSON
