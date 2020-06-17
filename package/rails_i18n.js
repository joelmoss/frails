const { addPlugins } = require("@webpack-blocks/webpack");
const VirtualModulePlugin = require("virtual-module-webpack-plugin");
const path = require("path");
const fs = require("fs");
const glob = require("fast-glob");
const yaml = require("js-yaml");
const deepmerge = require("deepmerge");
const mapKeys = require("map-keys-deep-lodash");
const { camelCase } = require("lodash");

const listLocaleFiles = ({ localesPath, pattern }) =>
  glob.sync(pattern, { cwd: localesPath });

const readLocalFile = (filePath) => yaml.load(fs.readFileSync(filePath));

const loadTranslations = (locale) => ({
  localesPath = "",
  pattern = "**/*.yml",
}) => {
  let translations = {};

  listLocaleFiles({ localesPath, pattern }).map((file) => {
    translations = mapKeys(
      deepmerge(translations, readLocalFile(path.join(localesPath, file))),
      (v, k) => camelCase(k)
    );

    return translations;
  });

  return translations[locale];
};

const RailsI18nLoader = (locale = "en") => {
  return {
    loadTranslations: loadTranslations(locale),
  };
};

class RailsI18nPlugin extends VirtualModulePlugin {
  constructor({
    localesPath,
    pattern,
    pathRoot = "",
    outputName = "translations",
  }) {
    const loader = RailsI18nLoader();

    super({
      moduleName: path.join(pathRoot, `${outputName}.js`),
      contents:
        "module.exports = " +
        JSON.stringify(loader.loadTranslations({ localesPath, pattern })),
    });
  }
}

const block = (options = {}) => {
  options = {
    localesPath: path.resolve(process.cwd(), "config/locales"),
    pathRoot: "app/assets",
    ...options,
  };

  return addPlugins([new RailsI18nPlugin(options)]);
};

module.exports = {
  RailsI18nPlugin,
  block,
};
