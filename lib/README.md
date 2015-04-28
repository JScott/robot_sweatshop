Job lifecycle:

```
in-* -> payloads { payload:, user_agent:, job_name: } ->
job-assembler -> jobs { context:, commands:, job_name: } ->
job-worker
```

All passing done via the moneta core in queue/*

Also queue/watcher for debugging

---

The Job Assembler also uses the Payload Parser service:

```
{ payload:, user_agent: } -> payload-parser -> { payload:, error: }
```

Error is an empty string when it's successful. Otherwise it details what went wrong.
