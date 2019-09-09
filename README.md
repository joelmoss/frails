# Frails == Modern Front End on Rails

Frails is a modern asset pipeline for [Rails](https://rubyonrails.org), built on [Webpack](https://webpack.js.org/). Its aims are:

  - Follow convention over configuration as much as possible.
  - Tight integration with Rails, without tying you up in knots.
  - Un-opinionated webpack configuration - batteries not included!
  - Full Webpack control without fighting with the likes of Webpacker.
  - Embrace modern front end practices.

## Installation

Frails is designed to work only within a Rails application, so must be installed in an existing Rails app. It also requires Node.js and a valid `package.json` file in your app root.

Add this line to your application's Gemfile:

```ruby
gem 'frails'
```

And then execute:

    $ bundle

Then run the installer:

    $ bin/rails frails:install

## Usage

Frails tries to keep as close as possible to a standard Webpack setup, so you can run webpack and webpack-dev-server in the usual way. For example, using yarn you can build:

    $ yarn webpack

or run the dev server:

    $ yarn webpack-dev-server

Rails will proxy requests to any running Webpack dev server.

### Using in Tests

Please note that Frails is not designed or intended to be run in your test environment. This would require a full webpack compile on every test run, which would slow your tests down hugely! Instead, I recommend that you test your Javascript independently using the likes of Jest or some other good Javascript test runner.

### Webpack Configuration

Frails requires the user of the `webpack-assets-manifest` webpack plugin in order for its helpers to
work correctly. This is because it needs to be able lookup the real paths of assets, and the
manifest file provides that data.

```javascript
module.exports = {
  ...
  plugins: [
    new WebpackAssetsManifest({
      writeToDisk: true,
      entrypoints: true,
      publicPath: true
    })
  ]
}
```

### Compilation for Production

To take advantage of Rails asset host functionality, we recommend that you compile your assets using the provided Rake task:

    $ rails frails:compile

This will ensure that you assets respect the `asset_host` configuration.

### Rails Helpers

#### `javascript_pack_tag`

Just like `javascript_include_tag`, but will use your webpack assets.

```ruby
javascript_include_tag 'application'
```

#### `stylesheet_pack_tag`

Just like `stylesheet_link_tag`, but will use your webpack assets.

```ruby
stylesheet_pack_tag 'application'
```

#### `image_pack_tag`

Just like `image_tag`, but will use your webpack assets.

```ruby
image_pack_tag 'logo.png'
```

### Side Loaded Assets

Frails has the ability to automatically include your Javascript and CSS based on the current layout
and/or view.

As an example, given a view at `/app/views/pages/home.html.erb`, we can create
`/app/views/pages/home.css` and/or `/app/views/pages/home.js`. These side-loaded assets will then be
included automatically in the page.

```yml
app/views/pages:
  ├── home.html.erb
  ├── home.css
  ├── home.js
```

Make sure you include the `side_load_assets` helper into the top of each layout, along with
`<%= yield :side_loaded_css %>` in your `<head>`, and `<%= yield :side_loaded_js %>` at the bottom:

```html
<!DOCTYPE html>
<html>
  <%- side_load_assets -%>
  <head>
    <title>My App</title>
    <%= csrf_meta_tags %>
    <%= yield :side_loaded_css %>
  </head>
  <body>
    <%= yield %>

    <%= yield :side_loaded_js %>
  </body>
</html>
```

CSS will be included in-line for faster renders.

Check out `./package/side_load.js` for the webpack config needed to make this work.

## Configuration

Frails is built to be as simple as possible, so has very few configuration options. But if you really must change the defaults, just set any of the following environment variables. Of course, if you do change any of these options, be sure to modify your Webpack config accordingly.

Be sure to install dotenv-flow package and add that to the very top of your primary webpack config:

```javascript
require('dotenv-flow').config()
```

### Options

  - `ENV['FRAILS_DEV_SERVER_PORT']` - The HTTP port that Rails will proxy asset requests to. (default: `8080`)
  - `ENV['FRAILS_DEV_SERVER_HOST']` - The HTTP host that Rails will proxy asset requests to. (default: `localhost`)
  - `ENV['FRAILS_PUBLIC_OUTPUT_PATH']` - The public path where Webpack will output its build to, relative to your app's `/public` directory. (default: `assets`)
  - `ENV['FRAILS_MANIFEST_PATH']` - Path to the produced Webpack manifest file, relative to the `public_output_path`. (default: `manifest.json`)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joelmoss/frails.

## Thanks...

A huge thank you goes out to the peeps behind [Webpacker](https://github.com/rails/webpacker). Frails has borrowed heavily from Webpacker, particularly for the dev server proxy and minifest code. 🙏