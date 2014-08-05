daily = require "./daily"

module.exports =
  xml = (cb)->
    daily.queryStory query, {}, (err, storysObj)->
      return cb err if err
      feed = new RSS
        title: "知乎日报"
        description: "知乎日报 - 满足你的好奇心"
        feed_url: "http://www.zhihudaily.net/rss.xml"
        site_url: "http://www.zhihudaily.net"
        author: "知乎"
        webMaster: "faceair"
        copyright: "© 2013-2014 知乎"
        language: "zh"
        pubDate: (new Date).toUTCString()
      for storyObj in storysObj
        feed.item
          title:  storyObj.title,
          description: storyObj.body,
          url: storyObj.share_url,
          guid: storyObj.id,
          date: storyObj.date
      return cb null, feed.xml()