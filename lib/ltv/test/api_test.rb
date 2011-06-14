require "test/unit"
require "mechanize"
require "ltv_api"

class ApiTest < Test::Unit::TestCase
  LtvApi.autenticar

  def test_deve_retornar_true_quando_conseguir_autenticar_no_site
    assert LtvApi.autenticar
  end
  
  def test_deve_retornar_false_quando_nao_conseguir_autenticar_no_site
    assert_equal false, LtvApi.autenticar("john", "doe")
  end

  def test_deve_retornar_array_de_resultados_da_busca
    retorno = LtvApi.buscar("old boy")
    assert_equal String, retorno[0][:id].class
  end
  
  def test_deve_retornar_subtitle_hash_quando_executar_o_methodo_baixar
    retorno = LtvApi.baixar("4d109fc88be299bd5d71f4822bc7107c")
    assert_equal Hash, retorno.class
  end

  def test_deve_montar_pack
    legendas = LtvApi.buscar("house")
    sub_ids = [legendas[0][:id], legendas[1][:id], legendas[2][:id]]
    tmp = LtvApi.baixar_pack(sub_ids)
    assert_equal Tempfile, tmp.class
  end
  
end
