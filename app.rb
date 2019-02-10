require "sinatra"
require "sinatra/reloader" if development?
require_relative "database"

class WebApp < Sinatra::Application

  # Initialization
  def initialize
    super()
    @database = DB
    @comments = COMMENTS
  end

  # Routing

  get '/' do
    erb :index
  end

  get '/posts/:title' do
    @post = @database.find { |post| post[:title] == params[:title]}
    @index = @database.find_index { |post| post[:title] == params[:title]}
    @comment = @comments[@index]
    erb :posts
  end

  post '/posts/:title/vote' do 
    @post = @database.find { |post| post[:title] == params[:title]}
    if @post[:rating].nil?
      @post[:rating] = 0
    end
    if @params[:vote] == "upvote" 
      @post[:rating] = Integer(@post[:rating])+1
    else
      @post[:rating] = Integer(@post[:rating])-1 
    end

    if @post[:rating] > 10 
      @post[:rating] = 10
    elsif @post[:rating] < 0
      @post[:rating] = 0
    else
    end
    save
    redirect "/posts/#{params[:title]}"
  end

  post '/posts/:title/comment' do
    @post = @database.find{ |post| post[:title] == params[:title]} 
    @index = @database.find_index { |post| post[:title] == params[:title]}
    @comment = @comments[@index]
    if !@params[:comment].nil?
      @comment.push(@params[:comment])
    end
    save
    redirect "/posts/#{params[:title]}"
  end

  # Method
  def save()
    open('database.rb', 'w') { |f|
      f.puts "DB = #{@database}\nCOMMENTS = #{@comments}"
    }
  end


end

# Extension
class String
  def truncate(max)
    length > max ? "#{self[0...max]}..." : self
  end
end

# Starting 
WebApp.run!

