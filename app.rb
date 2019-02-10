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

  get '/new' do
    erb :new
  end

  post '/new' do
    post = Hash.new
    post[:title] = params[:title]
    if params[:photo] != ""
      post[:photo] = params[:photo]
    end
    post[:content] = params[:content]
    post[:rating] = 0
    puts post
    @database.push(post)
    @comments.push([])
    save
    redirect "/posts/#{URI.escape(params[:title])}"
  end
  
  get '/posts/:title' do
    @post = @database.find { |post| post[:title] == params[:title]}
    if @post.nil?
      redirect "404"
    end
    @index = @database.find_index { |post| post[:title] == params[:title]}
    @comment = @comments[@index]
    erb :posts
  end
  
  delete '/posts/:title' do
    @index = @database.find_index { |post| post[:title] == params[:title]}
    if @index.nil?
      redirect "404"
    end
    @database.delete_at(@index)
    @comments.delete_at(@index)
    save
    redirect "/"
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
    redirect "/posts/#{URI.escape(params[:title])}"
  end

  post '/posts/:title/comment' do
    @post = @database.find{ |post| post[:title] == params[:title]} 
    @index = @database.find_index { |post| post[:title] == params[:title]}
    @comment = @comments[@index]
    if !@params[:comment].nil?
      @comment.push(@params[:comment])
    end
    save
    redirect "/posts/#{URI.escape(params[:title])}"
  end

  delete '/posts/:title/comment' do
    @index = @database.find_index { |post| post[:title] == params[:title]}
    if @index.nil?
      redirect "404"
    end
    @comment = @comments[@index]
    @comment.delete_at(Integer(params[:comment_index]))
    save
    redirect "/posts/#{URI.escape(params[:title])}"
  end

  get '/404' do
    erb :notFound
  end

  not_found do
    redirect "/404" 
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

