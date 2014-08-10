mongoose = require "mongoose"
{StorySchema} = require "../model/schema"

exports.getStory = (title, cb)->
  StorySchema.aggregate [
      {
        $match:
          section_name: title
      },{
        $sort:
          date: -1
          index: -1
      }
    ]
  , (err, sectionsArr)->
    return cb err if err
    return cb null, sectionsArr

exports.all = (cb)->
  StorySchema.aggregate [
      {
        $group:
          _id:
            title: "$section_name"
          count:
            $sum: 1
          images:
            $push: "$image"
      },{
        $sort:
          count: -1
      }
    ]
  , (err, sectionsArr)->
    return cb err if err
    return cb null, sectionsArr