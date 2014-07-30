class RustKit < Sinatra::Base

  get '/admin' do
    erb :admin
  end

end
