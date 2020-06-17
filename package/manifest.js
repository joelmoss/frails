const { addPlugins } = require("@webpack-blocks/webpack");
const WebpackAssetsManifest = require("webpack-assets-manifest");

module.exports = () =>
  addPlugins([
    new WebpackAssetsManifest({
      writeToDisk: true,
      entrypoints: true,
      sortManifest: false,
      publicPath: true,
    }),
  ]);
