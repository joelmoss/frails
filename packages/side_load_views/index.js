const path = require('path')

const has = require('lodash/has')
const { merge } = require('webpack-merge')
const glob = require('fast-glob')
const { config: frailsConfig, createConfigBlock } = require('@frails/core')

module.exports = createConfigBlock('sideLoadViews', (options, baseConfig) => {
  if (options === false) return

  baseConfig.entry = merge(baseConfig.entry, entry())
})

// Entry points for side-loaded CSS and JS, which are any .css and .js files that exist alongside
// view and partial templates. For example, a view template at /app/views/pages/show.html.erb could
// have a css file alongside it at /app/views/pages/show.css.
//
// NOTE: Adding new files will require a rebuild!
function entry() {
  const result = {}

  glob.sync(path.join(frailsConfig.appPath, 'views/**/*.{css,js}')).forEach(paf => {
    const namespace = path.relative(frailsConfig.appPath, path.dirname(paf))
    const name = path.join(namespace, path.basename(paf, path.extname(paf)))

    has(result, name) ? result[name].push(paf) : (result[name] = [paf])
  })

  return result
}
