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
    comment = Comment.find_by(book_id:book.id)
    sentence = Sentence.find_by(book_id:book.id)
    comment.update(comment:params[:comment]) unless params[:comment].empty?
    sentence.update(sentence:params[:sentence]) unless params[:sentence].empty?

    Comment.create(comment:params[:comment2],book_id:book.id) unless params[:comment2].empty?
    Sentence.create(sentence:params[:sentence2],book_id:book.id) unless params[:sentence2].empty?
    binding.pry
    redirect to '/books'
  end

  delete '/books/:book_id/delete' do
    @book=Book.find(params[:book_id])
    @comments = Comment.all.collect do |c|
      c.book_id==@book.id
      c
    end
    if @book.user_id == session[:user_id]
      flash[:message] = "#{@book.name} has been deleted."
      @book.delete
      @comments.each do |c|
        c.delete
      end
      redirect to '/books'
    else
      flash[:message] = "You can only delete books you've enrolled."
      redirect to '/books'
    end
  end

  get '/books/delete-all' do
    if book.user_id==session[:user_id]
      Book.all.each{|b| b.delete}
      Comment.all.each{|c| c.delete}
      Sentence.all.each{|s| s.delete}
    flash[:message] = "Your library has been initialized."
    redirect to '/books'
  end

  get '/books/others' do
    erb :'/books/others_books'
  end
  get '/books/quotes' do
    binding.pry
    erb :'/books/show_comments_and_sentences'
  end
end
