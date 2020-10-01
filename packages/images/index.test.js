const serializer = require('jest-serializer-path')
const { createConfig } = require('@frails/core')

const images = require('.')
jest.mock('./require_resolve')

describe('images', () => {
  beforeAll(() => {
    expect.addSnapshotSerializer(serializer)
  })

  test('createConfig', () => {
    expect(createConfig(images)).toMatchSnapshot()
    expect(JSON.stringify(createConfig(images()))).toBe(JSON.stringify(createConfig(images)))
  })

  test('disabled', () => {
    expect(createConfig(images(false))).toMatchSnapshot()
  })

  test('with options', () => {
    expect(createConfig(images({ name: '[path][name]-[hash].[ext]' }))).toMatchSnapshot()
  })
})
