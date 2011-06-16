class HomeController < ApplicationController

  def index
    if params[:q].present?
      @subtitles = Subtitle.search params[:q]
      
      store_search_term_in_cookie params[:q] unless @subtitles.nil?

      flash[:notice] = nil
      flash[:notice] = "Nenhuma legenda encontrada" unless @subtitles.present?
    end
    
    if cookies[:search_terms]
      @search_terms = cookies[:search_terms].split('&')
      @search_terms = @search_terms | @search_terms
    end
  end
  
end
