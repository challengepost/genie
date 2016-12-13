Satellite.configure do |config|

  # Required
  #
  # Configure provider and arguments for OmniAuth middleware
  ssl_options = { ca_path: "/usr/lib/ssl/certs" }
  # certificate verification removed for dev only
  ssl_options[:verify] = false if Rails.env.development?

  config.omniauth :devpost,
    Rails.application.secrets.omniauth_provider_key,
    Rails.application.secrets.omniauth_provider_secret,
    provider_ignores_state: false,
    client_options: { ssl: ssl_options }

  # Optional
  #
  # Override default Warden Configuration
  # config.warden do |warden|
  #   warden.default_strategies :satellite
  #   warden.default_scope = :satellite
  #   warden.failure_app = Satelitte::SessionsController.action(:failure)
  # end
  #
  # Set the user class serialized in session and instantiated
  # as current_satellite_user and current_user if found
  config.user_class            = User
  #
  # Set the anonymous user class instantiated as current_user
  # when no user is serialized in session
  # config.anonymous_user_class  = AnonymousUser
  #
  # Controllers will attempt to authenticate user by default
  config.enable_auto_login     = false
  #
  # Configures Omniauth.config.path_prefix
  config.path_prefix = "/teams/auth"

  # config.ssl_enabled = Figleaf::Settings.ssl.enabled?

  # config.provider_root_domain = Figleaf::Settings.domain.root

  config.env = Figleaf::Settings.env
  config.jwt_secret_key_base = Rails.application.secrets.jwt_secret_key_base
end

# ssl_enabled = Figleaf::Settings.ssl.enabled?
# root_domain = Figleaf::Settings.domain.root
# OmniAuth.config.full_host = (ssl_enabled ? URI::HTTPS : URI::HTTP).build(host: root_domain).to_s
