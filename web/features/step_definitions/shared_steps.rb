# Shared_steps é para reutilizar os steps que são validos tanto para login_steps e cadastro_steps.

Então("sou redirecionado para o Dashboard") do
  # Expect é um recurso de validação.
  # Page é um objeto do capybara
  # .to have_css, contenha um tipo de css selector
  # Inspeciona uma class que é dashboard
  # Elemento que garante que está na área logada
  # expect(page).to have_css ".dashboard"

  # Perguntando se está no dashboard. usando o page object
  expect(@dash_page.on_dash?).to be true

  # Depois que rodar toda a aplicação para e espera 10s nesse exemplo.
  # sleep 10 # Temporário
end

# Foi gerado quando modifiquei a mensagem de alerta colocando entre "".
# quando Rodar no console todos os cenários que contém o alarme, o valor do alarme será passado para a string.
# Agora está automatizando e melhorando visualmente o projeto.
# usa um step unico que reaproveita as mensagens dos steps.
Então("vejo a mensagem de alerta: {string}") do |expect_alert|

  # expect_alert busca o elemento na tela e valida o texto nele. com o texto que vem da documentação.
  expect(@alert.dark_alert).to eql expect_alert
end
