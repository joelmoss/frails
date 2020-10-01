const { createConfigBlock } = require('@frails/core')
const { merge } = require('webpack-merge')
const requireResolve = require('./require_resolve')

module.exports = createConfigBlock('babel', (options, baseConfig) => {
  if (options === false) return

  baseConfig.module = merge(baseConfig.module || {}, {
    rules: [
      {
        test: /\.js$/i,
        use: {
          loader: requireResolve('babel-loader'),
          options: merge({ cacheDirectory: true }, options)
        }
      }
    ]
  })
})
