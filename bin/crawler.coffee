mongoose = require "mongoose"
moment = require "moment"
config = require "../config"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
_ = require "underscore"
Daily = require "../model/daily"
{db, crawler} = require "../config"

fetchBeforeDay = (date , getAll)->
  Daily.fetchBeforeDay date, (err, dayObj)->
    throw err if err
    if dayObj.stories
      _.each dayObj.stories, (storyObj)->
        Daily.fetchStory storyObj.id, (err, storyObj)->
          unless err
            Daily.saveStory storyObj, dayObj.date, (err)->
              unless err
                if crawler.fetch is "today"
                  Daily.getStory storyObj.id, (err, storyObj)->
                    unless err
                      if storyObj.pre
                        cache.del "//story/#{storyObj.pre.id}", ->
                  cache.del "//mobile", ->
                  cache.del "//desktop", ->
                  cache.del "/day/#{dayObj.date}/mobile", ->
                  cache.del "/day/#{dayObj.date}/desktop", ->
                  cache.del "/rss", ->
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
