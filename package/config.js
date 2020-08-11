const spawnSync = require("child_process").spawnSync;
const path = require("path");

const ioDelimiter = "__FRAILS_RAILS_RUNNER_DELIMETER__";
const configFromRails = railsRun(
  `puts "${ioDelimiter}#{Frails.config_as_json}${ioDelimiter}"`
);
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
    // Output is delimited to filter out unwanted warnings or other output
    // that we don't want in our files.
    const sourceRegex = new RegExp(ioDelimiter + "([\\s\\S]+)" + ioDelimiter);
    const matches = result.stdout.toString().match(sourceRegex);
    if (matches) {
      return JSON.parse(matches[1]);
    } else {
      throw "Rails runner failed having been unable to parse the output.";
    }
  } else if (result.signal !== null) {
    throw `Rails runner was terminated with signal: ${result.signal}`;
  } else {
    throw `Rails runner failed with '${result.stderr.toString()}'.`;
  }
}
