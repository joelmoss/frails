const serializer = require('jest-serializer-path')

const { createConfig, createConfigBlock } = require('./create_config')

describe('createConfig', () => {
  beforeAll(() => {
    expect.addSnapshotSerializer(serializer)
  })

  test('without args', () => {
    expect(createConfig()).toMatchSnapshot()
  })

  test('with function', () => {
    const aBlock = createConfigBlock('aBlock', (options, config) => {
      config.aBlock = true
    })

    const anotherBlock = createConfigBlock('anotherBlock', ({ name }, config) => {
      config.anotherBlock = { name }
    })

    const config = createConfig(aBlock, anotherBlock({ name: 'Joel' }))

    expect(config.aBlock).toBe(true)
    expect(config.anotherBlock).toEqual({ name: 'Joel' })
  })

  test('included plugins', () => {
    const config = createConfig()
    const plugins = config.plugins.map(plugin => plugin.constructor.name)

    expect(plugins).toEqual(['WebpackFixStyleOnlyEntriesPlugin', 'WebpackAssetsManifest'])
  })
})
