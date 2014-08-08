mongoose = require "mongoose"
async = require "async"
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

Daily.saveStory = (storyObj, date, index, cb)->
  crawler.upImage storyObj, (err, storyObj)->
    return cb err if err
    sectionArr = storyObj.title.match /(.*) · /
    if sectionArr
      section_title = sectionArr[1]
      cache.del "/section", ->
      cache.del "/section/" + section_title, ->
      Section.get section_title, (err, sectionObj)->
        if err
          if err.message is "SectionNotFound"
            Daily.randOne {section: section_title}, (err, randObj)->
              return cb err if err
              sectionObj =
                title: section_title
                count: 1
                image: randObj.image
                stories: [
                  _id: storyObj._id
                  date: storyObj.date
                  index: storyObj.index
                ]
              Section.save sectionObj, (err)->
                return cb err if err
          else
            return cb err if err
        Daily.randOne {section: section_title}, (err, randObj)->
          return cb err if err
          sectionObj.count += 1
          sectionObj.image = randObj.image
          sectionObj.stories.push
            _id: storyObj._id
            date: storyObj.date
            index: storyObj.index
          Section.update sectionObj, sectionObj, (err)->
            return cb err if err
    else
      section_title = null
    storyObj_new =
      id: storyObj.id
      body: storyObj.body
      image_source: storyObj.image_source
      title: storyObj.title
      section: section_title
      image: storyObj.image
      share_url: storyObj.share_url
      date: date
      index: index
    story = new StorySchema storyObj_new
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

Daily.getStoryById = (id, cb)->
  StorySchema.findById id, (err, storyObj)->
    return cb err if err
    unless storyObj
      return cb new Error "StoryNotFound"
    return cb null, storyObj

Daily.getDay = (date, cb)->
  query =
    date: date
  StorySchema.find(query).sort('-index').exec (err, storysArr)->
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
  StorySchema.find().sort({$natural:1}).limit(20).exec (err, storysArr)->
    return cb err if err
    return cb null, storysArr

module.exports = Daily