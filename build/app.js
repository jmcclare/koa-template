'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _koa = require('koa');

var _koa2 = _interopRequireDefault(_koa);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var app;

app = new _koa2.default();

// response
app.use(function (ctx) {
  return ctx.body = 'Hello World';
});

exports.default = app;