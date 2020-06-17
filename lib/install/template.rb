# frozen_string_literal: true

if File.exist?('.gitignore')
  append_to_file '.gitignore' do
    "\n" \
    "/node_modules\n" \
    "/yarn-error.log\n" \
    "yarn-debug.log*\n" \
    ".yarn-integrity\n"
  end
end

say "Installing all JavaScript dependencies [#{Frails::VERSION}]"
run 'yarn add webpack webpack-cli'

say 'Installing Webpack dev server for development and live reloading'
run 'yarn add --dev webpack-dev-server'

say 'Frails successfully installed 🎉', :green
