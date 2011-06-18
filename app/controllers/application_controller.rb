#encoding=utf-8
require 'unicode_utils/downcase'

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate
  before_filter :_reload_libs, :if => :_reload_libs?

  def _reload_libs
    RELOAD_LIBS.each do |lib|
      require_dependency lib
    end
  end

  def _reload_libs?
    defined? RELOAD_LIBS
  end

  def authenticate
    LtvApi.autenticar
  end

  def admin?
    redirect_to home_path, :alert => "Sem Autorização"
  end
  
  def store_search_term_in_cookie(term)
    term = UnicodeUtils.downcase(term)
    
    if cookies[:search_terms].nil?
      cookies.permanent[:search_terms] = term
    else
      if cookies[:search_terms].size > 500
        array = cookies[:search_terms].split('&')
        compact_array = array[0..15]
        cookies[:search_terms] = compact_array.join('&')
        cookies[:search_terms] = term + '&' + cookies[:search_terms]
      else
        cookies[:search_terms] = term + '&' + cookies[:search_terms]
      end
    end
  end


end
