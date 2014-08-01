RustKit
=======

A community-made library explorer for crates.io, the [rust](https://github.com/rust-lang/rust) package manager.

## Built on top of:
 - [RethinkDB](http://rethinkdb.com/)
 - [Sinatra](http://www.sinatrarb.com/)

Setup
-----
0. [Install the QT Framework for Tests](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit)
1. Install the gems with ```bundle install --without production staging```
2. View all available rake commands with ```rake -T```
3. Make a config.rb file. Add the following to it:
```
RDB_CONFIG = {
  :host => ENV['RDB_HOST'] || 'localhost',
  :port => ENV['RDB_PORT'] || 28015,
  :db   => ENV['RDB_DB']   || 'rustkit_db'
}

KEYS = {
  :GithubToken => '<YOUR GITHUB ACCESS TOKEN>'
}
```
4. Run the server with ```shotgun```

### With much thanks to:

 - [oren/sinatra-template](https://github.com/oren/sinatra-template)
