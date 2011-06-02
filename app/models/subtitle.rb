class Subtitle < ActiveRecord::Base
  attr_accessor :name, :ltv_id

  def self.search(q)
    #Procedimento necessario para transformar as legendas buscadas
    #em models, e assim, sendo melhor aproveitadas pelo sistema
    search_result = LtvApi.buscar q
    if search_result.present?
      @subtitles = []
      search_result.each do |s|
        subtitle = Subtitle.new(:ltv_id => s[:id] ,:name => s[:nome])
        @subtitles << subtitle
      end
      return @subtitles
    else
      nil
    end
  end

end
