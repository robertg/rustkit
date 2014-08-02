require 'sinatra/base'
require 'sinatra/asset_snack'
require 'octokit'
require 'pry'
require 'rethinkdb'
require 'pry-remote'
require 'pry-stack_explorer'
require 'pry-debugger'
require 'json'

require_relative 'config'
require_relative 'routes/init'
require_relative 'helpers/init'
require_relative 'models/init'

class RustKit < Sinatra::Base
  enable :method_override
  enable :sessions
  set :session_secret, 'super secret'

  register Sinatra::AssetSnack
  asset_map '/javascript/startup.js', ['assets/coffee/app.coffee']
  asset_map '/javascript/application.js', ['assets/coffee/controllers/*.coffee', 'assets/coffee/directives/*.coffee', 'assets/coffee/filters/*.coffee']
  asset_map '/stylesheets/application.css', ['assets/scss/**/*.scss', 'assets/scss/*.scss']

  set :r, r = RethinkDB::RQL.new

  configure do
    set :app_file, __FILE__
    set :db, RDB_CONFIG[:db]
    begin
      connection = r.connect(:host => RDB_CONFIG[:host], :port => RDB_CONFIG[:port])
    rescue Exception => err
      puts "Cannot connect to RethinkDB database #{RDB_CONFIG[:host]}:#{RDB_CONFIG[:port]} (#{err.message})"
      Process.exit(1)
    end

    begin
      unless r.db_list.run(connection).include? RDB_CONFIG[:db]
        r.db_create(RDB_CONFIG[:db]).run(connection)
      end
    rescue RethinkDB::RqlRuntimeError => err
      puts "ERROR: Database `#{RDB_CONFIG[:db]}` already exists."
    end

    begin
      unless r.db(RDB_CONFIG[:db]).table_list.run(connection).include? 'libraries'
        r.db(RDB_CONFIG[:db]).table_create('libraries').run(connection)
      end
    rescue RethinkDB::RqlRuntimeError => err
      puts "ERROR: Table `libraries` already exists."
    ensure
      connection.close
    end
  end

  configure :development do
    enable :logging, :dump_errors, :raise_errors
  end

  configure :qa do
    enable :logging, :dump_errors, :raise_errors
  end

  configure :production do
    set :raise_errors, false #false will show nicer error page
    set :show_exceptions, false #true will ignore raise_errors and display backtrace in browser
  end
end
