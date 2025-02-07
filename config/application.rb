require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Caodoo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Beijing'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.available_locales = [:"zh-CN"]
    config.i18n.default_locale = :"zh-CN"

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')

    redis_config = YAML.load(File.open(Rails.root.join("config/redis.yml"))).deep_symbolize_keys[Rails.env.to_sym]
    redis_config = {host: '127.0.0.1',  port: 6379, db: 0, expires_in: 120.minutes}.merge(redis_config)
    config.cache_store = :redis_store, redis_config
    
    cdn_config = YAML.load(File.open(Rails.root.join("config/cdn.yml"))).deep_symbolize_keys
    config.x.aws_s3_bucket = cdn_config[:aws][:s3][:bucket]

    config.action_controller.asset_host = Proc.new { |source|
      if (source.include?('images/products/') || source.include?('images/brands/')) && !source.include?('development')
        hosts = cdn_config[:cdn][:hosts]
        hosts[Digest::MD5.hexdigest(source).to_i(16) % 2 % hosts.length]
      end
    }
  end
end
