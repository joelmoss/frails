const { entryPoint, group, addPlugins } = require("@webpack-blocks/webpack");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const glob = require("fast-glob");
const path = require("path");
const has = require("lodash.has");

const useCss = require("./utils/use_css");
const appPath = path.join(process.cwd(), "app");

module.exports = () =>
  group([
    entryPoints(),
    cssLoadersForViews(),
    cssLoadersForPartials(),
    addPlugins([
      new MiniCssExtractPlugin({
        filename: "[name]-[contenthash:16].css",
        chunkFilename: "[name]-[contenthash:16].chunk.css",
      }),
    ]),
  ]);

// Entry points for side-loaded CSS and JS, which are any .css and .js files that exist alongside
// the view template. For example, a view template at /app/views/pages/show.html.erb could have a
// css file alongside it at /app/views/pages/show.css.
//
// NOTE: Adding new files will require a rebuild!
const entryPoints = () => {
  const result = {};

  glob.sync(path.join(appPath, "views/**/*.{css,js}")).forEach((paf) => {
    const namespace = path.relative(appPath, path.dirname(paf));
    const name = path.join(namespace, path.basename(paf, path.extname(paf)));

    has(result, name) ? result[name].push(paf) : (result[name] = [paf]);
  });

  return entryPoint(result);
};

const cssLoadersForPartials = () => (context, { addLoader }) => {
  return addLoader({
    // Partials - modules (local)
    test: /app\/views\/.+(\/_([\w-_]+)\.css)$/,
    use: useCss({
      mode: context.mode,
      useModules: true,
      postcss: context.postcss,
    }),
  });
};

const cssLoadersForViews = () => (context, { addLoader }) => {
  return addLoader({
    // Views - no CSS modules
    test: /app\/views\/.+(\/[^_]([\w-_]+)\.css)$/,
    sideEffects: true,
    use: useCss({ mode: context.mode, postcss: context.postcss }),
  });
};
