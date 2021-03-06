gulp = require 'gulp'
gutil = require 'gulp-util'
stylus = require 'gulp-stylus'
autoprefixer = require 'gulp-autoprefixer'

$ = require('gulp-load-plugins')()

# config
# src_dir = './src'
# public_dir = './public'

# NOTE: template -> jade, script -> coffee, script -> stylus のがいいかも?
config =
  jade:
    source: './src/jade'
    watch: 'src/jade/*.jade'
    destination: './public'
    config:
      pretty: true
  scripts:
    source: './src/coffee'
    watch: './src/coffee/*.coffee'
    destination: './public/js'
    option:
      bare: true
  styles:
    source: './src/stylus'
    watch: './src/stylus/*.styl'
    destination: './public/css'

# error handle
handleError = (err) ->
  gutil.log err
  gutil.beep()
  this.emit 'end'


gulp.task 'jade', ->
  gulp
    .src config.jade.watch
    .pipe $.jade(
      config.jade.option
    )
    .on 'error', handleError
    .pipe gulp.dest config.jade.destination


gulp.task 'script', ->
  gulp
    .src config.scripts.watch
    .pipe $.coffee()
    .on 'error', handleError
    .pipe gulp.dest config.scripts.destination

gulp.task "style", ->
  gulp
    .src config.styles.watch
    .pipe $.sourcemaps.init()
    .pipe stylus
      compress: true
    .pipe autoprefixer
      browsers: ['last 2 versions']
    .pipe $.sourcemaps.write('.')
    .on 'error', handleError
    .pipe gulp.dest config.styles.destination


# watch
gulp.task 'watch', ->
  gulp.watch config.scripts.watch, ['script']
  gulp.watch config.styles.watch, ['style']
  gulp.watch config.jade.watch, ['jade']

#load
gulp.task 'default', ["script", "style", "jade"]
