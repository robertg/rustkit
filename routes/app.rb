class RustKit < Sinatra::Base
  before do
    @r = settings.r
    @connection = @r.connect(:host => RDB_CONFIG[:host], :port => RDB_CONFIG[:port])
  end

  after do
    @connection.close()
  end

  get '/' do
    erb :main
  end

  get '/api/libraries' do
    @r.db('rustkit_db').table('libraries').run(@connection).to_a.to_json
  end

end
