require 'fileutils'

module Alvedon

  def self.project_file
    file = File.join(Alvedon.root, 'alvedon')
    unless File.exists?("#{file}.rb")
      abort "Sorry, no project file found. Aborting.."
    end
    file
  end

  class << self
    
    def project &block
      @project = Project.new &block
    end

    def get_project
      @project if @project
    end

  end

  class Project

    attr_reader :asset_dir
    attr_reader :apps

    def initialize &block
      @apps = Hash.new

      instance_eval &block
    end

    def app id, &block
      app = App.new &block
      @apps[id] = app
    end

  end

  class App

    attr_reader :sources

    def initialize &block
      @sources = []
      instance_eval &block
    end

    def source source, options = {}
      @sources.push Source.new(source, options)
    end

    def find_source path
      @sources.find {|s| s.path == path }
    end

    def match_source file
      @sources.select { |s| File.dirname(file).match(File.dirname(s.path.to_s)) }.size > 0
    end

  end

  class Source

    attr_reader :path
    attr_reader :options

    def initialize path, options = {}
      @path = File.join(Alvedon.root, path)
      @options = options
    end

  end

end