class HomeController < ApplicationController
  def index
    if params[:q].present?
      @subtitles = Subtitle.search params[:q]

      flash[:notice] = "Nenhuma legenda encontrada" if @subtitles.nil?
    end
  end
  
end
