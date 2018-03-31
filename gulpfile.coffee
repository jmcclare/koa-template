import gulp        from 'gulp'
import newer       from 'gulp-newer'
import shell       from 'gulp-shell'
import del         from 'del'
import Rsync       from 'rsync'
import coffee      from 'gulp-coffee'
import babel       from 'gulp-babel'
import stylus      from 'gulp-stylus'
import kswiss      from 'kouto-swiss'
import jeet        from 'jeet'
import gulpWebpack from 'webpack-stream'
import webpack     from 'webpack'
import wpcfg       from './core/webpack.config'
import path        from 'path'


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


# We tell Gulp to check only the main site.styl file that we import the others from
# because otherwise it will tell Stylus to compile each file separately with
# disastrous results. Many of the .styl files in the framework depend on others
# being imported in the correct order by the framework’s index.styl.
#
# NOTE: If you want to link to any separate compiled .css files in your
# template, you need to also include them here in the stylusSrc.
stylusSrc = './assets/_css/site.styl'
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


#
# Front end .jsx (React) JavaScript / XML app.
#
packJsx = ->
  return gulp.src('./assets/_js/react-app.jsx')
    .pipe(gulpWebpack(
      {config: wpcfg 'build' },
      webpack
    ))
    .pipe(gulp.dest('./build/public/_js/'))


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


build = gulp.series buildDir, gulp.parallel indexCoffee, coreCoffee, siteModCoffee, testCoffee, syncViews, gulp.series(syncPublic, gulp.parallel(buildStylus, buildFECoffee, packJsx))

gulp.task 'default', build
gulp.task 'clean', clean
