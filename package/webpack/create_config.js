const path = require('path')
const debug = require('debug')('frails')
const { default: merge } = require('webpack-merge')
const validate = require('schema-utils')
const webpack = require('webpack')
const WebpackAssetsManifest = require('webpack-assets-manifest')
const FixStyleOnlyEntriesPlugin = require('webpack-fix-style-only-entries')

const frailsConfig = require('../config')
const applyDevServer = require('./config/dev_server')
const applySideLoadAssets = require('./config/side_load_views')
const schema = require('./schema.json')

module.exports = (options = {}) => {
  validate(schema, options)

  // Make sure NODE_ENV env variable is set.
  process.env.NODE_ENV = frailsConfig.railsEnv === 'test' ? 'development' : frailsConfig.railsEnv

  const config = merge(
    // Default config.
    {
      mode: process.env.NODE_ENV,
      entry: {},

      // Merge with user-provided options.
      ...options
    },

    // Required config - this should be untouched.
    {
      output: {
        path: frailsConfig.absolutePublicPath,
        publicPath: `/${frailsConfig.publicOutputPath}/`
      },
      resolve: {
        alias: {
          assets: path.resolve(frailsConfig.appPath, 'assets')
        }
      },
      plugins: [
        new FixStyleOnlyEntriesPlugin(),
        new WebpackAssetsManifest({
          writeToDisk: true,
          entrypoints: true,
          sortManifest: false,
          publicPath: true
        })
      ]
    }
  )

  applyDevServer(config)
  applySideLoadAssets(config)

  debug(config)

  return config
}
