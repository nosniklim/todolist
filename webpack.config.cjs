const path    = require("path")
const webpack = require("webpack")

module.exports = {
  mode: "production",
  devtool: "source-map",
  entry: {
    application: "./app/javascript/application.js"
  },
  output: {
    filename: "[name].js",
    sourceMapFilename: "[file].map",
    chunkFormat: "module",
    // ESモジュール形式で出力
    // `type="module"` のスクリプトとしてブラウザへ渡すための設定（`chunkFormat: "module"` を使う場合に必要）
    module: true,
    path: path.resolve(__dirname, "app/assets/builds"),
  },
  experiments: {
    outputModule: true,
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    })
  ]
}
