# Robot Sweatshop

_TODO_

I was using Jenkins as a glorified script runner, as I'm sure a lot of people are.
I just want to run scripts on code that I push.
I don't need my CI to assume what repos I use, how I record results, or how to contact people.
I certainly don't need it to run on a JVM, have a messy plugin system, or run within virtualization.

MCI is just a barebones, script-based CI server that runs from configuration files.
It works exceptionally well in conjunction with other single-purpose tools.

# Usage

Robot Sweatshop uses Eye to handle its services. To just get things running, `bundle install` and run `eye load robot_sweatshop.production.eye`.

# Configuration

The server isn't much help without a job to run. Run `sweatshop job <name>` to create a new job or edit an existing one.

_TODO_

Job structure is...

Then hook into `url.com/:tool/payload-for/:job`. For example, `url.com/bitbucket/payload-for/selenium-tests`.

Also configuration of server variables such as port.

Currently supported tools:
- bitbucket

# Security

_TODO_

Run as another user (uid/gid in eye)

# Roadmap

- Proper gem distribution
- CLI job running
- Set up the Payload Parser as an independent service to streamline data flow
- Common scrips such as git repo syncing
- Support multiple workers
- Better logging for the processes
- CLI job linting
