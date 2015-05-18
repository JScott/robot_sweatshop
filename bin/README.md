# Services

sweatshop-conveyor
```
{ method:, data: }

id = enqueue(item)
id = dequeue
item = lookup(id)
something = finish(id)
```

sweatshop-payload-parser
```
req: { payload:, user_agent: }
rep: { data:, error: }
```

sweatshop-job-dictionary
```
req: { job_name: }
rep: { data:, error: }
```
