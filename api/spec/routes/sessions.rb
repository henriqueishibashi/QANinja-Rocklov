require_relative "base_api"
# PAGE OBJECTS

class Sessions < BaseApi
  def login(payload)

    # .self.class ter acesso aos objetos da própria classe
    return self.class.post(
             "/sessions",
             # Converte a informação payload para json, conforme a API solicita ver "application/json"
             body: payload.to_json,
             # Montando requisição POST para fazer login através do ruby e HTTParty
             headers: {
               "Content-Type": "application/json",
             },
           )
  end
end
