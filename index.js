const { file } = require("@webpack-blocks/assets");
const { match, resolve } = require("@webpack-blocks/webpack");

const createConfig = require("./package/create_config");
const devServer = require("./package/dev_server");
const postcss = require("./package/postcss");
const sideLoadViews = require("./package/side_load_views");
const components = require("./package/components");
const assets = require("./package/assets");
const babel = require("./package/babel");
const reactSvg = require("./package/react_svg");
const erb = require("./package/erb");
const railsI18n = require("./package/rails_i18n");

module.exports = {
  createConfig,
  components,
  devServer,
  postcss,
  sideLoadViews,
  babel,
  file,
  match,
  resolve,
  reactSvg,
  erb,
  assets,
  railsI18n,
};

// const path = require('path')

// const rootPath = path.resolve(__dirname, '../../../')
// const publicOutputPath = process.env.FRAILS_PUBLIC_OUTPUT_PATH || 'assets'

// // Ensure that the publicPath includes our asset host so dynamic imports
// // (code-splitting chunks and static assets) load from the CDN instead of a relative path.
// const getPublicPathWithAssetHost = () => {
//   const rootUrl = process.env.RAILS_ASSET_HOST || '/'
//   let packPath = `${publicOutputPath}/`

//   // Add relative root prefix to pack path.
//   if (process.env.RAILS_RELATIVE_URL_ROOT) {
//     let relativeRoot = process.env.RAILS_RELATIVE_URL_ROOT
//     relativeRoot = relativeRoot.startsWith('/') ? relativeRoot.substr(1) : relativeRoot
//     packPath = `${ensureTrailingSlash(relativeRoot)}${packPath}`
//   }

//   return (rootUrl.endsWith('/') ? rootUrl : `${rootUrl}/`) + packPath
// }
