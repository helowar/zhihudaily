http = require("http")
mysql = require("mysql")
connection = mysql.createConnection(
  host: ""
  user: ""
  password: ""
  database: ""
)

connection.connect()


getDay = (url) ->
  http.get(url, (res) ->
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
      obj = JSON.parse buffer
      if typeof(obj.news) != "undefined"
        for news, i in obj.news
          dealDay news.url,obj.news.length - i,obj.date
        getDay "http://news-at.zhihu.com/api/2/news/before/" + obj.date
  )

dealDay = (url,index,date) ->
  http.get(url, (res) ->
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
      obj = JSON.parse buffer
      connection.query "INSERT ignore INTO `daily` (title,share_url,id,body,date,image,image_source,date_index) VALUES (#{connection.escape(obj.title)},#{connection.escape(obj.share_url)},#{connection.escape(obj.id)},#{connection.escape(obj.body)},#{connection.escape(date)},#{connection.escape(obj.image)},#{connection.escape(obj.image_source)},#{connection.escape(index)})", (err, rows, fields) ->
      console.log date
  )

getDay "http://news-at.zhihu.com/api/2/news/latest"