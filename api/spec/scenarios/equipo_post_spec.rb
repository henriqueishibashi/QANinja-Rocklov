describe "POST /equipos" do

  # Executando a autenticação antes de adicionar os equipos.
  before(:all) do
    payload = { email: "to@mate.com.br", password: "pwd123" }
    result = Sessions.new.login(payload)
    # Coletando o user_id para confirmar que existe.
    @user_id = result.parsed_response["_id"]

    # Coloquei puts result para entender o porque não estava autorizando, sendo que o resultado dava 401 no teste, após esse put, descobri que o email estava incorreto.
    #puts result
  end

  context "novo equipo" do
    before(:all) do
      payload = {
        thumbnail: Helpers::get_thumb("kramer.jpg"),
        name: "Kramer Eddie Van Halen",
        category: "Cordas",
        price: 299,
      }

      MongoDB.new.remove_equipo(payload[:name], @user_id)

      @result = Equipos.new.create(payload, @user_id)

      # Puts para pegar o resultado que a API devolve e enteder o que está acontecendo.
      puts @result
    end

    it "deve retornar 200" do
      expect(@result.code).to eql 200
    end
  end

  context "nao autorizado" do
    before(:all) do
      payload = {
        thumbnail: Helpers::get_thumb("baixo.jpg"),
        name: "Contra Baixo",
        category: "Cordas",
        price: 59,
      }
      # Dados nulos no Ruby = nil
      @result = Equipos.new.create(payload, nil)
    end

    it "deve retornar 401" do
      # 401 representa não autorizado
      expect(@result.code).to eql 401
    end
  end
end
