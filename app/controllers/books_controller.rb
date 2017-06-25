require 'rack-flash'
class BooksController < ApplicationController
  use Rack::Flash

  get '/books' do
    if logged_in?
      @user=User.find(session[:user_id])
      erb :'/books/books'
    else
      flash[:message]="Please Login to access books page."
      redirect to '/login'
    end
  end

  get '/books/new' do
    if logged_in?
      erb :'/books/create_books'
    else
      redirect to '/login'
    end
  end

  post '/books/new' do
  end
end
