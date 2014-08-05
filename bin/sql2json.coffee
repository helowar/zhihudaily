mysql = require "mysql"
mongoose = require "mongoose"
{StorySchema} = require "../model/schema"
{db} = require "../config"

connection = mysql.createConnection
  host: ""
  user: ""
  password: ""
  database: ""

connection.connect()

mongoose.connect db.url, (err)->
  throw err if err
  connection.query "SELECT * FROM `daily` WHERE `date` != 0 ORDER BY `daily`.`id` ASC", (err, storysArr) ->
    throw err if err
    for storyObj in storysArr
      storyObj_new =
        id: storyObj.id
        body: storyObj.body
        image_source: storyObj.image_source
        title: storyObj.title
        image: storyObj.image
        share_url: storyObj.share_url
        date: storyObj.date
        index: storyObj.date_index
      story = new StorySchema storyObj_new
      story.save (err, storyObj) ->
        throw err if err
        console.log storyObj.id