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
  section:
    type: String
    index:
      unique: false
  image: String
  share_url: String
  date: String
  index: Number
, { versionKey: false }

SectionSchema = new Schema
  title:
    type: String
    index:
      unique: true
  stories: Array
  count: Number
  image: String
, { versionKey: false }

module.exports =
  SectionSchema: mongoose.model "section", SectionSchema
  StorySchema: mongoose.model "story", StorySchema