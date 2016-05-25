# Exception Notification for Pushbullet

[![Build Status](https://travis-ci.org/y-yagi/exception_notification-pushbullet.svg?branch=master)](https://travis-ci.org/y-yagi/exception_notification-pushbullet)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exception_notification-pushbullet'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exception_notification-pushbullet

## Usage

```ruby
# config/environments/production.rb
Rails.application.configure do
  config.middleware.use ExceptionNotification::Rack,
    pushbullet: {
      users: [{
        api_token: 'xxx',
        device_idens: %w(yyy)
      }]
    }
end
```
### Options

#### users

*Array, required*

Users to send notifications.

`users` includes the following options.

##### api_token

*String, required*

Access token for Pushbullet API.

Check [Pushbullet API](https://docs.pushbullet.com/#pushbullet-api) for details.

##### device_idens

*Array, default: All devices*

ID of devices to send notifications.  Default is send to all devices registered in user.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/y-yagi/exception_notification-pushbullet. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

