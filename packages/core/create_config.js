const path = require('path')

const { merge } = require('webpack-merge')
const isPlainObject = require('lodash/isPlainObject')
const debug = require('debug')
const WebpackAssetsManifest = require('webpack-assets-manifest')
const FixStyleOnlyEntriesPlugin = require('webpack-fix-style-only-entries')

const frailsConfig = require('./config')

// Create and return a Webpack config object based on the given `blocks`, where a block is created
// from `createConfigBlock`, or a plain object.
const createConfig = (...blocks) => {
  // Make sure NODE_ENV env variable is set.
  process.env.NODE_ENV = frailsConfig.railsEnv === 'test' ? 'development' : frailsConfig.railsEnv

  // Default config.
  let config = {
    mode: process.env.NODE_ENV,
    entry: {},
    output: {
      path: frailsConfig.absolutePublicPath,
      publicPath: `/${frailsConfig.publicOutputPath}/`
    },
    context: frailsConfig.appPath,
    resolve: {
      modules: [frailsConfig.appPath]
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
  blocks.forEach((block, i) => {
    if (typeof block === 'function') {
      if (block.blockDepth === 1) {
        block()(config)
      } else {
        block(config)
      }
    } else if (isPlainObject(block)) {
      config = merge(config, block)
    } else {
      throw `Expected function or plain object; received ${typeof block} from argument ${i}`
    }
  })

  debug('frails')(config)

  return config
}

// Create and return a Webpack config "block" for use with `createConfig` above. A block is a
// curried function that accepts two arguments: an `options` object, and a `config` object.
//
// Example:
//
//  const myBlock = createConfigBlock('myBlock', (options, config) => {
//    config.myBlock = options.name || 'Joel'
//  })
//
//  createConfig(myBlock) // returns { myBlock: 'Joel' }
//  createConfig(myBlock({ name: 'Bob' })) // returns { myBlock: 'Bob' }
const createConfigBlock = (name, blockFn) => {
  Object.defineProperty(blockFn, 'blockName', { value: name })

  return Object.defineProperties(
    (options = {}) => {
      return Object.defineProperties(
        (config = {}) => {
          return blockFn(options, config)
        },
        {
          blockName: { value: name },
          blockDepth: { value: 2 }
        }
      )
    },
    {
      blockName: { value: name },
      blockDepth: { value: 1 }
    }
  )
}

module.exports = { createConfig, createConfigBlock }
