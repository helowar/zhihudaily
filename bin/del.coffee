mongoose = require "mongoose"
Daily = require "../model/daily"
{db, crawler} = require "../config"

mongoose.connect db.url, (err)->
  throw err if err
  Daily.getStory 4121787, (err, storyObj)->
    Daily.deleteStory storyObj, ->