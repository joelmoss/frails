const glob = require("glob");
const path = require("path");
const has = require("lodash.has");

const appPath = path.join(process.cwd(), "app");

// Entry points for side-loaded CSS and JS, which are any .css and .js files that exist alongside
// the view template. For example, a view template at /app/views/pages/show.html.erb could have a
// css file alongside it at /app/views/pages/show.css.
const build = () => {
  const result = {};

  glob.sync(path.join(appPath, "views/**/*.{css,js}")).forEach(paf => {
    const namespace = path.relative(appPath, path.dirname(paf));
    const name = path.join(namespace, path.basename(paf, path.extname(paf)));

    has(result, name) ? result[name].push(paf) : (result[name] = [paf]);
  });

  return result;
};

module.exports = {
  entry: { ...build() }
};
