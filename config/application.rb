require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsTodo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # NOTE: Rails7.1
    config.add_autoload_paths_to_load_path = false

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    #
    # Debug: Disable SSL / HSTS
    if Rails.env.test?
      OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
      config.force_ssl = false
      config.ssl_options = { hsts: false }
      config.action_dispatch.default_headers.delete('Strict-Transport-Security')
    end
  end
end
