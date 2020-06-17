// TODO: Make this work with the manifest, as currently copied files do not appear in the manifest
// JSON created by webpack-assets-manifest. Which means, Rails is not aware of the files.

const path = require("path");
const CopyPlugin = require("copy-webpack-plugin");
const { appPath } = require("../../config");

module.exports = images;

function images() {
  return (_, { addPlugin }) =>
    addPlugin(
      new CopyPlugin({
        patterns: [
          {
            from: "images/**/*",
            to: "[path]/[name]-[contenthash].[ext]",
            toType: "template",
            context: path.resolve(appPath, "assets"),
          },
        ],
      })
    );
}
