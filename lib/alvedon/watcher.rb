require 'listen'

module Alvedon

  def self.watcher 
    @watcher ||= Alvedon::Watcher.new
  end

  class Watcher
    
    def listen(*apps)
      Alvedon.builder.compile(*apps)
      paths = Alvedon.environment.paths.select { |p| p.match(Alvedon.root.to_s) }
      Listen.to(*paths) { Alvedon.builder.compile(*apps) }
    end
  
  end

end