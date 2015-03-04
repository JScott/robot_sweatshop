Gem::Specification.new do |gem|
  gem.name        = 'robot_sweatshop'
  gem.version     = '0.1.0'
  gem.licenses    = 'MIT'
  gem.authors     = ['Justin Scott']
  gem.email       = 'jvscott@gmail.com'
  gem.homepage    = 'http://jscott.github.io/robot_sweatshop/'
  gem.summary     = 'Robot Sweatshop'
  gem.description = 'A lightweight, unopinionated CI server.'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- kintama/**/*`.split("\n")
  gem.executables   = `git ls-files -- bin/sweatshop`.split("\n").map { |f| File.basename(f) }

  gem.add_runtime_dependency 'sinatra'
  gem.add_runtime_dependency 'ezmq'
  gem.add_runtime_dependency 'faker'
  gem.add_runtime_dependency 'commander'
  gem.add_runtime_dependency 'eye'
  gem.add_runtime_dependency 'colorize'
  gem.add_runtime_dependency 'configurator'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'kintama'
  gem.add_development_dependency 'http'
end
