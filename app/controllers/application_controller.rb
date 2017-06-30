require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions unless test?
    set :session_secret, "secret"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    if logged_in?
      redirect to '/books'
    else
      redirect to '/books/others'
    end
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      # memoization
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  end
end
