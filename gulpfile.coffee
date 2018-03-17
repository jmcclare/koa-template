import gulp from 'gulp'
import newer from 'gulp-newer'
import coffee from 'gulp-coffee'
import babel from 'gulp-babel'
import del from 'del'
import stylus from 'gulp-stylus'
import Rsync from 'rsync'
import shell from 'gulp-shell'


clean = ->
    del [ 'build' ]

buildDir = ->
  gulp.src('*.js', {read: false})
    .pipe(shell(['if [ ! -d build ]; then mkdir build; fi']))


compileCoffee = (src, dst) ->
  gulp.src(src)
    .pipe(newer dst)
    .pipe(coffee({bare: true}))
    .pipe(babel())
    .pipe(gulp.dest dst)

indexCoffee = ->
  compileCoffee ['./index.coffee' ], './build/'

coreCoffee = ->
  compileCoffee ['./core/**/*.coffee' ], './build/core/'

testCoffee = ->
  compileCoffee ['./test/**/*.coffee'], './build/test/'


stylusSrc = './assets/_css/**/*.styl'
stylusDst = './build/public/_css'
buildStylus = ->
  gulp.src(stylusSrc)
    .pipe(newer stylusDst)
    .pipe(stylus { compress: true })
    .pipe(gulp.dest(stylusDst))


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
build = gulp.series buildDir, gulp.parallel indexCoffee, coreCoffee, testCoffee, syncViews, gulp.series(syncPublic, buildStylus)

gulp.task 'default', build
gulp.task 'clean', clean
