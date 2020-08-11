const path = require("path");

module.exports = (env) => ({
  mode: env,
  entry: "./app/assets/application.js",
  output: {
    filename: "application.js",
    path: path.resolve(__dirname, "public", "assets"),
  },
});
