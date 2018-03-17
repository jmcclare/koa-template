import Koa from 'koa'
import Router from 'koa-router'
import Pug from 'koa-pug'
import path from 'path'

import stylus from 'koa-stylus'
import serve from 'koa-static'


# This will be true if we are not in production mode.
nonProd = process.env.NODE_ENV == 'development' || process.env.NODE_ENV == 'test'

app = new Koa()


topRouter = new Router()
userRouter = new Router()


viewPath = path.join __dirname, '../views'
global_locals_for_all_pages =
  title: 'Koa Template'

pug = new Pug
  viewPath: viewPath,
  basedir: viewPath,
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
if nonProd
  app.use stylus
    src:path.join __dirname, '../assets'
    dest:path.join __dirname, '../public'

app.use serve path.join __dirname, '../public'


userRouter.get 'users', '/', (ctx, next) =>
  ctx.render 'users', { title: 'Users' }, true

userRouter.get 'test1', '/test1', (ctx, next) =>
  ctx.render 'test1', { title: 'Test 1' }, true

userRouter.get 'test2', '/test2', (ctx, next) =>
  ctx.render 'test2', { title: 'Test 2' }, true


topRouter.get 'home', '/', (ctx, next) =>
  ctx.render 'home', { title: 'Home Page' }, true

topRouter.use '/users', userRouter.routes(), userRouter.allowedMethods()


app
  .use(topRouter.routes())
  .use(topRouter.allowedMethods())


export default app
