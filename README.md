# Frails == Modern Front End on Rails

Frails is a modern asset pipeline for [Rails](https://rubyonrails.org), built on [Webpack](https://webpack.js.org/). Its aims are:

- Follow convention over configuration as much as possible.
- Tight integration with Rails, without tying you up in knots.
- Un-opinionated webpack configuration - batteries not included!
- Full Webpack control without fighting with the likes of Webpacker.
- Embrace modern front end practices.

PLUS...

- Side loaded layouts, views and partials.
- Components
  - React + SSR
  - Ruby/HTML

IDEAS...

- Lazy loaded Webpack blocks - Only load a block if it is needed. For example, if an erb file is encountered, include the `erb` block.
- Show manifest contents on Rails development error pages - as an expandable "dump".

## Installation

Frails is designed to work only within a Rails application, so must be installed in an existing Rails app. It also requires Node.js and a valid `package.json` file in your app root.

Add this line to your application's Gemfile:

```ruby
gem 'frails'
```

And then execute:

    $ bundle

Then run the installer which will create a minimum viable Webpack config file, and a basic assets directory with a few example assets:

    $ bin/rails frails:install

## Webpack Usage

Frails tries to keep as close as possible to a standard Webpack setup, so you can run webpack and webpack-dev-server in the usual way. For example, using yarn you can build:

    $ yarn webpack

or run the dev server:

    $ yarn webpack-dev-server

In development, you should use `webpack-dev-server` alongside `rails server`. Rails will proxy requests to the running Webpack dev server.

## Getting Started

Create a new entry point (or pack, if you are coming from Webpacker). For example, create a new file at `app/assets/application.entry.js` and add any JS or `import`s you wish in that file.

Now in your HTML views, include your entry file using the `javascript_entry_tag` helper:

```ruby
javascript_entry_tag 'application'
```

You can do the same with CSS and the `stylesheet_entry_tag` helper:

```ruby
stylesheet_entry_tag 'application'
```

However, if you `import` a CSS file in your JS, that CSS will be included in your pages automatically. So you may find that calling `stylesheet_entry_tag` is rarely needed.

Images can be used with the ``

```ruby
image_tag 'application'
```

## Configuration

The minimum required configuration that is needed to get Frails and Webpack running is a `webpack.config.js` in the root of your project:

```javascript
const { createConfig } = require("frails");
module.exports = createConfig();
```

If you have run the installer (`bin/rails frails:install`), then the above config file will be created for you, and all needed dependencies installed.

### Right, but what does `createConfig()` do?

Calling `createConfig()` without any arguments will set up a basic asset pipeline for your Rails app, along with support webpack dev server during development. All your front end assets are expected to be located in the `app/assets` directory. This includes support for the following formats, along with their file extensions:

- Javascript (`**/*.js`)
- CSS (`**/*.css`)

How you organise your assets within `app/assets` is entirely up to you. However, there is just one requirement to how you name your Javascript files. Webpack has a concept of **[entry points](https://webpack.js.org/concepts/#entry)**...

> An entry point indicates which module webpack should use to begin building out its internal dependency graph. Webpack will figure out which other modules and libraries that entry point depends on (directly and indirectly).

So any file you want to include in your views should be named as an entry file: `*.entry.{js,css}`. For example: `application.entry.js`.

Reular JS imports are not entry points, and must not include the `entry` suffix in their file names.

## Webpack Configuration Blocks

Frails comes with the following Webpack configuration presets and blocks, allowing you to pick and choose as you please:

- Presets:
  - `assets` - Basic asset pipeline, supporting JS and CSS.
  - `side_load_views` - Automatically side load assets for your views, layouts and partials.
  - `components`
- Blocks:
  - `postcss`

### `assets` preset

The `assets` preset will configure a basic asset pipeline, supporting JS and CSS. It includes these blocks:

- `assets/entryPoints`
- `assets/css`

### `assets/entryPoints` block

An entry pack is made up of one or more entry points in the manifest, and can be a mix of JS and CSS entry points. Including an entry pack will therefore include all entry points in that pack.

Just create a JS and/or CSS file in `app/assets` as your entry point(s) (eg. `app/assets/application.entry.js` or `app/assets/admin/index.entry.js`), and include with the `entry_pack_tags` or `include_entry_pack` helpers:

```erb
<%= entry_pack_tags 'application' %>
<% include_entry_pack 'admin' %>
```

The difference being that `entry_pack_tags` will return the `<script>` and/or `<link>` HTML tags for the included JS and CSS, while `include_entry_pack` will return nothing. Instead `include_entry_pack` will store the HTML tags in a `content_for` block. Just yield the CSS and JS in your layout:

```erb
<!DOCTYPE html>
<html>
  <head>
    <title>My App</title>
    <%= yield :css %>
  </head>
  <body>
    <%= yield %>
    <%= yield :js %>
  </body>
</html>
```

### `assets/css` block

Adds support for CSS (`app/assets/**/*.css`), including [CSS modules](https://github.com/css-modules/css-modules).

Import a CSS file into any Javascript, and the CSS will automatically be included into the page as a separate CSS file link:

```js
import "my_styles.css"; // don't forget the file extension.
```

You can also import a CSS module and use it within your Javascript. Just name your CSS file as a module:

```js
import styles from './styles.module.css
const ul = document.querySelector("ul");
ul.className = styles.list; // className will something like "assets-styles-module__list___e5dc54"
```

### `postcss`

Adds support for processing CSS with [PostCSS](https://postcss.org/). Just include this block, and
all your CSS will be processed with PostCSS.

## Rails Helpers

### `javascript_pack_tag`

Just like `javascript_include_tag`, but will use your webpack assets.

```ruby
javascript_include_tag 'application'
```

### `stylesheet_pack_tag`

Just like `stylesheet_link_tag`, but will use your webpack assets.

```ruby
stylesheet_pack_tag 'application'
```

### `image_pack_tag`

Just like `image_tag`, but will use your webpack assets.

```ruby
image_pack_tag 'logo.png'
```

## Side Loaded Assets

Frails has the ability to automatically include your Javascript and CSS based on the current layout
and/or view. It even supports side loading partials.

Just set the `side_load_assets` class variable to your `ApplicationController`, or indeed to any
controller.

```ruby
class ApplicationController < ActionController::Base
  self.side_load_assets = true
end
```

As an example, given a view at `/app/views/pages/home.html.erb`, we can create
`/app/views/pages/home.css` and/or `/app/views/pages/home.js`. These side-loaded assets will then be
included automatically in the page.

```yml
app/views/pages: ├── home.html.erb
  ├── home.css
  ├── home.js
  ├── _header.html.erb
  ├── _header.css
```

Make sure you yield the side loaded CSS and JS tags; `<%= yield :side_loaded_css %>` in your
`<head>`, and `<%= yield :side_loaded_js %>` at the bottom of the body:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>My App</title>
    <%= yield :side_loaded_css %>
  </head>
  <body>
    <%= yield %> <%= yield :side_loaded_js %>
  </body>
</html>
```

CSS is included in-line for faster renders, and JS is included as `<script src="...">` tags. Check out `./package/side_load.js` for the webpack config needed to make this work.

### Partials and CSS Modules

Partial CSS supports CSS Modules, and it is recommended that partial CSS are compiled as local CSS modules. Then in your partial, you can use the `css_module` attribute on any HTML tag, and it will be replaced with the compiled class name of the CSS module.

So given a partial `views/layouts/_awesome.html.erb`:

```html
<div css_module="base">Hello World</div>
```

and a stylesheet at `views/layouts/_awesome.css`:

```css
.base {
  color: red;
}
```

When the partial is rendered, it will look something like this:

```html
<div class="app-views-layouts-_awesome__base___abc123">Hello World</div>
```

And the compiled CSS:

```css
.app-views-layouts-_awesome__base___abc123 {
  color: red;
}
```

Of course in theory, you could apply this to all your side loaded CSS, but Frails will only
transform `css_module` HTML attributes in partials.

Your Webpack config could use the following to compile your partial CSS as modules (local), and
layout and view CSS normally (global):

```javascript
module.exports = {
  module: {
    rules: [
      {
        // Partials - modules (local)
        test: /app\/views\/.+(\/_([\w-_]+)\.css)$/,
        use: ["style-loader", "css-loader"],
      },
      {
        // Layouts and views - no CSS modules (global)
        test: /app\/views\/.+(\/[^_]([\w-_]+)\.css)$/,
        use: ["style-loader", "css-loader"],
      },
    ],
  },
};
```

## Configuration

Frails is built to be as simple as possible, so has very few configuration options:

- `Frails.dev_server_host` - The HTTP port that Rails will proxy asset requests to. (default: `8080`)
- `Frails.dev_server_path` - The HTTP host that Rails will proxy asset requests to. (default: `localhost`)
- `Frails.public_output_path` - The public path where Webpack will output its build to, relative to your app's `/public` directory. (default: `assets`)
- `Frails.manifest_path` - Path to the produced Webpack manifest file, relative to the `public_output_path`. (default: `manifest.json`)

## Using in Tests

Please note that Frails is not designed or intended to be run in your test environment. This would require a full webpack compile on every test run, which would slow your tests down hugely! Instead, I recommend that you test your Javascript independently using the likes of Jest or some other good Javascript test runner.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joelmoss/frails.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Thanks...

A huge thank you goes out to the peeps behind [Webpacker](https://github.com/rails/webpacker). Frails has borrowed heavily from Webpacker, particularly for the dev server proxy and minifest code. 🙏
