ENV['database'] ||= 'MakersBnB'
require 'sinatra'

class MakersBnB < Sinatra::Base
  get '/' do
    'MakersBnB'
  end
end
