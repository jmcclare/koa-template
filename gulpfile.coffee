import gulp from 'gulp'
import coffee from 'gulp-coffee'
import babel from 'gulp-babel'
import del from 'del'
import stylus from 'gulp-stylus'


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


#build = gulp.series clean, gulp.parallel coreCoffee, testCoffee
build = gulp.series gulp.parallel coreCoffee, buildStylus

gulp.task 'default', build
gulp.task 'clean', clean
