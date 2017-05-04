var webpack = require('webpack');
var path = require('path');
var loaders = require('./webpack.loaders');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var WebpackCleanupPlugin = require('webpack-cleanup-plugin');

const BASE_PATH = path.resolve('web', 'static')
const ENTRY_FILE = path.resolve(BASE_PATH, 'js', 'index.js')
const OUTPUT_PATH = path.resolve('priv', 'static')
const TEMPLATE_FILE = path.resolve(BASE_PATH, 'template.html')
const OUTPUT_PATH_JS = path.resolve(OUTPUT_PATH, 'js')
const OUTPUT_PATH_CSS = path.resolve(OUTPUT_PATH, 'css')


//global css
loaders.push({
  test: /\.css$/,
  include: path.join(__dirname, 'node_modules', 'flexboxgrid'),
  exclude: /[\/\\](web|priv)[\/\\]/,
  loader: ExtractTextPlugin.extract('style', 'css?modules')
});

// grommet scss
loaders.push({
  test: /\.scss$/,
  loader: ExtractTextPlugin.extract('style', 'css!postcss!sass')
});

// local css modules
loaders.push({
  test: /\.css$/,
  exclude: /[\/\\](node_modules|bower_components|public)[\/\\]/,
  loader: ExtractTextPlugin.extract('style', 'css?modules&importLoaders=1&localIdentName=[path]___[name]__[local]___[hash:base64:5]')
});

module.exports = {
  entry: [
    ENTRY_FILE
  ],
  output: {
    path: OUTPUT_PATH_JS,
    filename: 'bundle.js'
  },
  resolve: {
    extensions: ['', '.js', '.jsx', '.scss'],
    modulesDirectories: ['node_modules', './deps/phoenix/web/static/js']
  },
  module: {
    loaders
  },
  sassLoader: {
    includePaths: './node_modules'
  },
  plugins: [
    new webpack.ProvidePlugin({
      Promise: 'imports?this=>global!exports?global.Promise!es6-promise',
      fetch: 'imports?this=>global!exports?global.fetch!isomorphic-fetch'
    }),
    new WebpackCleanupPlugin(),
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"production"'
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
        screw_ie8: true,
        drop_console: true,
        drop_debugger: true
      }
    }),
    new webpack.optimize.OccurenceOrderPlugin(),
    new ExtractTextPlugin('../css/bundle.css', {
      allChunks: true
    }),
    new webpack.optimize.DedupePlugin()
  ]
};
