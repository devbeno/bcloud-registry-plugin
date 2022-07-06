require "optparse"
require "uri"
require "pathname"

require_relative "../uploader"

module BcloudPlugins
  module Registry
    module Command
      class Push < Vagrant.plugin("2", :command)

        def execute
          options = {}

          opts = OptionParser.new do |o|
            o.banner = "Usage: vagrant registry push <path> <url> <version> <provider> [options]"
            o.separator ""
            o.on("-n", "--new-upload", "Upload without continuing interrupted upload") do |n|
              options[:new_upload] = n
            end
          end

          argv = parse_options(opts)
          return unless argv

          path, url, version, provider = argv[0], argv[1], argv[2], argv[3]
          if !path || !url || !version || !provider || argv.length > 4
            raise Vagrant::Errors::CLIInvalidUsage,
                  help: opts.help.chomp
          end

          if url =~ /^\w+\/\w+$/
            # User specified box name instead of URL. Construct full URL.
            env_url = ENV["VAGRANT_REGISTRY_URL"]
            unless env_url
              raise Vagrant::Errors::CLIInvalidUsage,
                    help: I18n.t("bcloud_registry.push.env_url_missing")
            end
            url = URI.join(env_url, url).to_s
          end

          raise Registry::Errors::InvalidURL,
                url: url unless url =~ /^http(s)?:\/\/.+\/[\w.@+-]+\/[\w.@+-]+(\/)?$/

          raise Registry::Errors::BoxFileNotFound,
                path: path unless Pathname.new(path).file?

          self.logged_in?(url)

          uploader = Registry::Uploader.new(@env, path, url, version, provider)

          if options[:new_upload]
            uploader.upload_box!
          else
            uploader.upload_box
          end

          # Success, exit status 0
          0
        end

        protected

        def logged_in?(url)
          require_relative "../client"
          client = BcloudPlugins::Registry::Client.new(@env, url)
          unless client.logged_in?
            raise Registry::Errors::NotLoggedIn
          end
        end

      end
    end
  end
end
