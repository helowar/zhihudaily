middleware = {}

middleware.showDay = (req, res) ->
  daily = require "../model/daily"
  moment = require "moment"
  moment.locale("zh-cn")
  daily.getDay req.params.date, (err, storysArr)->
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
    beforeDay = moment(req.params.date, "YYYYMMDD").add(-1, 'd').format("YYYYMMDD")
    daily.randOne beforeDay, (err, randObj)->
      storysArr_new.push
        url: "/day/" + beforeDay
        image: randObj.image
        title: moment(beforeDay, "YYYYMMDD").format("YYYY.MM.DD dddd")
      time = Date.now() - res.socket._idleStart
      if req.params.date == moment().format("YYYYMMDD")
        date = "今日热闻"
      else
        date = moment(req.params.date, "YYYYMMDD").format("YYYY.MM.DD dddd")
      res.render "day",
        css: "day"
        date: date
        storys: storysArr_new
        time: time

module.exports = middleware