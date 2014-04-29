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
  if url
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
    ).on('error', (e) ->
      console.log url
      getData url,callback,parameter
    )

addMysql = (storyJson) ->
  connection.query "INSERT ignore INTO `daily` (title,share_url,id,body,date,image,image_source,date_index) VALUES (#{connection.escape(storyJson.title)},#{connection.escape(storyJson.share_url)},#{connection.escape(storyJson.id)},#{connection.escape(storyJson.body)},#{connection.escape(storyJson.date)},#{connection.escape(storyJson.image)},#{connection.escape(storyJson.image_source)},#{connection.escape(storyJson.date_index)})", (err, rows, fields) ->
    console.log "sql " + storyJson.id

dealStory = (storyJson) ->
  images = storyJson.body.match(/http:\/\/[\w-]+\.zhimg([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/g)
  images = [] if images == null
  images.push storyJson.image
  for image in images
    imgname = image.match(/[^\/\\\\]+$/g)[0]
    imgpath = __dirname + "/../Static/img/" + imgname.slice(0,2) + "/" + imgname.slice(2,4) + "/" + imgname
    fs.exists(imgpath,(exists)->
      if !exists
        getData(image,(imgData,image) ->
          imgname = image.match(/[^\/\\\\]+$/g)[0]
          folderA = __dirname + "/../Static/img/" + imgname.slice(0,2) + "/"
          folderB = folderA + imgname.slice(2,4) + "/"

          if ! fs.existsSync folderA
            fs.mkdirSync folderA
            fs.mkdirSync folderB
          else
            if ! fs.existsSync folderB
              fs.mkdirSync folderB

          fs.writeFile folderB + imgname, imgData
          console.log "img " + storyJson.id
        ,image)
    )
  addMysql storyJson

getDay = (url) ->
  getData url, (buffer) ->
    dayJson = JSON.parse buffer
    if typeof(dayJson.news) != "undefined"
      for news, index in dayJson.news
        getData(news.url, (buffer,index) ->
          storyJson = JSON.parse buffer
          storyJson.date = dayJson.date
          storyJson.date_index = dayJson.news.length - index
          dealStory storyJson
        ,index)
      #getDay "https://news-at.zhihu.com/api/2/news/before/" + dayJson.date

getDay "https://news-at.zhihu.com/api/2/news/latest"