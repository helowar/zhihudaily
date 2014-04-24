http = require("http")
mysql = require("mysql")
connection = mysql.createConnection(
  host: ""
  user: ""
  password: ""
  database: ""
)
connection.connect()

getData = (url,callback,parameter = '') ->
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
      Json = JSON.parse buffer
      callback Json,parameter if parameter != ''
      callback Json if parameter == ''
  )

addMysql = (storyJson) ->
  connection.query "INSERT ignore INTO `daily` (title,share_url,id,body,date,image,image_source,date_index) VALUES (#{connection.escape(storyJson.title)},#{connection.escape(storyJson.share_url)},#{connection.escape(storyJson.id)},#{connection.escape(storyJson.body)},#{connection.escape(storyJson.date)},#{connection.escape(storyJson.image)},#{connection.escape(storyJson.image_source)},#{connection.escape(storyJson.date_index)})", (err, rows, fields) ->
    console.log storyJson.date

getDay = (url) ->
  getData url, (dayJson) ->
    if typeof(dayJson.news) != "undefined"
      for news, index in dayJson.news
        getData(news.url, (storyJson,index) ->
          storyJson.date = dayJson.date
          storyJson.date_index = dayJson.news.length - index
          addMysql storyJson
        ,index)
      getDay "http://news-at.zhihu.com/api/2/news/before/" + dayJson.date

getDay "http://news-at.zhihu.com/api/2/news/latest"