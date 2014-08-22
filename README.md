# mci

I was Jenkins as a glorified script runner, as I'm sure a lot of people are.
I don't need a JVM or generalized plugins to do this, I just want to run scripts on code that I push.
That's what this is: a minimal CI server from the command line.

# use

Setup:
 - Configure your server by creating jobs and modifying config.yaml to your preference
 - Run the worker script via `./worker.rb`
 - Run the publisher via `./server.rb`

Then hook into `url.com/:tool/payload-for/:job`. For example, `url.com/bitbucket/payload-for/selenium-tests`.

Currently supported tools:
- bitbucket

# security

Sandbox your process.

```
useradd --home /opt/minimal-ci ci-bot
su ci-bot -c "./worker.rb"
su ci-bot -c "./server.rb"
```

Add SSH keys as appropriate.

# roadmap

- Replace Sidekiq with rabbitmq and either the rcelery or amqp gems
- Document support for slaving off script running
- Reload scripts without restarting the server
