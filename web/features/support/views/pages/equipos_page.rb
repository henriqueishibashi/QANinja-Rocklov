class EquiposPage
  include Capybara::DSL

  def create(equipo)
    # ? quer dizer que retorna verdadeiro ou falso, faz um check point que usa o timeout do Capybara para aguardar até que este elemento esteja visível no capybara
    # Checkpoint com timeout explicito
    page.has_css?("#equipoForm")

    # .length é o metodo que consegue obter a quantidade de letras num array ou uma string.
    upload(equipo[:thumb]) if equipo[:thumb].length > 0

    find("input[placeholder$=equipamento]").set equipo[:nome]

    # Condição de verificação
    select_cat(equipo[:categoria]) if equipo[:categoria].length > 0
    find("#price").set equipo[:preco]

    click_button "Cadastrar"
  end

  # Foi criado esse métodos, porque não tem uma categoria para escolher em "Branco", pois é um dos testes automatizados que deverá ser feito.
  def select_cat(cat)
    find("#category").find("option", text: cat).select_option
  end

  def upload(file_name)
    # Quando digita pwd no console, ele mostra a pasta que está sendo executado o projeto, dir = diretório
    
    # Quando digita pwd no console, ele mostra a pasta que está sendo executado o projeto, dir = diretório
    thumb = File.join(Dir.pwd, "/features/support/fixtures/images/" + file_name)
    # Corrigindo inconsistencia na hora de montar o caminho do arquivo quando usamos o firefoxdriver
    thumb = thumb.tr("/", "\\") if OS.windows?								  
    # Como adicionar a imagem, buscando nas pastas.
    # Para a busca ser mais acertiva, foi colocado um id (onde está o "pai") e o type file input (que é considerado "filho")
    find("#thumbnail input[type=file]", visible: false).set thumb
    #type file está oculto a nível de usuário, ver que tem um display = none., por isso foi adicionado o visible: false
  end
end
