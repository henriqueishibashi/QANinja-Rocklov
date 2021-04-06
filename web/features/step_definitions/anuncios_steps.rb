Dado("Login com {string} e {string}") do |email, password|
  @email = email
  # Metodos ou propriedades que representam os elementos da página. lembrando que podemos chamar de funções.
  @login_page.open
  # .set o valor que irá receber.
  @login_page.login(email, password)

  # Check point garantir que só vai sair do step se estiver no dashboard. com esse código tem até 10s para ir pro dashboard.
  expect(@dash_page.on_dash?).to be true
end

Dado("que acesso o formulário de cadastro de anúncios") do
  @dash_page.goto_equipo_form
  # Ponto de verificação (check point) para garantir que estou no lugar correto.
  # Proibido colocar expect dentro de um PAGE OBJECT, violação de arquitetura
  # expect(page).to have_css "#equipoForm"
  # era para apagar pois não faz mais sentido pois está no arquivo equipos_page.rb
end

Dado("que eu tenho o seguinte equipamento:") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  # cria a tabela de chave e valor para um objeto no Ruby.
  # Quando usa o @ a variável se torna uma varial de instancia ou uma variavel global, ficando disponível durante toda a execussão do cenário.
  @anuncio = table.rows_hash
  # log @anuncio

  MongoDB.new.remove_equipo(@anuncio[:nome], @email)
end

Quando("submeto o cadastro desse item") do
  @equipos_page.create(@anuncio)
end

Então("devo ver esse item no meu Dashboard") do
  #validações
  expect(@dash_page.equipo_list).to have_content @anuncio[:nome]
  expect(@dash_page.equipo_list).to have_content "R$#{@anuncio[:preco]}/dia"
end

Então("deve conter a mensagem de alerta: {string}") do |expect_alert|
  # have_text vai verificar se no elemento CONTÉM o texto, ignorando o íncone que vem nessa aplicação
  expect(@alert.dark_alert).to have_text expect_alert
end

# Remover anuncios
# Após fazer o login no site, No console digitando um comando javascript localStorage.getItem("user"), Se ir na aba application, poderá ver que usa o user como key.
Dado("que eu tenho um anúncio indesejado:") do |table|
  # Usando comando para javascript, uso aspas simples, porque o javascript entende tanto aspas duplas quanto simples.
  user_id = page.execute_script("return localStorage.getItem('user')")
  # para ver se está funcionando.
  log user_id

  # consumindo a classe relacionada a API para
  thumbnail = File.open(File.join(Dir.pwd, "/features/support/fixtures/images/" + table.rows_hash[:thumb]))

  @equipo = {
    thumbnail: thumbnail,
    name: table.rows_hash[:nome],
    category: table.rows_hash[:categoria],
    price: table.rows_hash[:preco],
  }

  EquiposService.new.create(@equipo, user_id)

  #faz um refresh na página, para ver o produto cadastrado na API
  visit current_path
end

Quando("eu solicito a exclusão desse item") do
  @dash_page.request_removal(@equipo[:name])
  # thinking time - simula o usuário pensando
  sleep 5
end

Quando("confirmo a exclusão") do
  @dash_page.confirm_removal
end

Quando("não confirmo a solicitação") do
  @dash_page.cancel_removal
end

Então("não devo ver esse item no meu Dashboard") do
  expect(@dash_page.has_no_equipo?(@equipo[:name])).to be true
end

Então("esse item deve permanecer no meu Dashboard") do
  expect(@dash_page.equipo_list).to have_content @equipo[:name]
end
