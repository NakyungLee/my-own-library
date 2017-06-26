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
    if !params[:name].empty? && !params[:author].empty?
      book = Book.create(name:params[:name],author:params[:author],user_id:session[:user_id])
    else
      flash[:message]="Please fill in the blanks below, especially title and author."
      redirect to '/books/new'
    end

    comment = Comment.create(comment:params[:comment],book_id:book.id)  if !params[:comment].empty?
    sentence = Sentence.create(sentence:params[:sentence],book_id:book.id)  if !params[:sentence].empty?
    redirect to '/books'
  end

  get '/books/:book_id/edit' do
    @book = Book.find(params[:book_id])
    erb :"/books/edit_books"
  end

  patch '/books/:book_id/edit' do
    book = Book.find(params[:book_id])
    book.update(name:params[:name]) unless params[:name].empty?
    book.update(author:params[:author]) unless params[:author].empty?
    redirect to '/books'
  end

  delete '/books/:book_id/delete' do
    @book=Book.find(params[:book_id])
    if @book.user_id == session[:user_id]
      flash[:message] = "#{@book.name} has been deleted."
      @book.delete
      redirect to '/books'
    else
      flash[:message] = "You can only delete books you've enrolled."
      redirect to '/books'
    end
  end

  get '/books/delete-all' do
    Book.all.each{|book| book.delete if book.user_id==session[:user_id]}
    flash[:message] = "Your library has been initialized."
    redirect to '/books'
  end

  get '/books/others' do
    erb :'/books/others_books'
  end
end
