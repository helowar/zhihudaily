debug = require("debug")("zhihudaily")
app = require "../app"
server = app.listen app.get("port"), ->
  debug "Express server listening on port " + server.address().port