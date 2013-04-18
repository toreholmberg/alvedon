require 'thor'
require 'pathname'

module Alvedon
  class CLI < Thor

    def initialize(*args)
      super *args
      require Alvedon.project_file
    end

    desc 'build [app1 app2 ..]', 'build app(s)'

    def build(*apps)
      Alvedon.builder.compile(*apps)
    end

    desc 'watch [app1 app2 ..]', 'watch app(s)'

    def watch(*apps)
      Alvedon.watcher.listen(*apps)
    end

    default_task :build
    
  end
end