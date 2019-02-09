require "sinatra"
require "sinatra/reloader" if development?
require_relative "database"


get '/' do
  @database = DB
  erb :index
end

get '/posts/:title' do
  @database = DB
  @database.each do |posts|
    if posts[:title] == params[:title] 
      @post = posts
      puts "success"
      puts @post
      break
    end
  end
  erb :posts
end
