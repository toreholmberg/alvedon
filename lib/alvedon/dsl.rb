require 'fileutils'

module Alvedon

  def self.project_file
    "#{root}/alvedon"
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

    def source source
      @sources.push File.join(Alvedon.root, source)
    end

    def target target
      @target = target
    end

    def get_target
      @target if @target
    end

  end

end