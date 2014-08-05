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
    unless storyObj
      crawler.getData "http://news-at.zhihu.com/api/3/story/" + story_id, (err, storyObj)->
        return cb err if err
        unless storyObj.body
          return cb new Error "StoryNotFound"
        return cb null, storyObj
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
      ga_prefix: storyObj.ga_prefix
      type: storyObj.type
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
  StorySchema.find(query).sort('-index').exec (err, storysObj)->
    return cb err if err
    if storysObj.length is 0
      return cb new Error "DayNotFound"
    return cb null, storysObj

daily.updateStory = (storyObj, storyObj_new, cb)->
  StorySchema.findByIdAndUpdate storyObj._id, storyObj_new, (err, storyObj)->
    return cb err if err
    return cb null, storyObj

daily.deleteStory = (storyObj, cb)->
  StorySchema.findByIdAndRemove storyObj._id, (err)->
    return cb err if err
    return cb null, true

module.exports = daily