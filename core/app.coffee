import Koa from 'koa'
import Router from 'koa-router'

app = new Koa()
topRouter = new Router()
userRouter = new Router()


userRouter.get 'users', '/', (ctx, next) =>
  ctx.body = 'main users page'

userRouter.get 'test1', '/test1', (ctx, next) =>
  ctx.body = 'this is test1'

userRouter.get 'test2', '/test2', (ctx, next) =>
  ctx.body = 'this is test2'


topRouter.get 'home', '/', (ctx, next) =>
  ctx.body = 'Hello World'

topRouter.use '/users', userRouter.routes(), userRouter.allowedMethods()


app
  .use(topRouter.routes())
  .use(topRouter.allowedMethods())


export default app
