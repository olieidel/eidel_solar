'use strict';
var webpack = require('webpack');
var path = require('path');
var HtmlWebpackPlugin = require('html-webpack-plugin');

var loaders = require('./webpack.loaders');


const HOST = process.env.HOST || '127.0.0.1';
const PORT = process.env.PORT || '8888';

const BASE_PATH = path.resolve(__dirname, 'web', 'static')
const ENTRY_FILE = path.resolve(BASE_PATH, 'js', 'index.js')
const TEMPLATE_FILE = path.resolve(BASE_PATH, 'template.html')
const OUTPUT_PATH = path.resolve(__dirname, 'priv', 'static')
const OUTPUT_PATH_JS = path.resolve(OUTPUT_PATH, 'js')
const OUTPUT_PATH_CSS = path.resolve(OUTPUT_PATH, 'css')

//global css
loaders.push({
  test: /\.css$/,
  include: path.join(__dirname, 'node_modules', 'flexboxgrid'),
  exclude: /[\/\\](web|priv)[\/\\]/,
  loaders: [
    'style?sourceMap',
    'css?modules'
  ]
});

// grommet scss
loaders.push({
  test: /\.scss$/,
  loaders: [
    'style?sourceMap',
    /*     'css?modules&importLoaders=1&localIdentName=[path]___[name]__[local]___[hash:base64:5]',*/
    'css',
    'postcss',
    'sass'
  ]
});

// local scss modules
/* loaders.push({
 *   test: /\.scss$/,
 *   exclude: /[\/\\](node_modules|bower_components|public)[\/\\]/,
 *   loaders: [
 *     'style?sourceMap',
 *     'css?modules&importLoaders=1&localIdentName=[path]___[name]__[local]___[hash:base64:5]',
 *     'postcss',
 *     'sass'
 *   ]
 * });*/

// local css modules
loaders.push({
  test: /\.css$/,
  exclude: /[\/\\](node_modules|bower_components|public)[\/\\]/,
  loaders: [
    'style?sourceMap',
    'css?modules&importLoaders=1&localIdentName=[path]___[name]__[local]___[hash:base64:5]'
  ]
});

module.exports = {
  entry: [
    'react-hot-loader/patch',

    ENTRY_FILE
  ],
  devtool: process.env.WEBPACK_DEVTOOL || 'eval-source-map',
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
  devServer: {
    contentBase: "./public",
    // do not print bundle build stats
    noInfo: true,
    // enable HMR
    hot: true,
    // embed the webpack-dev-server runtime into the bundle
    inline: true,
    // serve index.html in place of 404 responses to allow HTML5 history
    historyApiFallback: true,
    port: PORT,
    host: HOST
  },
  plugins: [
    new webpack.ProvidePlugin({
      Promise: 'imports?this=>global!exports?global.Promise!es6-promise',
      fetch: 'imports?this=>global!exports?global.fetch!isomorphic-fetch'
    }),
    new webpack.NoErrorsPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new HtmlWebpackPlugin({
      template: TEMPLATE_FILE
    }),
  ]
};
