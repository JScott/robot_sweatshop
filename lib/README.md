Job lifecycle:

```
input -> conveyor
{ payload:, user_agent:, job_name: }

assembler <-> conveyor

assembler <-> payload-parser
{ payload:, user_agent: } <-> { payload:, error: }

assembler -> worker
{ context:, commands:, job_name:, job_id }
```

context is passed around with string keys because it's user provided
everything else is passed with symbol keys
