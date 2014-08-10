mongoose = require "mongoose"
async = require "async"
moment = require "moment"
moment.locale("zh-cn")
{StorySchema} = require "../model/schema"
crawler = require "./crawler"
Section = require "./section"
config = require "../config"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
Daily = {}

Daily.fetchBeforeDay = (date, cb) ->
  crawler.getData "http://news-at.zhihu.com/api/3/stories/before/" + date, (err, dayObj)->
    return cb err if err
    return cb null, dayObj

Daily.fetchStory = (story_id, cb)->
  Daily.getStory story_id, (err, storyObj)->
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

Daily.saveStory = (storyObj, date, cb)->
  crawler.upImage storyObj, (err, storyObj)->
    return cb err if err
    story = new StorySchema
      id: storyObj.id
      body: storyObj.body
      image_source: storyObj.image_source
      title: storyObj.title
      ga_prefix: storyObj.ga_prefix
      section_name: storyObj.section_name
      image: storyObj.image
      share_url: storyObj.share_url
      date: date
      publish_at: moment(date + storyObj.ga_prefix.substr(-2), "YYYYMMDDHH").format()
    story.save (err, storyObj) ->
      return cb err if err
      return cb null, storyObj

Daily.getStory = (story_id, cb)->
  query =
    id: story_id
  StorySchema.findOne query, {}, (err, storyObj)->
    return cb err if err
    unless storyObj
      return cb new Error "StoryNotFound"
    return cb null, storyObj

Daily.getDay = (date, cb)->
  query =
    date: date
  StorySchema.find(query).sort({ publish_at: -1, id: -1 }).exec (err, storysArr)->
    return cb err if err
    if storysArr.length is 0
      return cb new Error "DayNotFound"
    return cb null, storysArr

Daily.randOne = (query, cb)->
  StorySchema.find(query).exec (err, storysArr)->
    return cb err if err
    return cb null, storysArr[Math.floor(Math.random()*storysArr.length)]

Daily.updateStory = (storyObj, storyObj_new, cb)->
  StorySchema.findByIdAndUpdate storyObj._id, storyObj_new, (err, storyObj)->
    return cb err if err
    return cb null, storyObj

Daily.deleteStory = (storyObj, cb)->
  StorySchema.findByIdAndRemove storyObj._id, (err)->
    return cb err if err
    return cb null, true

Daily.rss = (cb)->
  StorySchema.find({}, null,{limit: 20}).sort({ publish_at: -1, id: -1 }).exec (err, storysArr)->
    return cb err if err
    return cb null, storysArr

module.exports = Daily