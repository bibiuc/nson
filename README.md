# NSON

### 简单基于事件的可传输方法结构。

代码不是很健全。打算自己用所以也会维护。

普通npm安装

```shell
npm install --save nson
```

```coffeescript
NSON = require 'nson'
nson = new NSON
obj =
    log: () ->
        console.log arguments
        'show'
iobj = nson.encode obj
ret = nson.decode iobj

ret.log(obj)
    #{log: function}
    .then(console.log)
    #show
```
