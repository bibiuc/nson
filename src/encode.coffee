R = require 'ramda'
_ = require 'lodash'
Lazy = require 'lazy.js'
shortid = require 'shortid'

#创建返回函数
pickReturn = R.curryN 2, (ret) ->
  [ret]

#解析函数
encodeFunction = (emitter, data) ->
  func_id = shortid.generate()
  return_id = shortid.generate()
  emitter.on func_id, () ->
    result = data(arguments...)
    emitter.emit(return_id, result);
  [func_id, return_id]

#解析对象
encodeObject = (emitter, data) ->
  _encode = encode emitter;
  sequence = []
  sequence.push(['object', JSON.stringify(data)])
  isArray = _.isArray data
  _.forIn data, (val, key) ->
    if _.isObject(val) and !_.isFunction(val)
      [first, other...] =  _encode(val)
      sequence.push([key, other])
    else if (isArray and !/^\d+$/.test(key)) or (_.isFunction(val) and !_.isNative(val))
      ret = _encode(val)
      sequence.push([key, ret...])
  if _.isPlainObject(data) or _.isArray(data)
    return sequence
  [first, other...] =  _encode(data.__proto__)
  sequence.push(['__proto__', other])
  sequence

module.exports = encode =  R.curry (emitter, data) ->
  switch
    when _.isFunction(data)
      if !_.isNative(data)
        ret = encodeFunction(emitter, data)
        ['function', ret...]
      else
        ['other', JSON.stringify(data)]
    when _.isNumber(data) or _.isString(data) or _.isBoolean(data)
      [
        typeof data
        JSON.stringify data
      ]
    when _.isObject data
      encodeObject emitter, data
    else
      ['other', JSON.stringify(data)]
