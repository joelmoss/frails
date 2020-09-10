const createConfig = require('../../../package/webpack/create_config')

describe('config.devServer', () => {
  test('boolean', () => {
    expect(createConfig({ devServer: false }).devServer).toBeUndefined()
    expect(createConfig({ devServer: true }).devServer).toMatchSnapshot()
  })

  test('object', () => {
    expect(
      createConfig({ devServer: { hot: true, watchOptions: { poll: true } } }).devServer
    ).toMatchSnapshot()
  })
})
