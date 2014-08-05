mongoose = require "mongoose"
async = require "async"
{StorySchema} = require "../model/schema"
crawler = require "./crawler"
daily = {}

daily.fetchStory = (story_id, cb)->
  crawler.getData "http://news-at.zhihu.com/api/3/story/" + story_id, (err, storyObj)->
    return cb err if err
    daily.saveStory storyObj, (err, storyObj)->
      return cb err if err
      return cb null, storyObj

daily.saveStory = (storyObj, cb)->
  crawler.upImage storyObj, (err, cb)->
    return cb err if err
    story = new StorySchema storyObj
    story.save (err, storyObj) ->
      return cb err if err
      return cb null, storyObj

daily.getStory = (story_id, cb)->
  StorySchema.findById mongoose.Types.ObjectId(story_id), (err, storyObj)->
    return cb err if err
    unless storyObj
      return cb new Error "StoryNotFound"
    return cb null, storyObj

daily.queryStory = (query, option, cb)->
  StorySchema.find query, null, option, (err, storysObj) ->
    return cb err if err
    return cb null, storysObj

daily.updateStory = (storyObj, storyObj_new, cb)->
  StorySchema.findByIdAndUpdate storyObj._id, storyObj_new, (err, storyObj)->
    return cb err if err
    return cb null, storyObj

daily.deleteStory = (storyObj, cb)->
  StorySchema.findByIdAndRemove storyObj._id, (err)->
    return cb err if err
    return cb null, true

daily.fetchDay = (date, cb) ->
  crawler.getData "http://news-at.zhihu.com/api/3/stories/before/" + date, (err, dayObj)->
    return cb err if err
    return cb null, dayObj

daily.getDay = (date, cb)->
  query =
    date: date
  daily.queryStory query, {}, (err, storysObj) ->
    return cb err if err
    if storysObj.length is 0
      return cb new Error "DayNotFound"
    return cb null, storysObj

module.exports = daily