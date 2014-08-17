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
    if storyObj.body.indexOf("禁止转载") > -1 or storyObj.body.indexOf("谢绝转载") > -1
      prohibit = true
    else
      prohibit = false
      storyObj.body = storyObj.body.replace '<div class="img-place-holder"></div>','<div class="img-wrap"><h1 class="headline-title">' + storyObj.title + '</h1><span class="img-source">图片：' + storyObj.image_source + '</span><img alt="' + storyObj.title + '"  src="' + storyObj.image + '"><div class="img-mask"></div></div>'
      storyObj.body = storyObj.body.replace '<i class="icon-arrow-right"></i>',''
      view_more = storyObj.body.match /<div class="view-more.+?\/div>/g
      if view_more
        if view_more.length > 1
          view_more = null
        else
          view_more = view_more[0]
          storyObj.body = storyObj.body.replace /<div class="view-more.+?\/div>/, ""
    time = Date.now() - res.socket._idleStart
    res.render "story",
      css: "story"
      title: "#{storyObj.title} - 知乎日报"
      date: storyObj.date
      body: storyObj.body
      pre: storyObj.pre
      next: storyObj.next
      prohibit: prohibit
      origin_url: storyObj.share_url
      bdText: "#{storyObj.title}（分享自 知乎日报 网页版）http://zhihudaily.net/story/#{storyObj.id}"
      bdUrl: "http://zhihudaily.net/story/#{storyObj.id}"
      view_more: view_more
      time: time

module.exports = router
