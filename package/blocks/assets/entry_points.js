const glob = require("fast-glob");
const path = require("path");
const has = require("lodash.has");
const { appPath } = require("../../config");

module.exports = entryPoints;

function entryPoints() {
  return (_, { merge }) => merge({ entry });
}

function entry() {
  const result = {};

  glob.sync(path.join(appPath, "assets/**/*.entry.{js,css}")).forEach((paf) => {
    const namespace = path.relative(appPath, path.dirname(paf));
    const name = path.join(namespace, path.basename(paf, path.extname(paf)));

    has(result, name) ? result[name].push(paf) : (result[name] = [paf]);
  });

  return result;
}
