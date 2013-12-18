services = {
  'ExampleApp' => %w[example_app_team],
}

Hato::Config.define do
  api_key 'example'
  host    '0.0.0.0'
  port    9699

  # ExampleApp::Exception will be sent to #example_app_team channel via Ikachan
  tag /^exception\.([^.:]+)/ do |service|
    if channel = services[service]
      plugin 'Ikachan' do
        host    'ikachan.example.com'
        port    4979
        channel channel
      end
    end
  end
end
