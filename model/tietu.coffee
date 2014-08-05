tietuku = require("../config").tietuku

class tietusdk
  constructor: (@accesskey,@secretkey) ->

  Token: (param) ->
    base64param = @Base64(JSON.stringify(param))
    sign = @Sign(base64param,@secretkey)
    return @accesskey + ':' + sign + ':' + base64param

  Sign: (str, key) ->
    return @Base64(require('crypto').createHmac('sha1', key).update(str).digest())

  Base64: (str) ->
    return new Buffer(str).toString('base64').replace('+','-').replace('/','_')

module.exports =
  getToken = ->
    param =
      deadline: Date.now() + 31536000
      album: tietuku.album
      from: 'web'
      returnBody:
        ubburl: 'url'

    sdk = new tietusdk tietuku.accesskey,tietuku.secretkey
    return sdk.Token param