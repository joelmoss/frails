const { env } = require("@webpack-blocks/webpack");

const frailsConfig = require("./config");

module.exports = (options = {}) => env("development", [devServer(options)]);

const devServer = (options = {}) => {
  // TODO: throw or warn when any of the default options below are overwritten.

  const config = {
    devServer: {
      port: frailsConfig.devServerPort,
      public: `${frailsConfig.devServerHost}:${frailsConfig.devServerPort}`,
      publicPath: `/${frailsConfig.publicOutputPath}/`,
      contentBase: frailsConfig.absolutePublicPath,
      // useLocalIp: false,
      ...options,
    },
  };

  return (_, { merge }) => merge(config);
};
