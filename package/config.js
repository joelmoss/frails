const spawnSync = require('child_process').spawnSync
const path = require('path')

const rootPath = process.cwd()
const target = { rootPath, appPath: path.join(rootPath, 'app') }
const handler = {
  get: function (target, prop, receiver) {
    // Return the prop if it already exists.
    if (Object.keys(target).includes(prop)) return target[prop]

    // Return the prop if found in the Rails config cache.
    const config = getConfigFromRails()
    if (Object.keys(config).includes(prop)) return (target[prop] = config[prop])

    if (prop === 'absolutePublicPath') {
      return (target[prop] = path.join(rootPath, 'public', config.publicOutputPath))
    }

    return Reflect.get(...arguments)
  }
}
const config = new Proxy(target, handler)

module.exports = config

function getConfigFromRails() {
  if (configFromRails) return configFromRails

  const ioDelimiter = '__FRAILS_RAILS_RUNNER_DELIMETER__'

  const result = spawnSync('./bin/rails', [
    'runner',
    `puts "${ioDelimiter}#{Frails.config_as_json}${ioDelimiter}"`
  ])

  if (result.status === 0) {
    // Output is delimited to filter out unwanted warnings or other output
    // that we don't want in our files.
    const sourceRegex = new RegExp(ioDelimiter + '([\\s\\S]+)' + ioDelimiter)
    const matches = result.stdout.toString().match(sourceRegex)
    if (matches) {
      configFromRails = JSON.parse(matches[1])
    } else {
      throw 'Rails runner failed having been unable to parse the output.'
    }
  } else if (result.signal !== null) {
    throw `Rails runner was terminated with signal: ${result.signal}`
  } else if (result.error) {
    throw `Rails runner failed with '${result.error.toString()}'.`
  } else {
    throw `Rails runner failed with '${result.stderr.toString()}'.`
  }

  return configFromRails
}

// Cache the rails config.
let configFromRails = undefined
