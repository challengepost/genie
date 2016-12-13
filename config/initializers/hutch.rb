Figleaf::Settings.hutch.each_pair do |key, value|
  Hutch::Config.set(key.to_sym, value)
end

if Rails.env.development?
  Hutch::Logging.setup_logger(Rails.root.join('log', 'hutch.log'))

  Dir["#{Rails.root}/app/consumers/*_consumer.rb"].each { |file| load file }
else
  Hutch::Config.error_handlers << Hutch::ErrorHandlers::Honeybadger.new
end
