const { isPlainObject, has } = require('lodash')
const { merge } = require('webpack-merge')
const glob = require('fast-glob')
const path = require('path')

const { appPath } = require('../../config')

module.exports = baseConfig => {
  if (typeof baseConfig.sideLoadViews === 'undefined') {
    // default
    baseConfig.sideLoadViews = true
  }

  if (baseConfig.sideLoadViews) {
    baseConfig.entry = merge(baseConfig.entry, entry())
  }

  delete baseConfig.sideLoadViews
}

// Entry points for side-loaded CSS and JS, which are any .css and .js files that exist alongside
// view and partial templates. For example, a view template at /app/views/pages/show.html.erb could
// have a css file alongside it at /app/views/pages/show.css.
//
// NOTE: Adding new files will require a rebuild!
function entry() {
  const result = {}

  glob.sync(path.join(appPath, 'views/**/*.{css,js}')).forEach(paf => {
    const namespace = path.relative(appPath, path.dirname(paf))
    const name = path.join(namespace, path.basename(paf, path.extname(paf)))

    has(result, name) ? result[name].push(paf) : (result[name] = [paf])
  })

  return result
}
