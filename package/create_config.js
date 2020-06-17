const FixStyleOnlyEntriesPlugin = require("webpack-fix-style-only-entries");
const path = require("path");
const {
  setOutput,
  setMode,
  setEnv,
  setContext,
  addPlugins,
  setDevTool,
  env,
  createConfig,
  resolve,
} = require("@webpack-blocks/webpack");

const frailsConfig = require("./config");
const devServer = require("./dev_server");
const manifest = require("./manifest");
const assets = require("./blocks/assets");

// Basic Rails asset pipeline.
module.exports = (blocks = []) =>
  createConfig(
    [
      setContext(frailsConfig.appPath),
      setMode(process.env.NODE_ENV || frailsConfig.railsEnv),
      setEnv({
        NODE_ENV: frailsConfig.railsEnv,
      }),

      env("development", [setDevTool("cheap-module-eval-source-map")]),
      devServer(),

      setOutput({
        path: frailsConfig.absolutePublicPath,
        publicPath: `/${frailsConfig.publicOutputPath}/`,
      }),

      resolve({
        // Allow imports from 'assets'.
        modules: [path.join(process.cwd(), "app", "assets"), "node_modules"],
      }),

      addPlugins([new FixStyleOnlyEntriesPlugin()]),

      assets(),
      manifest(),
    ].concat(blocks)
  );
