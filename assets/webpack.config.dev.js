const webpack = require("webpack");
const merge = require("webpack-merge");

const webpackCommonConfig = require("./webpack.config.common")();

module.exports = merge(webpackCommonConfig, {
  mode: "development",
  // output: {
  //   publicPath: "/dist/"
  // },
  // plugins: [new webpack.HotModuleReplacementPlugin()],
  devtool: "source-map"
  // devServer: {
  //   hot: true
  // }
});
