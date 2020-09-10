const createConfig = require('../../../package/webpack/create_config')

describe('config.sideLoadViews', () => {
  test('boolean', () => {
    expect(createConfig({ sideLoadViews: false })).toMatchSnapshot()
    expect(createConfig({ sideLoadViews: true })).toMatchSnapshot()
  })

  test('existing entry prop', () => {
    expect(createConfig({ entry: { 'some/path': 'some/path.js' } }).entry).toMatchSnapshot()
  })
})
