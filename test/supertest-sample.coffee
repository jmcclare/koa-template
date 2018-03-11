import request from 'supertest'
import assert from 'assert'
import app from '../app'

import server from '../server'
# Another way to setup an http server for testing.
#server = app.listen()

describe 'home page', ->
  it 'responds with text', (done) ->
    request(server)
      .get('/')
      .expect(200)
      .expect('Content-Type', /text/)
      .expect('Hello World', done)
    # Add a blank return so that CoffeeScript doesn’t put one in front of the
    # request call. That confuses Mocha. If you put a `return` in front of the
    # call to `request` Mocha assumes you are giving it a promise.
    return

  # Now with a promise. I put the return in explicitly to demonstrate what’s
  # going on. CoffeeScript would have put it in anyway though.
  it 'responds with text again', ->
    return request(server)
      .get('/')
      .expect(200)
      .then (response) =>
        assert(response.body, 'Hello World')
