const { join } = require("path");

if (!process.cwd().endsWith("test/dummy")) {
  process.chdir(join(process.cwd(), "test/dummy"));
}
