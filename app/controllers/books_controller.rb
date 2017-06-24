class BooksController < ApplicationController
  get '/books' do
    @user=User.find_by(session[:user_id])
    erb :'/books/books'
  end

  get '/books/new' do
    if logged_in?
      erb :'/books/create_books'
    else
      redirect to '/login'
    end
  end

  post '/books/new' do
    binding.pry
  end
end
