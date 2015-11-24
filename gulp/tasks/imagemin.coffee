gulp = require "gulp"
config = require "../config"
$ = require('gulp-load-plugins')()

gulp.task 'imagemin', ->
  gulp.src config.image, {base: config.dir}
  .pipe $.imagemin({
    progressive: true
  })
  .pipe gulp.dest config.output
