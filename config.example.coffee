module.exports =
  web:
    port: 4000

  db:
    url: "mongodb://localhost:27017/zhihudaily"

  tietuku:
    album: 1000
    accesskey: ""
    secretkey: ""

  crawler:
    interval: 600000
    fetch: "today"

  redis:
    switch: true
    host: "localhost"
    port: 6358