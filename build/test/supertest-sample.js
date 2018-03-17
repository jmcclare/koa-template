'use strict';

var _supertest = require('supertest');

var _supertest2 = _interopRequireDefault(_supertest);

var _assert = require('assert');

var _assert2 = _interopRequireDefault(_assert);

var _ = require('../');

var _2 = _interopRequireDefault(_);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var server;

server = _2.default.listen();

describe('home page', function () {
  it('responds with text', function (done) {
    (0, _supertest2.default)(server).get('/').expect(200).expect('Content-Type', /text/).expect('Hello World', done);
  });
  // Now with a promise. I put the return in explicitly to demonstrate what’s
  // going on. CoffeeScript would have put it in anyway though.
  // Add a blank return so that CoffeeScript doesn’t put one in front of the
  // request call. That confuses Mocha. If you put a `return` in front of the
  // call to `request` Mocha assumes you are giving it a promise.
  return it('responds with text again', function () {
    return (0, _supertest2.default)(server).get('/').expect(200).then(function (response) {
      return (0, _assert2.default)(response.body, 'Hello World');
    });
  });
});