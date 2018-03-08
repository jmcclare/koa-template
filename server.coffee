import app from './app'

port = process.env.PORT || 3000

app.listen port, () =>
  console.log "server started at port #{port}"
