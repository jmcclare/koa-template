'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _koa = require('koa');

var _koa2 = _interopRequireDefault(_koa);

var _koaRouter = require('koa-router');

var _koaRouter2 = _interopRequireDefault(_koaRouter);

var _koaPug = require('koa-pug');

var _koaPug2 = _interopRequireDefault(_koaPug);

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _koaStylus = require('koa-stylus');

var _koaStylus2 = _interopRequireDefault(_koaStylus);

var _koaStatic = require('koa-static');

var _koaStatic2 = _interopRequireDefault(_koaStatic);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var app, global_locals_for_all_pages, pug, topRouter, userRouter, viewPath;

app = new _koa2.default();

topRouter = new _koaRouter2.default();

userRouter = new _koaRouter2.default();

viewPath = _path2.default.join(__dirname, '../views');

global_locals_for_all_pages = {
  title: 'Koa Template'
};

pug = new _koaPug2.default({
  viewPath: viewPath,
  basedir: viewPath,
  debug: process.env.NODE_ENV === 'development',
  pretty: process.env.NODE_ENV === 'development',
  compileDebug: process.env.NODE_ENV === 'development',
  locals: global_locals_for_all_pages,
  //helperPath: [
  //'path/to/pug/helpers',
  //{ random: 'path/to/lib/random.js' },
  //{ _: require('lodash') }
  //],
  app: app // equals to pug.use(app) and app.use(pug.middleware)
});

// We only use stylus here in development mode. In production the .styl files
// will already be compiled into .css and stored in the pubic directory.
if (process.env.NODE_ENV === 'development') {
  app.use((0, _koaStylus2.default)({
    src: _path2.default.join(__dirname, '../assets'),
    dest: _path2.default.join(__dirname, '../public')
  }));
}

app.use((0, _koaStatic2.default)(_path2.default.join(__dirname, '../public')));

userRouter.get('users', '/', function (ctx, next) {
  return ctx.render('users', {
    title: 'Users'
  }, true);
});

userRouter.get('test1', '/test1', function (ctx, next) {
  return ctx.render('test1', {
    title: 'Test 1'
  }, true);
});

userRouter.get('test2', '/test2', function (ctx, next) {
  return ctx.render('test2', {
    title: 'Test 2'
  }, true);
});

topRouter.get('home', '/', function (ctx, next) {
  return ctx.render('home', {
    title: 'Home Page'
  }, true);
});

topRouter.use('/users', userRouter.routes(), userRouter.allowedMethods());

app.use(topRouter.routes()).use(topRouter.allowedMethods());

exports.default = app;