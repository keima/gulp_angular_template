gulp = require "gulp"
config = require "../config"
$ = require('gulp-load-plugins')()

gulp.task 'inject', ->
  sources = gulp.src [config.js, config.css], {read: false}

  gulp.src config.index
  .pipe $.inject sources, {ignorePath: 'app', addRootSlash: false}
  .pipe gulp.dest config.dir
