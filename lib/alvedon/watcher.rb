require 'listen'

module Alvedon

  def self.watcher 
    @watcher ||= Alvedon::Watcher.new
  end

  class Watcher
    
    def listen(*apps)
      
      Alvedon.builder.compile(*apps)
      
      # TODO: only listen to current app files
      paths = Alvedon.environment.paths
      Listen.to(*paths) { Alvedon.builder.compile(*apps) }
    end
  
  end

end