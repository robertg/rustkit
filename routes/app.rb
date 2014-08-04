class RustKit < Sinatra::Base

  before do
    @r = settings.r
    @connection = @r.connect(:host => RDB_CONFIG[:host], :port => RDB_CONFIG[:port])
  end

  after do
    @connection.close()
  end

  def libraries_on_page(page)
    libraries = @r.db('rustkit_db').table('libraries')
    response = libraries.orderby(@r.desc(:stargazers_count))
                .run(@connection).to_a

    {
      results: response[(CONSTANTS[:per_page]*page)...(CONSTANTS[:per_page]+CONSTANTS[:per_page]*page)],
      all_results_size: response.length
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

  post '/api/search/:page' do

    page = params[:page].to_i
    ng_params = JSON.parse(request.body.read)
    query = ng_params["query"]
    #Find tags
    tags = []
    cur_tag = ""
    in_tag = false

    query.each_char do |c|
      if c == "["
        if cur_tag.length > 0 && in_tag
          return {error: "Sent a query with an extra opening tag bracket, '['."}.to_json
        else
          cur_tag = ""
          in_tag = true
        end
      elsif c == "]"
        if cur_tag.length == 0
          return {error: "Sent a query with an extra bracket, or an empty tag."}.to_json
        else
          tags << cur_tag
          cur_tag = ""
          in_tag = false
        end
      elsif in_tag
        cur_tag << c
      end
    end
    libraries = @r.db('rustkit_db').table('libraries')
    query = query.downcase.gsub /\[.+?\]\s*/, '' #Remove tags, and contents within brackets.
    query = query.gsub /[^a-zA-Z0-9 -]/, '' #Remove any non-alphanumeric characters.
    filter_proc = Proc.new do |repo|
      query.split(' ').inject(repo["description"].downcase()){ |filter, query| filter.match(query) }
    end
    if tags.length > 0
      if query.split(' ').length > 0
        response = libraries.get_all(*tags, {index: "tags"}).filter(filter_proc).orderby(@r.desc(:stargazers_count)).run(@connection).to_a
      else
        response = libraries.get_all(*tags, {index: "tags"}).orderby(@r.desc(:stargazers_count)).run(@connection).to_a
      end
    else
      if query.split(' ').length > 0
        response = libraries.filter(filter_proc).orderby(@r.desc(:stargazers_count)).run(@connection).to_a
      else
        response = libraries.orderby(@r.desc(:stargazers_count)).run(@connection).to_a
      end
    end

    {
      results: response[(CONSTANTS[:per_page]*page)...(CONSTANTS[:per_page]+CONSTANTS[:per_page]*page)],
      all_results_size: response.length
    }.to_json
  end
end
