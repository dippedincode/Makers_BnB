ENV['database'] ||= 'MakersBnB'
# require 'sinatra'
require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/space.rb'
require_relative './lib/user.rb'
require_relative './lib/hashHandler.rb'


class MakersBnB < Sinatra::Base
  enable :sessions, :method_override
  get '/' do
    @user = session['user']
    @spaces = Space.all
    erb :index
  end

  get '/my-spaces' do
    @spaces = Space.all
    erb :my_spaces
  end

  get '/space-creator' do
    erb :space_creator
  end

  post '/space-editor' do
    @space = Space.find(params[:space_id])
    erb :space_editor
  end

  post '/space' do
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
      pass_hash: HashHandler.new.to_hash("tractorTR10@kul"+params[:password])
    )
    redirect '/'
  end

  post '/session' do
    access = HashHandler.new.authenticate(
      "tractorTR10@kul"+params[:password],
       User.find_by(username: params[:username]).pass_hash)
    access ? session['user'] = User.find_by(username: params[:username]) : redirect('/')
    redirect('/')
    #add sinatra flash for wrong password
  end

  delete '/session' do
    session['user'] = nil
    redirect '/'
  end

  put '/space' do
    Space.find(params['space_id']).update(
      space_name: params[:spacename],
      description: params[:description],
      price: params[:price]
    )
    redirect '/my-spaces'
  end

  delete '/space' do
    Space.find(params['space_id']).destroy
    redirect '/my-spaces'
  end

  run! if app_file == $0
end
