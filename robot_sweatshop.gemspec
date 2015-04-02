Gem::Specification.new do |gem|
  gem.name        = 'robot_sweatshop'
  gem.version     = '0.1.6'
  gem.licenses    = 'MIT'
  gem.authors     = ['Justin Scott']
  gem.email       = 'jvscott@gmail.com'
  gem.homepage    = 'http://www.github.com/jscott/robot_sweatshop/'
  gem.summary     = 'Robot Sweatshop'
  gem.description = 'A lightweight, unopinionated CI server.'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- kintama/**/*`.split("\n")
  gem.executables   = `git ls-files -- bin/sweatshop`.split("\n").map { |f| File.basename(f) }

  gem.required_ruby_version = '>= 2.1'

  gem.add_runtime_dependency 'sinatra', '~> 1'
  gem.add_runtime_dependency 'ezmq', '~> 0.4'
  gem.add_runtime_dependency 'faker', '~> 1'
  gem.add_runtime_dependency 'commander', '~> 4'
  gem.add_runtime_dependency 'eye', '~> 0.6'
  gem.add_runtime_dependency 'colorize', '~> 0.7'
  gem.add_runtime_dependency 'configatron', '~> 4'
  gem.add_runtime_dependency 'moneta', '~> 0.8'

  gem.add_development_dependency 'rake', '~> 10'
  gem.add_development_dependency 'kintama', '~> 0.1'
  gem.add_development_dependency 'http', '~> 0.7'
end
