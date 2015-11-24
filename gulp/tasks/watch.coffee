gulp = require "gulp"
config = require("../config")

gulp.task 'watch', ["setWatch"], ->
  gulp.watch config.js,
    ['inject', 'bs-reload']
  gulp.watch config.css,
    ['inject', 'bs-reload']

gulp.task 'setWatch', ->
  config.isWatching = true
