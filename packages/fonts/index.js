const { createConfigBlock } = require('@frails/core')
const { merge } = require('webpack-merge')
const requireResolve = require('./require_resolve')

module.exports = createConfigBlock('fonts', (options, baseConfig) => {
  if (options === false) return

  baseConfig.module = merge(baseConfig.module || {}, {
    rules: [
      {
        // Match woff2 in addition to patterns like .woff?v=1.1.1.
        test: /\.(woff|woff2)(\?v=\d+\.\d+\.\d+)?$/,
        use: {
          loader: requireResolve('file-loader'),
          options: merge({ mimetype: 'application/font-woff' }, options)
        }
      }
    ]
  })
})
