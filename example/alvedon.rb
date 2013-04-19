Alvedon.project do

  app :js do
    source 'assets/javascripts/application.coffee', :target => 'build/javascripts'
  end

  app :css do
    source 'assets/stylesheets/styles.scss', :target => 'build/stylesheets'
  end

end