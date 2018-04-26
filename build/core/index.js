'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _debug = require('debug');

var _debug2 = _interopRequireDefault(_debug);

var _koa = require('koa');

var _koa2 = _interopRequireDefault(_koa);

var _koaRouter = require('koa-router');

var _koaRouter2 = _interopRequireDefault(_koaRouter);

var _koaPug = require('koa-pug');

var _koaPug2 = _interopRequireDefault(_koaPug);

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _koaError = require('koa-error');

var _koaError2 = _interopRequireDefault(_koaError);

var _stylus = require('stylus');

var _stylus2 = _interopRequireDefault(_stylus);

var _koaStylus = require('koa-stylus');

var _koaStylus2 = _interopRequireDefault(_koaStylus);

var _koutoSwiss = require('kouto-swiss');

var _koutoSwiss2 = _interopRequireDefault(_koutoSwiss);

var _jeet = require('jeet');

var _jeet2 = _interopRequireDefault(_jeet);

var _koaStatic = require('koa-static');

var _koaStatic2 = _interopRequireDefault(_koaStatic);

var _koaWebpack = require('koa-webpack');

var _koaWebpack2 = _interopRequireDefault(_koaWebpack);

var _webpack = require('./webpack.config');

var _webpack2 = _interopRequireDefault(_webpack);

var _products = require('products');

function _interopRequireDefault(obj) {
  return obj && obj.__esModule ? obj : { default: obj };
}

// 'production' mode is the default. That’s what we do if `NODE_ENV` is
// undefined.

// This is a simple boolean to tell most things if they should operate in
// production mode or not. Some things may have to check for specific values of
// NODE_ENV to decide which database to use, etc.
var app, debug, errorEnv, global_locals_for_all_pages, inProd, pug, stylusCompile, topRouter, viewPath;

inProd = process.env.NODE_ENV === void 0 || process.env.NODE_ENV === 'production' || process.env.NODE_ENV === 'production-test';

debug = (0, _debug2.default)('core');

app = new _koa2.default();

topRouter = new _koaRouter2.default();

if (inProd) {
  // This tells the default error handler to not log any thrown middleware error
  // to the console. It has no effect if your own middleware handles all errors.
  app.silent = true;
}

if (!inProd) {
  errorEnv = 'development';
} else {
  errorEnv = 'production';
}

app.use((0, _koaError2.default)({
  engine: 'pug',
  template: _path2.default.join(__dirname, '../views/error.pug'),
  env: errorEnv
}));

//app.use (ctx, next) =>
//try
//await next()
//catch err
//console.log err
//ctx.body = 'caught an error'
viewPath = _path2.default.join(__dirname, '../views');

global_locals_for_all_pages = {
  title: 'Koa Template',
  router: topRouter
};

pug = new _koaPug2.default({
  viewPath: viewPath,
  basedir: viewPath,
  cache: !process.env.NODE_ENV === 'development',
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

if (!inProd) {
  stylusCompile = function stylusCompile(str, path) {
    return (0, _stylus2.default)(str).set('filename', path).set('compress', false).use((0, _koutoSwiss2.default)()).use((0, _jeet2.default)());
  };
  app.use((0, _koaStylus2.default)({
    src: _path2.default.join(__dirname, '../assets'),
    dest: _path2.default.join(__dirname, '../public'),
    compile: stylusCompile
  }));
}

if (!inProd) {
  app.use((0, _koaWebpack2.default)({
    config: (0, _webpack2.default)('development')
  }));
}

app.use((0, _koaStatic2.default)(_path2.default.join(__dirname, '../public')));

// Test middleware that does nothing but throw an error.
// This has no effect if it’s used after any routes are used.
//app.use (ctx, next) =>
//throw new Error 'Wolf!'
topRouter.get('react-sample', '/react-sample', function (ctx, next) {
  return ctx.render('react-sample', {
    title: 'React Sample'
  }, true);
});

topRouter.get('home', '/', function (ctx, next) {
  var locals;
  locals = {
    title: 'Home Page',
    subHeading: 'A template for a Node.js Koa site'
  };
  return ctx.render('home', locals, true);
});

topRouter.use('/products', _products.productsRouter.routes(), _products.productsRouter.allowedMethods());

app.use(topRouter.routes()).use(topRouter.allowedMethods());

// This must come after the routes to only catch unhandled requests.
app.use(async function (ctx, next) {
  var locals;
  ctx.response.status = 404;
  await next();
  if (ctx.request.accepts('html')) {
    locals = {
      title: 'Page Not Found'
    };
    return ctx.render('404', locals, true);
  }
  if (ctx.request.accepts('json')) {
    ctx.body = {
      error: 'Not Found'
    };
    return;
  }
  // default to plain text
  return ctx.body = 'Not Found';
});

// A makeshift error event handler middleware.
// This can be defined anywhere after the app object is created.
//app.on 'error', (err, ctx) =>
//#log.error('server error', err, ctx)
//console.log 'stuff'
//console.log err
exports.default = app;