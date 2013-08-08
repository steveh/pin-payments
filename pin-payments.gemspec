# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'pin-payments'
  s.version     = '2.0'
  s.date        = '2013-08-08'
  s.summary     = "Pin Payments API wrapper"
  s.description = "A wrapper for the Pin Payments (https://pin.net.au/) API"
  s.authors     = ["Alex Ghiculescu", "Steve Hoeksema"]
  s.email       = 'steve@thefold.co.nz'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.licenses    = ["MIT"]
  s.homepage    = 'https://github.com/steveh/pin-payments'

  s.add_dependency "faraday"
  s.add_dependency "faraday_middleware"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "webmock"
  s.add_development_dependency "rake"
  s.add_development_dependency "activesupport"
end
