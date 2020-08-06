import config from "./config";

describe("config", () => {
  test("config", () => {
    expect(config).toMatchSnapshot();
  });
});
