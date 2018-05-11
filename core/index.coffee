import debugMod from 'debug'
debug = debugMod 'core'
import Koa from 'koa'
app = new Koa()
import Router from 'koa-router'
import Pug from 'koa-pug'
import path from 'path'
import error from 'koa-error'
import stylus from 'stylus'
import kStylus from 'koa-stylus'
import kswiss from 'kouto-swiss'
import jeet from 'jeet'
import serve from 'koa-static'
import webpack from 'koa-webpack'

import webpackConfig from './webpack.config'
import { inProd } from './utils'
import loggerSetup from './logger'
import CacheBuster from './pug-cache-buster-link-filter'

import { productsRouter } from 'products'


staticDir = path.join __dirname, '../public'
viewPath = path.join __dirname, '../views'
defaultLocals =
  title: 'Koa Template'


if inProd
  # This tells the default error handler to not log any thrown middleware error
  # to the console. It has no effect if your own middleware handles all errors.
  app.silent = true


if ! inProd
  errorEnv = 'development'
else
  errorEnv = 'production'
app.use error
  engine: 'pug',
  template: path.join __dirname, '../views/error.pug'
  env: errorEnv


# Basic error handler that logs any errors to console.
# This must be 'used' before any middleware that may throw errors to ensure it
# catches them.
#app.use (ctx, next) =>
  #try
    #await next()
  #catch err
    #console.log err
    #ctx.body = 'caught an error'

#app.use (ctx, next) =>
  #try
    #await next()
  #catch err
    #console.log err
    #ctx.body = 'caught an error'

loggerOpts = {}
if inProd
  loggerOpts.logReq = true
  loggerOpts.logErr = true
else
  loggerOpts.logReq = false
logger = loggerSetup loggerOpts
app.use logger


pug = new Pug
  viewPath: viewPath,
  basedir: viewPath,
  cache: ! process.env.NODE_ENV == 'development',
  debug: process.env.NODE_ENV == 'development',
  pretty: process.env.NODE_ENV == 'development',
  compileDebug: process.env.NODE_ENV == 'development',
  locals: defaultLocals,
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

app.use serve staticDir


# Test middleware that does nothing but throw an error.
# This has no effect if it’s used after any routes are used.
#app.use (ctx, next) =>
  ##throw new Error 'Fake Error'
  #ctx.throw 500, 'Fake Error'
  #


topRouter = new Router()

# An example of adding variables that will show up in the template context for
# everything under this router. bodyClasses will also show up in the template
# contexts for every router nested under topRouter.
topRouter.use (ctx, next) =>
  #ctx.state.bodyClasses = 'regular special'
  ctx.state.router = topRouter
  cacheBuster = new CacheBuster staticDir
  ctx.state.cburl = cacheBuster.url
  await next()

topRouter.get 'home', '/', (ctx, next) =>
  # This terser method will allow you to override context state parameters.
  # Parameters of the locals object will not override values in ctx.state.
  #ctx.state.bodyClasses = 'something something-else'
  locals =
    #bodyClasses: 'something something-else'
    title: 'Home Page'
    subHeading: 'A template for a Node.js Koa site'
  ctx.render 'home', locals

topRouter.get 'react-sample', '/react-sample', (ctx, next) =>
  locals =
    title: 'React Sample'
    subHeading: 'Tic Tac Toe'
  ctx.render 'react-sample', locals

topRouter.use '/products', productsRouter.routes(), productsRouter.allowedMethods()

app
  .use(topRouter.routes())
  .use(topRouter.allowedMethods())


# This must come after the routes to only catch unhandled requests.
app.use (ctx, next) =>
  ctx.response.status = 404
  ctx.response.message = 'Not Found'
  await next()

  if ctx.request.accepts 'html'
    locals =
      title: 'Page Not Found'
    return ctx.render '404', locals, true

  if ctx.request.accepts 'json'
    ctx.body = { message: 'Not Found' }
    return

  # default to plain text
  ctx.body = 'Not Found'


# A makeshift error event handler middleware.
# This can be defined anywhere after the app object is created.
#app.on 'error', (err, ctx) =>
  ##log.error('server error', err, ctx)
  #console.log 'stuff'
  #console.log err


export default app
