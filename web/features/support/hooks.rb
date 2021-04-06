# Hooks significa ganchos, isso quer dizer que vai fazer um hook de antes da inicialização do cenário.

# Before Vai executar o código antes de cada cenário
Before do
  #ativa a classe LoginPage, instânciando essa classe numa variagem login_page
  @login_page = LoginPage.new
  #ativa a classe Alert, instânciando essa classe numa variagem alert
  @alert = Alert.new
  #ativa a classe SignupPage, instânciando essa classe numa variagem alert
  @signup_page = SignupPage.new

  @dash_page = DashPage.new

  @equipos_page = EquiposPage.new

  # Pode ser que executar abaixo não seja uma boa opção. Pois isso pode ser que não mostre todos os elementos da tela que deveria, num determinado monitor.
  # Podendo ser reprovado pela empresa.
  #page.driver.browser.manage.window.maximize

  # Configurado o tamanho de tela padrão para os testes. funcionaria para todos os tipos de monitores.
  page.current_window.resize_to(1440, 900)
end


After do
  # Melhorando o report com Allure. Com ScreenShots. criando evidências que o teste passou!!
  # Depois que executar um cenário, depois do ENTAO (desfecho), ele executa um gancho que tira um screenshot temporário
  # Pega o arquivo e anexa no arquivo json.
  # Para executar o allure no terminal digitar allure server log\
  temp_shot = page.save_screenshot("logs/temp_screenshot.png")

  Allure.add_attachment(
    name: "Screeshot",
    type: Allure::ContentType::PNG,
    source: File.open(temp_shot),
  )
end
