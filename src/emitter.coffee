R = require 'ramda'
_ = require 'lodash'
Lazy = require 'lazy.js'

push = (events, name, func, times = 0) ->
  return if typeof func != 'function'
  events[name] = events[name] || []
  if ! R.find(R.propEq('handle', func), events[name])
    events[name].push({
      handle: func,
      times: times
    })

pull = (events, name, funcs...) ->
  has = events[name] && events[name].length
  if has
    if !funcs or !funcs.length
      events[name] = []
      return
    events[name] = Lazy(events[name]).filter R.pipe({handle}) ->
      handle
    ,R.contains(R.__, funcs)
run = (events, name, args...)->
  return if !events[name]
  events[name] = Lazy(events[name])
    .filter (item, i) ->
      item.handle(args...)
      item.times++
      return item.times
    .toArray()

module.exports = class
  constructor: (id) ->
    @id = id
    events = new Object
    @on = R.curryN(3, push)(events)
    @emit = R.curryN(2, run)(events)
    @off = R.curryN(2, pull)(events)
    @once = R.partial R.partialRight(push, [-1]), [events]
    @reset = () ->
      _.each _.keys(events), (key) ->
        _.unset events,key
