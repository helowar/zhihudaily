mongoose = require "mongoose"
async = require "async"
{StorySchema} = require "../model/schema"
crawler = require "./crawler"
daily = {}

daily.fetchBeforeDay = (date, cb) ->
  crawler.getData "http://news-at.zhihu.com/api/3/stories/before/" + date, (err, dayObj)->
    return cb err if err
    return cb null, dayObj

daily.fetchStory = (story_id, cb)->
  daily.getStory story_id, (err, storyObj)->
    if storyObj
      return cb new Error "StoryExist"
    else
      crawler.getData "http://news-at.zhihu.com/api/3/story/" + story_id, (err, storyObj)->
        return cb err if err
        if storyObj.theme_name
          return cb new Error "StoryNotFound"
        unless storyObj.image
          return cb new Error "ImangeNotFound"
        return cb null, storyObj

daily.saveStory = (storyObj, date, index, cb)->
  crawler.upImage storyObj, (err, storyObj)->
    return cb err if err
    storyObj_new =
      id: storyObj.id
      body: storyObj.body
      image_source: storyObj.image_source
      title: storyObj.title
      image: storyObj.image
      share_url: storyObj.share_url
      date: date
      index: index
    story = new StorySchema storyObj_new
    story.save (err, storyObj) ->
      return cb err if err
      return cb null, storyObj

daily.getStory = (story_id, cb)->
  query =
    id: story_id
  StorySchema.findOne query, {}, (err, storyObj)->
    return cb err if err
    unless storyObj
      return cb new Error "StoryNotFound"
    return cb null, storyObj

daily.getDay = (date, cb)->
  query =
    date: date
  StorySchema.find(query).sort('-index').exec (err, storysArr)->
    return cb err if err
    if storysArr.length is 0
      return cb new Error "DayNotFound"
    return cb null, storysArr

daily.randOne = (date, cb)->
  daily.getDay date, (err, storysArr)->
    return cb err if err
    return cb null, storysArr[Math.floor(Math.random()*storysArr.length)]

module.exports = daily