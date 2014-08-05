express = require "express"
path = require "path"
favicon = require "static-favicon"
logger = require "morgan"
bodyParser = require "body-parser"
app = express()

app.set "views", path.join __dirname, "views"
app.set "view engine", "jade"
app.use logger "dev"
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use favicon path.join(__dirname, "/public/img/", "favicon.ico")
app.use express.static path.join(__dirname, "public")

app.use "/day", require "./routes/day"
app.use "/story", require "./routes/story"

app.use (req, res, next) ->
  err = new Error "Not Found"
  err.status = 404
  next err

if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err

app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}

module.exports = app