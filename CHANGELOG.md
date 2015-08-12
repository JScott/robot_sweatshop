# Change Log
All notable changes to this project will be documented in this file as specified by [http://keepachangelog.com/](http://keepachangelog.com/). This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased] - unreleased

## [1.0.1] - 2015-08-12
### Changed
- More documentation around Sweatshop Gears

### Added
- Dependency on `sweatshop_gears`

### Removed
- `sweatshop gears` got confusing and complex, use `sweatshop-gears` instead which is guaranteed to be there now

## [1.0.0] - 2015-08-10
### Added
- Multiple worker support

### Changed
- `sweatshop configure` takes a `--user` flag instead of looking for string arguments
- `sweatshop config` renamed `sweatshop configure`
- `sweatshop job` renamed `sweatshop plan`

## [0.4.13] - 2015-07-31
### Added
- Logging over ZMQ
- The Logger process to write files and reflect messages

## [0.4.12] - 2015-07-14
### Fixed
- Config erroring out if you don't have a home path

## [0.4.10] - 2015-07-13
### Added
- Started using a change log

### Removed
- `sweatshop config system` for convention over configuration

### Changed
- Input server being transformed into the API server

### Fixed
- Front-end hitting the the API server instead of always `localhost`

[0.4.9 and previous]: https://github.com/jscott/robot_sweatshop/compare/0.1.0...0.4.9
