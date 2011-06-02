#encoding=utf-8

class LtvApi
  @agente = Mechanize.new
  @pagina_inicial = @agente.get("http://legendas.tv")

  def self.autenticar(usuario='legendas1517', senha='legendas1517')
    form_login = @pagina_inicial.form_with(:action => "login_verificar.php")
    form_login["txtLogin"] = usuario
    form_login["txtSenha"] = senha

    retorno = @agente.submit(form_login)
    retorno.search("//*[contains(text(), 'Dados incorretos!')]").empty?
  end
  
  def self.buscar(termo)
    form_busca = @pagina_inicial.form_with(:action => "index.php?opcao=buscarlegenda")
    form_busca["txtLegenda"] = termo

    legendas = coletar(@agente.submit(form_busca))

    return legendas
  end

  def self.baixar(id)
    @agente.get("http://legendas.tv/info.php?d=#{id}&c=1")
  end
  
 
  
  #####  PRIVATE METHODS   ###########################

  private

  def self.coletar(pagina)
    legendas = []
    
    while pagina
        pagina.search("#conteudodest > div > span").each do |item|
            elemento_id = item.search(".buscaDestaque", ".buscaNDestaque")
            elemento_nome = item.search(".brls")

            id = elemento_id.attr("onclick").text
            id = id.gsub(/(javascript|abredown|[^a-zA-Z0-9])/,"")

            nome = elemento_nome.text

            legendas << { :id => id, :nome => nome }
        end

        pagina = proxima_pagina(pagina)
    end

    return legendas
  end

  def self.proxima_pagina(pagina)
    if pagina.search("//a[text()='Próxima']").present?
      proxima_pagina = @agente.click(pagina.links_with(:text => "Próxima").first)
    else
      nil
    end
  end

end
