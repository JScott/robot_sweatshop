You can run individual `_spec.rb` files with Ruby or `all.rb` to go through each. There's no way to run everything together with the way processes are set up but this hasn't been a problem so far.

Because I'm lazy, TestProcess::Stub uses the UNIX `lsof` to check if ports are in use. There's probably a better, more portable way to do this.
