const { group, match } = require("@webpack-blocks/webpack");
const { file } = require("@webpack-blocks/assets");

const useCss = require("./utils/use_css");

// Assets
//
// Adds support for JS, CSS, image and font assets from "/app/assets".
module.exports = () => group([css(), images(), fonts()]);

const css = () => {
  return (context, { addLoader }) =>
    addLoader(
      Object.assign(
        {
          test: /app\/assets\/(.*)\.css$/i,
          use: useCss({
            mode: context.mode,
            useModules: "auto",
            postcss: context.postcss,
          }),
        },
        context.match
      )
    );
};

const images = () => {
  return match("*.{jpg,jpeg,png,gif}", [
    file({
      name: "[path][name]-[hash].[ext]",
      context: "app/assets",
    }),
  ]);
};

const fonts = () => {
  // Match woff2 in addition to patterns like .woff?v=1.1.1.
  return match(/\.(woff|woff2)(\?v=\d+\.\d+\.\d+)?$/, [
    file({
      context: "app/assets",
      mimetype: "application/font-woff",
      name: "[path][name].[ext]",
    }),
  ]);
};
