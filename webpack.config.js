const webpack = require('webpack');
const path = require('path');
const LodashModuleReplacementPlugin = require('lodash-webpack-plugin');
const EslintWebpackPlugin = require('eslint-webpack-plugin');

const config = {
  entry: {
    // adminApi: path.join(__dirname, "packages/admin-api/index.t // "),
    //businessLogic: path.join(__dir // ame, "packages/business-logic/index.ts"),
    //frontendApi: path.join(__dirna // e, "packages/frontend-api/index.ts"),
    // qrCodesApi: path.join(__dirname, "packages/qr-codes-api/index.ts"),
    scripts: path.join(__dirname, "packages/scripts/index.ts")
  },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[contenthash].js'
  },
  plugins: [
    new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en/),
    new LodashModuleReplacementPlugin({}),
    new EslintWebpackPlugin({}),
  ],
  module: {
    rules: [
      {
        test: /\.ts(x)?$/,
        loader: 'ts-loader',
        exclude: /node_modules/
      }
    ]
  },
  resolve: {
    extensions: [
      '.tsx',
      '.ts',
      '.js'
    ]
  },
  optimization: {
    runtimeChunk: 'single',
    splitChunks: {
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all'
        }
      }
    }
  }
};

module.exports = config;
