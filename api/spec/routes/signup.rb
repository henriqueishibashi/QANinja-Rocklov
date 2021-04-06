require_relative "base_api"
# PAGE OBJECTS

class Signup < BaseApi
  def create(payload)

    # .self.class ter acesso aos objetos da própria classe
    return self.class.post(
             "/signup",
             body: payload.to_json,
             # Montando requisição POST para fazer login através do ruby e HTTParty
             headers: {
               "Content-Type": "application/json",
             },
           )
  end
end
