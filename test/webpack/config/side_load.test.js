const createConfig = require('../../../package/webpack/create_config')

describe('config.sideLoad', () => {
  test.skip('boolean', () => {
    expect(createConfig({ sideload: false })).toMatchSnapshot()
  })
})
