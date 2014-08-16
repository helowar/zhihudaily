express = require "express"
RSS = require "rss"
moment = require "moment"
Daily = require "../model/daily"
router = express.Router()

router.get "/", (req, res) ->
  Daily.rss (err, storysArr)->
    feed = new RSS(
      title: "知乎日报"
      description: "知乎日报 - 满足你的好奇心"
      feed_url: "http://www.zhihudaily.net/rss"
      site_url: "http://www.zhihudaily.net"
      author: "知乎"
      webMaster: "faceair"
      copyright: "© 2013-2014 知乎"
      language: "zh"
      pubDate: moment().format()
    )
    for storyObj in storysArr
      feed.item(
        title:  storyObj.title,
        description: storyObj.body,
        url: "http://www.zhihudaily.net/story/" + storyObj.id,
        guid: storyObj.id,
        date: storyObj.publish_at
      )
    res.contentType "application/xml"
    return res.send feed.xml()

module.exports = router
