Alvedon.project do

  config :compass do |config|
    config.images_dir = 'build/images'
    config.javascripts_dir = 'build/javascripts'
    config.fonts_dir = 'build/fonts'
  end

  app :js do
    source 'assets/javascripts/application.coffee', :target => 'build/javascripts'
  end

  app :css do
    source 'assets/stylesheets/styles.scss', :target => 'build/stylesheets'
  end

end