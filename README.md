RustKit
=======

A community-made library explorer for crates.io, the [rust](https://github.com/rust-lang/rust) package manager.

## Built on top of:
 - [RethinkDB](http://rethinkdb.com/)
 - [Sinatra](http://www.sinatrarb.com/)

Note: Library Developers
-----
Want to add a tag, or track your library under Rust Kit? We've made it easy for you. All you need to do is make a Pull Request
with your changes to [/helpers/yml/tags.yml](https://github.com/rgawdzik/rustkit/blob/master/helpers/yml/tags.yml).
This file is checked during a ```rake db:seed```; we automatically update our db tags and even add the repo (if it's missing) with it.
Setup
-----
1. Install the gems with ```bundle install --without test``` (Until we have Unit Tests)
2. View all available rake commands with ```rake -T```
3. Make a config.rb file. Add the following to it:
```
RDB_CONFIG = {
  host:    ENV['RDB_HOST'] || 'localhost',
  port:    ENV['RDB_PORT'] || 28015,
  db:      ENV['RDB_DB']   || 'rustkit_db'
}

KEYS = {
  client_id:     '<YOUR GITHUB APP CLIENT ID>',
  client_secret: '<YOUR GITHUB APP SECRET>'
}

CONSTANTS = {
  per_page: 100
}
```
4. Run ```rake db:seed``` to seed the database with repos, tags, etc.
5. Run the server with ```shotgun```

### With much thanks to:

 - [oren/sinatra-template](https://github.com/oren/sinatra-template)
