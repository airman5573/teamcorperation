const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const join = require('path').join;
const distPath = join(__dirname, '../../../public/warehouse/');

module.exports = {
  name: 'warehouse',
  entry: ["@babel/polyfill", join(__dirname, '/index.js')],
  devtool: 'source-map',
  output: {
    filename: "main.js",
    path: distPath,
    publicPath: '/warehouse',
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader" // 알아서 babelrc.js 파일을 참고한다
        }
      },
      {
        test: /\.(scss|css)$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: "css-loader",
            options: {
              minimize: {
                safe: true
              }
            }
          },
          {
            loader: 'postcss-loader',
            options: {
                plugins: () => [require('autoprefixer')({
                    'overrideBrowserslist': ['> 10%', 'last 2 versions']
                })],
            }
          },
          {
            loader: 'sass-loader',
            options: {}
          }
        ]
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({
      // Options similar to the same options in webpackOptions.output
      // both options are optional
      filename: "style.css",
      path: distPath,
      chunkFilename: "[id].css"
    })
  ],
  devServer: {
    proxy: {
      '/': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },
    }
  }
};
