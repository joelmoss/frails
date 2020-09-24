const { config: frailsConfig, createConfigBlock } = require('@frails/core')

module.exports = createConfigBlock('devServer', (options, baseConfig) => {
  if (options === false) return

  baseConfig.devServer = {
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
})
