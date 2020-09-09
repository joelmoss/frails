const createConfig = require("../../package/webpack/create_config");

describe("createConfig", () => {
  test("returns object", () => {
    expect(createConfig()).toMatchSnapshot();
  });
});
