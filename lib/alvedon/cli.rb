require 'thor'
require 'pathname'

module Alvedon
  class CLI < Thor

    def initialize(*args)
      super *args
      @builder = Alvedon::Builder.new
    end

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
        @builder.watch assets, target, compress
      else
        puts "Building.."
        @builder.build assets, target, compress
      end

    end

    default_task :build
  end
end