'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _url = require('url');

var _url2 = _interopRequireDefault(_url);

var _coffeescript = require('coffeescript');

var _coffeescript2 = _interopRequireDefault(_coffeescript);

var _helpers = require('coffeescript/lib/coffeescript/helpers');

var _helpers2 = _interopRequireDefault(_helpers);

var _fs = require('fs');

var _fs2 = _interopRequireDefault(_fs);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var compile, mwGenerator, updateSyntaxError;

updateSyntaxError = _helpers2.default.updateSyntaxError;

mwGenerator = function mwGenerator(opt) {
  if (!opt.src) {
    throw new Error('You should specify the source directory (src) for koa-coffeescript');
  }
  if (!opt.dst) {
    opt.dst = opt.src;
  }
  if (!opt.compileOpt) {
    opt.compileOpt = {};
  }
  return function (ctx, next) {
    var err;
    try {
      // NOTE: This try / catch statement is pointless because I cannot throw
      // errors from within compile without crashing the process.
      compile(ctx, opt);
    } catch (error) {
      err = error;
      return next(err);
    }
    return next();
  };
};

// TODO: If there is already a destination file, make this compare the file
// times of the source and destination and skip reading, compiling and writing
// if the destination has the same time or newer. Right now this is only useful
// in development because it does these things on every request.
compile = function compile(ctx, opt) {
  var compiledFilePath, filePath, pathname;
  pathname = _url2.default.parse(ctx.url).pathname;
  if (/\.js$/.test(pathname)) {
    compiledFilePath = _path2.default.join(opt.dst, pathname);
    filePath = compiledFilePath.replace(/\.js$/, '.coffee');
    filePath = filePath.replace(opt.dst, opt.src);
    // TODO: Find out why throwing an error from inside the fs.readFile callback
    // crashes the whole process. For now, I can log an error to console, but I
    // may not want to do that in production. I’d rather pass it on to the
    // next() function and let the appropriate middleware handle it.
    return _fs2.default.readFile(filePath, 'utf8', function (err, file) {
      var compiledFile;
      if (err) {
        if (err.code === 'ENOENT') {
          return;
        } else {
          //throw err
          // No matching .coffee file in the src directory for this .js file.
          // Nothing needs to be done here.
          console.log(err);
        }
      }
      try {
        compiledFile = _coffeescript2.default.compile(file, opt.compileOpt);
      } catch (error) {
        err = error;
        updateSyntaxError(err, null, filePath);
        //throw err
        console.log(err);
      }
      return _fs2.default.writeFile(compiledFilePath, compiledFile, function (err) {
        if (err) {
          //throw err
          return console.log(err);
        }
      });
    });
  }
};

exports.default = mwGenerator;