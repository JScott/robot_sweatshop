# Robot Sweatshop

[Jenkins](http://jenkins-ci.org/) doesn't work when you have to sanely automate server installation and configuration. [Drone](https://drone.io/) doesn't work if you don't use Docker. [Travis-CI](https://travis-ci.org/recent) is difficult to self-host. All of these frameworks are highly opinionated to some extent.

Robot Sweatshop is a single-purpose CI server that runs collections of arbitrary scripts when it needs to, usually when new code is pushed. There's no assumptions about what you want to report, what front-end you need, or even what repositories you want to clone because you can do that better than I can. It's just you, your code, and the scripts that test and deploy it.

# Usage

```
gem install robot_sweatshop
sweatshop start
```

Robot Sweatshop uses Eye to handle its services and that will set up and configure everything appropriately.

After configuring a job, POST a payload to `localhost:8080/:format/payload-for/:job`. For example, triggering a Bitbucket Git POST hook on `localhost:8080/bitbucket/payload-for/example` will parse the payload and run the 'example' job with the payload data in the environment.

Currently supported formats:

- bitbucket

# Configuration

The server isn't much help without a job to run. Run `sudo -E sweatshop job <name>` to create a new job or edit an existing one.

You can also use `sudo -E sweatshop config` to create and edit a user configuration at `/etc/robot_sweatshop/config.yaml`.

# Security

_TODO: Support for running as a custom user via eye uid/gid_

# Roadmap

- Enable Github support
- CLI job running
- Common scrips such as git repo syncing
- Support for multiple workers
- Better logging for the processes
- Improved architecture:

![Improved architecture diagram](http://40.media.tumblr.com/8a5b6ca59c0d93c4ce6fc6b733932a5f/tumblr_nko478zp9N1qh941oo1_1280.jpg)
