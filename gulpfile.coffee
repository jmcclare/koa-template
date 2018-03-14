import gulp from 'gulp'
import coffee from 'gulp-coffee'
import babel from 'gulp-babel'
import del from 'del'


clean = ->
    del [ 'build' ]

buildCoffee = (src, dst) ->
  gulp.src(src)
    .pipe(coffee({bare: true}))
    .pipe(babel())
    .pipe(gulp.dest dst)

mainCoffee = ->
  buildCoffee ['*.coffee', '!gulpfile.coffee'], './build/'

testCoffee = ->
  buildCoffee ['./test/**/*.coffee'], './build/test/'


build = ->
  clean()
  mainCoffee()
  testCoffee()

gulp.task 'default', build
gulp.task 'clean', clean
