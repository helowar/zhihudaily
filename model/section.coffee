mongoose = require "mongoose"
async = require "async"
{SectionSchema} = require "../model/schema"
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

module.exports = Section