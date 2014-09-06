Rust Kit [![Build Status](https://travis-ci.org/rgawdzik/rustkit.svg?branch=master)](https://travis-ci.org/rgawdzik/rustkit)
=======

A community-made library explorer for the [Rust](https://github.com/rust-lang/rust) programming language.

## Core Technologies:
 - [RethinkDB](http://rethinkdb.com/)
 - [Sinatra](http://www.sinatrarb.com/)

Note for Library Developers
-----
Want to add a tag, or track your library under Rust Kit? We've made it easy for you. All you need to do is make a Pull Request
with your changes to [/helpers/yml/tags.yml](https://github.com/rgawdzik/rustkit/blob/master/helpers/yml/tags.yml).
This file is checked during a ```rake db:seed```; we automatically update our db tags and even add the repo (if it's missing) with it.

Want us to automatically track your library so you don't need to do a Pull Request? Add the keyword 'library' into the title, description, or README of your project.

Was your project's last commit date older than 6 months? We automatically assume any inactive library does not function properly under Rust nightly. You can explicitly add it with the above instructions if it's not the case.

Setup
-----
1. Make sure to have at least Ruby 2.0.0. We recommend to use [rbenv](https://github.com/sstephenson/rbenv) as your enviroment.
2. Install bundler with ```gem install bundler```
3. Install the gems with ```bundle install --without test``` (Until we have Unit Tests). You can view all our rake commands with ```rake -T```
4. Make a ```config.rb``` file on the root of the project. Below the instructions you will find the contents of ```config.rb```.
5. Run ```rake db:seed``` to seed the database with repos, tags, etc.
6. Run the development server with ```shotgun``` You can now access the server at ```127.0.0.1:9393```.
7. [production] Run ```whenever --update-crontab``` to add a database seed cronjob to your server.

```
#config.rb
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

### With much thanks to:

 - [oren/sinatra-template](https://github.com/oren/sinatra-template)
