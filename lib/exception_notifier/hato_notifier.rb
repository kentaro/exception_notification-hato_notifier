module ExceptionNotifier
  class HatoNotifier
    class ConfigurationError < Exception; end

    attr_reader :logger

    def initialize(options)
      template = options.delete(:template)
      raise ConfigurationError.new('`template` key must be set') unless template

      @tag_template     = template.delete(:tag)
      @message_template = template.delete(:message)

      if !@tag_template || !@message_template
        raise ConfigurationError.new('Both `templlate.message` and `templlate.message` keys must be set')
      end

      @logger = Logger.new(
        host:    options.delete(:host),
        port:    options.delete(:port),
        api_key: options.delete(:api_key),
      )
    end

    def call(exception, options = {})
      tag     = Query.build(@tag_template, exception, options)
      message = Query.build(@message_template, exception, options)

      logger.post(tag, message)
    end

    class Logger
      require 'uri'
      require 'net/http'

      def initialize(settings)
        @host    = settings.delete(:host)
        @port    = settings.delete(:port) || 9699
        @api_key = settings.delete(:api_key)
      end

      def post(tag, message)
        client = Net::HTTP.new(@host, @port)
        req    = Net::HTTP::Post.new('/notify')

        req.form_data = { tag: tag, message: message }
        req.form_data.merge!(api_key: api_key) if @api_key

        client.request(req)
      end
    end

    class Query
      def initialize(template, exception, options = {})
        @exception = exception
        @options   = options
        @template  = template
      end

      def build
        expand_object(@template)
      end

      def self.build(template, exception, options = {})
        self.new(template, exception, options).build
      end

      private

      def expand_object(obj)
        case obj
        when Proc
          expand_proc(obj)
        else
          obj
        end
      end

      def expand_proc(prok)
        expand_object(prok.call(@exception, @options))
      end
    end
  end
end
