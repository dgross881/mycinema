Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = false
  config.assets.js_compressor = :uglifier

  config.assets.compile = true 
  config.assets.digest = true
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { host: 'myflixcinema.herokuapp.com' }
  ActionMailer::Base.smtp_settings = {
  :port           => ENV['MAILGUN_SMTP_PORT'],
  :address        => ENV['MAILGUN_SMTP_SERVER'],
  :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
  :password       => ENV['MAILGUN_SMTP_PASSWORD'],
  :domain         => 'myflixcinema.herokuapp.com',
  :authentication => :plain,
  }
  
  config.active_record.dump_schema_after_migration = false
  config.serve_static_assets = true
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  config.assets.compile = true
  config.assets.compress = true
end
