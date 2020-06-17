const { createConfig } = require("frails");
const debug = require("debug")("frails");

module.exports = createConfig();

debug(module.exports);
