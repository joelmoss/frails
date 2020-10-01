const { merge, mergeWithCustomize, unique } = require('webpack-merge')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const { config: frailsConfig, createConfigBlock } = require('@frails/core')

const requireResolve = require('./require_resolve')

module.exports = createConfigBlock('css', (options, baseConfig) => {
  if (options === false) return

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
            loader: requireResolve('css-loader'),
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
})
