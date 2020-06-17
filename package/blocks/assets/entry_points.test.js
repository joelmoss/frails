import { createConfig } from "@webpack-blocks/webpack";

import entryPoints from "./entry_points";

describe("assets/entryPoints", () => {
  test("config", () => {
    expect(createConfig(entryPoints())).toMatchSnapshot();
  });

  describe("entry()", () => {
    it("returns object of asset entry points", () => {
      const config = createConfig(entryPoints());

      expect(config.entry()).toMatchSnapshot();
    });
  });
});
