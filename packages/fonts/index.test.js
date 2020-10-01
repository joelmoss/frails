const serializer = require('jest-serializer-path')
const { createConfig } = require('@frails/core')

const fonts = require('.')
jest.mock('./require_resolve')

describe('fonts', () => {
  beforeAll(() => {
    expect.addSnapshotSerializer(serializer)
  })

  test('createConfig', () => {
    expect(createConfig(fonts)).toMatchSnapshot()
    expect(JSON.stringify(createConfig(fonts()))).toBe(JSON.stringify(createConfig(fonts)))
  })

  test('disabled', () => {
    expect(createConfig(fonts(false))).toMatchSnapshot()
  })

  test('with options', () => {
    expect(createConfig(fonts({ name: '[path][name]-[hash].[ext]' }))).toMatchSnapshot()
  })
})
