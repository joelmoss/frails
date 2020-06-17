module.exports = (options = {}) =>
  Object.assign(() => (config) => config, {
    pre: preHook(options),
  });

const preHook = (options) => (context) => {
  context.postcss = options;
};
