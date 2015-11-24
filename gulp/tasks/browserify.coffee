gulp = require "gulp"
config = require "../config"
browserify = require "browserify"
watchify = require "watchify"
source = require "vinyl-source-stream"

gulp.task "browserify", ->
  b = browserify
    entries: [config.vendorjs]
    cache: {}
    packageCache: {}
    debug: true

  if config.isWatching
    b.plugin(watchify)

  bundle = ->
    b.bundle()
    .pipe source "vendor.build.js"
    .pipe gulp.dest config.output

  if config.isWatching
    b.on "update", bundle
    b.on "log", (msg) ->
      console.log(msg)

  bundle()
