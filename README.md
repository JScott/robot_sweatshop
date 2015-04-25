[![Gem Version](https://badge.fury.io/rb/robot_sweatshop.svg)](http://badge.fury.io/rb/robot_sweatshop) [![Join the chat at https://gitter.im/JScott/robot_sweatshop](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/JScott/robot_sweatshop?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# Robot Sweatshop

[Jenkins](http://jenkins-ci.org/) is horrible to maintain and is problematic when automating installation and configuration. [Drone](https://drone.io/) assumes that you use Docker. [Travis-CI](https://travis-ci.org/recent) is difficult to self-host. All of these frameworks are highly opinionated in one way or another, forcing you to do things _their_ way.

Robot Sweatshop is a single-purpose CI server that runs collections of arbitrary scripts when it needs to, usually when new code is pushed. There's no assumptions about what you want to report, what front-end you need, or even what repositories you want to clone because you can do that better than I can. It's just you, your code, and the scripts that test and deploy it.

# Quick start

- install [ZMQ as described in the EZMQ gem](https://github.com/colstrom/ezmq)
- `gem install robot_sweatshop`
- `sweatshop start` ([you may need sudo on OSX](https://github.com/JScott/robot_sweatshop/wiki))
- `sweatshop job example --auto`
- POST a Github payload to `yourserver.com:8080/github/payload-for/example`
- `cat .robot_sweatshop/log/job-worker.log`

# Usage

Drop the `--auto` flag to create the job interactively. You can specify which branches will trigger the job, which commands will be run, and any environment variables you might need.

Robot Sweatshop uses [Eye](https://github.com/kostya/eye) to handle its processes so you can use its commandline tool to monitor their status.

# Configuration

By default, Robot Sweatshop looks in your current working directory to configure and run. You can supply a custom configuration with `sweatshop config [local|user|system]`. Read [the wiki](https://github.com/JScott/robot_sweatshop/wiki) for more information.

# Supported payload formats

- Github (application/json format only)
- Bitbucket

# Security

You probably don't want to run Robot Sweatshop as a sudo user. Create a testing user and group and point to them in the configuration file to run Robot Sweatshop processes with those permissions.

# Roadmap

- Improved architecture:

![Improved architecture diagram](http://40.media.tumblr.com/8a5b6ca59c0d93c4ce6fc6b733932a5f/tumblr_nko478zp9N1qh941oo1_1280.jpg)

- Automatically detect payload format
- Support for multiple workers
- Better logging for the processes
- Common scrips such as git repo syncing and creating a job run ID
- Use [eye-http](https://github.com/kostya/eye-http) for the '/' route?
