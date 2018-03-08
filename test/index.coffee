import request from 'supertest'
import app from '../app'

import server from '../server'
# Another way to setup an http server for testing.
#server = app.listen()


request(server)
  .get('/')
  .expect(200)
  .expect('Content-Type', /text/)
  .expect('Content-Length', '11')
  .end (err, res) ->
    if err
      throw err
