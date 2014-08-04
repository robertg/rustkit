class RustKit < Sinatra::Base

  before do
    #Tools::seed_db(settings.r)
    @r = settings.r
    @connection = @r.connect(:host => RDB_CONFIG[:host], :port => RDB_CONFIG[:port])
  end

  after do
    @connection.close()
  end

  def libraries_on_page(page)
    libraries = @r.db('rustkit_db').table('libraries')
    {
    results: libraries.orderby(@r.desc(:stargazers_count))
              .slice(CONSTANTS[:per_page]*page, CONSTANTS[:per_page]+CONSTANTS[:per_page]*page)
              .run(@connection).to_a,
    all_results_size: libraries.count().run(@connection)
    }.to_json
  end

  get '/' do
    erb :main, :locals => { :default_results => libraries_on_page(0) }
  end

  get '/api/libraries/:page' do #There are CONSTANTS[:per_page] library listing per page, and page begins at 0.
    libraries_on_page(params[:page].to_i)
  end

  get '/result.html' do
    send_file File.join(settings.public_folder, 'templates/result.html')
  end

end
