require 'thor'
require 'pathname'

module Alvedon
  class CLI < Thor

    desc 'build [app1.js app2.js..]', 'build assets'

    method_option :target, :aliases => '-t', :desc => 'Directory to compile target to'
    method_option :compress, :type => :boolean, :aliases => '-c', :desc => 'Compress assets'

    def build(*assets)
      puts "Alvedon: Building..."
      target = Pathname(options[:target] || './build/')
      compress = options[:compress]
      Alvedon.build(assets, target, compress)
    end

    desc 'watch [app1.js app2.js..]', 'watch assets'

    method_option :target, :aliases => '-t', :desc => 'Directory to compile target to'
    method_option :compress, :type => :boolean, :aliases => '-c', :desc => 'Compress assets'

    def watch(*assets)
      puts "Alvedon: Watching..."
      target = Pathname(options[:target] || './build/')
      compress = options[:compress]
      Alvedon.watch(assets, target, compress)
    end

    default_task :build
  end
end