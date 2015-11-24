gulp = require 'gulp'
$ = require('gulp-load-plugins')() # injecting gulp-* plugin
browserSync = require('browser-sync').create()
runSequence = require 'run-sequence'
rimraf = require "rimraf"
source = require 'vinyl-source-stream'
browserify = require 'browserify'

# config
config =
  dir: './app/'
  index: './app/index.html'
  vendorjs: './app/vendor.js'
  js: './app/js/**/*.js'
  css: './app/css/**/*.css'
  partials: './app/partials/**/*.html'
  copy: []
  output: './dist/'
  isWatching: false

#
# Task
#
gulp.task 'browser-sync', ->
  browserSync.init server: config.dir
# for GAE Proxy
# browserSync proxy: 'localhost:8080'

gulp.task 'bs-reload', ->
  browserSync.reload()

gulp.task 'watch', ->
  gulp.watch config.js, ['inject', 'bs-reload']
  gulp.watch config.css, ['inject', 'bs-reload']

gulp.task 'inject', ->
  sources = gulp.src [config.js, config.css], {read: false}

  gulp.src config.index
  .pipe $.inject sources, {ignorePath: 'app', addRootSlash: false}
  .pipe gulp.dest config.dir

gulp.task 'browserify', ->
  b = browserify
    entries: [config.vendorjs]
    cache: {}
    packageCache: {}
    debug: true

  if config.isWatching
    b.plugin(watchify)

  bundle = ->
    b.bundle()
    .pipe source 'vendor.build.js'
    .pipe gulp.dest config.output

  if config.isWatching
    b.on "update", bundle
    b.on "log", (msg) ->
      console.log(msg)

  bundle()

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

gulp.task 'imagemin', ->
  gulp.src config.image, {base: config.dir}
  .pipe $.imagemin({
    progressive: true
  })
  .pipe gulp.dest config.output

gulp.task 'copy', ->
  gulp.src config.partials, {base: config.dir}
  .pipe $.minifyHtml(empty: true)
  .pipe gulp.dest config.output

  # other
  gulp.src config.copy, {base: config.dir}
  .pipe gulp.dest config.output

gulp.task 'clean', (cb) ->
  rimraf(config.output, cb);

gulp.task 'setWatch', ->
  config.isWatching = true

gulp.task 'default', (cb) ->
  runSequence 'browserify', 'browser-sync', 'watch', cb

gulp.task 'build', (cb) ->
  runSequence 'clean', 'inject', 'usemin', 'copy', 'imagemin', cb

