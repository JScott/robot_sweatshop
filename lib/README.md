Job lifecycle:
```
in/*
  V
  raw payload
  v
payload/parser
  v
  parsed payload
  v
job/assembler
  v
  job hash
  v
worker
```

Also moneta core in queue/*

Also also queue/watcher for debugging
