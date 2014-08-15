express = require "express"
moment = require "moment"
config = require "../config"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
router = express.Router()
{showDay, platform} = require "./middleware"

router.get "/", platform
, (req, res, next) ->
  if config.redis.switch
    cache.route()(req, res, next)
  else
    next()
, (req, res) ->
  req.params.date = moment().format("YYYYMMDD")
  showDay(req, res)

module.exports = router
