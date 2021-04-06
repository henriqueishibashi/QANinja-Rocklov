# Todos os spec são scripts de testes.

describe "GET /equipos/{equipo_id}" do
  before(:all) do
    payload = { email: "to@mate.com.br", password: "pwd123" }
    result = Sessions.new.login(payload)
    @user_id = result.parsed_response["_id"]
  end

  context "obter unico equipo" do
    before(:all) do
      # Dado que eu tenho um novo equipamento
      @payload = {
        thumbnail: Helpers::get_thumb("sanfona.jpg"),
        name: "Sanfona",
        category: "Outros",
        price: 499,
      }

      MongoDB.new.remove_equipo(@payload[:name], @user_id)
      # e eu tenho o id desse equipamento
      equipo = Equipos.new.create(@payload, @user_id)
      @equipo_id = equipo.parsed_response["_id"]

      # quando faço uma requisição get por id
      @result = Equipos.new.find_by_id(@equipo_id, @user_id)
    end

    it "deve retornar 200" do
      expect(@result.code).to eql 200
    end

    # ver se retorna o nome do equipo, no exemplo sanfona
    it "deve retornar o nome" do
      # => fala que é com o valor que vem do payload
      expect(@result.parsed_response).to include("name" => @payload[:name])
    end
  end

  context "equipo não existe" do
    before(:all) do
      @result = Equipos.new.find_by_id(MongoDB.new.get_mongo_id, @user_id)
    end

    it "Deve retornar 404" do
      expect(@result.code).to eql 404
    end
  end
end

describe "GET /equipos" do
  before(:all) do
    payload = { email: "penelope@gmail.com", password: "pwd123" }
    result = Sessions.new.login(payload)
    @user_id = result.parsed_response["_id"]
  end

  context "obter uma lista" do
    before(:all) do
      # Dado que eu tenho uma lista de Equipos
      payloads = [{
        thumbnail: Helpers::get_thumb("sanfona.jpg"),
        name: "Sanfona",
        category: "Outros",
        price: 499,
      }, {
        thumbnail: Helpers::get_thumb("trompete.jpg"),
        name: "Trompete",
        category: "Outros",
        price: 599,
      }, {
        thumbnail: Helpers::get_thumb("slash.jpg"),
        name: "Les Paul do Slash",
        category: "Outros",
        price: 699,
      }]
      # Contexto de cada rodada fica entra | |
      payloads.each do |payload|
        MongoDB.new.remove_equipo(payload[:name], @user_id)
        Equipos.new.create(payload, @user_id)
      end

      # Quando faço uma requisição get para /equipos
      @result = Equipos.new.list(@user_id)
    end

    it "Deve retornar 200" do
      expect(@result.code).to eql 200
    end

    it "Deve retornar uma lista de equipos" do
      # não pode estar vazio e é uma lista, pois foi feita uma lista de equipos
      expect(@result.parsed_response).not_to be_empty
      puts @result.parsed_response
      puts @result.parsed_response.class
    end
  end
end
