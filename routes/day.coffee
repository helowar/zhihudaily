express = require "express"
config = require "../config"
daily = require "../model/daily"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
moment = require "moment"
moment.locale("zh-cn")

router = express.Router()

router.get "/:date"
, (req, res, next) ->
  if req.params.date != moment().format("YYYYMMDD")
    cache.route(req.originalUrl, 60*60*24*3)(req, res, next)
  else
    cache.route(req.originalUrl, 60*5)(req, res, next)
, (req, res) ->
  daily.getDay req.params.date, (err, storysArr)->
    throw err if err
    storysArr_new = []
    for story in storysArr
      storysArr_new.push
        url: "/story/" + story.id
        image: story.image
        title: story.title
    beforeDay = moment(req.params.date, "YYYYMMDD").add(-1, 'd').format("YYYYMMDD")
    daily.randOne beforeDay, (err, randObj)->
      storysArr_new.push
        url: "/day/" + beforeDay
        image: randObj.image
        title: moment(beforeDay, "YYYYMMDD").format("YYYY.MM.DD dddd")
      time = Date.now() - res.socket._idleStart
      res.render "day",
        css: "day"
        date: moment(req.params.date, "YYYYMMDD").format("YYYY.MM.DD dddd")
        storys: storysArr_new
        time: time

module.exports = router