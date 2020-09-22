const path = require('path')

const debug = require('debug')
const WebpackAssetsManifest = require('webpack-assets-manifest')
const FixStyleOnlyEntriesPlugin = require('webpack-fix-style-only-entries')

const frailsConfig = require('./config')

const createConfig = (...blocks) => {
  // Make sure NODE_ENV env variable is set.
  process.env.NODE_ENV = frailsConfig.railsEnv === 'test' ? 'development' : frailsConfig.railsEnv

  // Default config.
  const config = {
    mode: process.env.NODE_ENV,
    entry: {},
    output: {
      path: frailsConfig.absolutePublicPath,
      publicPath: `/${frailsConfig.publicOutputPath}/`
    },
    resolve: {
      alias: {
        lib: path.resolve(frailsConfig.appPath, 'lib')
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

  // Loop through each block and apply each one to the config object.
  blocks.forEach(block => {
    if (typeof block === 'function') {
      if (Object.prototype.hasOwnProperty.call(block, 'isBlockCreator')) {
        block()(config)
      } else {
        block(config)
      }
    }
  })

  debug('frails')(config)

  return config
}

const createConfigBlock = block => {
  block.isBlockCreator = true
  return block
}

module.exports = { createConfig, createConfigBlock }
