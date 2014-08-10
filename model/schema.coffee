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
  ga_prefix: String
  section_name:
    type: String
    index:
      unique: false
  image: String
  share_url: String
  date:
    type: String
    index:
      unique: false
  publish_at:
    type: Date
    index:
      unique: false
, { versionKey: false }

module.exports =
  StorySchema: mongoose.model "story", StorySchema