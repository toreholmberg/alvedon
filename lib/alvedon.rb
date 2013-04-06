require 'pathname'
require 'fileutils'
require 'sprockets'
require 'sprockets/commonjs'
require 'listen'

module Alvedon

  def self.root
    @root ||= Pathname('.').expand_path
  end

  def self.sprockets 
    @sprockets ||= begin
      sprockets = Sprockets::Environment.new(root)

      sprockets.register_postprocessor 'application/javascript', Sprockets::CommonJS

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

    if compress
      require 'uglifier'
      require 'yui/compressor'
      sprockets.js_compressor = Uglifier.new :mangle => true
      sprockets.css_compressor = YUI::CssCompressor.new
    end

    sprockets.each_logical_path(assets) do |logical_path|
      begin
        if asset = sprockets.find_asset(logical_path)
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

  def self.watch(*assets, target, compress)
    build(assets, target, compress)
    paths = sprockets.paths
    Listen.to(*paths) { build(assets, target, compress) }
  end

end