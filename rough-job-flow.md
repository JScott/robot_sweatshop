# *-in

-> queue-manager

- job name
- format
- raw payload

# queue-manager

-> parser

- format
- raw payload

# parser

-> overseer

- payload hash

# queue-manager

-> (moneta queue)

- payload hash
- job name
- job scripts
- job environment

# worker

grabs from moneta queue atomically
