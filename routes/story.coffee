express = require "express"
config = require "../config"
daily = require "../model/daily"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
router = express.Router()

router.get "/:story_id"
, (req, res, next) ->
  cache.route(req.originalUrl, 60*60*24*3)(req, res, next)
, (req, res) ->
  daily.getStory req.params.story_id, (err, storyObj)->
    throw err if err
    time = Date.now() - res.socket._idleStart
    storyObj.body = storyObj.body.replace '<div class="img-place-holder"></div>','<div class="img-wrap"><h1 class="headline-title">' + storyObj.title + '</h1><span class="img-source">图片：' + storyObj.image_source + '</span><img alt="' + storyObj.title + '"  src="' + storyObj.image + '"><div class="img-mask"></div></div>'
    res.render "story",
      css: "story"
      date: storyObj.date
      body: storyObj.body
      time: time

module.exports = router