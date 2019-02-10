require "sinatra"
require "sinatra/reloader" if development?
require_relative "database"


get '/' do
  @database = DB
  erb :index
end

get '/posts/:title' do
  @database = DB
  @comments = COMMENTS
  @post = @database.find { |post| post[:title] == params[:title]}
  @index = @database.find_index { |post| post[:title] == params[:title]}
  @comment = @comments[@index]
  puts @comment
  erb :posts
end


# Class Extension 
class String
  def truncate(max)
    length > max ? "#{self[0...max]}..." : self
  end
end

