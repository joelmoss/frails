const glob = require("glob");
const path = require("path");
const fs = require("fs");

const appPath = path.join(process.cwd(), "app");

// Build entry points for HTML based components (components with an index.html.erb and index.css).
//
// NOTE: Adding new files will require a rebuild!
const buildComponents = () => {
  const result = {};

  // Find HTML partials and add its corresponding index.css as an entry point if it exists.
  glob
    .sync(path.join(appPath, "components/**/_index.html.erb"))
    .forEach(paf => {
      paf = paf.replace("_index.html.erb", "index.css");

      if (!fs.existsSync(paf)) return;

      const namespace = path.relative(path.join(appPath), path.dirname(paf));
      const name = path.join(namespace, path.basename(paf, path.extname(paf)));

      result[name] = paf;
    });

  // Find components with no JSX and HTML index files, and add its corresponding index.css as an
  // entry point if it exists. These will be components that render from within the Ruby class
  // itself.
  glob.sync(path.join(appPath, "components/**/*_component.rb")).forEach(paf => {
    css_paf = paf.replace("_component.rb", "/index.css");
    html_paf = paf.replace("_component.rb", "/_index.html.erb");
    jsx_paf = paf.replace("_component.rb", "/index.entry.jsx");

    // Ignore if we have a JSX or HTML file, or no CSS file.
    if (
      fs.existsSync(jsx_paf) ||
      fs.existsSync(html_paf) ||
      !fs.existsSync(css_paf)
    )
      return;

    const namespace = path.relative(path.join(appPath), path.dirname(css_paf));
    const name = path.join(
      namespace,
      path.basename(css_paf, path.extname(css_paf))
    );

    result[name] = css_paf;
  });

  return result;
};

module.exports = {
  entry: { ...buildComponents() }
};
