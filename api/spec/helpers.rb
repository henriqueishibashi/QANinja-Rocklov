module Helpers
  def get_fixture(item)
    # .load - carrega arquivo, .read - Ler aquivo, Dir.pwd concatenado com o local do arquivo, symbolize_names: true é paratransformar cada campo em um simbolo, chave simbolizada
    YAML.load(File.read(Dir.pwd + "/spec/fixtures/#{item}.yml"), symbolize_names: true)
  end

  # refatorando ainda mais a escolha do arquivo.
  # Obtendo o arquivo do thumbnail (imagem), pois na API ele não é uma string e sim um binário. Ver na aba Network na parte de inspeção da página F12.
  # argumento rb, além de encontrar, grava no formato binário, obtendo o conteudo correto.
  def get_thumb(file_name)
    return File.open(File.join(Dir.pwd, "spec/fixtures/images", file_name), "rb")
  end

  # falar que esse método é uma função do módulo.
  module_function :get_fixture

  module_function :get_thumb
end
