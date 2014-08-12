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
useradd --home /opt/lazyjenkins lazyjenkins
su lazyjenkins -c "./server.rb"
```

# roadmap

v1.0
- Create the idea of multiple jobs using various scripts
- Pass the payload to the scripts

v1.1
- Manually kick off a special script flow with custom parameters

v?.0
- Support for slaving off script running
