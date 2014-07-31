request = require "request"
async = require "async"
mysql = require "mysql"
fs = require "fs"

#贴图库SDK,暂时还未整合进来 https://gist.github.com/faceair/21ac198495edbb965c6b
Token = ''

connection = mysql.createConnection
  host: ""
  user: ""
  password: ""
  database: ""

connection.connect()

getData = (url, callback, parameter = '',   times = 0) ->
  request url, (error, response, body) ->
    if not error and response.statusCode is 200
      callback body, parameter if parameter != ''
      callback body if parameter == ''
    else
      times += 1
      getData url, callback, parameter, times if times < 3

addMysql = (storyJson, times = 0) ->
  connection.query "SELECT id FROM `daily` WHERE id = '#{connection.escape(storyJson.id)}'", (err, rows) ->
    if !rows[0] and storyJson.body?
      imageUrls = storyJson.body.match /https?:\/\/\S+?zhimg\.com\/\S+?\.(?:jpg|png|gif)/g
      imageUrls = [] if imageUrls == null
      imageUrls.push storyJson.image

      async.map imageUrls, ((imageUrl, callback) ->
        if imageUrl
          request.post "http://api.tietuku.com/v1/Up",
            form:
              Token: Token
              fileurl: imageUrl
          , (error, response, body) ->
            if not error and response.statusCode is 200 and !body.match('错误') and !body.match('失败')
              bodyJson = JSON.parse body
              tietukuUrls = bodyJson.url.match(/img\](.+)\[\/img/)
              callback null, [imageUrl,tietukuUrls[1]]
            else
              if times < 3
                console.log 'sleep 5s'
                sleep5s = ->
                  times += 1
                  addMysql storyJson, times
                setTimeout sleep5s, 5000
              else
                console.log imageUrl
                callback null, [imageUrl,imageUrl]
      ), (err, results) ->
        for result in results
          storyJson.body = storyJson.body.replace(result[0],result[1])
          storyJson.image = storyJson.image.replace(result[0],result[1])
        console.log 'id：' + storyJson.id
        console.log 'date：' + storyJson.date
        connection.query "INSERT ignore INTO `daily` (title,share_url,id,body,date,image,image_source,date_index) VALUES (#{connection.escape(storyJson.title)},#{connection.escape(storyJson.share_url)},#{connection.escape(storyJson.id)},#{connection.escape(storyJson.body)},#{connection.escape(storyJson.date)},#{connection.escape(storyJson.image)},#{connection.escape(storyJson.image_source)},#{connection.escape(storyJson.date_index)})", (err, rows) ->

getDay = (url = "http://news-at.zhihu.com/api/3/stories/latest") ->
  getData url, (buffer) ->
    dayJson = JSON.parse buffer
    if typeof(dayJson.stories) != "undefined"
      for story,index in dayJson.stories
        getData("http://news-at.zhihu.com/api/3/story/" + story.id, (buffer,index) ->
          storyJson = JSON.parse buffer
          storyJson.date = dayJson.date
          storyJson.date_index = dayJson.stories.length - index
          addMysql storyJson
        ,index)
      getDay "http://news-at.zhihu.com/api/3/stories/before/" + dayJson.date

getDay()
#setInterval getDay,600000