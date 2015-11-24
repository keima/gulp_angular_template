gulp = require "gulp"
config = require "../config"
$ = require('gulp-load-plugins')()

gulp.task 'usemin', ->
  cssTask = (files, filename) ->
    if files?
      files.pipe $.pleeease(
#      import: {path: ["dist/bower_components/onsenui/build/css","app/bower_components/onsenui/build/css"]}
        autoprefixer: {browsers: ["last 4 versions", "ios 6", "android 4.0"]}
#      rebaseUrls: false
        out: config.output + filename
      )
      .pipe $.concat(filename)
      .pipe $.rev()

  jsTask = (files, filename) ->
    if files?
      files.pipe $.ngAnnotate()
      .pipe $.uglify()
      .pipe $.concat(filename)
      .pipe $.rev()

  gulp.src config.index
  .pipe $.spa.html
    assetsDir: config.dir
    pipelines:
      main: (files)->
        files.pipe $.minifyHtml(empty: true, conditionals: true)
      vendorjs: (files)->
        jsTask files, "vendor.js"
      js: (files)->
        jsTask files, "app.js"
      vendorcss: (files)->
        cssTask files, "vendor.css"
      css: (files)->
        cssTask files, "app.css"
  .pipe gulp.dest(config.output)
