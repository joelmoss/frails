namespace :frails do
  desc 'Verifies if Node.js is installed'
  task :check_node do
    begin
      node_version = `node -v || nodejs -v`
      raise Errno::ENOENT if node_version.blank?

      pkg_path = Pathname.new("#{__dir__}/../../package.json").realpath
      node_requirement = JSON.parse(pkg_path.read)['engines']['node']

      requirement = Gem::Requirement.new(node_requirement)
      version = Gem::Version.new(node_version.strip.tr("v", ""))

      unless requirement.satisfied_by?(version)
        $stderr.puts "Frails requires Node.js #{requirement} and you are using #{version}"
        $stderr.puts "Please upgrade Node.js https://nodejs.org/en/download/"
        $stderr.puts "Exiting!" && exit!
      end
    rescue Errno::ENOENT
      $stderr.puts "Node.js not installed, or a Node version is not specified in your package.json."
      $stderr.puts "You can download Node.js from https://nodejs.org/en/download/"
      $stderr.puts "Exiting!" && exit!
    end
  end
end
