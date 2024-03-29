require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StarterTemplate
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework :test_unit, fixture: false
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.action_view.form_with_generates_remote_forms = false

    config.action_view.automatically_disable_submit_tag = true

    config.active_job.queue_adapter = :sidekiq

    # add this to make devise registration work
    config.paths['app/views'] << "app/views/devise"

    # autoload services folder
    config.autoload_paths += %W(#{config.root}/app/services)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
