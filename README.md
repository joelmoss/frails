# Frails == Modern Front End on Rails

Frails is a modern asset pipeline for [Rails](https://rubyonrails.org), built on [Webpack](https://webpack.js.org/). Its aims are:

  - Follow convention over configuration as much as possible.
  - Tight integration with Rails, without tying you up in knots.
  - Full Webpack control without fighting with the likes of Webpacker.
  - Embrace modern front end practises.

## Installation

Frails is designed to work only with Rails, so must be installed in an existing Rails app. It also requires Node.js and a valid `package.json` file in your app root.

Add this line to your application's Gemfile:

```ruby
gem 'frails'
```

And then execute:

    $ bundle

Then run the installer:

    $ bin/rails frails:install

## Usage

Frails tries to keep as close as possible to a standard Webpack setup, so you can run webpack and webpack-dev-server in the usual way. For example, using yarn:

    $ yarn webpack

or

    $ yarn webpack-dev-server

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joelmoss/frails.

## Thanks...

A huge thank you goes out to the peeps behind [Webpacker](https://github.com/rails/webpacker). Frails has borrowed heavily from Webpacker, particularly for the dev server proxy and minifest code. 🙏