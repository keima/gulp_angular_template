gulp = require "gulp"
config = require "../config"
runSequence = require 'run-sequence'

gulp.task 'default', (cb) ->
  runSequence 'browserify', 'browser-sync', 'watch', cb
