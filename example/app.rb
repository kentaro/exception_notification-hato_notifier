require 'sinatra/base'
require 'exception_notification'
require 'exception_notifier/hato_notifier'

class ExampleApp < Sinatra::Base
  use ExceptionNotification::Rack,
    hato: {
      host:    'localhost',
      port:    9699,
      api_key: 'example',
      template: {
        tag:     ->(exception, options) { "exception.#{exception.class}" },
        message: ->(exception, options) { "Exception: #{exception.class}: #{exception.message}" },
      },
    }

  class Exception < ::Exception; end

  get '/' do
    raise Exception.new('Example exception')
  end
end
