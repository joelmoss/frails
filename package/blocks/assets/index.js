const { group } = require("@webpack-blocks/webpack");

const entryPoints = require("./entry_points");
const css = require("./css");

module.exports = () => {
  return group([entryPoints(), css()]);
};
