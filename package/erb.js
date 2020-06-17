const path = require("path");
const { resolve, group } = require("@webpack-blocks/webpack");

module.exports = () => {
  return group([
    post,
    resolve({
      extensions: [".js.erb", ".jsx.erb"],
    }),
  ]);

  //   const setter = resolve({
  //     extensions: [".js.erb", ".jsx.erb"],
  //   });

  //   return Object.assign(setter, { pre, post });
};

const pre = (context) => {
  context.erb = true;
};

const post = (context, { addLoader }) => {
  const rootPath = process.cwd();

  return addLoader(
    Object.assign(
      {
        test: /\.(js|jsx)\.erb$/i,
        enforce: "pre",
        include: [
          path.join(rootPath, "app", "assets"),
          path.join(rootPath, "app", "components"),
        ],
        loader: "rails-erb-loader",
      },
      context.match
    )
  );
};
