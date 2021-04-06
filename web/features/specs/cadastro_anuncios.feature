#language: pt

Funcionalidade: Cadastro de Anúncios
    Sendo usuário cadastro no Rocklov que possui equipamentos musicais
    Quero cadastrar meus equipamentos
    Para que eu possa disponibilidos para locação

    # Agrega muito usar o contexto.
    Contexto: Login
        # * é um step genérico, não tem Gerking
        # Montar um step de pré condição mandatória para ter a orquestração do cenário Completa.
        * Login com "betao@yahoo.com" e "pwd123"
    
    @cadastro_equipo
    Cenario: Novo equipamento

        Dado que acesso o formulário de cadastro de anúncios
            # Tabela de chave e valor!
            E que eu tenho o seguinte equipamento:
            | thumb     | fender-sb.jpg |
            | nome      | Fender Strato |
            | categoria | Cordas        |
            | preco     | 200           |
        Quando submeto o cadastro desse item
        Então devo ver esse item no meu Dashboard

    Esquema do Cenario: Tentativa de cadastro de anúncios.

        Dado que acesso o formulário de cadastro de anúncios
            # Tabela de chave e valor!
            E que eu tenho o seguinte equipamento:
            | thumb     | <foto>      |
            | nome      | <nome>      |
            | categoria | <categoria> |
            | preco     | <preco>     |
        Quando submeto o cadastro desse item
        Então deve conter a mensagem de alerta: "<saida>"

        Exemplos: Novo
            | foto          | nome              | categoria | preco | saida                                |
            |               | Violao de Nylon   | Cordas    | 150   | Adicione uma foto no seu anúncio!    |
            | clarinete.jpg |                   | Outros    | 250   | Informe a descrição do anúncio!      |
            | mic.jpg       | Microfone Shure   |           | 100   | Informe a categoria                  |
            | trompete.jpg  | Trompete Clássico | Outros    |       | Informe o valor da diária            |
            | conga.jpg     | Conga             | Outros    | abc   | O valor da diária deve ser numérico! |
            | conga.jpg     | Conga             | Outros    | 100a  | O valor da diária deve ser numérico! |