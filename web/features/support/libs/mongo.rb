# Requerindo a GEM do MongoDb. importando a biblioteca
require "mongo"

# Para salvar os logs na pasta logs, ao invés de mostrar no console cmder
# Para isso foi criado uma pasta na raiz do projeto chamada logs.
Mongo::Logger.logger = Logger.new("./logs/mongo.log")

# A partir da aula de Classes, vide veiculos.rb, deixamos organizado a classe MongoDB

class MongoDB
  # Passando a ter as coleções como propriedades do MongoDB
  attr_accessor :client, :users, :equipos
  # Inicializador construtor não precisa receber nenhum argumento.
  def initialize
    # chama o módulo do mongo, chama a classe client, chama a string de qual o servidor a conectar, mas para funcionar
    # é necessário ter um require.
    # Recebendo a constante CONFIG e o campo que irá receber do local.yml
    @client = Mongo::Client.new(CONFIG["mongo"])
    # Colection
    # coleção que quero me conectar para remover um usuário, ver em ROBOT 3T, pasta colection, depois users
    @users = client[:users]
    @equipos = client[:equipos]
  end

  # fazendo a estratégia de semente.
  def drop_danger
    @client.database.drop
  end

  # fazendoa a estratégia de semente.
  def insert_users(docs)
    @users.insert_many(docs)
  end

  def remove_user(email)
    # Utilizo o delete_many para deletar todos os dados com a condição.
    # Assim o teste sempre vai passar sem utilizar o metodo FAKER email. Não deixando o banco de dados inflado.
    # users.delete_many({email: "fernando@gmail.com"})
    @users.delete_many({ email: email })
  end

  # Para deletar somente o anuncio feito por uma pessoa, pois como está no remove_equipo, ele remove tudo pelo nome do equipamento.
  def get_user(email)
    user = @users.find({ email: email }).first
    # Apartir do email o return retorna o id.
    return user[:_id]
    #puts é para ver no console.
    #puts user [:_id].class
  end

  def remove_equipo(nome, email)
    user_id = get_user(email)
    @equipos.delete_many({ name: nome, user: user_id })
  end
end

# PAra testar o acesso no Mongo para coletar o usuário. get_user.
# MongoDB.new.get_user("betao@yahoo.com")
