const path = require("path");
const debug = require("debug")("frails");
const frailsConfig = require("../config");

module.exports = (env = "development") => {
  const config = {
    mode: env,
    entry: "./app/assets/application.js",
    output: {
      path: path.join(
        frailsConfig.rootPath,
        "public",
        frailsConfig.publicOutputPath
      ),
      publicPath: `/${frailsConfig.publicOutputPath}/`,
    },
  };

  debug(config);

  return config;
};
