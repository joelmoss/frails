const core = require('@frails/core')
const devServer = require('@frails/dev_server')
const css = require('@frails/css')
const babel = require('@frails/babel')
const images = require('@frails/images')
const fonts = require('@frails/fonts')
const sideLoadViews = require('@frails/side_load_views')

const defaultBlocks = [sideLoadViews, images, fonts, css, devServer, babel]

// Create and return a Webpack config object with default Frails config blocks (see `defaultBlocks`
// above).
//
// It accepts any number of blocks as created by `createConfigBlock`. If a block is given that is
// already applied as a default block, it will be used instead of the default. This allows you to
// pass options to the block:
//
//  createConfig(css(false))
//
// The above will disable CSS, as it will override the default CSS block.
//
// Custom blocks or blocks that are not a default, will be appended.
const createConfig = (...givenBlocks) => {
  const givenBlockNames = givenBlocks.map(x => x.blockName)

  // Replace default blocks with `givenBlocks` of the same name.
  let newBlocks = defaultBlocks.map(block => {
    const index = givenBlockNames.indexOf(block.blockName)
    if (index >= 0) {
      return givenBlocks.splice(index, 1)[0]
    } else {
      return block
    }
  })

  // Append any remaining `givenBlocks` not used to replace a default block.
  newBlocks = newBlocks.concat(givenBlocks)

  return core.createConfig(...newBlocks)
}

module.exports = {
  createConfig,
  createConfigBlock: core.createConfigBlock,
  devServer,
  css,
  images,
  fonts,
  sideLoadViews,
  babel
}
