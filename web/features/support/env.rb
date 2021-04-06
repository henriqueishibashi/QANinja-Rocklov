# Importando o Allure - Cucumber.
require "allure-cucumber"
# Importando o Capybara
require "capybara"
# Importando o módulo do Capybara para funcionar com o cucumber.
require "capybara/cucumber"
# Importando o gerador de email fake.
require "faker"
# Importando a lib OS para corrigir inconsistencias na hora de montar o caminho da img com o firefox
require "os"

# Criando uma CONSTANT, são imutáveis, a partir do momento que der um valor, ela nunca vai mudar.
# YAML - módulo do Ruby para carregar arquivos nesse formato .yml
# file.join - caminho de execussão do projeto. (pasta Local)
# ENV recurso do Ruby, para conseguir acesso as variáveis de ambiente (ver em cucumber.yml)
CONFIG = YAML.load_file(File.join(Dir.pwd, "features/support/config/#{ENV["CONFIG"]}"))

# opção IF para escolha do browser.
# BROWSER = ENV["BROWSER"]

# if BROWSER == "firefox"
#   @driver = :selenium
# elsif BROWSER == "fire_headless"
#   @driver = :selenium_headless
# elsif BROWSER == "chrome"
#   @driver = :selenium_chrome
# else
#   @driver = :selenium_chrome_headless
# end

Capybara.register_driver :selenium_chrome do |app|
  version = Capybara::Selenium::Driver.load_selenium
  options_key = Capybara::Selenium::Driver::CAPS_VERSION.satisfied_by?(version) ? :capabilities : :options
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument("--disable-site-isolation-trials")
  end

  Capybara::Selenium::Driver.new(app, **{ :browser => :chrome, options_key => browser_options })
end

# teste multi browser com CASE.
case ENV["BROWSER"]
when "firefox"
  @driver = :selenium
when "fire_headless"
  @driver = :selenium_headless
when "chrome"
  @driver = :selenium_chrome
when "chrome headless"
  @driver = :selenium_chrome_headless
else
  # Aborta o processo! não executa a feature!
  raise "Invalid Browser, variable @drive is empt :("
end

# Configurando o Capybara para usar Selenium
Capybara.configure do |config|
  # Define o tipo de drive que vai utilizar nos testes automatizados
  # Por padrão o Selenium trabalha com o FireFox, mas vamos usar o Chrome.
  # Se usar o _headless no final, ele executa normalmente, porém não abre o navegador, faz tudo debaixo dos panos, e uma observação que se tem as screenshots, como pode ver no hooks.rb
  # Tirará normalmente a screenshot, mas por baixo dos panos. RODANDO MUITO MAIS RÁPIDO A APLICAÇÃO.
  # PARECE QUE O TEMPO DE EXECUSSÃO DO EM HEADLESS DO FIREFOX É MAIS RÁPIDO.
  # HEADLESS, rodar em servidores do jenkins, por não ter telas (linux)
  config.default_driver = @driver
  # Se por ventura eu tenho uma nova URL e meu ambiente de teste for implantado em um endereço diferente, terei que alterar em todos os arquivos que temos visit.
  # Para URL Duplicadas, então uso .app_host Consigo definir a url padrão. Ver os arquivos cadastro_step e login_steps a parte de visit, isso ajuda caso have uma modificação de nomenclaturas.
  # Recebendo a constante CONFIG e o campo que irá receber do local.yml
  config.app_host = CONFIG["url"]
end

# Por motivos de tempo de resposta do banco de dados, informações entre outras, para que dê tempo
# executar toda a aplicação as vezes é necessário adicionar um timer, que nesse caso significa que o capybara tem até 10s.
Capybara.default_max_wait_time = 10
# Ou posso usar o config.default_max_wait_time = 10.

# Bloco de configuração do Allure
AllureCucumber.configure do |config|
  config.results_directory = "/logs"
  # Para limpar sempre que cucumber fizer uma execução.
  config.clean_results_directory = true
end
