# Implementando o Page Object para Cadastro

class SignupPage
  include Capybara::DSL

  def open
    visit "/signup"
  end

  # poeria passar como argumento name, email, password, porém, dentro do cadastro_steps,
  # temos um objeto chamado user, que está montado na feature de cadastro. Por isso é mais interessante já receber o objeto inteiro,
  # pois se tenho um objeto com 10 campos, citar todos é pior.
  def create(user)

    # find é para localizar um elemento html e CSS
    # .set é para colocar alguma informação dentro do elemento.
    find("#fullName").set user[:nome]
    find("#email").set user[:email]
    find("#password").set user[:senha]

    # clicar no botão "Cadastrar"
    click_button "Cadastrar"
  end
end
