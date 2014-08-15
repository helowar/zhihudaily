config = require "../config"
cache = require('express-redis-cache')
  host: config.redis.host, port: config.redis.port

cache.ls (err, cachesArr)->
  for cacheObj in cachesArr
    cache.del cacheObj.name, ->
  console.log "Done."