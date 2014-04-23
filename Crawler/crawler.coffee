http = require("http")

http.get('', (res) ->
  console.log "Got response: " + res.statusCode
  res.on "data", (chunk) ->
    console.log "BODY: " + chunk

).on "error", (e) ->
  console.log "Got error: " + e.message

