require 'sprockets'
require 'sprockets-sass'
require 'sass'
require 'compass'
require 'sprockets/commonjs'
require 'haml_coffee_assets'

module Alvedon

  def self.root
    @root ||= Pathname('.').expand_path
  end

  def self.environment
    @environment ||= Alvedon::Environment.new Alvedon.root
  end

  class Environment < ::Sprockets::Environment

    def initialize root

      super root

      # register compass config
      Alvedon::Compass.configuration.register

      # register postprocessors
      register_postprocessor 'application/javascript', ::Sprockets::CommonJS
      
      # register engines
      register_engine '.hamlc', ::HamlCoffeeAssets::Tilt::TemplateHandler

      # append paths
      try_paths = [
        %w{ assets },
        %w{ app },
        %w{ app assets },
        %w{ vendor },
        %w{ vendor assets },
        %w{ lib },
        %w{ lib assets }
      ].inject([]) do |sum, v|
        sum + [
          File.join(v, 'javascripts'), 
          File.join(v, 'js'), 
          File.join(v, 'stylesheets')
        ]
      end

      ([root] + $:).each do |root_path|
        try_paths.map {|p| File.join(root_path, p)}.
          select {|p| File.directory?(p)}.
          each {|path| append_path(path)}
      end

    end

    def enable_compressors
      Alvedon.environment.js_compressor = Alvedon::Compressor::JS.new
      Alvedon.environment.css_compressor = Alvedon::Compressor::CSS.new
    end

    def disable_compressors
      Alvedon.environment.js_compressor = nil
      Alvedon.environment.css_compressor = nil
    end

  end
end