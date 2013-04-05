require 'pathname'
require 'fileutils'
require 'sprockets'
require 'sprockets/commonjs'
require 'coffee_script'
require 'sass'

require_relative 'alvedon/cli'

module Alvedon
  autoload :CLI, 'catapult/cli'

  def self.root
    @root ||= Pathname(Dir.pwd).expand_path
  end

  def self.build

    target = Pathname('./build')

    #environment = Sprockets::Environment.new
    environment = Sprockets::Environment.new(root)

    require 'uglifier'
    environment.js_compressor = Uglifier.new :mangle => true

    require 'yui/compressor'
    environment.css_compressor = YUI::CssCompressor.new

    #environment.append_path 'assets/stylesheets'
    #environment.append_path 'assets/javascripts'

    environment.append_path(root.join('assets', 'javascripts'))
    environment.append_path(root.join('assets', 'stylesheets'))
    environment.append_path(root.join('assets', 'images'))

    environment.append_path(root.join('vendor', 'assets', 'javascripts'))
    environment.append_path(root.join('vendor', 'assets', 'stylesheets'))

    environment.append_path(root.join('components'))


    environment.each_logical_path do |logical_path|
      begin
        if asset = environment.find_asset(logical_path)

          puts logical_path
          puts asset.inspect

          filename = target.join(logical_path)
          FileUtils.mkpath(filename.dirname)
          asset.write_to(filename)
          #puts ">> #{filename}"
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