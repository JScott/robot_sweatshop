While not a usable role straight out of the box, this should give an in-depth idea on how to set up and configure mci.

Assumptions and context:
- log_root: /var/log
- runtime_root: /var/run
- You're using monit to handle processes
- You're essentially installing ruby2.1 and ruby2.1-dev from brightbox in meta/main.yaml
- You have beaver configured to pass your logs around

There's a lot of text but it's all fairly simple concepts.
