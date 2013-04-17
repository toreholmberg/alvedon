require 'listen'

module Alvedon

  def self.watcher 
    @watcher ||= Alvedon::Watcher.new
  end

  class Watcher
    
    def start(*assets, target, compress)
      Alvedon.builder.compile(assets, target, compress)
      paths = Alvedon.environment.paths
      Listen.to(*paths) { Alvedon.builder.compile(assets, target, compress) }
    end
  
  end

end