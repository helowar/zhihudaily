module.exports =
  web:
    port: 4000

  db:
    url: "mongodb://localhost:27017/zhihudaily"

  tietuku:
    upurl: "http://up.tietuku.com"
    album: 1000
    accesskey: ""
    secretkey: ""

  crawler:
    interval: 600000
    fetch: "today"

  api:
    beforeDay: ""
    story: ""

  redis:
    switch: true
    host: "localhost"
    port: 6358