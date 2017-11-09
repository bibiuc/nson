NSON = require '../src/index'
Emitter = require '../src/emitter.coffee'

nson = new NSON(new Emitter)

ret = nson.encode {log: ()-> console.log arguments}
ret = nson.decode ret
ret.log 222
