'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _app = require('./app');

var _app2 = _interopRequireDefault(_app);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var port, server;

port = process.env.PORT || 3000;

server = _app2.default.listen(port, function () {
  return console.log('server started at port ' + port);
});

exports.default = server;