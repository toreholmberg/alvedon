require 'thor'
require 'pathname'

module Alvedon
  class CLI < Thor

    desc 'build [app1.js app2.js..]', 'build assets'

    method_option :target, :aliases => '-t', :desc => 'Directory to compile target to'
    method_option :watch, :type => :boolean, :aliases => '-w', :desc => 'Watch and build'
    method_option :compress, :type => :boolean, :aliases => '-c', :desc => 'Compress assets'

    def build(*assets)
      
      target = Pathname(options[:target] || './build/')
      watch = options[:watch]
      compress = options[:compress]

      if watch
        puts "Watching.."
        Alvedon.watcher.start assets, target, compress
      else
        puts "Building.."
        Alvedon.builder.compile assets, target, compress
      end

    end

    default_task :build
    
  end
end