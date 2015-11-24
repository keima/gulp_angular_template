gulp = require "gulp"
config = require "../config"
runSequence = require 'run-sequence'

gulp.task 'build', (cb) ->
  runSequence 'clean', 'inject', 'usemin', 'copy', 'imagemin', cb
