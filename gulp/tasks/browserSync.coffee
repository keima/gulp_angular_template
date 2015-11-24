gulp = require "gulp"
config = require("../config")
browserSync = require("browser-sync").create()

gulp.task "browser-sync", ->
  browserSync.init server: config.dir
#  browserSync.init proxy: "localhost:8080" # for GAE Proxy

gulp.task "bs-reload", ->
  browserSync.reload()
