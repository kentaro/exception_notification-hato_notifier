# exception_notification-hato [![](https://travis-ci.org/kentaro/exception_notification-hato.png)](http://travis-ci.org/kentaro/exception_notification-hato)

`ExceptionNotifier::HatoNotifier` is a custom notifier for [Exception Notification](http://smartinez87.github.io/exception_notification/). It sends exception notification via [Hato](https://github.com/kentaro/hato).

## Usage

As other exception notifiers, add settings at the environments:

  * `host` is the host of Hato server
  * `port` is the port of the server (optional, default is `9699`)
  * `api_key` is to set the API key if the server requires it (optional)
  * `template` is to set templates for tag and message to be sent to Hato

### Example

```ruby
Whatever::Application.config.middleware.use ExceptionNotification::Rack,
  hato: {
    host:     'localhost',
    port:     9699,
    api_key:  'YOUR API KEY',
    template: {
        tag:     ->(exception, options) { "exception.#{exception.class}" },
        message: ->(exception, options) { "Exception: #{exception.class}: #{exception.message}" },
    },
  }
```

## Installation

Add this line to your application's Gemfile:

    gem 'exception_notification-hato'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exception_notification-hato

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
