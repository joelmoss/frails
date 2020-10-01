const serializer = require('jest-serializer-path')
const { createConfig } = require('@frails/core')

const babel = require('.')
jest.mock('./require_resolve')

describe('babel', () => {
  beforeAll(() => {
    expect.addSnapshotSerializer(serializer)
  })

  test('createConfig', () => {
    expect(createConfig(babel)).toMatchSnapshot()
    expect(JSON.stringify(createConfig(babel()))).toBe(JSON.stringify(createConfig(babel)))
  })

  test('disabled', () => {
    expect(createConfig(babel(false))).toMatchSnapshot()
  })

  test('with options', () => {
    expect(createConfig(babel({ cacheCompression: false }))).toMatchSnapshot()
  })
})
