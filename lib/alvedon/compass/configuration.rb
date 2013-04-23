module Alvedon
  module Compass

    def self.configuration
      @configuration ||= Alvedon::Compass::Configuration.new
    end

    class Configuration

      # TODO: add more attrs
      attr_accessor :images_dir, :javascripts_dir, :fonts_dir, :line_comments

      def initialize *args
        # defaults
        @images_dir = 'images'
        @javascripts_dir = 'javascripts'
        @fonts_dir = 'fonts'
        @line_comments = true
      end

      def register
        config = Hash.new
        instance_variables.each do |var|
          config[var.to_s.gsub(/[@]/, '')] = instance_variable_get var
        end
        ::Compass.add_configuration config, 'Alvedon'
      end
    end
  end
end