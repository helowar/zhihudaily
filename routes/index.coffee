express = require "express"
moment = require "moment"
config = require "../config"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
router = express.Router()
showDay = require("./middleware").showDay

router.get "/", cache.route(), (req, res) ->
  req.params.date = moment().format("YYYYMMDD")
  showDay(req, res)

module.exports = router