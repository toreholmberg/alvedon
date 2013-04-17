require 'alvedon/cli'
require 'alvedon/dsl'
require 'alvedon/builder'
require 'alvedon/watcher'
require 'alvedon/version'
require 'alvedon/sprockets/environment'

module Alvedon

  def self.root
    @root ||= Pathname('.').expand_path
  end

  def self.asset_path
    @asset_path ||= File.join(root, 'assets')
  end

end


# TODO: load config
# require "#{root}/alvedon"

# Alvedon.project :project1 do

#   asset_dir = 'assets'

#   app :app1 do
#     source 'javascript/app1.coffee'
#     target 'build/javascript'
#   end

#   app :app2 do
#     source 'javascript/app2.coffee'
#     target 'build/javascript'
#   end

# end

# TODO: add frameworks and engines/post processors

# if gem_available?('susy')
#   require 'susy'
#   puts "Found Susy"
# end

# if gem_available?('compass')
#   require 'compass'
#   puts "Found compass"
# end

# def gem_available?(name)
#   Gem::Specification.find_by_name(name)
# rescue Gem::LoadError
#   false
# rescue
#   Gem.available?(name)
# end

# TODO: add compressors

# if compress
#   require 'uglifier'
#   require 'yui/compressor'
#   Alvedon.environment.js_compressor = Uglifier.new :mangle => true
#   Alvedon.environment.css_compressor = YUI::CssCompressor.new
# end