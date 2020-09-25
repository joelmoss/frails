const serializer = require('jest-serializer-path')
const { createConfig } = require('@frails/core')

const sideLoadViews = require('.')

describe('sideLoadViews', () => {
  beforeAll(() => {
    expect.addSnapshotSerializer(serializer)
  })

  test('createConfig', () => {
    expect(createConfig(sideLoadViews)).toMatchSnapshot()
    expect(JSON.stringify(createConfig(sideLoadViews()))).toBe(
      JSON.stringify(createConfig(sideLoadViews))
    )
  })

  test('disabled', () => {
    expect(createConfig(sideLoadViews(false))).toMatchSnapshot()
  })
})
