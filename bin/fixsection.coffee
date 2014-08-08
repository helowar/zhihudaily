mongoose = require "mongoose"
daily = require "../model/daily"
crawler = require "../model/crawler"
{StorySchema} = require "../model/schema"
{db} = require "../config"

mongoose.connect db.url, (err)->
  throw err if err
  StorySchema.find {}, null, {}, (err, storysArr)->
    throw err if err
    for storyObj in storysArr
      sectionArr = storyObj.title.match /(.*) · /
      if sectionArr
        storyObj_new =
          section: sectionArr[1]
      else
        storyObj_new =
          section: ""
      daily.updateStory storyObj, storyObj_new, (err, storyObj)->
        throw err if err
        console.log storyObj.id