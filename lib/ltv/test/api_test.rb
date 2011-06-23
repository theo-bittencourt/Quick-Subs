require "test/unit"
require "mechanize"
require "ltv_api"

class ApiTest < Test::Unit::TestCase
  def setup
    @subs_archives_paths = []
    test_files_dir = Dir.new(File.dirname(File.expand_path(__FILE__)) + '/files')
    test_files_dir.each do |entry|
      unless File.directory?(entry)
        @subs_archives_paths << File.expand_path("../", __FILE__) + '/files/' + entry
      end
    end
  end

  def test_deve_retornar_true_quando_conseguir_autenticar_no_site
    assert LtvApi.autenticar
  end

  def test_deve_retornar_false_quando_nao_conseguir_autenticar_no_site
    assert_equal false, LtvApi.autenticar("john", "doe")
  end

  def test_deve_retornar_array_de_resultados_da_busca
    LtvApi.autenticar
    retorno = LtvApi.buscar("old boy")
    assert_equal String, retorno[0][:id].class
  end

  def test_deve_retornar_subtitle_hash_quando_executar_o_methodo_baixar
    LtvApi.autenticar
    retorno = LtvApi.baixar("4d109fc88be299bd5d71f4822bc7107c")
    assert_equal Hash, retorno.class
  end

  def test_deve_montar_pack
    pack_path = LtvApi.montar_pack(@subs_archives_paths)
    assert File.exist?(pack_path)
  end

  def test_extrair_legendas
    subtitles_dir = LtvApi.extrair_legendas(@subs_archives_paths)
    assert Dir.exist?(subtitles_dir)
  end

  end
