# Capybara para teste de somente aplicação WEB

# Tem o Selenium imbutido

Dado("que acesso a página de cadastro") do
  @signup_page.open
end

Quando("submeto o seguinte formulário de cadastro:") do |table|
  # Para ficar mais claro a tabela, para entender como foi o tratamento de dados.
  # [{"nome"=>"Fernando Papito", "email"=>"fernando@gmail.com", "senha"=>"pwd123"}]
  # log table.hashes

  # table is a Cucumber::MultilineArgument::DataTable
  # Metodo hashes, converta a tabela em um Array.
  # .first pega a primeira posição da tabela do Cucumber.
  user = table.hashes.first

  # {"nome"=>"Fernando Papito", "email"=>"fernando@gmail.com", "senha"=>"pwd123"}
  # log user

  # instanciar a classe mongoDb, .new para ativar a classe
  MongoDB.new.remove_user(user[:email])

  @signup_page.create(user)
  # sleep 5 # Temporário
end
