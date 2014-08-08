mongoose = require "mongoose"
Daily = require "../model/daily"
Section = require "../model/section"
crawler = require "../model/crawler"
{StorySchema} = require "../model/schema"
{db} = require "../config"

mongoose.connect db.url, (err)->
  throw err if err
  StorySchema.find {}, null, {}, (err, storysArr)->
    throw err if err
    sectionsObj = {}
    for storyObj in storysArr
      results = storyObj.title.match /(.*) · /
      if results
        title = results[1]
        if sectionsObj[title]
          sectionsObj[title].count += 1
          sectionsObj[title].stories.push
            _id: storyObj._id
            date: storyObj.date
            index: storyObj.index
        else
          sectionsObj[title] =
            title: title
            count: 1
            stories: [
              _id: storyObj._id
              date: storyObj.date
              index: storyObj.index
            ]
        storyObj_new =
          section: title
      else
        storyObj_new =
          section: null
      Daily.updateStory storyObj, storyObj_new, (err, storyObj)->
        throw err if err
        console.log storyObj.id
    for title, sectionObj of sectionsObj
      Daily.randOne {section: title}, (err, randObj)->
        throw err if err
        sectionObj = sectionsObj[randObj.section]
        sectionObj.image = randObj.image
        Section.save sectionObj, (err, sectionObj)->
          throw err if err
