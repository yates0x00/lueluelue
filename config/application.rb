require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MassInfo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    #require_relative "log4r"
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_support.key_generator_hash_digest_class = OpenSSL::Digest::SHA1
    config.active_job.queue_adapter = :delayed_job
    config.hosts << "localhost"
    config.hosts << "showmethemoneymanymanymoney.happysky6.com"

  end
end
