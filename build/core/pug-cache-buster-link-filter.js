'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () {
  function defineProperties(target, props) {
    for (var i = 0; i < props.length; i++) {
      var descriptor = props[i];descriptor.enumerable = descriptor.enumerable || false;descriptor.configurable = true;if ("value" in descriptor) descriptor.writable = true;Object.defineProperty(target, descriptor.key, descriptor);
    }
  }return function (Constructor, protoProps, staticProps) {
    if (protoProps) defineProperties(Constructor.prototype, protoProps);if (staticProps) defineProperties(Constructor, staticProps);return Constructor;
  };
}();

function _classCallCheck(instance, Constructor) {
  if (!(instance instanceof Constructor)) {
    throw new TypeError("Cannot call a class as a function");
  }
}

var CacheBuster, getRandomInt;

getRandomInt = function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
};

CacheBuster = function () {
  function CacheBuster(staticDir) {
    _classCallCheck(this, CacheBuster);

    this.staticDir = staticDir;
    this.cachedIDs = {};
    // Pug needs to be able to call these class methods without referencing the
    // object instance after we pass them as filter methods.
    this.link = this.link.bind(this);
  }

  _createClass(CacheBuster, [{
    key: 'link',
    value: function link(text, options) {
      var id, tag;
      // TODO: generate id for href based on local file date.
      // TODO: iterate over all options and include them as tag parameters.
      tag = '<link ';
      if (options.rel) {
        tag += ' rel="' + options.rel + '"';
      }
      if (options.type) {
        tag += ' type="' + options.type + '" ';
      }
      if (options.href) {
        //console.log 'in cacheBusterLink: ' + options.href
        //console.log 'in cacheBusterLink: ' + @staticDir
        if (this.cachedIDs[options.href]) {
          id = this.cachedIDs[options.href];
        } else {
          id = getRandomInt(1000000);
          this.cachedIDs[options.href] = id;
        }
        tag += ' href="' + options.href + '?v=' + id + '"';
      }
      tag += ' />';
      return tag;
    }
  }]);

  return CacheBuster;
}();

exports.default = CacheBuster;