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

      # no app specified, get all
      if apps.size == 0
        project.apps.each do |key, app|
          @apps.push app
        end
      end

      # get specified apps
      apps.each do |app_name|
        if app = project.apps[app_name.to_sym]
          @apps.push app
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

    # find app for changed file and compile
    def build(file)
      @apps.select { |a| a.match_source(file) }.each do |app|
        puts "Change: #{Pathname(file).relative_path_from(Alvedon.root)}"
        Alvedon.builder.compile_app app
      end
    end
  
  end

end