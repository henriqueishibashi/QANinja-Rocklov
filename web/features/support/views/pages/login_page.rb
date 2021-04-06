# Implementando a Classe Login_Page

# Representa a página Login
class LoginPage
  # falando pro Ruby que a Classe login page precisa conhecer todos os recursos do capybara.
  include Capybara::DSL

  # Blocos de códigos, todos os métodos que representam a página login.
  def open
    visit "/"
  end

  # Metodo que tem uma responsabilidade, a função de efetuar login.
  def login(email, password)
    find("input[placeholder='Seu email']").set email
    find("input[type=password]").set password
    click_button "Entrar"
  end
end
