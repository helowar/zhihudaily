express = require "express"
config = require "../config"
async = require "async"
Daily = require "../model/daily"
Section = require "../model/section"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
router = express.Router()

router.get "/", (req, res) ->
  Section.all (err, sectionsArr)->
    console.log sectionsArr


router.get "/:title", cache.route(), (req, res) ->
  Section.getStory req.params.title, (err, sectionsArr)->
    stories = bubbleSort sectionsArr
    sectionsArr_new = []
    for story in stories
      sectionsArr_new.push
        url: "/story/" + story.id
        image: story.image
        title: story.title
    time = Date.now() - res.socket._idleStart
    res.render "day",
      css: "day"
      date: story.section
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