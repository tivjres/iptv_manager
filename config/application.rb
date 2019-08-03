require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module IptvManager
  class Application < Rails::Application
    config.load_defaults 5.2
    Dotenv.load(".env_files/.#{Rails.env}.env")
    config.active_record.schema_format = :sql
    config.autoload_paths << Rails.root.join('lib')

    config.generators do |g|
      g.orm                 :active_record
      g.template_engine     :haml
      g.javascript_engine   :js
      g.scaffold_stylesheet false
    end
  end
end
