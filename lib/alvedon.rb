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

  def self.root
    @root ||= Pathname('.').expand_path
  end

  def self.asset_path
    # TODO: make configurable
    @asset_path ||= File.join(root, 'assets')
  end

  def self.sprockets 
    @sprockets ||= begin

      if gem_available?('susy')
        require 'susy'
        puts "Found Susy"
      end

      if gem_available?('compass')
        require 'compass'
        puts "Found compass"
      end

      sprockets = Sprockets::Environment.new

      sprockets.register_postprocessor 'application/javascript', Sprockets::CommonJS
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
          each {|path| sprockets.append_path(path)}
      end

      sprockets
    end
  end

  def self.build(*assets, target, compress)

    puts "Asset dir: #{asset_path}"

    if compress
      require 'uglifier'
      require 'yui/compressor'
      sprockets.js_compressor = Uglifier.new :mangle => true
      sprockets.css_compressor = YUI::CssCompressor.new
    end

    sprockets.each_logical_path(assets) do |logical_path|
      begin
        if asset = sprockets.find_asset(logical_path) and asset.pathname.to_s.match(asset_path)
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

  def self.watch(*assets, target, compress)
    build(assets, target, compress)
    paths = sprockets.paths
    Listen.to(*paths) { build(assets, target, compress) }
  end

  def self.gem_available?(name)
    Gem::Specification.find_by_name(name)
  rescue Gem::LoadError
    false
  rescue
    Gem.available?(name)
  end

end