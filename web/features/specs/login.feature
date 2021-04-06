#language: pt

Funcionalidade: Login
    Sendo um usuário cadastrado
    Quero acessar o sistema da Rocklov
    Para que eu possa anunciar meus equipamentos musicais

    @login
    Cenario: Login do usuário

        Dado que acesso a página principal
        Quando submeto minhas credenciais com "papito@yahoo.com" e "pwd123"
        Então sou redirecionado para o Dashboard

    Esquema do Cenario: Tentativa de login

        Dado que acesso a página principal
        Quando submeto minhas credenciais com "<login_input>" e "<senha_input>"
        Então vejo a mensagem de alerta: "<mensagem_output>"

        Exemplos:
            | login_input        | senha_input | mensagem_output                  |
            | papito@yahoo.com   | abc123      | Usuário e/ou senha inválidos.    |
            | louco@yahoooo.com  | pwd123      | Usuário e/ou senha inválidos.    |
            | papito&yahoooo.com | pwd123      | Oops. Informe um email válido!   |
            |                    | pwd12345    | Oops. Informe um email válido!   |
            | papito@yahoo.com   |             | Oops. Informe sua senha secreta! |

