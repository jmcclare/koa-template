import Koa from 'koa'
import Router from 'koa-router'
import Pug from 'koa-pug'
import path from 'path'

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
