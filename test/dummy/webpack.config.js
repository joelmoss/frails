const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const { webpack } = require('frails')

module.exports = webpack.createConfig({
  plugins: [new OptimizeCssAssetsPlugin()]
})
