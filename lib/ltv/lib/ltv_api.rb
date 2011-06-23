#encoding=utf-8

require 'mechanize'
require 'timeout'

class LtvApi

  LTV_ROOT = File.expand_path("../../", __FILE__)

  @agent = Mechanize.new

  def self.iniciar
    conectar

    if check_auth_status
      return "ja esta autenticado"
    else
      autenticar
    end
  end

  def self.conectar
    begin
      Timeout::timeout(20) {
        @ltv_home = @agent.get("http://legendas.tv")
      }
    rescue Timeout::Error
      return false
    end
  end

  def self.autenticar(usuario='legendas1517', senha='legendas1517')
    form_login = @ltv_home.form_with(:action => "login_verificar.php")
    form_login["txtLogin"] = usuario
    form_login["txtSenha"] = senha

    retorno =  @agent.submit(form_login)
    if retorno.search("//*[contains(text(), 'Dados incorretos!')]").empty?
      @agent.page.links[0].click
      "autenticou"
    end
  end

  def self.check_status
    if @agent.page
      check_auth_status
    end
  end

  def self.check_auth_status
    if @agent.page
      @agent.page.link_with(:text => 'Logoff...')
    end
  end

  def self.buscar(termo)
    form_busca = @ltv_home.form_with(:action => "index.php?opcao=buscarlegenda")
    form_busca["txtLegenda"] = termo

    resultado = coletar(@agent.submit(form_busca))
  end

  def self.baixar(id, options = {})
    if id.nil?
      return nil
    end

    subtitle_mechanize_file = @agent.get("http://legendas.tv/info.php?d=#{id}&c=1")

    if options[:name]
      subtitle_mechanize_file.filename =  options[:name].gsub(/\//, '_') + subtitle_mechanize_file.filename[/....$/]
    else
      subtitle_mechanize_file.filename =  subtitle_mechanize_file.filename.gsub(/\//, '_')
    end

    return subtitle_mechanize_file
  end

  def self.baixar_pack(subs = {})
    if subs.empty?
      return nil
    end

    subtitle_mechanize_files = []
    subs.each_value do |index|
      subtitle_mechanize_files << LtvApi.baixar(index['id'], :name => index['name'])
    end

    # save subs mechanize file in tmp dir
    subtitles_full_paths = []
    subtitle_mechanize_files.each do |sub|
      full_path = LTV_ROOT + "/lib/tmp/#{sub.filename}"
      subtitles_full_paths << full_path

      sub.save(full_path)
    end

    pack_path = montar_pack(subtitles_full_paths)
  end

  def self.get_page
    @current_page
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
      proxima_pagina =  @agent.click(pagina.links_with(:text => "Próxima").first)
    else
      nil
    end
  end

  def self.montar_pack(subtitles_archives_paths)
    subtitles_dir = extrair_legendas(subtitles_archives_paths)

    raw_subtitles_paths = []
    Dir.foreach(subtitles_dir).each do |entry|
      unless File.directory?(entry) or File.extname(entry) == ".txt"
        raw_subtitles_paths << subtitles_dir + '/' + entry
      end
    end

    pack_path = subtitles_dir
    pack_call = (   LTV_ROOT + "/vendor/p7zip/bin/7z a -tzip" + ' ' +
                 pack_path + '.zip' + ' ' +
                 raw_subtitles_paths.join(' ') )

    system pack_call

    return pack_path + '.zip'
  end

  def self.extrair_legendas(subtitles_archives_paths)
    output_dir =  LTV_ROOT + "/lib/tmp/pack_" +
      (hash = (Time.now.to_s + rand(1000).to_s).hash.abs.to_s)

    subtitles_archives_paths.each do |path|
      unpack_call = ( LTV_ROOT + "/vendor/p7zip/bin/7z e -y -o" + output_dir + ' ' + path )
      system unpack_call
    end

    subtitles_dir = output_dir
  end

end
