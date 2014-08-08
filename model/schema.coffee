mongoose = require "mongoose"

Schema = mongoose.Schema
StorySchema = new Schema
  id:
    type: Number
    index:
      unique: true
  body: String
  image_source: String
  title: String
  section: String
  image: String
  share_url: String
  date: String
  index: Number
, { versionKey: false }

module.exports =
  StorySchema: mongoose.model "story", StorySchema