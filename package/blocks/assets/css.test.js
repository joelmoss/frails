import { createConfig } from "@webpack-blocks/webpack";

import css from "./css";

describe("assets/css", () => {
  test("config", () => {
    expect(createConfig(css())).toMatchSnapshot();
  });
});
