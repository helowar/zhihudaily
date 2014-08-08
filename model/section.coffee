mongoose = require "mongoose"
async = require "async"
Daily = require "../model/daily"
{SectionSchema, StorySchema} = require "../model/schema"
Section = {}

Section.save = (sectionObj, cb)->
  section = new SectionSchema sectionObj
  section.save (err, sectionObj) ->
    return cb err if err
    return cb null, sectionObj

Section.get = (title, cb)->
  query =
    title: title
  SectionSchema.findOne query, {}, (err, sectionObj)->
    return cb err if err
    unless sectionObj
      return cb new Error "SectionNotFound"
    return cb null, sectionObj

Section.getStory = (title, cb)->
  StorySchema.aggregate
    $match:
      section: title
  , (err, sectionsArr)->
    return cb err if err
    return cb null, sectionsArr

Section.all = (cb)->
  SectionSchema.find({}).sort('-count').exec (err, sectionsArr)->
    return cb err if err
    if sectionsArr.length is 0
      return cb new Error "DayNotFound"
    return cb null, sectionsArr

Section.update = (sectionObj, sectionObj_new, cb)->
  SectionSchema.findByIdAndUpdate sectionObj, sectionObj_new, (err, sectionObj)->
    return cb err if err
    return cb null, sectionObj

Section.removeStory = (title, story_id, cb)->
  Section.get title, (err, sectionObj)->
    return cb err if err
    Daily.getStory story_id, (err, storyObj)->
      return cb err if err
      stories = []
      for story in sectionObj.stories
        if story._id != storyObj._id
          stories.push story
      sectionObj_new =
        count: stories.length
        stories: stories
      Section.update sectionObj, sectionObj_new, (err, sectionObj)->
        return cb err if err
        return cb null, sectionObj

module.exports = Section