require 'pathname'
require 'fileutils'
require 'sprockets'
require 'sprockets-sass'
require 'sprockets-helpers'
require 'sass'
require 'sprockets/commonjs'
require 'haml_coffee_assets'
require 'listen'

module Alvedon

  class Builder

    def initialize
      puts "Alvedon #{Alvedon::VERSION}"

      # load config
      require "#{root}/alvedon"

      # init environment
      # TODO: move
      environment
    end

    def root
      @root ||= Pathname('.').expand_path
    end

    def asset_path
      # TODO: make configurable
      @asset_path ||= File.join(root, 'assets')
    end

    def environment
      @environment ||= begin

        if gem_available?('susy')
          require 'susy'
          puts "Found Susy"
        end

        if gem_available?('compass')
          require 'compass'
          puts "Found compass"
        end

        puts "Asset path: #{asset_path}"

        environment = Sprockets::Environment.new
        environment.register_postprocessor 'application/javascript', Sprockets::CommonJS
        Sprockets.register_engine '.hamlc', ::HamlCoffeeAssets::Tilt::TemplateHandler

        try_paths = [
          %w{ assets },
          %w{ app },
          %w{ app assets },
          %w{ vendor },
          %w{ vendor assets },
          %w{ lib },
          %w{ lib assets }
        ].inject([]) do |sum, v|
          sum + [File.join(v, 'javascripts'), File.join(v, 'js'), File.join(v, 'stylesheets')]
        end

        ([root] + $:).each do |root_path|
          try_paths.map {|p| File.join(root_path, p)}.
            select {|p| File.directory?(p)}.
            each {|path| environment.append_path(path)}
        end
        environment
      end
    end

    def build(*assets, target, compress)
      if compress
        require 'uglifier'
        require 'yui/compressor'
        environment.js_compressor = Uglifier.new :mangle => true
        environment.css_compressor = YUI::CssCompressor.new
      end

      environment.each_logical_path(assets) do |logical_path|
        begin
          if asset = environment.find_asset(logical_path) and asset.pathname.to_s.match(asset_path)
            filename = target.join(logical_path)
            FileUtils.mkpath(filename.dirname)
            asset.write_to(filename)
            puts "Writing: #{filename}"
          end
        rescue Exception => e
          puts "Error: #{logical_path}\n#{e}" 
        end
      end
    end

    def watch(*assets, target, compress)
      build(assets, target, compress)
      paths = environment.paths
      Listen.to(*paths) { build(assets, target, compress) }
    end

    private

    def gem_available?(name)
      Gem::Specification.find_by_name(name)
    rescue Gem::LoadError
      false
    rescue
      Gem.available?(name)
    end

  end
end