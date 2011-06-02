class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate 

  def authenticate
    LtvApi.autenticar
  end

end
