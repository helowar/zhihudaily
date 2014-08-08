moment = require "moment"
moment.locale("zh-cn")
Daily = require "../model/daily"
middleware = {}

middleware.showDay = (req, res) ->
  getDay req.params.date, (err, storysArr)->
    if err
      if err.message == "DayNotFound"
        return res.status(404).send "Day Not Found"
      else
        return res.status(500).send err.message
    storysArr_new = []
    for story in storysArr
      storysArr_new.push
        url: "/story/" + story.id
        image: story.image
        title: story.title
    beforeDay = moment(story.date, "YYYYMMDD").add(-1, 'd').format("YYYYMMDD")
    Daily.randOne {date: beforeDay}, (err, randObj)->
      unless err
        storysArr_new.push
          url: "/day/" + beforeDay
          image: randObj.image
          title: moment(beforeDay, "YYYYMMDD").format("YYYY.MM.DD dddd")
      if story.date == moment().format("YYYYMMDD")
        date = "今日热闻"
      else
        date = moment(story.date, "YYYYMMDD").format("YYYY.MM.DD dddd")
      time = Date.now() - res.socket._idleStart
      res.render "day",
        css: "day"
        date: date
        storys: storysArr_new
        time: time

getDay = (date, cb)->
  beforeDay = moment(date, "YYYYMMDD").add(-1, 'd').format("YYYYMMDD")
  Daily.getDay date, (err, storysArr)->
    if err
      if err.message == "DayNotFound"
        Daily.getDay beforeDay, (err, storysArr)->
          return cb err if err
          return cb null, storysArr
      else
        return cb err
    else
      return cb null, storysArr

module.exports = middleware