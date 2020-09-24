const serializer = require('jest-serializer-path')
const { createConfig } = require('@frails/core')

const devServer = require('.')

describe('devServer', () => {
  beforeAll(() => {
    expect.addSnapshotSerializer(serializer)
  })

  test('createConfig', () => {
    expect(createConfig(devServer)).toMatchSnapshot()
    expect(JSON.stringify(createConfig(devServer()))).toBe(JSON.stringify(createConfig(devServer)))
  })

  test('disabled', () => {
    expect(createConfig(devServer(false))).toMatchSnapshot()
  })
})
