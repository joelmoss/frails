const { isPlainObject } = require('lodash')
const { merge } = require('webpack-merge')

const frailsConfig = require('../../config')

module.exports = baseConfig => {
  if (typeof baseConfig.devServer === 'undefined') {
    // webpack-dev-server is enabled by default in development.
    baseConfig.devServer = process.env.NODE_ENV === 'development'
  }

  if (!baseConfig.devServer) {
    delete baseConfig.devServer
    return
  }

  const config = {
    port: frailsConfig.devServerPort,
    public: `${frailsConfig.devServerHost}:${frailsConfig.devServerPort}`,
    contentBase: frailsConfig.absolutePublicPath,
    publicPath: `/${frailsConfig.publicOutputPath}/`,
    watchOptions: {
      ignored: '**/node_modules/**'
    }
    // clientLogLevel: "none",
    // disableHostCheck: true,
    // historyApiFallback: { disableDotRule: true },
    // headers: { "Access-Control-Allow-Origin": "*" },
    // overlay: true,
    // stats: { errorDetails: true },
  }

  if (isPlainObject(baseConfig.devServer)) {
    baseConfig.devServer = merge(config, baseConfig.devServer)
  } else {
    baseConfig.devServer = config
  }
}
