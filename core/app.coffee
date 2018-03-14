import Koa from 'koa'
app = new Koa()


# response
app.use (ctx) =>
  ctx.body = 'Hello World'


export default app
