#encoding=utf-8
require 'unicode_utils/downcase'

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :_reload_libs, :if => :_reload_libs?
  before_filter :ltv_init unless LtvApi.check_status

  def _reload_libs
    RELOAD_LIBS.each do |lib|
      require_dependency lib
    end
  end

  def _reload_libs?
    defined? RELOAD_LIBS
  end

  def ltv_init
    if LtvApi.iniciar
      return
    else
      render :template => 'errors/dead_source', :layout => 'error'
    end
  end

  def admin?
    redirect_to home_path, :alert => "Sem Autorização"
  end

  def store_search_term_in_cookie(term)
    term = UnicodeUtils.downcase(term)

    if cookies[:search_terms].nil?
      cookies.permanent[:search_terms] = term
    else
      term_array = cookies[:search_terms].split('&')
      unless term_array.include?(term)    
        if cookies[:search_terms].size > 500
          compact_array = term_array[0..15]
          cookies.permanent[:search_terms] = compact_array.join('&')
          cookies.permanent[:search_terms] = term + '&' + cookies[:search_terms]
        else
          cookies.permanent[:search_terms] = term + '&' + cookies[:search_terms]
        end
      end
    end
  end


end
