Job lifecycle:
```
in/*
  V
  raw payload
  v
job/assembler -> parsed payload ->  payload/parser
  v           <- raw payload    <-----
  job hash
  v
worker
```

All passing done via the moneta core in queue/*

Also queue/watcher for debugging
