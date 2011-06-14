#encoding=utf-8

require 'zip/zip'
require 'zip/zipfilesystem'
require 'mechanize'

class LtvApi
  @agente = Mechanize.new
  @pagina_inicial = @agente.get("http://legendas.tv")

  def self.autenticar(usuario='legendas1517', senha='legendas1517')
    form_login = @pagina_inicial.form_with(:action => "login_verificar.php")
    form_login["txtLogin"] = usuario
    form_login["txtSenha"] = senha

    retorno =  @agente.submit(form_login)
    retorno.search("//*[contains(text(), 'Dados incorretos!')]").empty?
  end

  def self.buscar(termo)
    form_busca = @pagina_inicial.form_with(:action => "index.php?opcao=buscarlegenda")
    form_busca["txtLegenda"] = termo

    resultado = coletar(@agente.submit(form_busca))
  end

  def self.baixar(id, options = {})
    if id.nil?
      return nil
    end
    
    mechanize_file = @agente.get("http://legendas.tv/info.php?d=#{id}&c=1")
    
    subtitle = {} #this hash will be returned

    if options[:name]
      subtitle[:name] =  options[:name].gsub(/\//, '_') + mechanize_file.filename[/....$/]
    else
      subtitle[:name] =  mechanize_file.filename.gsub(/\//, '_')
    end      
    subtitle[:content_type] =   mechanize_file.response['content-type']
    subtitle[:body] =           mechanize_file.body

    return subtitle
  end

  def self.baixar_pack(subs = {})
    if subs.empty?
      return nil
    end

    subtitle_array = []
    subs.each_value do |index|
        subtitle_array << LtvApi.baixar(index['id'], :name => index['name'])
    end

    tmp_pack_file = Tempfile.new(["sub_pack_tmp", '.zip'])
    #tmp_pack_file = Tempfile.new(["sub_pack_tmp", '.zip'])

    Zip::ZipOutputStream.open(tmp_pack_file.path) do |zos|
      subtitle_array.each do |sub|
        zos.put_next_entry(sub[:name])
        zos.write(sub[:body])
      end
    end
    
    return tmp_pack_file
  end



  #####  PRIVATE METHODS   ###########################

  private

  def self.coletar(pagina)
    legendas = []

    while pagina
      pagina.search("#conteudodest > div > span").each do |item|
        elemento_id = item.search(".buscaDestaque", ".buscaNDestaque")

        id = elemento_id.attr("onclick").text
        id = id.gsub(/(javascript|abredown|[^a-zA-Z0-9])/,"")

        nome = item.search(".brls").text
        legender = item.search("a").text
        data_envio = item.search("td")[2].text
        nota = item.search("td")[1].text[/\d\d\/10/]
        downloads = item.search("td")[1].text[/Downloads:  \d*/][/\b\d+\b/]
        flag_link = "http://legendas.tv/" + item.search("td")[4].search("img").attr("src").text

        legendas << { :id => id,
                      :nome => nome,
                      :legender => legender,
                      :data_envio => data_envio,
                      :nota => nota,
                      :downloads => downloads,
                      :flag_link => flag_link
        }
      end

      pagina = proxima_pagina(pagina)
    end

    return legendas
  end

  def self.proxima_pagina(pagina)
    if not pagina.search("//a[text()='Próxima']").empty?
      proxima_pagina =  @agente.click(pagina.links_with(:text => "Próxima").first)
    else
      nil
    end
  end


end
