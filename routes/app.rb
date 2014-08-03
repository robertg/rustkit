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

  get '/api/libraries/:page' do #There are 200 library listing per page, and page begins at 0.
    page = params[:page].to_i
    libraries = @r.db('rustkit_db').table('libraries')
    {
    results: libraries.orderby(@r.desc(:stargazers_count))
              .slice(200*page, 200+200*page)
              .run(@connection).to_a,
    all_results_size: libraries.count().run(@connection)
    }.to_json
  end

  get '/searchResult.html' do
    send_file File.join(settings.public_folder, 'templates/searchResult.html')
  end

end
