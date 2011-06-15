class HomeController < ApplicationController
  caches_page :index

  def index
    if params[:q].present?
      @subtitles = Subtitle.search params[:q]
      flash[:notice] = nil
      flash[:notice] = "Nenhuma legenda encontrada" unless @subtitles.present?
    end
  end
  
end
