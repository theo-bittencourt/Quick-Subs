#encoding=utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate 

  def authenticate
    LtvApi.autenticar
  end

  def admin?
    redirect_to home_path, :alert => "Sem Autorização"
  end

end
