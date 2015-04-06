# Robot Sweatshop

[Jenkins](http://jenkins-ci.org/) is horrible to maintain and is problematic when automating installation and configuration. [Drone](https://drone.io/) assumes that you use Docker. [Travis-CI](https://travis-ci.org/recent) is difficult to self-host. All of these frameworks are highly opinionated in one way or another, forcing you to do things _their_ way.

Robot Sweatshop is a single-purpose CI server that runs collections of arbitrary scripts when it needs to, usually when new code is pushed. There's no assumptions about what you want to report, what front-end you need, or even what repositories you want to clone because you can do that better than I can. It's just you, your code, and the scripts that test and deploy it.

# Usage

First install [ZMQ as described in the EZMQ gem](https://github.com/colstrom/ezmq). Then `gem install robot_sweatshop`.

You can now use `sweatshop config` to configure the processes, `sweatshop setup` to ensure the directories in your config exist, and `sweatshop start` to run everything.

Robot Sweatshop uses [Eye](https://github.com/kostya/eye) to handle its processes so you can use its commandline tool to monitor their status.

After configuring a job, POST a payload to `localhost:8080/:format/payload-for/:job`. For example, triggering a Bitbucket Git POST hook on `localhost:8080/bitbucket/payload-for/example` will parse the payload and run the 'example' job with the payload data in the environment.

You can see what jobs are available with `sweatshop job --list`.

Currently supported formats:

- Github (application/json format only)
- Bitbucket

# Configuration

The server isn't much help without a job to run. Run `sweatshop job <name>` to create a new job or edit an existing one.

Not sure if your job is valid? Run `sweatshop job --inspection <name>` to see if there's something you overlooked.

# Security

You probably don't want to run Robot Sweatshop as a sudo user. Create a testing user and group and point to them in the configuration file to run Robot Sweatshop processes with those permissions.

# Roadmap

- CLI job running
- custom/empty payloads
- Common scrips such as git repo syncing and creating a job run ID
- Support for multiple workers
- Better logging for the processes
- Use [eye-http](https://github.com/kostya/eye-http) for the '/' route?
- Improved architecture:

![Improved architecture diagram](http://40.media.tumblr.com/8a5b6ca59c0d93c4ce6fc6b733932a5f/tumblr_nko478zp9N1qh941oo1_1280.jpg)
