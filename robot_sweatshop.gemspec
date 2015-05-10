Gem::Specification.new do |gem|
  gem.name        = 'robot_sweatshop'
  gem.version     = '0.3.1'
  gem.licenses    = 'MIT'
  gem.authors     = ['Justin Scott']
  gem.email       = 'jvscott@gmail.com'
  gem.homepage    = 'http://www.github.com/jscott/robot_sweatshop/'
  gem.summary     = 'Robot Sweatshop'
  gem.description = 'A lightweight, unopinionated CI server.'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- test/**/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 2.1'

  gem.add_runtime_dependency 'bundler'
  gem.add_runtime_dependency 'faker'
  gem.add_runtime_dependency 'commander'
  gem.add_runtime_dependency 'eye'
  gem.add_runtime_dependency 'colorize' # TODO: replace with rainbow
  gem.add_runtime_dependency 'configatron'
  gem.add_runtime_dependency 'moneta'
  gem.add_runtime_dependency 'contracts'
  gem.add_runtime_dependency 'sinatra'
  gem.add_runtime_dependency 'thin'
  gem.add_runtime_dependency 'ezmq'
  gem.add_runtime_dependency 'stubborn_queue'
  gem.add_runtime_dependency 'oj'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'kintama'
  gem.add_development_dependency 'http'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-byebug'
  gem.add_development_dependency 'simplecov'
end
