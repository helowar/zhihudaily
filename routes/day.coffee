express = require "express"
config = require "../config"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
router = express.Router()
showDay = require("./middleware").showDay

router.get "/:date"
, (req, res, next) ->
  if config.redis.switch
    cache.route(req.originalUrl, 60*60*24)(req, res, next)
  next()
, (req, res) ->
  showDay(req, res)

module.exports = router
