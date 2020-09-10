const createConfig = require('../../../package/webpack/create_config')

describe('config.devServer', () => {
  test('boolean', () => {
    expect(createConfig({ devServer: false })).toMatchSnapshot()
  })

  test('object', () => {
    expect(
      createConfig({ devServer: { hot: true, watchOptions: { poll: true } } })
    ).toMatchSnapshot()
  })
})
