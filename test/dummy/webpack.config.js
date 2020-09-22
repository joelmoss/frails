const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const frails = require('frails')

module.exports = frails.createConfig({
  plugins: [new OptimizeCssAssetsPlugin()]
})
