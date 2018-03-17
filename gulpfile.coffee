import gulp from 'gulp'
import coffee from 'gulp-coffee'
import babel from 'gulp-babel'
import del from 'del'
import stylus from 'gulp-stylus'
import Rsync from 'rsync'


clean = ->
    del [ 'build' ]

buildCoffee = (src, dst) ->
  gulp.src(src)
    .pipe(coffee({bare: true}))
    .pipe(babel())
    .pipe(gulp.dest dst)

coreCoffee = ->
  buildCoffee ['./core/**/*.coffee', '!gulpfile.coffee'], './build/core/'

testCoffee = ->
  buildCoffee ['./test/**/*.coffee'], './build/test/'


buildStylus = ->
  gulp.src('./assets/_css/**/*.styl')
    .pipe(stylus { compress: true })
    .pipe(gulp.dest('./build/public/_css'))


syncFiles = (src, dst) ->
  rsync = new Rsync()
    .shell('ssh')
    .flags('rltogpH')
    .set('delete')
    .source(src)
    .destination(dst)
  rsync.execute (err, code, cmd) ->
    if err
      console.log "Problem syncing files from #{src} to #{dst}."
      console.log err


syncViews = ->
  syncFiles './views/', './build/views'

# This must be completed before Stylus or front end CoffeeScript files are
# compiled.
syncPublic = ->
  syncFiles './public/', './build/public'

syncNodeModules = ->
  syncFiles './node_modules/', './build/node_modules'


#build = gulp.series clean, gulp.parallel coreCoffee, testCoffee
build = gulp.parallel coreCoffee, gulp.series(syncPublic, buildStylus), syncViews, syncNodeModules

gulp.task 'default', build
gulp.task 'clean', clean
