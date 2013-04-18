require 'pathname'
require 'fileutils'

module Alvedon

  def self.builder 
    @builder ||= Alvedon::Builder.new
  end

  class Builder

    def compile(*assets, target, compress)
      
      Alvedon.environment.each_logical_path(assets) do |logical_path|
        begin
          if asset = Alvedon.environment.find_asset(logical_path) and asset.pathname.to_s.match(Alvedon.asset_path)
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

    def compile_app app_name

      app = Alvedon.get_project.apps[app_name.to_sym]

      unless app
        puts "Sorry, app \"#{app_name}\" not found in project file."
        return
      end

      sources = app.sources
      target = Pathname(app.get_target)

      Alvedon.environment.each_logical_path do |logical_path|

        if asset = Alvedon.environment.find_asset(logical_path) #and sources.include?(asset.pathname.to_s)

          filename = target.join(logical_path)

          FileUtils.mkpath(filename.dirname)

          asset.write_to(filename)

          puts "Writing: #{filename}"

        end

      end

    end

  end

end