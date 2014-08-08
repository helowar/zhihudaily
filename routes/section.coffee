express = require "express"
config = require "../config"
async = require "async"
Daily = require "../model/daily"
Section = require "../model/section"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
router = express.Router()

router.get "/"
, (req, res, next) ->
  cache.route(req.originalUrl, 60*5)(req, res, next)
, (req, res) ->
  Section.all (err, sectionsArr)->
    return res.status(500).send err.message if err
    async.map sectionsArr, (section, callback)->
      if section.count > 4
        callback null,
          url: "/section/" + section.title
          image: section.image
          title: section.title
      else
        callback null
    , (err, sectionsArr)->
      return res.status(500).send err.message if err
      sectionsArr_new = []
      for section in sectionsArr
        if section
          sectionsArr_new.push section
      time = Date.now() - res.socket._idleStart
      res.render "day",
        css: "day"
        date: "专题"
        storys: sectionsArr_new
        time: time

module.exports = router