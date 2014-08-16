mongoose = require "mongoose"
daily = require "../model/daily"
crawler = require "../model/crawler"
config = require "../config"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port
{StorySchema} = require "../model/schema"
{db} = require "../config"

mongoose.connect db.url, (err)->
  throw err if err
  StorySchema.find {}, null, {}, (err, storysArr)->
    throw err if err
    for storyObj in storysArr
      imageUrls = storyObj.body.match /https?:\/\/\S+?zhimg\.com\/\S+?\.(?:jpg|png|gif)/g
      imageUrls = [] if imageUrls == null
      imageUrls_new = storyObj.image.match /https?:\/\/\S+?zhimg\.com\/\S+?\.(?:jpg|png|gif)/g
      imageUrls_new = [] if imageUrls_new == null
      for imageUrl in imageUrls_new
        imageUrls.push imageUrl
      if imageUrls.length > 0
        crawler.upImage storyObj, (err, storyObj)->
          throw err if err

          storyObj_new =
            body: storyObj.body
            image: storyObj.image
          daily.updateStory storyObj, storyObj_new, (err, storyObj)->
            throw err if err
            cache.del "/story/#{storyObj.id}", ->
            console.log storyObj.id

