const path = require('path')
const debug = require('debug')('frails')

const frailsConfig = require('../config')
const applyDevServer = require('./config/dev_server')
const { default: merge } = require('webpack-merge')
const validate = require('schema-utils')
const schema = require('./schema.json')

module.exports = (options = {}) => {
  validate(schema, options)

  // Make sure NODE_ENV env variable is set.
  process.env.NODE_ENV = frailsConfig.railsEnv === 'test' ? 'development' : frailsConfig.railsEnv

  const config = merge(
    // Default config.
    {
      mode: process.env.NODE_ENV,

      // webpack-dev-server is enabled by default in development.
      devServer: process.env.NODE_ENV === 'development',

      // Merge with user-provided options.
      ...options
    },

    // Required config - this should be untouched.
    {
      entry: './app/assets/application.js',
      output: {
        path: frailsConfig.absolutePublicPath,
        publicPath: `/${frailsConfig.publicOutputPath}/`
      }
    }
  )

  applyDevServer(config)

  debug(config)

  return config
}
