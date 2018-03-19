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

function _interopRequireDefault(obj) {
  return obj && obj.__esModule ? obj : { default: obj };
}

var compile, doCompile, mwGenerator, updateSyntaxError;

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
    // NOTE: This try / catch statement is pointless because I cannot throw
    // errors from within compile without crashing the process.
    //try
    //compile(ctx, opt)
    //catch err
    //return next err
    //next()
    return compile(ctx, opt, function (err) {
      if (err) {
        return next(err);
      }
      return next();
    });
  };
};

// TODO: If there is already a destination file, make this compare the file
// times of the source and destination and skip reading, compiling and writing
// if the destination has the same time or newer. Right now this is only useful
// in development because it does these things on every request.
compile = function compile(ctx, opt, cb) {
  var compiledFilePath, filePath, pathname;
  pathname = _url2.default.parse(ctx.url).pathname;
  if (/\.js$/.test(pathname)) {
    compiledFilePath = _path2.default.join(opt.dst, pathname);
    filePath = compiledFilePath.replace(/\.js$/, '.coffee');
    filePath = filePath.replace(opt.dst, opt.src);
    // Compare the file modification times.
    return _fs2.default.stat(filePath, function (err, fileStat) {
      if (err) {
        if (err.code === 'ENOENT') {
          // No matching .coffee file in the src directory for this .js file.
          // Nothing needs to be done here.
          return cb();
        } else {
          return cb(err);
        }
      }
      return _fs2.default.stat(compiledFilePath, function (err, compFileStat) {
        if (err) {
          if (err.code === 'ENOENT') {
            // Compiled .js file does not exist yet. No need to compare times.
            // Do the compilation..
            return doCompile(filePath, compiledFilePath, cb);
          } else {
            return cb(err);
          }
        }
        if (fileStat.mtime > compFileStat.mtime) {
          // The source file is newer than the compiled .js file. Do the
          // compilation.
          return doCompile(filePath, compiledFilePath, cb);
        } else {
          return cb();
        }
      });
    });
  } else {
    return cb();
  }
};

// This final stop where we actually perform the compilation, after verifying
// that we need to.
doCompile = function doCompile(filePath, compiledFilePath, cb) {
  return _fs2.default.readFile(filePath, 'utf8', function (err, file) {
    var compiledFile;
    if (err) {
      //throw err
      //console.log err
      return cb(err);
    }
    try {
      compiledFile = _coffeescript2.default.compile(file, opt.compileOpt);
    } catch (error) {
      err = error;
      updateSyntaxError(err, null, filePath);
      //throw err
      //console.log err
      return cb(err);
    }
    return _fs2.default.writeFile(compiledFilePath, compiledFile, function (err) {
      if (err) {
        //throw err
        //console.log err
        return cb(err);
      }
    });
  });
};

exports.default = mwGenerator;