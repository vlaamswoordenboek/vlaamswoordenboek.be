# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'production'

require 'RedCloth'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # See Rails::Configuration for more options

  # TODO: put in secrets
  config.action_controller.session = { :key => "_vlaamswoordenboek_session", :secret => "31fc6aae-0cc5-42d6-b88f-1ca8672134f5" }
end

# Add new inflection rules using the following format
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below

# require 'acts_as_ferret'

module ActionView #nodoc
  module Helpers
    module ActiveRecordHelper
      def error_messages_for(object_name, options = {})
        options = options.symbolize_keys
        object = instance_variable_get("@#{object_name}")
        unless object.errors.empty?
          content_tag("div",
            content_tag(
              options[:header_tag] || "h2",
              "Onvolledig formulier"
            ) +
            content_tag("p", "Het formulier is onvolledig ingevuld:") +
            content_tag("ul", object.errors.full_messages.collect { |msg| content_tag("li", msg) }),
            "id" => options[:id] || "errorExplanation", "class" => options[:class] || "errorExplanation"
          )
        end
      end
    end
  end
end
