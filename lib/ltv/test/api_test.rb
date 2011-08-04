require "test/unit"
require "mechanize"
require "ltv_api"

class ApiTest < Test::Unit::TestCase

  @subs_archives_paths = []
  test_files_dir = Dir.new(File.dirname(File.expand_path(__FILE__)) + '/files')
  test_files_dir.each do |entry|
    unless File.directory?(entry)
      @subs_archives_paths << File.expand_path("../", __FILE__) + '/files/' + entry
    end
  end

  def test_deve_conectar
    assert LtvApi.conectar
  end

  def test_deve_autenticar
    LtvApi.conectar
    assert LtvApi.autenticar
    LtvApi.logoff
  end

  def test_deve_nao_autenticar
    LtvApi.conectar
    assert_equal false, LtvApi.autenticar("john", "doe")
  end

  def test_deve_fazer_logoff
    LtvApi.conectar
    LtvApi.autenticar
    assert LtvApi.logoff
  end

  def test_deve_retornar_array_de_resultados_da_busca
    LtvApi.iniciar

    retorno = LtvApi.buscar("breaking bad")
    assert_equal String, retorno[0][:id].class

    LtvApi.logoff
  end

  def test_deve_retornar_mechanize_file_no_methodo_baixar
    LtvApi.iniciar

    retorno = LtvApi.baixar("4d109fc88be299bd5d71f4822bc7107c")
    assert_equal Mechanize::File, retorno.class

    LtvApi.logoff
  end

  def test_deve_montar_pack
    pack_path = LtvApi.montar_pack(@subs_archives_paths)
    assert File.exist?(pack_path)
  end

  def test_extrair_legendas
    subtitles_dir = LtvApi.extrair_legendas(@subs_archives_paths)
    assert Dir.exist?(subtitles_dir)
  end

  def test_deve_estar_logado
    LtvApi.iniciar
    assert LtvApi.check_auth_status
    LtvApi.logoff
  end

  def test_deve_nao_estar_logado
    LtvApi.conectar  # conecta, mas ainda nao loga

    assert_equal false, LtvApi.check_auth_status
  end

  def test_check_status
    assert_not_equal true, LtvApi.check_status

    LtvApi.iniciar
    assert LtvApi.check_status

    LtvApi.logoff
  end

end
