https = require("https")
http = require("http")
mysql = require("mysql")
RSS = require("rss")
fs = require("fs")
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

addFeed = () ->
  dt = new Date()
  Y = dt.getFullYear()
  m = dt.getMonth() + 1
  if m < 10
    m = "0" + m
  d = dt.getDate()
  if d < 10
    d = "0" + d
  connection.query "SELECT * FROM `daily` WHERE `date` = '#{Y + m + d}' ORDER BY - `date_index`", (err, rows) ->
    feed = new RSS(
      title: "知乎日报"
      description: "知乎日报 - 满足你的好奇心"
      feed_url: "http://zhihudaily.faceair.me/rss.xml"
      site_url: "http://zhihudaily.faceair.me"
      author: "知乎"
      webMaster: "faceair"
      copyright: "© 2013-2014 知乎"
      language: "zh"
      pubDate: (new Date).toUTCString()
    )
    for row in rows
      feed.item(
        title:  row.title,
        description: row.body,
        url: row.share_url,
        guid: row.id,
        date: row.date
      )
    fs.writeFile __dirname + "/../rss.xml", feed.xml()

dealStory = (storyJson) ->
  images = storyJson.body.match(/http:\/\/[\w]+\.zhimg.com\/[\w_.\/]+/g)
  images = [] if images == null
  images.push storyJson.image
  for image in images
    if image
      imgname = image.match(/[^\/\\\\]+$/g)[0]
      imgpath = __dirname + "/../Static/img/" + imgname.slice(0,2) + "/" + imgname.slice(2,4) + "/" + imgname
      if ! fs.existsSync imgpath
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
          console.log "img " + imgname
        ,image)
  addMysql storyJson

getDay = (url = "https://news-at.zhihu.com/api/2/news/latest") ->
  Today = new Date()
  if Today.getHours() > 6 and Today.getHours() < 24
    getData url, (buffer) ->
      dayJson = JSON.parse buffer
      if typeof(dayJson.news) != "undefined"
        addFeed dayJson
        for news, index in dayJson.news
          getData(news.url, (buffer,index) ->
            storyJson = JSON.parse buffer
            storyJson.date = dayJson.date
            storyJson.date_index = dayJson.news.length - index
            dealStory storyJson
          ,index)
        #getDay "https://news-at.zhihu.com/api/2/news/before/" + dayJson.date

getDay()
setInterval getDay,600000