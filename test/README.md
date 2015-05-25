You can run individual `_spec.rb` files with Ruby or `run_all.rb` to go through each.

Because I'm lazy, TestProcess::Stub uses the UNIX `lsof` to check if ports are in use. There's probably a better, more portable way to do this.
