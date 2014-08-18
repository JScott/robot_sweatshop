# mci

I was Jenkins as a glorified script runner, as I'm sure a lot of people are.
I don't need a JVM or front-end to do this, I just want to run scripts on code that I push.
That's what this is: a minimal CI server.

# use

Set up config.yml with the branches you want to watch for and the scripts you want to run on push.
Run the server and push to `url.com/:tool/payload-for/:job`. For example, `url.com/bitbucket/payload-for/selenium-tests`.

Currently supported tools:
- bitbucket

# security

Sandbox your process.

```
useradd --home /opt/minimal-ci ci-bot
su ci-bot -c "./server.rb"
```

Add SSH keys as appropriate.

# roadmap

- Fix multiple requests coming in at once with the Ruby EventMachine

- Manually kick off a special script flow with custom parameters
- Support for slaving off script running
- Reload scripts without restarting the server
