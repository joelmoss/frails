const MiniCssExtractPlugin = require("mini-css-extract-plugin");

// The local ident name required for loading component styles.
const cssLocalIdentName = (mode) =>
  mode === "development"
    ? "[path][name]__[local]___[md5:hash:hex:6]"
    : "[local]-[md5:hash:hex:6]";

module.exports = (options = {}) => {
  options = {
    mode: "development",
    useModules: false,
    ...options,
  };

  options.postcss =
    typeof options.postcss === "undefined" ? false : options.postcss;

  const miniCssLoader = {
    loader: MiniCssExtractPlugin.loader,
    options: {
      esModule: true,
    },
  };

  const cssLoader = {
    loader: "css-loader",
    options: {
      sourceMap: options.mode === "development",
    },
  };

  const postcssLoader = {
    loader: "postcss-loader",
    options: {
      sourceMap: options.mode === "development",
      ...options.postcss,
    },
  };

  if (options.useModules === true) {
    cssLoader.options.modules = {
      localIdentName: cssLocalIdentName(options.mode),
    };
  } else if (options.useModules === "auto") {
    cssLoader.options.modules = {
      auto: true,
      localIdentName: cssLocalIdentName(options.mode),
    };
  }

  if (options.postcss) {
    cssLoader.options.importLoaders = 1;
  }

  const loaders = [miniCssLoader, cssLoader];
  options.postcss && loaders.push(postcssLoader);

  return loaders;
};
