require 'thor'

module Alvedon
  class CLI < Thor

    desc "build", "build assets"
    def build
      puts "Alvedon: Building..."
      Alvedon.build
    end

    desc "watch", "watch assets"
    def watch
      puts "Alvedon: Watching..."
      Alvedon.watch
    end

    default_task :build
  end
end