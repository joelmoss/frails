const { file } = require("@webpack-blocks/assets");

module.exports = () => {
  return match(['*.eot', '*.ttf', '*.woff', '*.woff2'], [
    file()
  ]),
};
