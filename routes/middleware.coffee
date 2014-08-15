moment = require "moment"
config = require "../config"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
deviceType = require "ua-device-type"
moment.locale("zh-cn")
Daily = require "../model/daily"

exports.platform = (req, res, next) ->
  platform = deviceType req.headers["user-agent"]
  if platform in ["desktop", "tablet", "tv"]
    req.originalUrl = req.originalUrl + "/desktop"
    req.platform = "desktop"
  else
    req.originalUrl = req.originalUrl + "/mobile"
    req.platform = "mobile"
  next()

exports.showDay = (req, res) ->
  getDay req.params.date, (err, storysArr)->
    if err
      if err.message == "DayNotFound"
        return res.status(404).send "Day Not Found"
      else
        return res.status(500).send err.message

    if storysArr[0].date == moment().format("YYYYMMDD")
      date = "今日热闻"
      title = "知乎日报 - 满足你的好奇心"
    else
      date = moment(storysArr[0].date, "YYYYMMDD").format("YYYY.MM.DD dddd")
      title = moment(storysArr[0].date, "YYYYMMDD").format("LL") + " - 知乎日报"

    beforeDay = moment(storysArr[0].date, "YYYYMMDD").add(-1, 'd').format("YYYYMMDD")
    if req.platform == "desktop"
      Daily.randOne {date: beforeDay}, (err, randObj)->
        if not err and randObj
          storysArr.push
            url: "/day/" + beforeDay
            image: randObj.image
            title: moment(beforeDay, "YYYYMMDD").format("YYYY.MM.DD dddd")
        time = Date.now() - res.socket._idleStart
        res.render "day",
          title: title
          section_title: date
          storys: storysArr
          time: time
    else
      time = Date.now() - res.socket._idleStart
      res.render "day-mobile",
        title: title
        section_title: date
        beforeday: beforeDay
        storys: storysArr
        time: time

getDay = (date, cb)->
  storysArr_new = []
  if date == moment().format("YYYYMMDD")
    Daily.getFirstDay (err, storysArr)->
      return cb err if err
      for story in storysArr
        storysArr_new.push
          image_source: story.image_source
          url: "/story/" + story.id
          image: story.image
          title: story.title
          date: story.date
      return cb null, storysArr_new
  else
    Daily.getDay date, (err, storysArr)->
      return cb err if err
      for story in storysArr
        storysArr_new.push
          image_source: story.image_source
          url: "/story/" + story.id
          image: story.image
          title: story.title
          date: story.date
      return cb null, storysArr_new
