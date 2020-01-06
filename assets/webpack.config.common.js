const path = require("path");
const glob = require("glob");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const WebpackMd5Hash = require("webpack-md5-hash");
const CleanWebpackPlugin = require("clean-webpack-plugin");
const webpack = require("webpack");

module.exports = (env, options) => ({
  entry: {
    app: ["./js/app.js"].concat(glob.sync("./vendor/**/*.js"))
    // "./js/app.js": ["./js/app.js"].concat(glob.sync("./vendor/**/*.js"))
  },
  // entry: path.resolve(__dirname, "js/index.js"),
  output: {
    //filename: "app.js",
    filename: "[name].js",
    path: path.resolve(__dirname, "../priv/static/js")
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ["@babel/preset-env"]
          }
        }
        //exclude: /node_modules/
      },
      {
        test: /\.scss$/,
        use: [
          "style-loader",
          MiniCssExtractPlugin.loader,
          "css-loader",
          "postcss-loader",
          "sass-loader"
        ]
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, "css-loader"]
      },
      {
        test: /\.(png|svg|jpg|gif)$/,
        use: [
          {
            loader: "file-loader",
            options: {
              name(file) {
                return "[name]_[hash].[ext]";
              },
              outputPath: "../images/"
            }
          }
        ]
      },
      {
        test: /\.(ttf|eot|woff|woff2)$/,
        use: {
          loader: "file-loader",
          options: {
            name(file) {
              return "[name]_[hash].[ext]";
            },
            outputPath: "../fonts/"
          }
        }
      }
    ]
  },
  optimization: {
    splitChunks: {
      chunks: "all"
    }
  },
  plugins: [
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      jquery: "jquery",
      "window.jQuery": "jquery",
      "window.$": "jquery"
    }),
    new CleanWebpackPlugin("../priv/static", {
      verbose: true,
      allowExternal: true
    }),
    new MiniCssExtractPlugin({
      filename: "../css/[name].css"
    }),
    new CopyWebpackPlugin([
      { from: "static/", to: "../" }
      // { from: "js/sw.js", to: "../js/" }
    ]),

    new WebpackMd5Hash()
  ]
});
