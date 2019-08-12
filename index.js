const path = require('path')

const rootPath = path.resolve(__dirname, '../../../')
const publicOutputPath = process.env.FRAILS_PUBLIC_OUTPUT_PATH || 'assets'

// Ensure that the publicPath includes our asset host so dynamic imports
// (code-splitting chunks and static assets) load from the CDN instead of a relative path.
const getPublicPathWithAssetHost = () => {
  const rootUrl = process.env.RAILS_ASSET_HOST || '/'
  let packPath = `${publicOutputPath}/`

  // Add relative root prefix to pack path.
  if (process.env.RAILS_RELATIVE_URL_ROOT) {
    let relativeRoot = process.env.RAILS_RELATIVE_URL_ROOT
    relativeRoot = relativeRoot.startsWith('/') ? relativeRoot.substr(1) : relativeRoot
    packPath = `${ensureTrailingSlash(relativeRoot)}${packPath}`
  }

  return (rootUrl.endsWith('/') ? rootUrl : `${rootUrl}/`) + packPath
}

module.exports = {
  // Configuration
  publicOutputPath,
  manifestPath: process.env.FRAILS_MANIFEST_PATH || 'manifest.json',
  devServerPort: process.env.FRAILS_DEV_SERVER_PORT || '8080',
  devServerHost: process.env.FRAILS_DEV_SERVER_HOST || 'localhost',

  getPublicPathWithAssetHost
}
