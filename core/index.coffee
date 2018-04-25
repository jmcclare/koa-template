# 'production' mode is the default. That’s what we do if `NODE_ENV` is
# undefined.
#
# This is a simple boolean to tell most things if they should operate in
# production mode or not. Some things may have to check for specific values of
# NODE_ENV to decide which database to use, etc.
inProd = process.env.NODE_ENV == undefined || process.env.NODE_ENV == 'production' || process.env.NODE_ENV == 'production-test'

import debugMod from 'debug'
debug = debugMod 'core'
import Koa from 'koa'
import Router from 'koa-router'
import Pug from 'koa-pug'
import path from 'path'

import stylus from 'stylus'
import kStylus from 'koa-stylus'
import kswiss from 'kouto-swiss'
import jeet from 'jeet'
import serve from 'koa-static'
import webpack from 'koa-webpack'
import webpackConfig from './webpack.config'

import { productsRouter } from 'products'


app = new Koa()

if inProd
  # This tells the default error handler to not log any thrown middleware error
  # to the console. It has no effect if your own middleware handles all errors.
  app.silent = true

# Basic error handler that logs any errors to console.
# This must be 'used' before any middleware that may throw errors to ensure it
# catches them.
#app.use (ctx, next) =>
  #try
    #await next()
  #catch err
    #console.log err
    #ctx.body = 'caught an error'


topRouter = new Router()


viewPath = path.join __dirname, '../views'
global_locals_for_all_pages =
  title: 'Koa Template'
  router: topRouter

pug = new Pug
  viewPath: viewPath,
  basedir: viewPath,
  cache: ! process.env.NODE_ENV == 'development',
  debug: process.env.NODE_ENV == 'development',
  pretty: process.env.NODE_ENV == 'development',
  compileDebug: process.env.NODE_ENV == 'development',
  locals: global_locals_for_all_pages,
  #helperPath: [
    #'path/to/pug/helpers',
    #{ random: 'path/to/lib/random.js' },
    #{ _: require('lodash') }
  #],
  app: app # equals to pug.use(app) and app.use(pug.middleware)


# We only use stylus here in development mode. In production the .styl files
# will already be compiled into .css and stored in the pubic directory.
if ! inProd
  stylusCompile = (str, path) ->
    return stylus(str)
      .set('filename', path)
      .set('compress', false)
      .use(kswiss())
      .use(jeet())
  app.use kStylus
    src: path.join __dirname, '../assets'
    dest: path.join __dirname, '../public'
    compile: stylusCompile

# Webpack handles on the fly compiling of front end .coffee, .js, and .jsx
# files (in the _assets/_js dir).
#
# This is only used in development or regular development test mode. In
# production, these files will be precompiled into JavaScript files by Gulp
# using webpack.
if ! inProd
  app.use webpack config: webpackConfig 'development'

app.use serve path.join __dirname, '../public'


# Test middleware that does nothing but throw an error.
# This has no effect if it’s used after any routes are used.
#app.use (ctx, next) =>
  #throw new Error 'Wolf!'


topRouter.get 'react-sample', '/react-sample', (ctx, next) =>
  ctx.render 'react-sample', { title: 'React Sample' }, true

topRouter.get 'home', '/', (ctx, next) =>
  locals =
    title: 'Home Page'
    subHeading: 'A template for a Node.js Koa site'
  ctx.render 'home', locals, true

topRouter.use '/products', productsRouter.routes(), productsRouter.allowedMethods()


app
  .use(topRouter.routes())
  .use(topRouter.allowedMethods())


# A makeshift error event handler middleware.
# This can be defined anywhere after the app object is created.
#app.on 'error', (err, ctx) =>
  ##log.error('server error', err, ctx)
  #console.log 'stuff'
  #console.log err


export default app
