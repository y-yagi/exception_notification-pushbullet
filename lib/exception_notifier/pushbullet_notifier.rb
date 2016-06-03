require 'exception_notification/pushbullet/version'
require 'pushbullet'

module ExceptionNotifier
  class PushbulletNotifier
    attr_reader :users

    def initialize(options)
      @users = options[:users]
      raise(ArgumentError, 'Users must be specified') unless @users
      users.each do |user|
        raise(ArgumentError, 'api_token must be specified') unless user[:api_token]

        Pushbullet.api_token = user[:api_token]
        user[:device_idens] = Pushbullet::Device.all.map(&:iden) unless user[:device_idens]
      end

      Pushbullet.api_token = nil
      @title = options[:title]
    end

    def call(exception, options = {})
      @users.each do |user|
        Pushbullet.api_token = user[:api_token]
        user[:device_idens].each do |device_iden|
          Pushbullet::Push.create_note(device_iden, title, body(exception))
        end
      end

      Pushbullet.api_token = nil
    end

    def title
      if @title
        @title
      elsif app && environment
        "New exception occurred in #{app}(#{environment})."
      else
        'New exception occurred.'
      end
    end

    def body(exception)
      body = "'#{exception.message}'"
      body += " on '#{exception.backtrace.first}'" if exception.backtrace
      body
    end

    def app
      Rails.application.class.parent_name if defined?(Rails.application)
    end

    def environment
      Rails.env if defined?(Rails.env)
    end
  end
end
