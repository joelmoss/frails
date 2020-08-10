const spawnSync = require("child_process").spawnSync;
const path = require("path");

const configFromRails = railsRun("print Frails.config_as_json");
const rootPath = process.cwd();

module.exports = {
  ...configFromRails,

  rootPath,
  appPath: path.join(rootPath, "app"),
  absolutePublicPath: path.join(
    rootPath,
    "public",
    configFromRails.publicOutputPath
  ),
};

function railsRun(argument) {
  const result = spawnSync("./bin/rails", ["runner", argument]);

  if (result.status === 0) {
    return JSON.parse(result.stdout.toString());
  } else if (result.signal !== null) {
    throw `Rails runner was terminated with signal: ${result.signal}`;
  } else {
    throw `Rails runner failed with '${result.error.toString()}'.`;
  }
}
