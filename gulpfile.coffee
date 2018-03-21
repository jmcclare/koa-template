import gulp from 'gulp'
import newer from 'gulp-newer'
import coffee from 'gulp-coffee'
import babel from 'gulp-babel'
import del from 'del'
import stylus from 'gulp-stylus'
import kswiss from 'kouto-swiss'
import jeet from 'jeet'
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
    .pipe(coffee {
      bare: true
      transpile:
        presets: 'es2015'
    })
    .pipe(babel())
    .pipe(gulp.dest dst)

indexCoffee = ->
  compileCoffee ['./index.coffee' ], './build/'

coreCoffee = ->
  compileCoffee ['./core/**/*.coffee' ], './build/core/'

siteModCoffee = ->
  compileCoffee ['./site_modules/**/*.coffee' ], './build/site_modules/'

testCoffee = ->
  compileCoffee ['./test/**/*.coffee'], './build/test/'


stylusSrc = './assets/_css/**/*.styl'
stylusDst = './build/public/_css'
buildStylus = ->
  gulp.src(stylusSrc)
    .pipe(newer stylusDst)
    .pipe(stylus {
      compress: true
      use: [ kswiss(), jeet() ]
    })
    .pipe(gulp.dest(stylusDst))


# Front end CoffeeScript files.
#
# These are generated per‐request by koa-coffeescript, but we also do it here
# in case we change a front‐end coffee file without accessing it in the
# browser, or in case we want different compiler settings for production. We
# also have a separate function for the front end coffee in case I need to
# compile it differently from the back end.
feCoffeeSrc = './assets/_js/**/*.coffee'
feCoffeeDst = './build/public/_js'
buildFECoffee = ->
  gulp.src(feCoffeeSrc)
    .pipe(newer feCoffeeDst)
    .pipe(coffee {
      bare: true
      transpile:
        presets: 'es2015'
    })
    .pipe(gulp.dest(feCoffeeDst))


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
build = gulp.series buildDir, gulp.parallel indexCoffee, coreCoffee, siteModCoffee, testCoffee, syncViews, gulp.series(syncPublic, gulp.parallel(buildStylus, buildFECoffee))

gulp.task 'default', build
gulp.task 'clean', clean
