require "httparty"

class BaseApi
  include HTTParty
  # Propriedade HTTParty, recortando e colando a URL da API, fazendo com que só trabalhe com as rotas fazendo o post ou qualquer outra chamada.
  base_uri "http://rocklov-api:3333"
end
