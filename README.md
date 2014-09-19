# mci

I was using Jenkins as a glorified script runner, as I'm sure a lot of people are.
I just want to run scripts on code that I push.
I don't need my CI to assume what repos I use, how I record results, or how to contact people.
I certainly don't need it to run on a JVM, have a messy plugin system, or run within virtualization.

MCI is just a barebones, script-based CI server that runs from configuration files.
It works exceptionally well in conjunction with other single-purpose tools.

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
