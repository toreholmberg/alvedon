require 'listen'

module Alvedon

  def self.watcher 
    @watcher ||= Alvedon::Watcher.new
  end

  class Watcher
    
    def listen(*apps)
      
      # first, compile like normal
      Alvedon.builder.compile(*apps)

      puts "Watching..."

      # get involved apps
      project = Alvedon.get_project

      @apps = []
      @sources = []

      # no app specified, get all
      if apps.size == 0
        project.apps.each do |key, app|
          @apps.push app
          @sources |= app.sources
        end
      end

      # get specified apps
      apps.each do |app_name|
        if app = project.apps[app_name.to_sym]
          @apps.push app
          @sources |= app.sources
        end
      end
      
      # get paths and filters from sprockets env
      paths = Alvedon.environment.paths.select { |p| p.match(Alvedon.root.to_s) }
      filters = Alvedon.environment.extensions.map { |e| /#{Regexp.quote(e)}$/ }

      # listener callback
      callback = Proc.new do |modified, added, removed|
        file = (modified + added + removed).first()
        build(file)
      end

      # start listener
      Listen.to(*paths)
        .filter(*filters)
        .change(&callback)
        .start
    end

    private

    # find app for changed file and compile app
    def build(file)
      
      puts "Change: #{Pathname(file).relative_path_from(Alvedon.root)}"

      # for sprockets requires, find out if changed file is a source or source dependency and compile

      # TODO: implement dependency lookup for SASS imports
      
      dependency_found = false

      @sources.each do |source|
        if asset = Alvedon.environment[source.path.to_s] and ([asset] + asset.dependencies).select { |a| a.pathname.to_s == file }.size > 0
          Alvedon.builder.compile_source(source)
          dependency_found = true
        end
      end
      
      # for non sprockets imports, run if dependency isn't found and compile apps based on path

      unless dependency_found
        @apps.select { |a| a.match_source(file) }.each do |app|
           Alvedon.builder.compile_app app
        end
      end

    end
  
  end

end