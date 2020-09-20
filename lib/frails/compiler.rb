require 'open3'
require 'digest/sha1'

class Frails::Compiler
  CACHE_PATH = 'tmp/cache/frails'.freeze

  def initialize
    @cache_path = Rails.root.join(CACHE_PATH)
  end

  def compile
    if stale?
      run_webpack.tap do |_success|
        record_compilation_digest
      end
    else
      Frails.logger.debug 'All up to date!'
      true
    end
  end

  def fresh?
    watched_files_digest == last_compilation_digest
  end

  def stale?
    !fresh?
  end

  private

    def last_compilation_digest
      if compilation_digest_path.exist? # && config.public_manifest_path.exist?
        compilation_digest_path.read
      end
      # rescue Errno::ENOENT, Errno::ENOTDIR
    end

    def watched_files_digest
      Dir.chdir(Rails.root) do
        files = Dir[*watched_paths].reject { |f| File.directory?(f) }
        file_ids = files.sort.map { |f| "#{File.basename(f)}/#{Digest::SHA1.file(f).hexdigest}" }
        Digest::SHA1.hexdigest(file_ids.join('/'))
      end
    end

    def record_compilation_digest
      @cache_path.mkpath
      compilation_digest_path.write(watched_files_digest)
    end

    def run_webpack
      Frails.logger.info 'Compiling assets...'
      Frails.logger.debug "Executing `#{webpack_command}`"

      stdout, stderr, status = Open3.capture3(webpack_command, chdir: Rails.root)

      if status.success?
        Frails.logger.info "Compiled all assets in ./#{relative_public_path}"
        Frails.logger.error stderr.to_s unless stderr.empty?
        # Frails.logger.info stdout # if Frails.verbose
      else
        non_empty_streams = [stdout, stderr].delete_if(&:empty?)
        Frails.logger.error "Compilation failed:\n#{non_empty_streams.join("\n\n")}"
      end

      status.success?
    end

    def compilation_digest_path
      @cache_path.join("last-compilation-digest-#{Rails.env}")
    end

    def watched_paths
      [
        'app/{lib,views}/**/*.{js,css}',
        'yarn.lock', 'package.json', 'webpack.config.js'
      ].freeze
    end

    def relative_public_path
      Rails.public_path.join(Frails.public_output_path).relative_path_from(Rails.root)
    end

    def webpack_command
      env = Rails.env.development? || Rails.env.test? ? 'development' : 'production'
      "yarn webpack --env #{env}"
    end
end
