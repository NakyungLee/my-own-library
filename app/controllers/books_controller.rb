require 'rack-flash'
class BooksController < ApplicationController
  use Rack::Flash

  get '/books' do
    if logged_in?
      @user = User.find(session[:user_id])
      @books = Book.all
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
    book = Book.create(name:params[:name],author:params[:author],user_id:session[:user_id]) if !params[:name].empty? && !params[:author].empty?
    comment = Comment.create(comment:params[:comment],book_id:book.id)  if !params[:comment].empty?
    sentence = Sentence.create(sentence:params[:sentence],book_id:book.id)  if !params[:sentence].empty?
    redirect to '/books'
  end

  get '/books/edit/:book_id' do
    @book = Book.find(params[:book_id])
    binding.pry
    erb :"/books/edit_books"
  end
end
