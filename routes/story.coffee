express = require "express"
config = require "../config"
Daily = require "../model/daily"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
router = express.Router()

router.get "/:story_id"
, (req, res, next) ->
  if config.redis.switch
    cache.route(req.originalUrl, 60*60*24)(req, res, next)
  else
    next()
, (req, res) ->
  Daily.getStory req.params.story_id, (err, storyObj)->
    if err
      if err.message == "StoryNotFound"
        return res.status(404).send "Story Not Found"
      else
        return res.status(500).send err.message
    storyObj.body = storyObj.body.replace '<div class="img-place-holder"></div>','<div class="img-wrap"><h1 class="headline-title">' + storyObj.title + '</h1><span class="img-source">图片：' + storyObj.image_source + '</span><img alt="' + storyObj.title + '"  src="' + storyObj.image + '"><div class="img-mask"></div></div>'
    time = Date.now() - res.socket._idleStart
    res.render "story",
      css: "story"
      title: storyObj.title + " - 知乎日报"
      date: storyObj.date
      body: storyObj.body
      time: time

module.exports = router
