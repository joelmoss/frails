// Only here tio allow us to mock `require.resolve`, which prevents snapshots from including the
// Yarn PnP virtual cache paths when resolving loaders.
module.exports = loader => require.resolve(loader)
