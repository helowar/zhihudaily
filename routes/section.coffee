express = require "express"
config = require "../config"
async = require "async"
Daily = require "../model/daily"
Section = require "../model/section"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
router = express.Router()

router.get "/", cache.route(), (req, res) ->
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

router.get "/:title", cache.route(), (req, res) ->
  Section.get req.params.title, (err, sectionObj)->
    return res.status(500).send err.message if err
    stories = bubbleSort sectionObj.stories
    async.map stories, (story, callback)->
      Daily.getStoryById story._id, (err, storyObj)->
        if err
          callback()
        else
          callback null,
            url: "/story/" + storyObj.id
            image: storyObj.image
            title: storyObj.title
    , (err, sectionsArr)->
      return res.status(500).send err.message if err
      sectionsArr_new = []
      for section in sectionsArr
        if section
          sectionsArr_new.push section
      time = Date.now() - res.socket._idleStart
      res.render "day",
        css: "day"
        date: sectionObj.title
        storys: sectionsArr_new
        time: time

bubbleSort = (arr) ->
  i = arr.length
  while i > 0
    j = 0
    while j < i - 1
      if arr[j].date.valueOf() > arr[j + 1].date.valueOf() or arr[j].date.valueOf() == arr[j + 1].date.valueOf() and arr[j].date.index > arr[j + 1].date.index
        tempVal = arr[j]
        arr[j] = arr[j + 1]
        arr[j + 1] = tempVal
      j++
    i--
  return arr.reverse()

module.exports = router