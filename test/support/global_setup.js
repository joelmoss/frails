const { join } = require('path')

module.exports = async () => {
  if (!process.cwd().endsWith('test/dummy')) {
    process.chdir(join(process.cwd(), 'test/dummy'))
  }
}
