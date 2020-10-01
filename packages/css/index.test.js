const serializer = require('jest-serializer-path')
const { createConfig } = require('@frails/core')

const css = require('.')
jest.mock('./require_resolve')

describe('css', () => {
  beforeAll(() => {
    expect.addSnapshotSerializer(serializer)
  })

  test('within createConfig', () => {
    expect(createConfig(css)).toMatchSnapshot()
    expect(JSON.stringify(createConfig(css()))).toBe(JSON.stringify(createConfig(css)))
  })

  test('disabled', () => {
    expect(createConfig(css(false))).toMatchSnapshot()
  })
})
