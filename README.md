[![Gem Version](https://badge.fury.io/rb/robot_sweatshop.svg)](http://badge.fury.io/rb/robot_sweatshop) [![Join the chat at https://gitter.im/JScott/robot_sweatshop](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/JScott/robot_sweatshop?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# Robot Sweatshop

[Jenkins](http://jenkins-ci.org/) is horrible to maintain and is problematic when automating installation and configuration. [Drone](https://drone.io/) assumes that you use Docker. [Travis-CI](https://travis-ci.org/recent) is difficult to self-host. All of these frameworks are highly opinionated in one way or another, forcing you to do things _their_ way.

Robot Sweatshop is a single-purpose CI server that runs collections of arbitrary scripts when it needs to, usually when new code is pushed. There's no assumptions about what you want to report, what front-end you need, or even what repositories you want to clone because you can do that better than I can. It's just you, your code, and the scripts that test and deploy it.

## Quick start

- install [ZMQ as described in the EZMQ gem](https://github.com/colstrom/ezmq#operating-system-notes)
- `gem install robot_sweatshop`
- `sweatshop start`
- `sweatshop plan example --auto`
- `curl -d '' localhost:10555/run/example`
- `cat .robot_sweatshop/log/worker.log`

## Usage

Drop the `--auto` flag to create the job interactively. You can specify which branches will trigger the job, which commands will be run, and any environment variables you might need. See [the wiki](https://github.com/JScott/robot_sweatshop/wiki/Job-configuration) for more details.

Robot Sweatshop uses [Eye](https://github.com/kostya/eye) to handle its processes so you can use its commandline tool to monitor their status.

Oh yeah, and there's a front end in case you want to run and watch jobs without using a console. By default it runs on port 10554.

## The implicit job

Just like Travis-CI will look for `.travis.yml`, Robot Sweatshop will look for `.robot_sweatshop.yaml` at the end of a job and run the job within immediately after. See [the wiki](https://github.com/JScott/robot_sweatshop/wiki/Implicit-jobs) for more details on how you might utilize this.

This is useful because it allows you to have a more centralized source of truth for building and testing your code. You can set up your canonical testing definition in your repository and have it pulled down for any server that runs it.

## Configuration

By default, Robot Sweatshop looks in your current working path to configure and run. You can supply a custom configuration with `sweatshop config [local|user|system]`. See [the wiki](https://github.com/JScott/robot_sweatshop/wiki) for more information.

## Supported payload formats

- Github (application/json format only)
- Bitbucket
- JSON
- Empty

## Security

You probably don't want to run Robot Sweatshop as a sudo user. Create a testing user and group and run `sweatshop start` as them.

## Roadmap

1.0

- Mascot/logo

1.1

- Use something appropriate than TCP for ZMQ connections
- Easier way to run multiple workers
- Push/pull out node that worker streams output to
- Add worker tags to output so it can all go to one file

Beyond

- Jenkins-to-Sweatshop job converting script
- Take a look at beefcake for data versioning/serialization
- Better logging for the processes
- CLI configuration via chomp and/or flags
- Use [eye-http](https://github.com/kostya/eye-http) for the '/' route?
