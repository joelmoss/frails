const serializer = require('jest-serializer-path')
const webpack = require('webpack')

const { createConfig, createConfigBlock } = require('./create_config')

describe('createConfig', () => {
  beforeAll(() => {
    expect.addSnapshotSerializer(serializer)
  })

  test('without args', () => {
    expect(createConfig()).toMatchSnapshot()
  })

  test('with an object arg', () => {
    // Act
    const config = createConfig({ devtool: 'cheap-module-eval-source-map' })

    expect(config).toMatchSnapshot()
    expect(config.devtool).toBe('cheap-module-eval-source-map')
  })

  test('with an unrecognised argument', () => {
    expect(() => createConfig(1)).toThrowError('Expected function or plain object')
  })

  test('with block args', () => {
    // Setup
    const aBlock = createConfigBlock('aBlock', (options, config) => {
      config.aBlock = true
    })

    const anotherBlock = createConfigBlock('anotherBlock', ({ name }, config) => {
      config.anotherBlock = { name }
    })

    // Act
    const config = createConfig(aBlock, anotherBlock({ name: 'Joel' }))

    // Expect
    expect(config.aBlock).toBe(true)
    expect(config.anotherBlock).toEqual({ name: 'Joel' })
  })

  test('included plugins', () => {
    // Act
    const config = createConfig()
    const plugins = config.plugins.map(plugin => plugin.constructor.name)

    // Expect
    expect(plugins).toEqual(['WebpackFixStyleOnlyEntriesPlugin', 'WebpackAssetsManifest'])
  })

  test('extra plugin', () => {
    const config = createConfig({ plugins: [new webpack.DefinePlugin({ URL: 'http://...' })] })
    const plugins = config.plugins.map(plugin => plugin.constructor.name)

    expect(plugins).toEqual([
      'WebpackFixStyleOnlyEntriesPlugin',
      'WebpackAssetsManifest',
      'DefinePlugin'
    ])
  })
})
