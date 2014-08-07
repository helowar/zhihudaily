mongoose = require "mongoose"
moment = require "moment"
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


