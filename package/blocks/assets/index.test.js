import { createConfig } from "@webpack-blocks/webpack";

import assets from "./";

describe("assets", () => {
  test("config", () => {
    expect(createConfig(assets())).toMatchSnapshot();
  });
});
