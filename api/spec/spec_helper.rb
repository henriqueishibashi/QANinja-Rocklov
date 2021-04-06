# Foi passado todos os require_relative dos _specs, para esse arquivo, pois é onde tudo começa.
# esse é o arquivo principal
# importando a rota
require_relative "routes/signup"
require_relative "routes/sessions"
require_relative "routes/equipos"

require_relative "libs/mongo"
require_relative "helpers"

# Recurso que vem na linguagem de programação MD5, que verifica o password criptografado.
require "digest/md5"

# transformando password para md5, ver exemplos no array users abaixo.
def to_md5(pass)
  return Digest::MD5.hexdigest(pass)
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Before executado uma única vez para todos os testes automatizados, a idéia é que sempre que cair o servidor durante o teste ou uma nova versão do software
  # que o desenvolvedor lança como revisão, podemos perder toda a massa de testes, o que acontece aqui é que todos os usuários que foram adicionados,
  # manualmente, não estão mais no banco de dados, ocasionando um erro em massa. Para corrigir isso usamos uma técnica na programação, que é utilizando no processo de migration, semente.
  # São dados pré adicionado no ambiente e que são fundamentais pro ambiente funcionar.

  #criando um gancho. Hook, onde será implementado semente de massa de teste.

  config.before(:suite) do
    # array que vai cadastras os usuários.
    users = [
      { name: "Roberto Silva", email: "betao@hotmail.com", password: to_md5("pwd123") },
      { name: "Tomate", email: "to@mate.com.br", password: to_md5("pwd123") },
      { name: "Penelope", email: "penelope@gmail.com", password: to_md5("pwd123") },
      { name: "Joe Perry", email: "joe@gmail.com", password: to_md5("pwd123") },
      { name: "Edward Cullen", email: "ed@gmail.com", password: to_md5("pwd123") },
    ]

    # para matar o banco de dados.
    MongoDB.new.drop_danger
    # Inserindo os users do array acima.
    MongoDB.new.insert_users(users)
  end
end
