# Trabalhando com rspec puro!!!
# Sempre em que ter (mandatória) _spec no nome para rodar o arquivo, se não o terminal nunca vai saber qual é o spec a rodar, quando colocar rpec.
# rspec por padrão não sabe consumir uma API, portanto precisando de uma nova gem/biblioteca httparty.
# não é recomendável usar 2 expect no mesmo it., pois se tem um erro, ele aborta e não executa a próxima linha de código, usando contexto, ver revisão 1 para entender o que foi alterado.
# nesse caso, falhando ou passando, irá executar o próximo it. testar mudando o 200 para outro número, ou 24 para outro número.

# Conceito DRY - Don`t Reapeat Yourself, e foi feito todo o refatoramento, porém quando se trata de TESTE temos que deixar CLARO o que está sendo testado, por isso o payload está nessa página.

# Com describe, criamos uma switch
describe "POST /sessions" do
  # Criando contexto
  context "login com sucesso" do

    # Gancho para implementar a pré condição do contexto. fazer a requisição no API.
    # :all executa o before uma única vez e testa. Para essa aplicação tudo bem usar o :all, porém depende do contexto.
    before(:all) do
      payload = { email: "betao@hotmail.com", password: "pwd123" }
      @result = Sessions.new.login(payload)
    end

    # it são considerados exemplos, ou podemos chamar de condições.
    it "valida status code" do
      # está validando o status code (200, 401, etc.)
      expect(@result.code).to eql 200
    end

    it "valida id do usuário" do
      # metodo parsed_response. transforma a classe de HTTParty para Hash, por exemplo.
      # [_id] para pegar somente o id do login.
      # .length para contar caracteres, e id tem 24 caracteres, é o padrão do MongoDB.
      expect(@result.parsed_response["_id"].length).to eql 24
    end
  end

  # Quando tempos muitos testes parecidos para fazer, como esse exemplo de testar login.
  # variavel examples é um array
  #   examples = [
  #     {
  #       title: "Senha Incorreta",
  #       payload: { email: "betao@yahoo.com", password: "123456" },
  #       code: 401,
  #       error: "Unauthorized",
  #     },
  #     {
  #       title: "Usuário não existe",
  #       payload: { email: "404@yahoo.com", password: "pwd123" },
  #       code: 401,
  #       error: "Unauthorized",
  #     },
  #     {
  #       title: "Email em Branco",
  #       payload: { email: "", password: "pwd123" },
  #       code: 412,
  #       error: "required email",
  #     },
  #     {
  #       title: "Sem o Campo Email",
  #       payload: { password: "pwd123" },
  #       code: 412,
  #       error: "required email",
  #     },
  #     {
  #       title: "Senha em Branco",
  #       payload: { email: "betao@yahoo.com", password: "" },
  #       code: 412,
  #       error: "required password",
  #     },
  #     {
  #       title: "Sem o campo Senha",
  #       payload: { email: "betao@yahoo.com" },
  #       code: 412,
  #       error: "required password",
  #     },
  #   ]

  # esse puts é para transformar o que está em array em formato json. Para que transformamos o json para yaml
  # puts examples.to_json

  # Utilizando um arquivo .yml como massa de dados.
  # .load - carrega arquivo, .read - Ler aquivo, Dir.pwd concatenado com o local do arquivo, symbolize_names: true é paratransformar cada campo em um simbolo, chave simbolizada
  # Massa de teste abaixo, seria sem o arquivo helpers.rb
  # examples = YAML.load(File.read(Dir.pwd + "/spec/fixtures/login.yml"), symbolize_names: true)

  # encapsulando dentro de um módulo.
  # trabalhando um arquivo de fixture, que obtem o arquivo de uma forma prática.
  # ver em módulo e o require acima adicionado.
  examples = Helpers::get_fixture("login")

  # for it, sobre a variavel, argumento |e|, que representa um exemplo por vez.
  examples.each do |e|

    # #{e[:title]} é uma interpolação
    context "#{e[:title]}" do
      before(:all) do
        # e[:payload] pega o payload que vem do array.
        @result = Sessions.new.login(e[:payload])
      end

      it "valida status code #{e[:code]}" do
        # está validando o status code (200, 401, etc.)
        expect(@result.code).to eql e[:code]
      end

      it "valida id do usuário" do
        # Se observar no teste manual no insomia, aparece "error", então será o valor esperado que terá que ser igual ao "Unauthorized"
        expect(@result.parsed_response["error"]).to eql e[:error]
      end
    end
  end
end
