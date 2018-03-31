import webpack from 'webpack'
import path from 'path'
import babelMinify from 'babel-minify-webpack-plugin'


appRoot = path.resolve path.join __dirname, '../'

developmentPlugins = [
  new webpack.NoEmitOnErrorsPlugin()
  new webpack.HotModuleReplacementPlugin()
]

productionPlugins = [
  # This is taken from the default production plugins so it unnecessary here.
  #new webpack.DefinePlugin({
    #'process.env.NODE_ENV': JSON.stringify('production')
  #})

  # These two plugins cause an error when compiling through webpack-stream.
  #new webpack.optimize.UglifyJsPlugin()
  #new webpack.optimize.DedupePlugin(),

  # This plugin seems to be unnecessary. It seems like the default production
  # plugins already do their own minification.
  #new babelMinify()
]



webpackConfig = (mode) ->

  if mode == 'development' || mode == 'test'
    mode = 'development'
    plugins = developmentPlugins
  else
    mode = 'production'
    plugins = productionPlugins

  config =
    entry:
      'js/app': [path.join(appRoot, 'assets', '_js', 'react-app.jsx')]
    #entry: [path.join(appRoot, 'assets', '_js', 'app.jsx')]
    #context: path.join(appRoot, 'assets')
    output:
      path: path.join(appRoot, 'public', '_js')
      publicPath: '/_js'
      #filename: '[name].js'
      filename: 'react-app.js'
    resolve:
      extensions: ['.js', '.jsx']
    plugins: plugins
    module:
      rules:
        [
          test: /\.jsx?$/,
          loader: 'babel-loader',
          query:
            presets: ['es2015', 'react']
            plugins: ['transform-regenerator', 'transform-async-to-generator']
          include: [path.resolve(appRoot, 'assets', '_js')]
        ]
    mode: mode

  return config

export default webpackConfig