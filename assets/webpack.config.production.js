const UglifyJsPlugin = require("uglifyjs-webpack-plugin");
const OptimizeCSSAssetsPlugin = require("optimize-css-assets-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const merge = require("webpack-merge");

const webpackCommonConfig = require("./webpack.config.common")();

module.exports = merge(webpackCommonConfig, {
  devtool: "source-map",
  mode: "production",

  optimization: {
    splitChunks: {
      chunks: "initial"
    },
    minimizer: [
      new UglifyJsPlugin({ cache: false, parallel: false, sourceMap: false }),
      new OptimizeCSSAssetsPlugin({})
    ]
  }
});
