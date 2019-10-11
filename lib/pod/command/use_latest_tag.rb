# The CocoaPods use-latest-tag command.

# The CocoaPods namespace
module Pod
  class Command
    class UseLatestTag < Command
      self.summary = <<-SUMMARY
          Try to change Podfile to use the latest tag.
      SUMMARY

      self.description = <<-DESC
          One key to change Pod to use the latest tag.
          In non-verbose mode, '~' indicates the Pod has been changed to use the latest tag.
      DESC

      self.arguments = []

      def self.options
        [
            ['--verbose', 'Show change details.']
        ].concat(super)
      end

      def initialize(argv)
        @check_command_verbose = argv.flag?('verbose')
        super
      end

      def run
        unless config.podfile
          raise Informative, 'Missing Podfile!'
        end

        results = change_podfile(config)
        print_results(results)
      end

      def change_podfile(config)
        target_pods = {}
        config.podfile.dependencies.each do |dependency|
          if dependency.external? && (dependency.external_source[:branch] != nil || dependency.external_source[:tag] != nil)
            target_pods[dependency.name] = dependency.external_source.clone
          end
        end
        target_pod_names = target_pods.keys

        target_pod_names.sort.uniq.map do |spec_name|
          git_path = target_pods[spec_name][:git].gsub("/", '\/')
          # get latest tag for spec
          latest_tag = get_latest_tag(target_pods[spec_name])
          next if latest_tag.empty?

          exp = ""
          preview_version = ""
          latest_version = "latest_tag: #{latest_tag}"
          if target_pods[spec_name][:tag] != nil && target_pods[spec_name][:tag] != latest_tag
            # preview use tag
            exp = "/#{git_path}/s/:tag[ ]*=>[ ]*'[^']*'/:tag => '#{latest_tag}'/"
            preview_version = "preview_tag: #{target_pods[spec_name][:tag]}"
          elsif target_pods[spec_name][:branch] != nil
            # preview use branch
            exp = %(/#{git_path}/s/:branch[ ]*=>[ ]*'[^']*'/:tag => '#{latest_tag}'/)
            preview_version = "preview_branch: #{target_pods[spec_name][:branch]}"
          end
          next if exp.empty?

          # sed command
          command = %(sed -i '' -E "#{exp}" Podfile)
          if @check_command_verbose
            UI.puts "Command: #{command}"
          end
          `#{command}`

          # cache changed result
          changed_result(spec_name, preview_version, latest_version)
        end.compact
      end

      def get_latest_tag(external_source)
        command = "git ls-remote --tags --refs --sort='v:refname' #{external_source[:git]} | tail -n1 | sed 's/.*\\///'"
        latest_tag = (`#{command}` || '').strip
        if @check_command_verbose
          UI.puts "Fetch latest tag for #{external_source[:git]} -> #{latest_tag}"
        end
        return latest_tag
      end

      def changed_result(spec_name, preview_version, latest_version)
        if @check_command_verbose
          "#{spec_name} #{preview_version} -> #{latest_version}"
        else
          "~#{spec_name}"
        end
      end

      def print_results(results)
        return UI.puts "The Podfile's dependencies all use latest tag." if results.empty?

        if @check_command_verbose
          UI.puts results.join("\n")
        else
          UI.puts results.join(', ')
        end

        raise Informative, "#{results.length} Pod#{'s' if results.length > 1} has been changed to use the latest tag. Please double check the Podfile's changes."
      end
    end
  end
end
