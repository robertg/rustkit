class RustKit < Sinatra::Base
  before do
  end

  get '/' do
    erb :main
  end

  get '/test-flash' do
    redirect to('/')
    erb :main
  end

end
