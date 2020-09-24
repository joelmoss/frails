const serializer = require('jest-serializer-path')

const { createConfig, createConfigBlock, css } = require('.')

describe('createConfig', () => {
  beforeAll(() => {
    expect.addSnapshotSerializer(serializer)
  })

  test('without args', () => {
    expect(createConfig()).toMatchSnapshot()
  })

  test('arguments override default blocks', () => {
    expect(createConfig(css(false))).toMatchSnapshot()
    expect(createConfig(css())).toMatchSnapshot()
  })

  test('custom blocks are appended', () => {
    const mockBlock = createConfigBlock('mockBlock', (options, config) => {
      config.mockBlock = true
    })
    const config = createConfig(mockBlock)

    expect(config).toMatchSnapshot()
    expect(config.mockBlock).toBe(true)
  })
})
