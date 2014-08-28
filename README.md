# mci

I was using Jenkins as a glorified script runner, as I'm sure a lot of people are.
I just want to run scripts on code that I push and I don't need JVM or user interface overhead.
What I do need is a way to easily configure everything from the command line so I can deploy it with config. management tools.
So that's what you get with this: a simple, scripting-based CI server that's easily configurable from the command line.

# use

Setup:
 - Configure your server by creating jobs and modifying config.yaml to your preference
 - Run the worker script via `./worker.rb`
 - Run the publisher via `./server.rb`

Then hook into `url.com/:tool/payload-for/:job`. For example, `url.com/bitbucket/payload-for/selenium-tests`.

Currently supported tools:
- bitbucket

See ansible-role for an in-depth set up through ansible scripts.

# security

Sandbox your process.

```
useradd --home /opt/minimal-ci ci-bot
su ci-bot -c "./worker.rb"
su ci-bot -c "./server.rb"
```

Add SSH keys as appropriate.

# roadmap

- Use Logger instead of whatever crazy thing I'm trying to do
- 'empty' tool for manual kick off with no payload
- Replace Sidekiq with rabbitmq and either the rcelery or amqp gems
- Enhance support for slaving off script running
- Reload scripts without restarting the server
