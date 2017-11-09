R = require 'ramda'
_ = require 'lodash'
Lazy = require 'lazy.js'
Bluebird = require 'bluebird'

module.exports = decode = R.curryN 2,(emitter, data, parent) ->
  if !data || !data[0]
    undefined
  else if _.isString data[0]
    if data[0] == 'function'
      (args...) ->
        promise = new Bluebird (resolve, reject) ->
          emitter.on data[3], (ret) ->
            if _.isError(ret)
              reject(ret)
            else
              resolve(ret)
          undefined
        emitter.emit data[1], data[2], args...
        promise
    else if _.isString data[1]
      JSON.parse data[1]
    else
      data[1]
  else if parent
    Lazy(data).each ([key, other...]) ->
      parent[key] = parent[key] || {}
      if other.length == 1
        decode emitter, other[0], parent[key]
      else
        parent[key] = decode emitter, other
    parent
  else
    [first, other...] = data
    parent = JSON.parse first[1]
    decode emitter, other, parent
    parent


