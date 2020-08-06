const config = require("./package/config");

module.exports = {
  config,

  // The local ident name required for loading component styles.
  cssLocalIdentName:
    config.railsEnv == "development"
      ? "[path][name]__[local]___[md5:hash:hex:6]"
      : "[local]-[md5:hash:hex:6]",

  sideLoadEntry: require("./package/side_load"),
  components: require("./package/components"),
};
