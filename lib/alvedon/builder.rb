require 'pathname'
require 'fileutils'

module Alvedon

  def self.builder 
    @builder ||= Alvedon::Builder.new
  end

  class Builder

    def compile(*apps)
      project = Alvedon.get_project

      # no app specified, run all
      if apps.size == 0
        project.apps.each do |key, app|
          compile_app app
        end
        return
      end

      # run specified apps
      apps.each do |app_name|
        if app = project.apps[app_name.to_sym]
          compile_app app
        else
          puts "Sorry, app \"#{app_name}\" not found in project file."
        end
      end
    end

    def compile_app(app)

      # compress option
      if app.get_options[:compress]
        Alvedon.environment.enable_compressors
      else
        Alvedon.environment.disable_compressors
      end

      Alvedon.environment.each_logical_path do |logical_path|
        begin
          resolved = Alvedon.environment.resolve(logical_path).to_s
          if source = app.find_source(resolved) and asset = Alvedon.environment.find_asset(logical_path)
            target = Pathname(source.options[:target] || app.get_options[:target])
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
  end

end