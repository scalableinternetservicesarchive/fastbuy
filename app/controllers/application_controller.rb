class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # Note: Temporarily commenting this to see if the 422 errors in tsung are fixed.
  #protect_from_forgery with: :exception
end
