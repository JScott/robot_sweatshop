# Platter

Jenkins is getting more and more obtuse as I try to integrate it into our flow so I'm creating a server to give it a hand.

# Paths

## /

This README!

## /:tool/payload-for/:job

Git hosts like Bitbucket and Github both have a hook for POSTing on push. The payload has a lot of relevant data in it which should be used in the Jenkins build but Jenkins relies on questionable plugins to read it. I could create a better plugin I guess but frankly I'd rather not.

POST to this instead and Platter will wrap up the appropriate data and pass it to a paramaterized build via URL.

Currently supported tools:
- bitbucket
