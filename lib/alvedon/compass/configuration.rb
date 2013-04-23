module Alvedon
  module Compass

    def self.configuration
      @configuration ||= Alvedon::Compass::Configuration.new
    end

    class Configuration

      # TODO: add more attrs
      attr_accessor :images_dir, :javascripts_dir, :fonts_dir

      def initialize *args
        # defaults
        @images_dir = 'images'
        @javascripts_dir = 'javascripts'
        @fonts_dir = 'fonts'
      end

      def register
        hash = Hash.new
        hash[:images_dir] = @images_dir
        hash[:javascripts_dir] = @javascripts_dir
        hash[:fonts_dir] = @fonts_dir
        ::Compass.add_configuration hash, 'Alvedon'
      end
    end
  end
end