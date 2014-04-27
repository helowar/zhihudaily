https = require("https")
http = require("http")
mysql = require("mysql")
fs = require('fs')
connection = mysql.createConnection(
  host: ""
  user: ""
  password: ""
  database: ""
)
connection.connect()

getData = (url,callback,parameter = '') ->
  protocol = ((if url.match(/https/) then https else http))
  protocol.get(url, (res) ->
    buffers = []
    nread = 0
    res.on "data", (chunk) ->
      buffers.push chunk
      nread += chunk.length
    res.on 'end', () ->
      buffer = null
      switch buffers.length
        when 0
          buffer = new Buffer(0)
        when 1
          buffer = buffers[0]
        else
          buffer = new Buffer(nread)
          i = 0
          pos = 0
          l = buffers.length

          while i < l
            chunk = buffers[i]
            chunk.copy buffer, pos
            pos += chunk.length
            i++
      callback buffer,parameter if parameter != ''
      callback buffer if parameter == ''
  )

addMysql = (storyJson) ->
  connection.query "INSERT ignore INTO `daily` (title,share_url,id,body,date,image,image_source,date_index) VALUES (#{connection.escape(storyJson.title)},#{connection.escape(storyJson.share_url)},#{connection.escape(storyJson.id)},#{connection.escape(storyJson.body)},#{connection.escape(storyJson.date)},#{connection.escape(storyJson.image)},#{connection.escape(storyJson.image_source)},#{connection.escape(storyJson.date_index)})", (err, rows, fields) ->
    console.log storyJson.date

dealStory = (storyJson) ->
  images = storyJson.body.match(/http:\/\/[\w-]+\.zhimg([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/g)
  if images
    for image in images
      getData(image,(imgData,image) ->
        nameArray =  image.match(/[^\/\\\\]+$/g)
        fs.writeFile __dirname + "/../Static/img/" + nameArray[0], imgData
      ,image)

getDay = (url) ->
  console.log url
  getData url, (buffer) ->
    dayJson = JSON.parse buffer
    if typeof(dayJson.news) != "undefined"
      for news, index in dayJson.news
        getData(news.url, (buffer,index) ->
          storyJson = JSON.parse buffer
          storyJson.date = dayJson.date
          storyJson.date_index = dayJson.news.length - index
          dealStory storyJson
          addMysql storyJson
        ,index)
      getDay "https://news-at.zhihu.com/api/2/news/before/" + dayJson.date

getDay "https://news-at.zhihu.com/api/2/news/latest"