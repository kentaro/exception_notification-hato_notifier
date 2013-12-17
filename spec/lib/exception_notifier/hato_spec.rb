require_relative '../../spec_helper'

describe ExceptionNotifier::HatoNotifier do
  class FooException < Exception; end

  let(:exception) do
    FooException.new('bar message')
  end

  let(:notifier) do
    ExceptionNotifier::HatoNotifier.new(
      host:    'localhost',
      port:    9699,
      api_key: 'test',
      template: {
        tag:     ->(exception, options) { "exception.#{exception.class}" },
        message: ->(exception, options) { "Exception: #{exception.class}: #{exception.message}" },
      }
    )
  end

  describe '#call' do
    context 'success' do
      before do
        stub_request(:any, 'localhost').to_return(
          status: 200,
          body: %q{"status":"success","message":"Successfully sent the message you notified to me."},
        )
      end

      it 'logs valid data' do
        expect(notifier.logger).to receive(:post).with(
          'exception.FooException',
          'Exception: FooException: bar message',
        )
        notifier.call(FooException.new('bar message'))
      end
    end
  end

  describe ExceptionNotifier::HatoNotifier::Query do
    subject do
      ExceptionNotifier::HatoNotifier::Query.build(template, exception, {})
    end

    context 'with String' do
      let(:template) do
        'string'
      end

      it 'returns string without any change' do
        should == 'string'
      end
    end

    context 'with Proc' do
      let(:template) do
        ->(e, opts) { "Exception: #{e.class}: #{e.message}" }
      end

      it 'returns intended string' do
        should == 'Exception: FooException: bar message'
      end
    end
  end
end
