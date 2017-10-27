NSON = require '../src/index'

nson = new NSON()

ret = nson.encode {log: ()-> console.log arguments}
ret = nson.decode ret
ret.log 222
