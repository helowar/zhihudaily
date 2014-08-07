express = require "express"
moment = require "moment"
config = require "../config"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
router = express.Router()
showDay = require("./middleware").showDay
cache.on 'message', (message)->
  console.log message

router.get "/"
, (req, res, next) ->
  cache.route(req.originalUrl, 60*5)(req, res, next)
, (req, res) ->
  req.params.date = moment().format("YYYYMMDD")
  showDay(req, res)

module.exports = router