const { merge, mergeWithCustomize, unique } = require('webpack-merge')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

const frailsConfig = require('../../config')

module.exports = baseConfig => {
  if (typeof baseConfig.css === 'undefined') {
    // CSS is enabled by default.
    baseConfig.css = true
  }

  if (baseConfig.css) {
    baseConfig.plugins = mergeWithCustomize({
      customizeArray: unique(
        'plugins',
        ['MiniCssExtractPlugin'],
        plugin => plugin.constructor && plugin.constructor.name
      )
    })(
      {
        plugins: baseConfig.plugins
      },
      {
        plugins: [new MiniCssExtractPlugin()]
      }
    ).plugins

    baseConfig.module = merge(baseConfig.module || {}, {
      rules: [
        {
          test: /\.css$/i,
          use: [
            MiniCssExtractPlugin.loader,
            {
              loader: 'css-loader',
              options: {
                modules: {
                  localIdentName: frailsConfig.cssLocalIdentName
                }
              }
            }
          ]
        }
      ]
    })
  }

  delete baseConfig.css
}
