require 'rack-flash'
class UsersController < ApplicationController
  use Rack::Flash
  get '/signup' do
    if logged_in?
      redirect to '/books'
    else
      erb :'/users/signup'
    end
  end

  post '/signup' do
    if params[:username].empty? || params[:password].empty? || params[:email].empty?
      flash[:message] = "Fill in every field."
      redirect to '/signup'
    else
      if User.find_by(username:params[:username],email:params[:email])
        flash[:message] = "Hello, #{params[:username]}. You've already signed up. Please Login."
        redirect to '/login'
      elsif User.find_by(username:params[:username])
        flash[:message] = "This username has already been picked. Please choose other username."
        redirect to '/signup'
      else
        @user = User.new(username:params[:username],email:params[:email],password:params[:password])
        @user.save
        session[:user_id] = @user.id
        redirect to '/books'
      end
    end
  end

  get '/login' do
    if logged_in?
      redirect to '/books'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/books"
    else
      redirect to "/failure"
    end
  end

  get '/failure' do
    erb :'/users/failure'
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect to '/login'
    else
      redirect to '/'
    end
  end

  get '/users/:username' do
    # binding.pry
    @user = User.find_by(username:params[:username])
    # binding.pry
    erb :'/users/show_comments_and_sentences'
  end
end
