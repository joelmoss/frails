const { createConfigBlock } = require('@frails/core')
const { merge } = require('webpack-merge')
const requireResolve = require('./require_resolve')

module.exports = createConfigBlock('images', (options, baseConfig) => {
  if (options === false) return

  baseConfig.module = merge(baseConfig.module || {}, {
    rules: [
      {
        test: /\.(jpg|jpe?g|png|gif|svg)$/i,
        use: {
          loader: requireResolve('file-loader'),
          options
        }
      }
    ]
  })
})
