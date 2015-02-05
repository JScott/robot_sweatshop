Job lifecycle:

```
*in -> raw-payloads { payload:, format:, job_name: } ->
payload-parser -> parsed-payloads { payload:, job_name: } ->  !
job-assembler -> jobs { commands:, environment_vars: }        ...
```

All passing done via the moneta core in queue/*

Also queue/watcher for debugging
