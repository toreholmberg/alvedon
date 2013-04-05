require 'pathname'
require 'fileutils'
require 'sprockets'
require 'listen'

require_relative 'alvedon/cli'

module Alvedon
  #autoload :CLI, 'catapult/cli'

  def self.root
    @root ||= Pathname('.').expand_path
  end

  def self.build

    target = Pathname('./build')

    #environment = Sprockets::Environment.new
    environment = Sprockets::Environment.new(root)

    require 'uglifier'
    environment.js_compressor = Uglifier.new :mangle => true

    require 'yui/compressor'
    environment.css_compressor = YUI::CssCompressor.new

    try_paths = [
      %w{ assets },
      %w{ app },
      %w{ app assets },
      %w{ vendor },
      %w{ vendor assets },
      %w{ lib },
      %w{ lib assets }
    ].inject([]) do |sum, v|
      sum + [File.join(v, 'javascripts'), File.join(v, 'stylesheets')]
    end

    $:.each do |root_path|
      try_paths.map {|p| File.join(root_path, p) }.
        select {|p| File.directory?(p) }.
        each {|path| environment.append_path(path) }
    end

    environment.each_logical_path do |logical_path|
      begin
        if asset = environment.find_asset(logical_path)
          filename = target.join(logical_path)
          FileUtils.mkpath(filename.dirname)
          asset.write_to(filename)
          puts ">> #{filename}"
        end
      rescue StandardError => exception
        puts "Error: #{exception}" 
      end
    end
  end

  def self.watch
    build
    Listen.to('assets') { build }
  end

end