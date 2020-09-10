const createConfig = require('../../package/webpack/create_config')

describe('createConfig', () => {
  test('returns object', () => {
    expect(createConfig()).toMatchSnapshot()
  })

  test('root prop', () => {
    expect(createConfig({ devtool: 'cheap-module-eval-source-map' })).toMatchSnapshot()
  })
})
