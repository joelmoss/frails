const {
  createConfig,
  postcss,
  devServer,
  sideLoadViews,
  babel,
  reactSvg,
  erb,
  railsI18n,
} = require("frails");

// module.exports = createConfig();

module.exports = createConfig([
  // erb(),
  // sideLoadViews(),
  // postcss(),
  // devServer({ overlay: true }),
  // babel(),
  // reactSvg(),
  // railsI18n.block(),
]);

console.debug(module.exports);
console.debug(module.exports.module.rules);
console.debug(module.exports.module.rules[0].use);
// console.debug(module.exports.module.rules[1].use);
