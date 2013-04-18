require "sprockets"
require "sprockets-sass"
require 'sprockets-helpers'
require 'sass'

require 'sprockets/commonjs'
require 'haml_coffee_assets'

module Alvedon

  def self.environment
    @environment ||= Alvedon::Environment.new Alvedon.root
  end

  class Environment < ::Sprockets::Environment

    def initialize root

      super root

      # frameworks
      require 'compass'
      require 'susy'

      # post processors
      register_postprocessor 'application/javascript', Sprockets::CommonJS
      
      # engines
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

  end

end

