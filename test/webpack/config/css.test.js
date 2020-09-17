const createConfig = require('../../../package/webpack/create_config')

describe('config.css', () => {
  test('boolean', () => {
    expect(createConfig({ css: true })).toMatchSnapshot()
    expect(createConfig({ css: false })).toMatchSnapshot()
  })
})
