const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const useCss = require("../../utils/use_css");

module.exports = css;

function css() {
  return (context, { addLoader, addPlugin }) => (prevConfig) => {
    const nextConfig = addLoader(
      Object.assign(
        {
          test: /\.css$/i,
          use: useCss({
            mode: context.mode,
            useModules: "auto",
            postcss: context.postcss,
          }),
        },
        context.match
      )
    )(prevConfig);

    return addPlugin(new MiniCssExtractPlugin())(nextConfig);
  };
}
