module.exports = () => (_, { merge }) =>
  merge({
    module: {
      rules: [
        {
          test: /\.svg$/i,
          issuer: {
            exclude: /\.jsx$/,
          },
          use: [
            {
              loader: "file-loader",
              options: {
                name: "[path][name]-[hash].[ext]",
                context: "app/assets",
              },
            },
          ],
        },
        {
          test: /\.svg$`/i,
          issuer: {
            test: /\.jsx$/,
          },
          use: [
            {
              loader: "babel-loader",
              options: {
                cacheDirectory: true,
              },
            },
            {
              loader: "react-svg-loader",
              options: {
                jsx: true,
              },
            },
          ],
        },
      ],
    },
  });
