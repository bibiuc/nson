Emitter = require './emitter'
encode = require './encode'
decode = require './decode'
shortid = require 'shortid'

class NSON
  constructor: (emitter) ->
    id = shortid.generate()
    _emitter = new Emitter(id)
    if (emitter)
      emitter.on id, (args...) ->
        _emitter.emit args...
      _emitter.on id, (args...) ->
        emitter.emit id,args...
    @reset = () ->
      _emitter.reset()
      emitter.off(id) if emitter
    @encode = encode(_emitter)
    @decode = decode(_emitter)

module.exports = NSON
