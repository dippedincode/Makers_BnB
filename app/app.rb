ENV['database'] ||= 'MakersBnB'
# require 'sinatra'
require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/space'
require_relative './lib/user'


class MakersBnB < Sinatra::Base
  enable :sessions
  get '/' do
    @user = session['user']
    @spaces = Space.all
    erb :index
  end

  get '/post-space' do
    erb :postspace
  end

  post '/post-space' do
    Space.create(
      space_name: params[:spacename],
      description: params[:description],
      price: params[:price]
    )
    redirect '/'
  end

  get '/users' do
    erb :users
  end

  post '/users' do
    session['user'] = User.create(
        username: params[:username],
        email: params[:email],
        pass_hash: params[:password]
    )
    redirect '/'
  end

  run! if app_file == $0
end
