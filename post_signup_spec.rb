require_relative "routes/signup"
require_relative "libs/mongo"

describe "POST /signup" do
  context "novo usuario" do
    before(:all) do
      payload = { name: "Pitty", email: "pitty@bol.com.br", password: "pwd123" }

      MongoDB.new.remove_user(payload[:email])

      @result = Signup.new.create(payload)
    end

    it "valida status code" do
      expect(@result.code).to eql 200
    end

    it "valida id do usuário" do
      expect(@result.parsed_response["_id"].length).to eql 24
    end
  end

  context "usuario já existe" do
    before(:all) do
      # Dado que eu tenho um novo usuário
      payload = { name: "João da Silva", email: "joao@ig.com.br", password: "pwd123" }
      MongoDB.new.remove_user(payload[:email])
      # e o Email desse usuário já foi cadastrado no sistema.
      Signup.new.create(payload)
      # quando faço uma requisição para a rota /signup
      @result = Signup.new.create(payload)
    end

    it "valida status code 409" do
      #então deve retornar 409
      expect(@result.code).to eql 409
    end

    it "Deve retornar code: 1001" do
      expect(@result.parsed_response["code"]).to eql 1001
    end

    it "Deve retornar mensagem: Email already exists :(" do
      expect(@result.parsed_response["error"]).to eql "Email already exists :("
    end
  end

  examples = [
    {
      title: "Nome é Obrigatório",
      payload: { name: "", email: "juan@yahoo.com", password: "pwd123" },
      code: 412,
      error: "required name",
    },
    {
      title: "Email é Obrigatório",
      payload: { name: "Juan Pablo", email: "", password: "pwd123" },
      code: 412,
      error: "required email",
    },
    {
      title: "Senha é Obrigatório",
      payload: { name: "Juan Pablo", email: "juan@yahoo.com", password: "" },
      code: 412,
      error: "required password",
    },
    {
      title: "Informar Email Válido",
      payload: { name: "Juan Pablo", email: "juan%yahoo.com", password: "pwd123" },
      code: 412,
      error: "wrong email",
    },
  ]

  # for it, sobre a variavel, argumento |e|, que representa um exemplo por vez.
  examples.each do |e|

    # #{e[:title]} é uma interpolação
    context "#{e[:title]}" do
      before(:all) do
        # e[:payload] pega o payload que vem do array.
        @result = Signup.new.create(e[:payload])
      end

      it "valida status code #{e[:code]}" do
        # está validando o status code (200, 401, etc.)
        expect(@result.code).to eql e[:code]
      end

      it "valida o error: #{e[:error]}" do
        # Se observar no teste manual no insomia, aparece "error", então será o valor esperado que terá que ser igual ao "Unauthorized"
        expect(@result.parsed_response["error"]).to eql e[:error]
      end
    end
  end
end
