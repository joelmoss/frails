namespace :frails do
  desc 'Verifies if Yarn is installed'
  task :check_yarn do
    begin
      yarn_version = `yarn --version`
      raise Errno::ENOENT if yarn_version.blank?

      pkg_path = Pathname.new("#{__dir__}/../../package.json").realpath
      yarn_requirement = JSON.parse(pkg_path.read)['engines']['yarn']

      requirement = Gem::Requirement.new(yarn_requirement)
      version = Gem::Version.new(yarn_version)

      unless requirement.satisfied_by?(version)
        $stderr.puts "Frails requires Yarn #{requirement} and you are using #{version}"
        $stderr.puts "Please upgrade Yarn https://yarnpkg.com/lang/en/docs/install/"
        $stderr.puts "Exiting!" && exit!
      end
    rescue Errno::ENOENT
      $stderr.puts "Yarn is not installed, or a Yarn version is not specified in your package.json."
      $stderr.puts "You can download Yarn from https://yarnpkg.com/lang/en/docs/install/"
      $stderr.puts "Exiting!" && exit!
    end
  end
end
