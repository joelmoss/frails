const path = require('path')
const webpack = require('webpack')

const createConfig = require('../../package/webpack/create_config')

describe('createConfig', () => {
  test('returns object', () => {
    expect(createConfig()).toMatchSnapshot()
  })

  test('root prop', () => {
    expect(createConfig({ devtool: 'cheap-module-eval-source-map' }).devtool).toBe(
      'cheap-module-eval-source-map'
    )
  })

  test('included plugins', () => {
    const config = createConfig()
    const plugins = config.plugins.map(plugin => plugin.constructor.name)

    expect(plugins).toIncludeAllMembers([
      'WebpackFixStyleOnlyEntriesPlugin',
      'WebpackAssetsManifest'
    ])
  })

  test('extra plugin', () => {
    const config = createConfig({ plugins: [new webpack.DefinePlugin({ URL: 'http://...' })] })
    const plugins = config.plugins.map(plugin => plugin.constructor.name)

    expect(plugins).toIncludeAllMembers([
      'DefinePlugin',
      'WebpackFixStyleOnlyEntriesPlugin',
      'WebpackAssetsManifest'
    ])
  })
})
