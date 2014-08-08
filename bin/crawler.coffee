mongoose = require "mongoose"
moment = require "moment"
config = require "../config"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
_ = require "underscore"
daily = require "../model/daily"
{db, crawler} = require "../config"

fetchBeforeDay = (date , getAll)->
  daily.fetchBeforeDay date, (err, dayObj)->
    throw err if err
    unless dayObj.stories
      throw new Error "StoriesNotFound"
    _.each dayObj.stories, (storyObj, index)->
      daily.fetchStory storyObj.id, (err, storyObj)->
        unless err
          daily.saveStory storyObj, dayObj.date, dayObj.stories.length - index, (err)->
            if crawler.fetch is "today"
              cache.del "/", ->
              cache.del "/day/" + dayObj.date, ->
            console.log storyObj.id
    return fetchBeforeDay dayObj.date, true if getAll
    return dayObj.date

mongoose.connect db.url, (err)->
  throw err if err
  tomorrow = moment().add(1, 'd').format("YYYYMMDD")
  switch crawler.fetch
      when "today"
        setInterval fetchBeforeDay(tomorrow, false), crawler.interval
      when "full"
        fetchBeforeDay tomorrow, true


