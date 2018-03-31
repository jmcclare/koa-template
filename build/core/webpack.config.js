'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _webpack = require('webpack');

var _webpack2 = _interopRequireDefault(_webpack);

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _babelMinifyWebpackPlugin = require('babel-minify-webpack-plugin');

var _babelMinifyWebpackPlugin2 = _interopRequireDefault(_babelMinifyWebpackPlugin);

function _interopRequireDefault(obj) {
  return obj && obj.__esModule ? obj : { default: obj };
}

var appRoot, developmentPlugins, productionPlugins, webpackConfig;

appRoot = _path2.default.resolve(_path2.default.join(__dirname, '../'));

developmentPlugins = [new _webpack2.default.NoEmitOnErrorsPlugin(), new _webpack2.default.HotModuleReplacementPlugin()];

productionPlugins = [];

// This is taken from the default production plugins so it unnecessary here.
//new webpack.DefinePlugin({
//'process.env.NODE_ENV': JSON.stringify('production')
//})

// These two plugins cause an error when compiling through webpack-stream.
//new webpack.optimize.UglifyJsPlugin()
//new webpack.optimize.DedupePlugin(),

// This plugin seems to be unnecessary. It seems like the default production
// plugins already do their own minification.
//new babelMinify()
webpackConfig = function webpackConfig(mode) {
  var config, plugins;
  if (mode === 'development' || mode === 'test') {
    mode = 'development';
    plugins = developmentPlugins;
  } else {
    mode = 'production';
    plugins = productionPlugins;
  }
  config = {
    entry: {
      'js/app': [_path2.default.join(appRoot, 'assets', '_js', 'react-app.jsx')]
    },
    //entry: [path.join(appRoot, 'assets', '_js', 'app.jsx')]
    //context: path.join(appRoot, 'assets')
    output: {
      path: _path2.default.join(appRoot, 'public', '_js'),
      publicPath: '/_js',
      //filename: '[name].js'
      filename: 'react-app.js'
    },
    resolve: {
      extensions: ['.js', '.jsx']
    },
    plugins: plugins,
    module: {
      rules: [{
        test: /\.jsx?$/,
        loader: 'babel-loader',
        query: {
          presets: ['es2015', 'react'],
          plugins: ['transform-regenerator', 'transform-async-to-generator']
        },
        include: [_path2.default.resolve(appRoot, 'assets', '_js')]
      }]
    },
    mode: mode
  };
  return config;
};

exports.default = webpackConfig;