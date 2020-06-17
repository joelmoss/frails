const path = require("path");

module.exports = () => {
  const setter = () => (config) => config;

  return Object.assign(setter, { pre, post });
};

const pre = (context) => {
  context.babel = true;
};

const post = (context, { addLoader }) => {
  const rootPath = process.cwd();

  return addLoader(
    Object.assign(
      {
        test: context.erb ? /\.(js|jsx)?(\.erb)?$/i : /\.(js|jsx)$/i,
        include: [
          path.join(rootPath, "app", "assets"),
          path.join(rootPath, "app", "components"),
        ],
        use: "babel-loader",
      },
      context.match
    )
  );
};
