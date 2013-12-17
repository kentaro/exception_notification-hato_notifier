# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exception_notifier/hato_notifier/version'

Gem::Specification.new do |spec|
  spec.name          = 'exception_notification-hato'
  spec.version       = ExceptionNotifier::HatoNotifier::VERSION
  spec.authors       = ['Kentaro Kuribayashi']
  spec.email         = ['kentarok@gmail.com']
  spec.description   = %q{Custom notifier for ExceptionNotification to send notification via Hato}
  spec.summary       = %q{Custom notifier for ExceptionNotification to send notification via Hato}
  spec.homepage      = 'https://github.com/kentaro/exception_notification-hato'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'webmock'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
