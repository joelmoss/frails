if File.exists?(".gitignore")
  append_to_file ".gitignore" do
    "\n"                   +
    "/node_modules\n"      +
    "/yarn-error.log\n"    +
    "yarn-debug.log*\n"    +
    ".yarn-integrity\n"
  end
end

say "Installing all JavaScript dependencies [#{Frails::VERSION}]"
run "yarn add webpack webpack-cli"

say "Installing Webpack dev server for live reloading"
run "yarn add --dev webpack-dev-server"

if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR > 1
  say "You need to allow webpack-dev-server host as allowed origin for connect-src.", :yellow
  say "This can be done in Rails 5.2+ for development environment in the CSP initializer", :yellow
  say "config/initializers/content_security_policy.rb with a snippet like this:", :yellow
  say "policy.connect_src :self, :https, \"http://localhost:3035\", \"ws://localhost:3035\" if Rails.env.development?", :yellow
end

say "Frails successfully installed 🎉", :green
